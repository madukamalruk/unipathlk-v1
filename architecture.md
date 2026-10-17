# UniPath LK architecture

## One pinned Jac application

Python3.12, Jac0.16.7, byLLM0.6.19. Native client components compile with Jac's frontend toolchain; no handwritten JavaScript recommendation service, FastAPI layer or unrelated framework. The Downloads checkout is authoritative; staging and development helpers stay outside publication.

## Graph and deterministic authority

`Catalogue` and `Offering` nodes connect through `ProgressesTo` edges carrying explicit prerequisites and claim evidence. Shared catalogue nodes are read-only through the API. Student profiles, lens findings, branch qualification sets and planning state are request-local.

`BranchSearchWalker` uses copied branch state and checks both node and transition conditions. Maximum4stages,100expanded states and20candidate paths; cycle guards terminate repeated nodes and truncation is reported. Three parameterised LensWalker executions produce Aspiration/Fiscal/Gatekeeper findings. Bridge findings are derived from multi-stage candidates; no fourth Bridge walker exists. Branch search uses an explicit frontier over typed graph edges; the lens walker performs node-entry visit/here traversal.

Requirements are pass/fail/unknown with nested all/any. Ranking retains hard status, editorial subject alignment and selected cost/duration/study preference before model tie-breaking. Goal tags establish neither professional eligibility nor employment.

Cash flow applies upfront payments then monthly contributions/expenses. Minimum balance determines extra initial savings. Unknown essential values make the ledger incomplete. Stress recomputes the same profile with travel+40% and6months of first-stage delay.

## Repeat-A/L comparison

`services/retake.jac` validates a separate retake dictionary. It uses the existing ledger on user-entered preparation estimates and separately multiplies months by income forgone. The monthly contribution is not reduced again. It runs present-route planning with AI disabled; it never changes grades or invents a future route.

`data/real/retake_guidance.json` contains year-scoped UGC guidance, explicitly historical DoE instructions and the current official portal. Attempt counts are self-reported advisory signals, not a legal exam ban or admission determination. Future dates, fees and results are not assumed.

## Shared bounded AI

Typed planner actions invoke search/evaluate/ask/finish. Maximum4actions and15seconds/session. `BoundedGeminiModel` uses byLLM's public parameter extension to supply SDK timeout8seconds/retries0; outer calls wait at most10seconds/remaining budget. A shared2-worker pool/semaphore and30calls/minute budget cover planner and guide together. Context variables propagate into workers. Limits are process-local, not per-user/distributed controls.

The guide's `AssistantDecision` contains only a supported topic, up to3known offering IDs and up to2curated tip IDs. Invalid structures/IDs fail to curated fallback. All answer prose, numeric facts and source URLs are server-authored. Gemini cannot emit arbitrary claims into the UI. The provider receives only the current question, recent user questions, selected field and public catalogue summaries; profile finances, grades and district are not automatically sent. Questions can themselves contain private data, so the UI warns against identifiers and requires separate opt-in. Conversation state is browser-session memory, not saved by product code; vendor processing/retention is separate.

## Public operations

| Walker | Input | Output |
| --- | --- | --- |
| get_app_info | Empty | Domains, counts, unique qualification choices |
| plan_pathways | profile | Checked routes, conditions, sources, question, events, graph, revision |
| run_stress_test | Full profile, named scenario | Stable route IDs and absolute deltas/incomplete result |
| get_catalogue_projection | Allowlisted catalogue mode | Read-only records and transitions |
| get_evidence | Mode and optional offering ID | Independent claims |
| evaluate_retake | profile, retake | Preparation estimates, current routes, considerations and scoped sources |
| ask_guide | profile, message, bounded history, allow_ai | Honest mode, server-owned answer/programmes/tips/sources |
| health | Empty | Readiness/counts without credentials |

POST uses `/walker/<name>` and Jac reports in `data.reports`. Unsupported business fields return invalid_input. Runtime-envelope errors are generic and may use HTTP200 in this release, so consumers inspect envelopes as well as transport status.

## Runtime and security adapters

Project-local hooks repair Jac0.16.7's root ID/CSS/viewport boundary and redact framework error envelopes without modifying installed packages. The request-handler subclass exposes only the eight POST operations; unused account/function endpoints and PUT/OPTIONS are denied. Bodies are capped at32KiB before parsing, duplicate/invalid lengths and transfer encoding rejected, content type enforced and body read timeout set12seconds. Cross-origin browser POSTs are rejected, wildcard CORS suppressed, POST responses no-store and nosniff/referrer headers applied.

GET serves the app and native static assets. Dot-segment, encoded-separator, backslash, drive-colon and NUL paths are rejected before framework static delegation. This is targeted hardening, not an exhaustive HTTP parser/load/sandbox audit. Upstream hosting controls, distributed abuse limits and vendor privacy review remain deployment work.

## Client and verification

Desktop profile sidebar; mobile collapsible profile; compact results/comparison; retake view; native dialog guide; Colombo clock. Request/revision refs prevent stale plan, retake and chat responses replacing current state. Model text is not injected as HTML. Five owner images serve the header, theme-aware welcome state, retake and guide through the fixed-name binary compatibility route described below.

Jac's timestamp IR fast path can accept stale caches after copies preserving old mtimes. Changed-source sync now writes current mtimes; stale generated caches/builds were preserved under backup names before recompilation. Source and dependency files are never replaced to hide a failing check.

See the test matrix for current counts. Owner confirmed new panels open. Independent new browser interaction coverage remains blocked by Work settings; do not reuse earlier screenshots as current proof. Hosting stays deferred. Deadline17:00 on17October2026, Asia/Colombo.


## Public image compatibility

Jac 0.16.7 declares but does not implement the default binary send_static_file hook. The project HTTP adapter intercepts exactly five approved /static/*.png names and reads only their fixed assets/ paths, responding with image/png, byte length and revalidation caching. Path rejection precedes the allowlist; filesystem exceptions become generic 404. JavaScript/CSS keep their existing runtime routes. Installed runtime and generated outputs are unchanged.


## Audit: bounded agency and schema scope

The planner forces search first and evaluation second. Only then can it ask an allowed missing-field question or finish; valid model ordering only breaks deterministic priority ties. Evaluation sorts already checked search candidates and collects unknowns. There is no iterative alternative research, model-created transfer, independent LLM lens debate or persisted student-agent memory. The four named action values are not four unconstrained autonomous agents.

Institutions, qualifications, career tags and evidence remain fields in Offering/catalogue records. The implementation has Catalogue/Offering nodes and ProgressesTo edges, not the old proposed five-entity ontology. get_app_info returns catalogue/domain/qualification metadata; it does not currently publish actions/lenses lists. The public catalogue operation returns curated offering/transition records; graph projection with lens findings belongs to planning results. See docs/judge-audit-2026-10-17.md for observed schema differences.
