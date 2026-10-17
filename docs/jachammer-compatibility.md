# JacHammer compatibility increment — 17 October 2026

Owner request: make the existing repository work when imported/pulled and connected to JacHammer. Current checkout is the owner-supplied `unipathlk-v1`, branch `rusira`. Historical Downloads paths and hosting-deferral records describe earlier work.

## Changes

- Declared fullstack project kind, retained main.jac/app/port 8000 and all runtime pins, added `.python-version`.
- Added Linux setup/start scripts and Jac script aliases. Setup installs the exact constraints; startup checks Python/Jac/byLLM versions, accepts `PORT`, uses the project root and runs Jac in the foreground with stdin detached. Native client bundling stays enabled.
- Added optional server-only `UNIPATH_PUBLIC_ORIGINS` for proxies that replace Host. Only exact configured HTTP(S) origins are accepted; wildcard, userinfo, path/query/fragment and spoofed forwarded headers cannot widen access. Existing local same-origin requests still work.
- Local dotenv now supplies defaults without overwriting host environment values. All keys stay server-side. Launchers/CI use LiteLLM's local pricing map to avoid its optional remote fetch at import.
- Removed misleading localhost-only static index.html. The Jac native app remains the root page. Ignore rules exclude caches, secrets and presentation binaries from CLI uploads while retaining all catalogue data and public images.
- Expanded CI from API-only startup to native client build and root/script/stylesheet delivery. Added independent native and actual HTTP proxy/configuration tests. Programme catalogue and planning semantics are unchanged.

## Observed local evidence

| Check | Result |
| --- | --- |
| Fresh dependency installation | Python 3.12.12 project venv, Jac 0.16.7, byLLM 0.6.19; all 57 pinned packages installed. |
| Authored Jac checker | All 18 modules pass. H13 initially had two interop type errors; typed URL/body handling was fixed while preserving assertions. Changed audit module rechecked. |
| Native behavioural suite | 56 tests pass in 0.845s. T55 covers explicit origins/internal Host/spoof rejection; T56 checks environment precedence using mocked dotenv data. |
| Native startup/build | Fresh Bun 1.3.11 install, pinned npm dependencies installed in 15.2s, native client built in 8.5s; server bound `0.0.0.0:8765`, root app `app`. No provider key supplied. |
| Actual HTTP | All 13 groups pass. Includes all eight operations, exact bytes/MIME for five PNGs, root title/mount/viewport, real JavaScript/CSS fetches and configured public origin with `Host: internal-runtime:8000`. |
| Launch/configuration syntax | Git Bash `bash -n` passes both shell scripts; TOML and workflow YAML parse. Linux launcher execution is specified in updated CI, not claimed as locally exercised on Windows. |
| Clean Linux CI | Source `cef44ec` passed [run 39025035597](https://github.com/madukamalruk/unipathlk-v1/actions/runs/39025035597): pinned install, all module checks, native tests, actual Linux start.sh execution, native client build and all 13 HTTP groups. |
| Source composition after integration | Includes the owner's concurrent Vercel adapter/launchers and new shell support; excludes generated bundles and dependency/build caches. All source: 71.431% Jac nonblank lines / 86.424% nonwhitespace bytes. Application/support excluding tests/audit: 62.642% / 79.398%. No competition verdict inferred. |

Initial sandbox network/DNS restrictions prevented dependency fetch and local HTTP access; repeating those operations with network access succeeded. These were tooling restrictions, not relaxed test assertions. Module test discovery intentionally reports zero cases in the explicit HTTP runner; its 13 named groups were separately executed against the running server.

## Hosted boundary and next use

Remote main changed during verification to owner commit `37f6d7f` (Vercel deployment adapter and prebuilt assets). The attempted non-fast-forward push was rejected; those additions were fetched and merged without modification. No history was overwritten. The native Jac application source remains identical to tested `cef44ec`; all 13 HTTP groups passed again after integration. Vercel deployment itself was not tested in this task.

No authenticated JacHammer project, project ID or deployed URL was supplied/used. This increment verifies a clean local install/build and simulated proxy behaviour, not the actual hosted runtime or browser interactions. Follow [the import/connection guide](../JACHAMMER_INIT_PROMPT.md), confirm Settings > Jac version = 0.16.7, set runtime config as project-level variables, then repeat the HTTP and browser checks at the real URL. Pulling source and deploying a release are separate platform actions.

Official docs read: [creating a project](https://docs.jachammer.ai/features/creating-a-project), [Jac version](https://docs.jachammer.ai/features/jac-version), [environment variables](https://docs.jachammer.ai/features/environment-variables), [preview](https://docs.jachammer.ai/features/live-preview-overview), [Git panel](https://docs.jachammer.ai/features/the-git-panel), [CLI](https://docs.jachammer.ai/features/cli). Installed Jac 0.16.7 configuration, project-kind, type and deployment guides were checked against its implementation. Account-wide builder AI keys do not substitute for the app's runtime key; production needs project-level variables.
