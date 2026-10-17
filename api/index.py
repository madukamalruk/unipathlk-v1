"""Production-grade Vercel Serverless Function entrypoint for UniPath LK."""
import os
import sys
import tempfile
from pathlib import Path
from http.server import HTTPServer
from urllib.parse import urlsplit

# Ensure UTF-8 encoding across environments
os.environ["PYTHONIOENCODING"] = "utf-8"

# If running on Vercel or read-only filesystem, route runtime data to a clean temp directory
if os.environ.get("VERCEL") or os.name != "nt":
    data_dir = os.path.join(tempfile.gettempdir(), "unipath_jac_data")
    os.makedirs(data_dir, exist_ok=True)
    os.environ["JAC_DATA_PATH"] = data_dir

# Resolve workspace root and ensure it is in sys.path and cwd
WORKSPACE_DIR = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(WORKSPACE_DIR))
os.chdir(str(WORKSPACE_DIR))

from jaclang.jac0core.runtime import JacRuntime as Jac
from jaclang.cli.commands.cli_helpers import proc_file

base, mod, mach = proc_file(str(WORKSPACE_DIR / "main.jac"))
Jac.jac_import(target=mod, base_path=base, lng="jac")
ServerClass = Jac.get_api_server_class()
_jac_server = ServerClass(module_name=mod, port=0, base_path=base)
_jac_server.introspector.load()
_jac_server._ensure_sv_siblings()
_BaseJacHandler = _jac_server.create_handler()

APP_HTML = b'''<!DOCTYPE html><html lang="en"><head><meta charset="utf-8"/><title>UniPath LK | Education pathways</title><meta name="viewport" content="width=device-width,initial-scale=1"/><link rel="stylesheet" href="/static/styles.css"/></head><body><div id="root"></div><script id="__jac_init__" type="application/json">{"module": "main", "function": "app", "args": {}, "globals": {}, "argOrder": [], "endpointEffects": {"walker:get_app_info": {"is_writer": false, "touches": ["Root"]}, "walker:plan_pathways": {"is_writer": false, "touches": ["Root"]}, "walker:run_stress_test": {"is_writer": false, "touches": ["Root"]}, "walker:get_catalogue_projection": {"is_writer": false, "touches": ["Root"]}, "walker:get_evidence": {"is_writer": false, "touches": ["Root"]}, "walker:health": {"is_writer": false, "touches": ["Root"]}, "walker:evaluate_retake": {"is_writer": false, "touches": ["Root"]}, "walker:ask_guide": {"is_writer": false, "touches": ["Root"]}, "func:install_page_compatibility": {"is_writer": false, "touches": ["*"]}}}</script><script type="module" src="/static/client.js"></script></body></html>'''


class handler(_BaseJacHandler):
    """Production Vercel Handler with instant static delivery and native Jac walkers."""

    def __init__(self, request, client_address, server):
        super().__init__(request, client_address, _jac_server.server or _jac_server)

    def parse_request(self):
        if not super().parse_request():
            return False

        raw_matched = self.headers.get("x-matched-path") or self.headers.get("x-invoke-path")
        resolved = raw_matched if (raw_matched and not raw_matched.startswith("/api/index")) else self.path

        split = urlsplit(resolved)
        path = split.path
        query = f"?{split.query}" if split.query else ""

        if path in ("", "/", "/api", "/api/", "/api/index", "/api/index.py"):
            self.path = "/" + query
        elif path.startswith("/api/"):
            self.path = path[4:] + query
        else:
            self.path = path + query

        fwd_host = self.headers.get("x-forwarded-host")
        if fwd_host and "Host" in self.headers:
            self.headers.replace_header("Host", fwd_host)

        return True

    def do_GET(self):
        path = urlsplit(self.path).path

        # Root HTML: Serve instantaneously
        if path in ("", "/"):
            self.send_response(200)
            self.send_header("Content-Type", "text/html; charset=utf-8")
            self.send_header("Cache-Control", "public, max-age=0, must-revalidate")
            self.send_header("Content-Length", str(len(APP_HTML)))
            self.end_headers()
            self.wfile.write(APP_HTML)
            return

        # Prebuilt client JavaScript bundle
        if path == "/static/client.js" or path.startswith("/static/client."):
            bundle_file = WORKSPACE_DIR / ".jac" / "client" / "dist" / "client.CsvrtV7z.js"
            if bundle_file.is_file():
                data = bundle_file.read_bytes()
                self.send_response(200)
                self.send_header("Content-Type", "application/javascript; charset=utf-8")
                self.send_header("Cache-Control", "public, max-age=31536000, immutable")
                self.send_header("Content-Length", str(len(data)))
                self.end_headers()
                self.wfile.write(data)
                return

        # Prebuilt styles
        if path == "/static/styles.css":
            css_file = WORKSPACE_DIR / ".jac" / "client" / "dist" / "styles.css"
            if css_file.is_file():
                data = css_file.read_bytes()
                self.send_response(200)
                self.send_header("Content-Type", "text/css; charset=utf-8")
                self.send_header("Cache-Control", "public, max-age=31536000, immutable")
                self.send_header("Content-Length", str(len(data)))
                self.end_headers()
                self.wfile.write(data)
                return

        # Owner public images from assets/
        if path.startswith("/static/"):
            img_name = path.removeprefix("/static/")
            img_file = WORKSPACE_DIR / "assets" / img_name
            if img_file.is_file():
                data = img_file.read_bytes()
                self.send_response(200)
                self.send_header("Content-Type", "image/png")
                self.send_header("Cache-Control", "public, max-age=86400")
                self.send_header("Content-Length", str(len(data)))
                self.end_headers()
                self.wfile.write(data)
                return

        return super().do_GET()


# Standalone runner for direct local testing
if __name__ == "__main__":
    port = int(os.environ.get("PORT", 8000))
    print(f"Starting UniPath LK local server on http://localhost:{port} ...")
    httpd = HTTPServer(("0.0.0.0", port), handler)
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        print("\nServer stopped.")
