# UniPath LK — සාක්ෂි මත කළ තරග ඇගයීම

2026-10-17, Asia/Colombo. පරීක්ෂා කළ application source: `2248e2ac21e457cdf64a20d9d2316fc22a8df0a4`; පසුව තිබෙන `ce0d1db` ලේඛන commit එකත් කියවීය. මේ audit එකේ application code වෙනස් කර නැහැ. README, architecture/agent විස්තර සහ ඉදිරිපත් කිරීමේ ලේඛන නිවැරදි කිරීම වෙනම සටහන් කර තිබෙනවා.

**තීන්දුව:** ඉදිරිපත් කරන්න පුළුවන්, වැඩ කරන prototype එකක් තිබෙනවා. දැනට එය “strong contender” බවට සාක්ෂි ප්‍රමාණවත් නැහැ. නිෂ්පාදන මට්ටමෙන් **mid-table** ලෙස අනුමාන කරනවා; **80% Jac counting සහ coding provenance තහවුරු නොවීම නිසා prize eligibility at risk**. මෙය නිල විනිසුරු තීරණයක් හෝ ජයග්‍රහණ සම්භාවිතාවක් නෙවෙයි.

## 1. නිල නීති සහ අමුණපු checklist එක වෙන් කිරීම

Owner දුන් `AI Hackathon 2026 Sri Lanka.pdf` පිටු 3, 4, 7, 8, 9 නැවත extract කර කියවීය:

- Hacking ආරම්භය 09:00; නිල submission deadline 17:30, 2026-10-17.
- අවම 80% code Jac විය යුතුයි. Lines, bytes හෝ වෙනත් denominator එකක් PDF එකේ දක්වා නැහැ.
- Team එකකට තිදෙනෙක්; ලියාපදිංචිය/check-in අවශ්‍යයි; coding hacking hours තුළ විය යුතුයි. කලින් brainstorming කළ හැකියි.
- Repository link, වැඩ කරන project එකේ video, Jac/Jaseci භාවිතය විස්තර කරන written description සහ Jac repo star කිරීම checklist එකේ තිබෙනවා.
- JacHammer hosting **encouraged**; මේ PDF එක අනුව අනිවාර්ය නෑ.
- වැරදි ප්‍රතිරූපයක් දීම disqualification හේතුවක්.

Ownerගේ 17:00 internal target එක සහ කලින් එකඟ වූ 15:30 feature freeze එක තබනවා. Official deadline එක 17:00 කියලා වෙනස් කරලා කියන්නේ නැහැ. Event-day නව නිවේදනයක් තිබුණොත් එය වෙනම තහවුරු කළ යුතුයි.

අමුණපු audit text එකේ “code වෙනස් නොකරන්න” සහ “සියලු failures වහාම fix කරන්න” යන දෙකම තිබෙනවා. එහි six endpoints, four separate lens walkers, `LoadCatalogue`, `Institution` ආදී පැරණි architecture අපේ වර්තමාන implementation එකට සමාන නෑ. ඒ නිසා ඒවා **requested comparison criteria** ලෙස පරීක්ෂා කරනවා; සියල්ල නිල තරග නීති ලෙස හඳුන්වන්නේ නැහැ. Ownerගේ සෘජු README වෙනස් කිරීමේ ඉල්ලීම ක්‍රියාත්මක කළා; runtime එක අවදානම් refactor එකකට ලක් කළේ නැහැ.

## 2. නැවත ධාවනය කළ පරීක්ෂණ

| Command / scope | ඇත්තටම ලැබුණු ප්‍රතිඵලය |
| --- | --- |
| `.venv/Scripts/jac.exe --version` | Jac 0.16.7; Python 3.12.13; byLLM 0.6.19; Windows AMD64. |
| `.venv/Scripts/jac.exe run main.jac` | Exit 0; import/entry execution සාර්ථකයි; stdout හි business output එකක් නැහැ. Web server එක සඳහා `jac start` අවශ්‍යයි. |
| Main/services/components/scripts/tests සියලු authored Jac files සඳහා `jac check <file> --nowarn` | Files 18ම PASS; compilation errors නැහැ. `--nowarn` නිසා zero warnings කියලා ප්‍රකාශ කරන්නේ නැහැ. |
| `.venv/Scripts/jac.exe test -d tests -v` | `Ran 54 tests in 0.248s` / `OK`. HTTP helper discovery වෙනම `Ran 0 tests` කියනවා; එය HTTP checks සමත් වූ බවට ගන්නේ නැහැ. |
| `.venv/Scripts/jac.exe run tests/http_regression.jac` | Authoritative localhost:8000 server එකේ H01–H11 PASS; `11 HTTP regression groups passed`. |
| `.venv/Scripts/jac.exe run scripts/audit_source.jac` | Files 22; read errors නැහැ; පහත exact composition. |
| Synthetic profile එකක් සමඟ සැබෑ Gemini planner HTTP request | `live_ai`; fallback reason හිස්; search → evaluate → finish; 3.667s; catalogue-derived route IDs තුනක්. එක smoke observation එකක් පමණයි. |
| Reachable Git blobs සියල්ල තුළ configured key exact-value scan | Blobs 164; matching blobs 0. පැරණි වෙනත්/encoded credentials සියල්ල නැති බවට සහතිකයක් නෙවෙයි. |

`jac start main.jac --port 8000` මඟින් දැනට ධාවනය වන authoritative server එක native client rebuild එකෙන් පසු H01–H11 පරීක්ෂා කර තිබෙනවා. මේ audit එකේ නැවත HTTP checks ඒ server එකට යැව්වා. Image-fix source එකේ clean Linux install/check/native/HTTP [CI run 39019439501](https://github.com/madukamalruk/unipathlk-v2/actions/runs/39019439501) ද සමත්. Hosted JacHammer run එකක් මේවායින් තහවුරු වෙන්නේ නැහැ.

### පැරණි test labels වලට වර්තමාන assertions ගැළපීම

| ඉල්ලූ හැසිරීම | වර්තමාන සාක්ෂිය | ප්‍රතිඵලය |
| --- | --- | --- |
| Direct සහ foundation → diploma → top-up සොයාගැනීම | `tests/engine_tests.jac:86`, `:97`; `tests/http_regression.jac:58` සහ live A/B/C probes | PASS |
| Incoming edge තිබුණත් maths prerequisite අසමත් නම් නවත්වීම/backtrack | `tests/engine_tests.jac:143`; `services/engine.jac:335`; actual A/B/C events වල `backtrack` | PASS |
| Unknown relocation වෙනම තබා clarification ඇසීම | `tests/engine_tests.jac:136`, `:240`; live Request A | PASS |
| Cash-flow 84,000 / −22,000 / 22,000; multistep 54,000 / 0 / 0; funded direct 0 gap | `tests/engine_tests.jac:86`, `:97`; live A/B/C numeric outputs | PASS |
| Cycles සහ sibling/request isolation | `tests/engine_tests.jac:157`, `:167`, `:190` | PASS |
| Key ඉවත් කළ විට provider නොකැඳවා honest fallback | `tests/engine_tests.jac:289`; provider boundary patch binding සහ call_count assertions | PASS |
| Client totals/status tampering ප්‍රතික්ෂේප කිරීම | `tests/engine_tests.jac:226`; HTTP H05/H07 (`tests/http_regression.jac:124`, `:153`) | PASS |

මෙහි T01/T13 නම් පැරණි checklist එකේ test නම් සමඟ එකට එක සමාන නෑ. ඉහත verdict දෙන්නේ actual computation/assertions අනුවයි.

## 3. Exact Jac composition

JSON/data, lock/config files, documentation, generated code, image bytes, dependencies සහ caches ඉවත් කරලා handwritten source ගණන් කළා. CSS සහ launchers ඇතුළත්. Comments ඇතුළත්; whitespace ඉවත් කළ UTF-8 bytes සහ nonblank lines දෙක වෙන වෙනම මැනුවා.

| Language | Files | Nonblank lines | Nonwhitespace UTF-8 bytes |
| --- | ---: | ---: | ---: |
| Jac | 18 | 3,794 | 158,781 |
| CSS | 1 | 1,473 | 21,758 |
| PowerShell | 1 | 16 | 806 |
| HTML | 1 | 5 | 309 |
| Batch | 1 | 3 | 77 |
| Total | 22 | 5,291 | 181,731 |

- **සියලු authored source:** lines 71.707%; bytes 87.371% Jac.
- **Tests සහ audit script ඉවත් කළ application/support source:** lines 2,629/4,126 = 63.718%; bytes 99,943/122,893 = 81.325% Jac.
- Blank lines ද ඇතුළත් raw-line count: Jac 3,964; other source 1,498; Jac 72.574%.
- ඒ නිසා **line-based 80% gate: FAIL**. **Byte-based 80% gate: PASS**. නිල counting method එක නොදන්නා නිසා overall eligibility තවම **UNKNOWN / AT RISK**.

Non-Jac files: `styles/global.css`, `run_project.ps1`, `run_project.bat`, `index.html`. Handwritten `.py` හෝ `.js` app files නැහැ. Python standard-library imports භාවිත වෙන්නේ Jac source තුළයි; ඒක වෙනම Python service එකක් නෙවෙයි. Generated JavaScript compiler output එකයි.

CSS එක Jac string එකකට ගෙනයාම හෝ minify කර line count අඩු කිරීම ගුණාත්මක compliance විසඳුමක් නෙවෙයි. Launchers/legacy note ඉවත් කළත් ප්‍රධාන line-share හිඟය විසඳෙන්නේ නැහැ. සැබෑ duplicate/dead CSS ඉවත් කිරීම සාධාරණ maintenance වැඩක් වුණත් visual regression review නැතුව deadline ළඟ එය කිරීම අවදානම්. Filler එකතු නොකර organiserගෙන් denominator එක තහවුරු කරගැනීම පළමු ක්‍රියාවයි.

## 4. Verification gates 1–6

| Gate | Verdict | සාක්ෂිය සහ ප්‍රධාන සීමාව |
| --- | --- | --- |
| 1 — Compilation/core tests | PASS, scoped | Actual 18 checks / 54 native cases. Test map ඉහත. |
| 2 — Live REST operations | PASS for current 8 operations; PARTIAL against old schema | H01–H11 actual HTTP. Current operations: info, plan, stress, projection, evidence, health, retake, guide. `get_app_info` actions/lenses allowlist metadata නොදෙයි (`services/api.jac:8`). Projection returns public `offerings/transitions`, not a new `nodes/edges` schema (`:51`). |
| 3 — OSP and 80% | Meaningful OSP PASS; old full ontology FAIL; 80% unresolved | `node Catalogue/Offering`, `edge ProgressesTo` (`services/engine.jac:12`); generic lens `visit/here` (`:350`). Branch search explicitly uses frontier traversal (`:290`). Institution/Qualification/CareerGoal/EvidenceClaim node classes and Offers/Awards/SupportsGoal/SupportedBy edges නැහැ. |
| 4 — Truthfulness/data | PARTIAL | No unlabelled invented real paths or resilience percentages found. Unknown costs preserved (`services/engine.jac:180`). Real data has claim metadata. Entire UI prose is English, but internal Sinhala keyword matching exists at `services/assistant.jac:56–62`; pasted checklist's literal zero-Sinhala-source condition fails. It is not an official PDF rule and should not be confused with English UI. |
| 5 — UI/UX | PARTIAL / live interactions UNKNOWN | Revision guards in `components/App.cl.jac:339`, `:430`; fixture banner at `:884`; planner mode at `:1216`. Graph is a readable node/edge list with findings (`:1135` onward), not clickable nodes opening a separate inspector. New mobile/keyboard/focus interactions remain independently unverified because browser control is disabled. |
| 6 — Report/remediation | DONE for audit and documentation | README, current contracts and 150-second script corrected; real gaps remain explicitly open. “100% green” is not claimed by weakening the rubric, inventing coverage or rewriting code during a read-only audit. |

### Live A/B/C outputs

Profile: fictional catalogue, savings 2,000, contribution 5,000, three A/L passes, maths grade F. Only changes below:

| Request | Result | Operational actions |
| --- | --- | --- |
| A — relocation unknown | Pending `can_relocate`; multistep needs_confirmation, 54,000/0 gap; direct blocked, 84,000/22,000 gap | backtrack → search_alternatives → evaluate_candidates → ask_student |
| B — relocation yes, revision 2 | Multistep conditional; direct remains cash-blocked | backtrack → search_alternatives → evaluate_candidates → finish |
| C — relocation yes, savings 24,000, revision 3 | Direct feasible_under_stated_assumptions, 84,000/0 gap; multistep conditional | backtrack → search_alternatives → evaluate_candidates → finish |

**B සහ C action sequence එක සමානයි.** Results/ranking වෙනස් වුණත් pasted checklist එකේ “B action sequence must differ from C” කියන අමතර assertion සපුරන්නේ නැහැ. A සහ B අතර සැබෑ clarification branch වෙනස තිබෙනවා. `backtrack` graph search event එකක්; අමතර LLM action එකක් නෙවෙයි.

## 5. Official-rule readiness checklist

| Item | Status | සාක්ෂිය / ඉතිරිය |
| --- | --- | --- |
| >=80% Jac | UNKNOWN; FAIL if lines | Exact measurements above; PDF denominator unspecified. |
| Meaningful Jac primitives | PASS | Engine nodes/edge/search/lens traversal; planner native byLLM. |
| Fictional data explicitly labelled | PASS in source/API; scoped UI evidence | `data/demo/catalogue.json:2`; `components/App.cl.jac:795`, `:803`, `:884`; README data table. Fixtures are intentionally invented, not real institutions. |
| Source/fees/transfer truthfulness | PARTIAL | 309 claims all have `source_url/checked_on`; 92 marked verified, 215 unreviewed, two stale. Marked statuses were counted, not independently re-certified page-by-page in this audit. All 37 complete costs unknown; one English application edge; no real loan approvals or arbitrary credit transfers. |
| Runnable and secret handling | Local PASS / hosting UNKNOWN | Current HTTP/native checks and clean Linux CI. Exact current secret absent in 164 reachable Git blobs. `.env` ignored. JacHammer not deployed. |
| README explains Jac/Jaseci | PASS after update | Concrete primitive/architecture tables; no nonexistent council claims. |
| Coding-hour provenance | UNKNOWN | Visible commits d2f41e8 through ce0d1db have 13:05–14:32 event-day timestamps, within hacking hours. Received original source existed before the first commit. Commit timestamps alone cannot establish when every line was written. Preserve provenance and obtain organiser guidance; do not backdate. |
| 2–3 minute current demo | PARTIAL | Existing MP4/PDF/PPTX files exist and predate the new UI. Updated 150-second script exists; a current recording is still needed. |
| Submission items | PARTIAL | Repo and written description present; current video/public app/submission confirmation missing. Public starred-list check returned 17 repositories and included `jaseci-labs/jac`. Team registration/check-in and one-project rule are not verified here. |

## 6. Judging criteria — අපේ ඇස්තමේන්තුව

මෙය නිල ලකුණු නොවෙයි. Rubric weighting, අනෙක් කණ්ඩායම් සහ judge preferences නොදන්නා නිසා ජයග්‍රහණයක් පුරෝකථනය කරන්නේ නැහැ.

| Criterion | /10 | සාක්ෂිය | එක ප්‍රධාන අඩුව |
| --- | ---: | --- | --- |
| Depth of agentic behaviour | 5 | Native typed action proposals, actual dispatch, clarification branch, route-ID validation, branch pruning and fallback. Live planner was actually called. | Initial search/evaluate choices are forced (`services/planner.jac:92`); no iterative alternative expansion, autonomous research or cross-agent negotiation/memory. |
| Excellent use of Jac/Jaseci | 7 | Native nodes/typed edge, spawn, visit/here, byLLM/sem and Jac client. | Two node types/one edge type; Bridge is projection, not a fourth autonomous walker. Line-based 80% gate fails. |
| Technical execution | 8 | 18 check passes, 54 cases, 11 actual HTTP groups, Linux CI, fixed binary images and failure boundaries. | Hosted compatibility and current comprehensive browser journey unverified. |
| Creativity and innovation | 6 | Student cash-flow constraints, uncertainty/evidence, another-A/L scenario and practical vocational choices are a useful combination. | Programme recommendation itself is familiar; one real progression edge limits the strongest graph story. |
| Impact and novelty | 8 | Clear Sri Lankan decision problem across fields; practical alternatives; avoids fabricated fees and admission guarantees. | No measured student outcomes; small catalogue and unknown complete costs restrict real financial advice. |
| Clear presentation/demo | 5 | Written description, deck/video artifacts and a current 150-second script exist. | Existing video/deck show the prior release; current concise recording and rehearsal missing. |

Indicative total **39/60**, not an official score. A strong demonstration and eligibility clarification could improve readiness more than another decorative feature. Current safety constraints are strengths; they do not by themselves imply high autonomy.

## 7. Judge අහන්න ඉඩ තියෙන අමාරු ප්‍රශ්න

**“මේකට Jac/agents ඕන ඇයි? If-else lookup එකකින් බැරිද?”**

සරල catalogue filtering එකකට if-else ප්‍රමාණවත්. මෙහි ගැටලුව route එකක් ඔස්සේ ලැබෙන qualification state, edge prerequisites, multiple stages, cycle/branch isolation සහ whole-route cash flow එකට සම්බන්ධ වීමයි. Jac ඒ graph සහ mobile-code lens model එක පැහැදිලි කරයි. එහෙත් මේක වෙනත් language එකකින් කරන්න බැහැ කියන්නේ නැහැ. LLM එකේ වර්තමාන autonomy සීමිත බවත් පිළිගන්නවා.

**“LLM එක route/credit transfer එකක් හදනවද?”**

නෑ. Route එක engine එක graph catalogue එකෙන් ගණනය කරනවා. Model එකට ලබාදුන් route IDs අතරින් පමණක් තෝරන්න පුළුවන්; duplicate/unknown IDs ප්‍රතික්ෂේප වෙනවා (`services/planner.jac:125–142`). Entry/evidence/cost gates model එකට වෙනස් කරන්න බැහැ. English diploma→BA edge එක application eligibility ගැනයි; automatic credit transfer එකක් නෙවෙයි.

**“API fail වුණොත් හෝ garbage output ආවොත්?”**

Typed validation, known-ID checks සහ time/call bounds අසමත් වුණොත් deterministic/curated fallback. `live_ai`, `mixed`, `rules_fallback` actual usage අනුව තබනවා (`services/planner.jac:179`). SDK timeout 8s/retries 0; session 15s. Native tests check missing key, malformed structures, invented IDs and injected provider failure. Browser-to-backend connection failure නම් retry/error පෙන්වයි; client engine එකකින් නිහඬව ප්‍රතිඵල නිර්මාණය කරන්නේ නැහැ.

**“Real මොනවාද, mock මොනවාද?”**

Real: sourced programme identities/partial claims, one sourced application edge and year-scoped retake policy. Unknown: complete real fees, many admissions/current-intake/professional-recognition claims. Mock: explicit demo catalogue offers and exact 84,000/54,000 cash examples. Retake expenses student-entered scenario estimates. They are not institutional fees.

**“Student state shared catalogue එකට ලියනවද?”**

Application API through catalogue writes නැහැ. Search branch qualification lists copy කරයි (`services/engine.jac:343`); lens findings walker instance තුළයි (`:352`, `:371`); planner state local variables තුළයි (`services/planner.jac:74`). Isolation tests exercise sibling branches, two profiles and guide requests. Graph ownership/authentication for unrelated users is not inferred from these anonymous request-isolation checks.

**“Agent council සහ memory කොහෙද?”**

Development සඳහා වෙන වෙනම reviewer/engineer roles තිබුණා. Runtime එකේ independent LLM agents debate කරන council එකක් නැහැ. Three lens executions deterministic; Bridge findings derived. `memory.md` engineering record එකක්; persistent student-agent memory එකක් නෙවෙයි. Guide history browser-session context එකක් පමණයි. මේ වෙනස presentation එකේ පැහැදිලිව කියන්න.

## 8. ඉල්ලූ extra capabilities — ඇත්ත තත්ත්වය

| Capability | Status | ඉවර කිරීමේ වටිනාකම |
| --- | --- | --- |
| Gap Finder | PARTIAL | Unknown fields, blocked reasons, prerequisites සහ shortfall දැනට තිබෙනවා. Structured route-specific “unmet requirement → next action” view එක තවම නැහැ. හොඳ extension එකක්; scope කුඩාව තබන්න. |
| Minimum Change Finder | PARTIAL | Known-cost route එකට extra initial savings exact ගණනය වෙයි; user can manually change profile/replan. Automatic minimal budget/relocation counterfactual search නැහැ. Real unknown costs වලට මුදලක් invent නොකළ යුතුයි. |
| Action Plan checklist | PARTIAL | Route `next_actions` තුන සහ retake `next_steps` ඇත (`services/engine.jac:286`, `services/retake.jac:101`). Interactive/saved checklist එකක් නැහැ; known deadline completion schedule එකක් නෙවෙයි. |
| LLM-proposed pathway validation | IMPLEMENTED within bounded design | LLM arbitrary new paths propose කරන්නේ නැහැ. Known route IDs, allowed actions and fields validate කරයි; engine remains authoritative. Arbitrary novel-path verifier එකක් කියලා හඳුන්වන්න එපා. |
| Three-scenario stress testing | NOT IMPLEMENTED | එක combined travel+40%/delay+6m scenario එකක් පමණයි (`services/engine.jac:415`). Baseline/retake view එක වෙනම තිබීම three independent stress scenarios බවට ගන්නේ නැහැ. |

## 9. ඉතිරි කාලයට ගැළපෙන ප්‍රමුඛතා

Effort estimates local working estimates; account permissions/network අනුව වැඩි විය හැකියි. Deadline අවට large redesign/runtime migration නොකරන්න.

| Fix / action | Criterion | Minutes | Risk | Before 15:30? |
| --- | --- | ---: | --- | --- |
| 80% counting denominator සහ received-code provenance organiserගෙන් තහවුරු කිරීම | Eligibility | 5–10 | Low; external response dependency | YES — පළමු ක්‍රියාව |
| Accurate reference-style README, current contracts and 150-second script | Presentation/Jac | 10–15 | Low | YES — මේ audit එකෙන් සිදු කර ඇත |
| Current student story එක rehearse කර 150-second video record කිරීම; real/fixture labels පෙන්වීම | Presentation/technical | 15–25 | Low–medium | YES |
| Current UI mobile/keyboard/source/clarification smoke සහ screenshots | Technical | 10–15 | Low; browser availability needed | YES |
| Forced single-choice states වල redundant AI calls skip කිරීම | Latency/cost | 5–10 | Low–medium; planner tests required | OPTIONAL; audit-only scope එකෙන් code වෙනස් කර නැහැ |
| Existing gap/unknown/next-actions එක එක route එකට පැහැදිලි grouping කිරීම | Agentic clarity/impact | 10–20 | Medium; current data reuse only | OPTIONAL if stable rehearsal already done |
| Minimal budget/relocation counterfactual finder | Agentic/impact | 25–40 | Medium–high; unknown-cost semantics | SKIP unless all release items done |
| Two extra independently tested stress scenarios | Technical/creativity | 20–35 | Medium | SKIP for this freeze |
| Reviewed additional real progression edges | Graph/impact | 30–60+ | High evidence/time dependency | SKIP; never synthesize accreditation |
| Genuine CSS deduplication solely for maintainability, with visual regression proof | Technical/line share | 25–45+ | High without browser access | SKIP until counting clarified |
| Large graph ontology rewrite, persistent council/memory, compiler migration | Jac/depth | 60+ | High | NO / SKIP |
| JacHammer import, exact runtime/secret setup and hosted smoke | Delivery | 15–30+ | Medium; host compatibility unknown | After local review; preserve submission buffer |

## 10. තත්පර 150ක demo එක

එක student story එකක් තබන්න: English/language-related higher education කැමති, A/L පසු අඩු මුදලක් සහිත සිසුවෙක්. ඔහුගේම hypothetical budget එකේ mechanics පැහැදිලි කිරීමට explicit fictional fixture toggle එක කෙටිව භාවිත කරනවා. Fictional computing route එක real English degree fee එකක් ලෙස පෙන්වන්නේ නැහැ.

| Time | Screen / narration |
| --- | --- |
| 0:00–0:15 | “A/L පස්සේ එකම මාර්ගයක් නැහැ. UniPath goals, qualifications, money සහ evidence එකට සසඳනවා.” Show real mode and Languages & Media. |
| 0:15–0:40 | Goal English education; synthetic profile; plan. Show real English diploma/degree options, needs_confirmation සහ actual sources. Unknown complete fees are not zero. |
| 0:40–1:00 | Open graph/source views; point to the one diploma→BA application route. Explain no automatic credit exemptions. |
| 1:00–1:25 | Explicitly switch to “fictional demo fixtures”. Savings 2,000/budget 5,000; relocation unknown → answer yes: needs_confirmation becomes conditional. Show direct 84,000/22,000 vs multistep 54,000/0. |
| 1:25–1:45 | Retake: six months, preparation 7,000 monthly +4,000 one-off; savings 2,000/contribution 5,000. Show 46,000 spend/14,000 extra initial savings; income forgone is separate. |
| 1:45–2:10 | Briefly show actual `node/edge`, `visit/here` and `by llm` source. Show planner operational events and its actual mode; do not imply graph backtracking is private LLM reasoning. |
| 2:10–2:30 | Impact and limits: across fields, sources/unknowns, no admission guarantee. State hosted URL only if it was actually verified; close with next real-world validation step. |

### Live fail වෙන්න ඉඩ වැඩි තැන් තුන

1. **Gemini quota/network/model access:** choose honest rules_fallback/curated mode; keep a clearly labelled recording of a successful prior live_ai run. Cached/recorded output live කියන්න එපා. Provider outage එකක් හදාගන්න stage එකේ spend කරන්න එපා.
2. **Unknown fees/intakes prevent a complete financial result:** show the real unknown state and official source, then explicitly labelled fixture for numerical engine proof. No guessed tuition number.
3. **JacHammer runtime/client/static compatibility or venue connection:** retain the verified local server and a current recorded demo. Hosting optional බව කියන්න; unverified URL live ලෙස නොපෙන්වන්න.

## 11. JacHammer මඟින් ඉතිරි වැඩ කිරීම ගැන

Tested repo එක import කර hosting පරීක්ෂා කිරීම හොඳ ඊළඟ පියවරක්. [JacHammer official page](https://jachammer.ai/) public-repo import සහ sandbox hosting විස්තර කරනවා. ඒක අපේ pinned runtime එක compatible බවට සාක්ෂියක් නෙවෙයි; linked docs මේ web tool එකෙන් ලබාගන්න බැරි වුණා.

මුලින් Jac 0.16.7/byLLM 0.6.19 සහ native client support තහවුරු කරන්න. Host server-secret environment එක configure කරන්න. Health, all-field plan, source lookup, retake, guide, stress, five PNGs සහ forbidden endpoints smoke කරන්න. Host එක newer runtime එකක් බලකරනවා නම් submission ළඟ compiler migration එකක් ආරම්භ නොකර local/video backup භාවිත කරන්න. AI builder එකෙන් architecture එක නැවත ලියවීම agentic score හෝ eligibility ගැටලුවට ස්වයංක්‍රීය විසඳුමක් නෙවෙයි.

## අවසන් ප්‍රමුඛ ක්‍රියා තුන

1. **80% method සහ coding-hour provenance තහවුරු කරගන්න.** Software quality ඉහළ වුණත් eligibility ගැටලුවක් ඉතිරි වුණොත් prize අවදානම නැති වෙන්නේ නැහැ.
2. **අලුත් UI එකෙන් තත්පර 150ක පැහැදිලි demo එක record කරන්න.** Real data, fixture math සහ actual planner events වෙන්ව පෙන්වන්න.
3. **Verified commit එක JacHammerට import කර scoped hosting check කරන්න**, pinned runtime compatible නම්; local/video fallback සහ submission buffer තබන්න.

“Agentic ගතිය තියෙනවද?” — **ඔව්, සැබෑ නමුත් සීමිත agentic orchestration එකක් තියෙනවා.** “ඉතා උසස් autonomous council එකක්ද?” — **නෑ; වර්තමාන code එක ඒක තහවුරු කරන්නේ නැහැ.** මේ prototype එකේ ශක්තිය වන්නේ graph/rule correctness, honest evidence සහ practical student trade-offs. ඒවා නිවැරදිව පෙන්වීමයි ඉතා අඩු අවදානමකින් ලකුණු වැඩි කළ හැකි මඟ.
