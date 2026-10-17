"""Vercel Serverless Function entrypoint for UniPath LK (Jac & Jaseci)."""
import os
import sys
from pathlib import Path
from http.server import HTTPServer
from urllib.parse import urlsplit

# Ensure UTF-8 encoding across environments
os.environ["PYTHONIOENCODING"] = "utf-8"

# If running on Vercel or read-only filesystem, route runtime data to /tmp
if os.environ.get("VERCEL") or os.name != "nt":
    os.environ.setdefault("JAC_DATA_PATH", "/tmp")

# Resolve workspace root and ensure it is in sys.path and cwd
WORKSPACE_DIR = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(WORKSPACE_DIR))
os.chdir(str(WORKSPACE_DIR))

from jaclang.jac0core.runtime import JacRuntime as Jac
from jaclang.cli.commands.cli_helpers import proc_file

# Bootstrap and import main.jac
_base, _mod, _mach = proc_file(str(WORKSPACE_DIR / "main.jac"))
Jac.jac_import(target=_mod, base_path=_base, lng="jac")

# Instantiate Jac API Server and obtain the underlying UniPathRequestHandler (port=0 for serverless)
ServerClass = Jac.get_api_server_class()
_jac_server = ServerClass(module_name=_mod, port=0, base_path=_base)
_jac_server.introspector.load()
_jac_server._ensure_sv_siblings()
_BaseJacHandler = _jac_server.create_handler()


class handler(_BaseJacHandler):
    """Vercel Serverless Handler wrapping UniPath's Jac request handler."""

    def parse_request(self):
        # Let BaseHTTPRequestHandler parse raw request line & headers
        if not super().parse_request():
            return False

        # Vercel rewrites provide the original matched path in x-matched-path or x-invoke-path
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

        # Normalize Host from x-forwarded-host if present, ensuring strict Origin checks pass
        fwd_host = self.headers.get("x-forwarded-host")
        if fwd_host and "Host" in self.headers:
            self.headers.replace_header("Host", fwd_host)

        return True


# Standalone runner for direct local testing
if __name__ == "__main__":
    port = int(os.environ.get("PORT", 8000))
    print(f"Starting UniPath LK local server on http://localhost:{port} ...")
    httpd = HTTPServer(("0.0.0.0", port), handler)
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        print("\nServer stopped.")
