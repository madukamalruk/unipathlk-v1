"""Vercel Serverless entrypoint for UniPath LK (Jac & Jaseci).

Static UI (HTML, prebuilt client bundle, CSS, images) is served without importing
Jac, so the page always loads. The Jac runtime is loaded lazily for /walker/* calls.
"""
import os
import sys
import tempfile
import traceback
from pathlib import Path
from http.server import BaseHTTPRequestHandler, HTTPServer
from urllib.parse import urlsplit

os.environ["PYTHONIOENCODING"] = "utf-8"

WORKSPACE_DIR = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(WORKSPACE_DIR))

# Serverless filesystems are read-only except for the temp dir.
if os.environ.get("VERCEL") or os.name != "nt":
    _data_dir = os.path.join(tempfile.gettempdir(), "unipath_jac_data")
    os.makedirs(_data_dir, exist_ok=True)
    os.environ["JAC_DATA_PATH"] = _data_dir

DIST = WORKSPACE_DIR / ".jac" / "client" / "dist"

APP_HTML = b'''<!DOCTYPE html><html lang="en"><head><meta charset="utf-8"/><title>UniPath LK | Education pathways</title><meta name="viewport" content="width=device-width,initial-scale=1"/><link rel="stylesheet" href="/static/styles.css"/></head><body><div id="root"></div><script id="__jac_init__" type="application/json">{"module": "main", "function": "app", "args": {}, "globals": {}, "argOrder": [], "endpointEffects": {"walker:get_app_info": {"is_writer": false, "touches": ["Root"]}, "walker:plan_pathways": {"is_writer": false, "touches": ["Root"]}, "walker:run_stress_test": {"is_writer": false, "touches": ["Root"]}, "walker:get_catalogue_projection": {"is_writer": false, "touches": ["Root"]}, "walker:get_evidence": {"is_writer": false, "touches": ["Root"]}, "walker:health": {"is_writer": false, "touches": ["Root"]}, "walker:evaluate_retake": {"is_writer": false, "touches": ["Root"]}, "walker:ask_guide": {"is_writer": false, "touches": ["Root"]}, "func:install_page_compatibility": {"is_writer": false, "touches": ["*"]}}}</script><script type="module" src="/static/client.js"></script></body></html>'''

_jac = {"server": None, "cls": None}


def _load_jac():
    if _jac["cls"] is None:
        os.chdir(str(WORKSPACE_DIR))
        from jaclang.jac0core.runtime import JacRuntime as Jac
        from jaclang.cli.commands.cli_helpers import proc_file

        base, mod, _mach = proc_file(str(WORKSPACE_DIR / "main.jac"))
        Jac.jac_import(target=mod, base_path=base, lng="jac")
        server = Jac.get_api_server_class()(module_name=mod, port=0, base_path=base)
        server.introspector.load()
        server._ensure_sv_siblings()
        _jac["server"] = server
        _jac["cls"] = server.create_handler()
    return _jac["cls"]


class handler(BaseHTTPRequestHandler):
    def _send(self, status, ctype, body, cache="public, max-age=0, must-revalidate"):
        self.send_response(status)
        self.send_header("Content-Type", ctype)
        self.send_header("Content-Length", str(len(body)))
        self.send_header("Cache-Control", cache)
        self.send_header("X-Content-Type-Options", "nosniff")
        self.end_headers()
        self.wfile.write(body)

    def parse_request(self):
        if not super().parse_request():
            return False
        raw = self.headers.get("x-matched-path") or self.headers.get("x-invoke-path")
        resolved = raw if (raw and not raw.startswith("/api/index")) else self.path
        split = urlsplit(resolved)
        path, query = split.path, (f"?{split.query}" if split.query else "")
        if path in ("", "/", "/api", "/api/", "/api/index", "/api/index.py"):
            self.path = "/" + query
        elif path.startswith("/api/"):
            self.path = path[4:] + query
        else:
            self.path = path + query
        fwd = self.headers.get("x-forwarded-host")
        if fwd and "Host" in self.headers:
            self.headers.replace_header("Host", fwd)
        return True

    def _delegate(self, method):
        try:
            cls = _load_jac()
            inst = object.__new__(cls)
            inst.__dict__.update(self.__dict__)
            getattr(inst, method)()
        except Exception:
            self._send(500, "text/plain; charset=utf-8",
                       ("Jac runtime error:\n" + traceback.format_exc()[-3000:]).encode("utf-8"),
                       "no-store")

    def do_GET(self):
        path = urlsplit(self.path).path
        if path in ("", "/"):
            return self._send(200, "text/html; charset=utf-8", APP_HTML)
        if path.startswith("/static/client."):
            files = sorted(DIST.glob("client.*.js"))
            if files:
                return self._send(200, "application/javascript; charset=utf-8",
                                  files[-1].read_bytes(), "public, max-age=3600")
        if path == "/static/styles.css" and (DIST / "styles.css").is_file():
            return self._send(200, "text/css; charset=utf-8",
                              (DIST / "styles.css").read_bytes(), "public, max-age=3600")
        if path.startswith("/static/"):
            name = path.removeprefix("/static/")
            img = WORKSPACE_DIR / "assets" / name
            if "/" not in name and ".." not in name and img.is_file():
                return self._send(200, "image/png", img.read_bytes(), "public, max-age=86400")
        if path == "/favicon.ico":
            return self._send(204, "image/x-icon", b"")
        return self._send(404, "text/plain; charset=utf-8", b"Not found")

    def do_POST(self):
        self._delegate("do_POST")


if __name__ == "__main__":
    port = int(os.environ.get("PORT", 8000))
    print(f"Starting UniPath LK local server on http://localhost:{port} ...")
    try:
        HTTPServer(("0.0.0.0", port), handler).serve_forever()
    except KeyboardInterrupt:
        print("\nServer stopped.")
