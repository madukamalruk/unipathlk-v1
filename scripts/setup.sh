#!/usr/bin/env bash
# Reproduce the verified runtime in a clean Linux/JacHammer checkout.
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
"${PYTHON_BIN:-python3.12}" -m venv .venv
.venv/bin/python -m pip install -r requirements.txt
PYTHONIOENCODING=utf-8 LITELLM_LOCAL_MODEL_COST_MAP=True .venv/bin/jac check main.jac --nowarn
