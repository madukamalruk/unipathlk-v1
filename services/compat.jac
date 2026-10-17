"""Project-local HTML compatibility hook for the pinned Jac 0.16.7 runtime.

That release's API page renderer emits __jac_root, while its React entry
mounts root. Its API HTML also omits the extracted Vite stylesheet and
viewport metadata. Use the public render_page hook to repair this app's
HTML without modifying installed packages or generated client code.
The send_json hook also sanitizes framework error envelopes before the
default serializer runs. It returns None without doing I/O, so the core
hook sends the response exactly once. Successful application reports
remain unchanged.
The public server factory selects a project subclass whose request handler
applies the same repair to canonical TransportResponse.data dictionaries;
Jac 0.16.7 sends those directly through HTTPTransport, bypassing send_json.
"""
import from importlib.metadata { version }
import json;
import from pathlib { Path }
import from urllib.parse { urlsplit }
import from jaclang.jac0core.runtime {
    hookimpl, plugin_manager, JacRuntimeImpl
}
import from jaclang.runtimelib.server { JacAPIServer }

def _sanitize_error_envelope(data: dict) -> None {
    if data.get("error") is not None {
        data["error"] = "Request rejected. Check the submitted fields and try again.";
        data.pop("traceback", None);
    }
    nested = data.get("data");
    if isinstance(nested, dict) and nested.get("error") is not None {
        nested["error"] = "Request rejected. Check the submitted fields and try again.";
        nested.pop("traceback", None);
    }
}

def _reject_http(handler: any, status: int) -> None {
    payload = json.dumps({"error": "Request rejected. Use a supported application operation and valid input."}).encode("utf-8");
    handler.close_connection = True;
    handler.send_response(status);
    handler.send_header("Content-Type", "application/json; charset=utf-8");
    handler.send_header("Content-Length", str(len(payload)));
    handler.send_header("Connection", "close");
    handler.end_headers();
    handler.wfile.write(payload);
}

# The pinned runtime declares send_static_file but its default hook raises
# NotImplementedError. Serve only these owner-approved public PNGs directly.
def _serve_public_image(handler: any, path: str) -> bool {
    names = ["brand-logo.png", "pathways-light.png", "pathways-dark.png", "pathway-steps.png", "study-icons.png"];
    name = path.removeprefix("/static/");
    if not path.startswith("/static/") or name not in names { return False; }
    asset = Path(str(__file__)).resolve().parent.parent / "assets" / name;
    if not asset.is_file() { _reject_http(handler, 404); return True; }
    try { body = asset.read_bytes(); }
    except OSError { _reject_http(handler, 404); return True; }
    handler.send_response(200);
    handler.send_header("Content-Type", "image/png");
    handler.send_header("Content-Length", str(len(body)));
    handler.send_header("Cache-Control", "public, max-age=0, must-revalidate");
    handler.end_headers();
    handler.wfile.write(body);
    return True;
}

obj _UniPathAPIServer(JacAPIServer) {
    def create_handler() -> type {
        base_handler = super.create_handler();
        original_send: any = getattr(base_handler, "_send_response");
        original_post: any = getattr(base_handler, "do_POST");
        original_get: any = getattr(base_handler, "do_GET");
        original_header: any = getattr(base_handler, "send_header");
        original_end_headers: any = getattr(base_handler, "end_headers");
        def limited_post(handler: any) -> None {
            path = urlsplit(str(handler.path)).path;
            allowed = ["/walker/" + name for name in ["get_app_info", "plan_pathways", "run_stress_test", "get_catalogue_projection", "get_evidence", "health", "evaluate_retake", "ask_guide"]];
            if path not in allowed { _reject_http(handler, 404); return; }
            origin = handler.headers.get("Origin");
            host = str(handler.headers.get("Host", ""));
            if origin and origin not in ["http://" + host, "https://" + host] { _reject_http(handler, 403); return; }
            if handler.headers.get("Transfer-Encoding") { _reject_http(handler, 400); return; }
            lengths = handler.headers.get_all("Content-Length", []) as list;
            if len(lengths) > 1 { _reject_http(handler, 400); return; }
            try { length = int(handler.headers.get("Content-Length", "0")); }
            except ValueError { _reject_http(handler, 400); return; }
            if length < 0 { _reject_http(handler, 400); return; }
            if length > 32768 { _reject_http(handler, 413); return; }
            content_type = str(handler.headers.get("Content-Type", "")).split(";")[0].strip().lower();
            if content_type != "application/json" { _reject_http(handler, 415); return; }
            try {
                handler.connection.settimeout(12.0);
                original_post(handler);
            } except (TimeoutError, OSError, UnicodeDecodeError) { _reject_http(handler, 400); }
        }
        def limited_get(handler: any) -> None {
            path = urlsplit(str(handler.path)).path;
            if "%" in path or "\\" in path or ":" in path or "\x00" in path or any([part in [".", ".."] for part in path.split("/")]) {
                _reject_http(handler, 404); return;
            }
            if path not in ["/", "/cl/app", "/favicon.ico"] and not path.startswith("/static/") {
                _reject_http(handler, 404); return;
            }
            if _serve_public_image(handler, path) { return; }
            original_get(handler);
        }
        def denied(handler: any) -> None { _reject_http(handler, 405); }
        def safe_header(handler: any, name: str, value: str) -> None {
            if name.lower() == "access-control-allow-origin" {
                origin = handler.headers.get("Origin");
                host = str(handler.headers.get("Host", ""));
                if origin in ["http://" + host, "https://" + host] { original_header(handler, name, origin); }
                return;
            }
            original_header(handler, name, value);
        }
        def safe_end_headers(handler: any) -> None {
            original_header(handler, "X-Content-Type-Options", "nosniff");
            original_header(handler, "Referrer-Policy", "strict-origin-when-cross-origin");
            if handler.command == "POST" { original_header(handler, "Cache-Control", "no-store"); }
            original_end_headers(handler);
        }
        def safe_send(handler: any, response: any) -> None {
            # Canonical TransportResponse bypasses send_json in this release.
            # Repair structured framework envelopes before normal serialization.
            data: any = getattr(response, "data", None);
            body: any = getattr(response, "body", None);
            if isinstance(data, dict) { _sanitize_error_envelope(data); }
            if isinstance(body, dict) { _sanitize_error_envelope(body); }
            original_send(handler, response);
        }
        return `type(
            "UniPathRequestHandler", (base_handler,), {"_send_response": safe_send,
                "do_POST": limited_post, "do_GET": limited_get, "do_PUT": denied,
                "do_OPTIONS": denied, "send_header": safe_header, "end_headers": safe_end_headers}
        );
    }
}

def _repair_app_html(page: str, bundle_hash: str) -> str {
    page = page.replace('<div id="__jac_root">', '<div id="root">');
    page = page.replace('<title>app</title>', '<title>UniPath LK | Education pathways</title>');
    additions = '<meta name="viewport" content="width=device-width,initial-scale=1"/>'
        + '<link rel="stylesheet" href="/static/styles.css?hash='
        + bundle_hash + '"/>';
    return page.replace('</head>', additions + '</head>');
}

class _UniPathPageCompatibility {
    # Jac 0.16.7's hook manager calls the latest registered hook first.
    # Its hookimpl marker takes only the callable; tryfirst is unsupported.
    @hookimpl
    static def get_api_server_class() -> type { return _UniPathAPIServer; }

    @hookimpl
    static def render_page(
        introspector: any, function_name: str, args: dict, username: str
    ) -> dict {
        core_render: any = getattr(JacRuntimeImpl, "render_page");
        payload = core_render(
            introspector, function_name, args, username
        ) as dict;
        if function_name == "app" {
            payload["html"] = _repair_app_html(
                str(payload["html"]), str(payload.get("bundle_hash", ""))
            );
        }
        return payload;
    }

    @hookimpl
    static def send_json(handler: any, status: any, data: dict) -> None {
        _sanitize_error_envelope(data);
        return None;
    }
}

def install_page_compatibility() -> None {
    if version("jaclang") == "0.16.7" {
        # Reloads replace this project's previous hook instead of accumulating it.
        plugin_manager.unregister(name="unipath-lk-page-compatibility");
        plugin_manager.register(
            _UniPathPageCompatibility, name="unipath-lk-page-compatibility"
        );
    }
}

with entry {
    install_page_compatibility();
}
