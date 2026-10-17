"""Load only allowlisted local settings; this module is never imported by the client."""
import os;

def _load_local_settings() -> None {
    path = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), ".env");
    if not os.path.isfile(path) { return; }
    with open(path, "r", encoding="utf-8-sig") as source {
        for line in source {
            stripped = line.strip();
            if not stripped or stripped.startswith("#") or "=" not in stripped { continue; }
            (key, value) = stripped.split("=", 1);
            key = key.strip();
            value = value.strip().strip('"').strip("'");
            if key in ["GOOGLE_API_KEY", "GEMINI_API_KEY", "UNIPATH_MODEL"] and value { os.environ[key] = value; }
        }
    }
}

with entry { _load_local_settings(); }
