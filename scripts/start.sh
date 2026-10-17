#!/usr/bin/env bash
# Foreground process; Jac binds 0.0.0.0 and builds the native client.
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
export PYTHONIOENCODING=utf-8
export LITELLM_LOCAL_MODEL_COST_MAP=True
if [[ -x .venv/bin/jac ]]; then
    jac_bin=.venv/bin/jac
    python_bin=.venv/bin/python
else
    jac_bin=jac
    python_bin="${PYTHON_BIN:-python3.12}"
fi
"$python_bin" -c 'import sys, importlib.metadata as m; assert sys.version_info[:2] == (3, 12), "Python 3.12 required"; assert m.version("jaclang") == "0.16.7", "Jac 0.16.7 required"; assert m.version("byllm") == "0.6.19", "byLLM 0.6.19 required"'
exec "$jac_bin" start main.jac --port "${PORT:-8000}" < /dev/null
