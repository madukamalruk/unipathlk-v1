# JacHammer import and connection

Import `https://github.com/madukamalruk/unipathlk-v1` as a **Web app** using the root `jac.toml`. The entry is `main.jac`, the root page is `app`, and the application port is 8000. Preserve the existing native Jac client and deterministic planning rules.

## Runtime and first preview

1. In **Settings > Jac version**, confirm **0.16.7**. Keep the committed `[project].jac-version` pin for preview and deployment. Use Python **3.12** and byLLM **0.6.19**. `.python-version` records Python for tools that support it; verify the actual host interpreter.
2. Let the platform install dependencies from `jac.toml` and run `jac start main.jac --port 8000`. Keep client bundling enabled. Jac binds `0.0.0.0`; `/` serves the native dashboard. There is no separate static `index.html` frontend.
3. For a host terminal/manual setup using the exact transitive constraints, run `bash scripts/setup.sh`, then `bash scripts/start.sh`. The start script runs from the repository root, verifies versions, accepts `PORT` (default 8000), and keeps Jac in the foreground with detached stdin. `PYTHON_BIN` can name a Python 3.12 executable for setup. Jac shortcuts: `jac script setup` and `jac script start`.
4. If JacHammer starts Jac itself, set server variable `LITELLM_LOCAL_MODEL_COST_MAP=True` to avoid LiteLLM's optional remote pricing-map fetch during import. This does not disable Gemini requests. The start script sets it automatically.

## Server variables

The app runs without an AI key, with explicit deterministic/curated fallback modes. Use **project-level** variables: JacHammer documents that account-global variables do not reach production deployments. Its builder API key setting is separate from this application's runtime configuration.

| Variable | Value |
| --- | --- |
| `GOOGLE_API_KEY` **or** `GEMINI_API_KEY` | Optional Gemini key, entered only in project server environment variables. |
| `UNIPATH_MODEL` | Optional; default `gemini/gemini-3.5-flash-lite`. Access depends on the provider account. |
| `UNIPATH_PUBLIC_ORIGINS` | If a proxy rewrites `Host`: exact browser origins, e.g. `https://actual-preview-host,https://actual-production-host`. No trailing slash, path, wildcard or credentials. |
| `LITELLM_LOCAL_MODEL_COST_MAP` | `True` for network-independent pricing-map startup. |

Normally same-origin requests work with the original `Host`. If health works from the terminal but browser POSTs return 403 behind the hosted proxy, set `UNIPATH_PUBLIC_ORIGINS` to the actual browser origin and restart/redeploy. `Forwarded` and `X-Forwarded-*` headers never grant access. Hosting environment values take precedence over local `.env` defaults. Keep wildcard CORS disabled.

## Verify the host

Use the actual preview URL, then repeat for a deployment URL:

```bash
curl --fail -H 'Content-Type: application/json' -d '{}' https://ACTUAL-HOST/walker/health
UNIPATH_TEST_BASE_URL=https://ACTUAL-HOST \
UNIPATH_TEST_CLIENT=1 \
.venv/bin/jac run tests/http_regression.jac
```

If using the host's installed pinned Jac, replace `.venv/bin/jac` with `jac`. For configured proxy-origin testing, also set `UNIPATH_TEST_PUBLIC_ORIGIN` to an origin configured on the server. The 13 HTTP groups cover all eight public operations, five exact PNG deliveries, body/path/account guards, browser origins, root HTML, JavaScript and CSS. Native tests: `jac test -d tests -v`.

Check the actual browser: profile submission, evidence, comparison, retake, guide, theme, images and mobile layout. HTTP asset checks do not prove browser interactions. Keep client bundling enabled for a UI preview and retain failing assertions until the defect is fixed.

## Git sync and deploy are separate

Import or pull the branch containing these changes. JacHammer documents automatic pull while an active connected project is cleanly behind; resolve divergence through its Git panel. Pulling updates editor/preview source. An existing deployment needs a separate redeploy, or an explicitly enabled production auto-deploy policy.

Optional CLI connection: `jachammer link <existing-project-name>`. It writes the real project ID into `[jachammer]` in `jac.toml`; commit that platform-generated ID after selecting the intended project. No account-specific ID is fabricated here. `jachammer deploy --dry-run` inspects the upload; `jachammer deploy` creates a preview deployment after login. Ignore files omit secrets, caches and presentation binaries while retaining runtime data/images.

## Prompt for the JacHammer builder

> Run the existing UniPath LK app from root main.jac using jac.toml. Preserve Jac 0.16.7, Python 3.12 and byLLM 0.6.19. Confirm Settings > Jac version respects the committed pin. Install dependencies and start with client bundling enabled on port 8000. Read JACHAMMER_INIT_PROMPT.md for server variables and proxy configuration. Keep secrets server-side. Preserve the current planner, rules, source evidence and native client. Verify health, native HTML/JS/CSS, all five images and the behavioural/HTTP suites. Report the actual preview URL and any failure; a source pull alone is not a production deployment.

Official references: [import](https://docs.jachammer.ai/features/creating-a-project), [Jac version](https://docs.jachammer.ai/features/jac-version), [server variables](https://docs.jachammer.ai/features/environment-variables), [Git sync](https://docs.jachammer.ai/features/the-git-panel), [CLI/link/deploy](https://docs.jachammer.ai/features/cli).
