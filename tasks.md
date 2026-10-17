# Implementation record — 2026-10-17

Owner deadline: **17:00 Asia/Colombo**. Earlier hosting deferral is superseded by the owner's request to prepare this repository for JacHammer import/pull. Current work is U12 below; actual hosted verification remains separate.

| Work | Status | Acceptance evidence |
| --- | --- | --- |
| U01–U05 baseline | DONE | Original 34-file backup/hashes; pinned Python 3.12/Jac 0.16.7/byLLM 0.6.19; graph, rules, cash flow and typed planner; prior Linux CI passed at a5ff6d5. |
| R01 real/student evidence | DONE | 37 programmes, 12 domains, seven providers; six practical alternatives; year-scoped official UGC retake evidence. |
| R02 retake scenario | DONE | Separate, immutable estimates; fixture 46,000 spending / 14,000 extra initial savings / 6,000 separately stated income forgone. No admission prediction. |
| R03 dashboard/comparison | IMPLEMENTED / SCOPED REVIEW | Native build/check passed; owner confirms retake tab opens. New mobile, keyboard and comparison interactions remain independently unverified. |
| R04 clock/study guide | IMPLEMENTED / SCOPED REVIEW | Owner confirms guide panel opens; real guide call live_ai, three known programmes/three official sources in 2.05s. Clock ticks, focus and Escape remain independently unverified. |
| R05 relevant security | DONE / LIMITS | Input, body, path, account-surface and model-output boundaries verified; process-local limits are not a distributed abuse-control system. |
| R06 regression verification | DONE | 18 authored Jac modules checked; 54 native tests and ten explicit HTTP groups pass. Earlier 71 overlapping cases consolidated into 54 meaningful cases. Native client builds locally. |
| R07 release records / publication | DONE | Source published at 92b9d31; redacted exact-secret scan clean; native bundle rebuilt; [Linux CI](https://github.com/madukamalruk/unipathlk-v2/actions/runs/39018179217) passed checker/native/HTTP steps for that source. |
| U08 JacHammer | RESUMED AS U12 | Owner requests compatibility on repository import/pull. No observed hosted URL yet. |
| U09 presentation | PREPARED / REHEARSAL NEEDED | Updated script/description; existing PDF/PPTX and 150-second silent video depict the prior release. Submission is not performed. |

## U12 — JacHammer repository import/pull compatibility

Status: **IMPLEMENTED / LOCAL VERIFIED**. Owner resumes compatibility work using official JacHammer docs. Root owns runtime/configuration/scripts/docs; independent test engineer owns T55/T56 and H12/H13. Added explicit fullstack/Python configuration, portable pinned setup/start, exact configured proxy origins and host-environment precedence. Removed the misleading static localhost index; native client/root serving preserved. CI now builds the client and verifies actual HTML/JS/CSS instead of API-only startup.

Evidence: fresh Python 3.12.12 environment installed all 57 constrained packages; all 18 authored Jac modules pass; 56 native tests pass (0.845s); native client build succeeds; all 13 HTTP groups pass on port 8765, including internal Host/public Origin and exact image/bundle delivery. Shell scripts pass Bash syntax checks; actual Linux launcher execution is left to updated CI. Tracked text credential-pattern scan: zero matches; no real dotenv tracked. [Detailed evidence](docs/jachammer-compatibility.md), [import guide](JACHAMMER_INIT_PROMPT.md). Actual authenticated JacHammer run/public URL remains unobserved; no deployment claim.

## Previous defect loop

Reproduce, isolate, fix, run the affected case and related regressions, record the result. Fixed stale Jac IR by preserving cache backups and using current write times; bounded SDK calls; corrected guide typing and a hospitality question incorrectly classified as generic study advice; validated partial grades and nested subject keys; denied unused framework accounts and unsafe static paths. Prior Linux CI narrowing error was repaired at a5ff6d5.

The browser tool reports a Work-settings block despite owner consent. Owner manual panel confirmation is recorded separately from automated UI verification. No unsupported accessibility, production-readiness or deployment claims.

## U10 — owner-reported broken images (2026-10-17)

Plan: reproduce the PNG 500 response; repair only allowlisted public-image serving in the project Jac adapter; place all five owner-supplied assets in relevant UI surfaces. Check MIME type, byte equality, missing file and traversal rejection through actual HTTP, check changed Jac components and rebuild the native client. No eligibility or AI behavior changes. Status: DONE. Source `2248e2a` published; [Linux CI](https://github.com/madukamalruk/unipathlk-v2/actions/runs/39019439501) passed dependency install, all authored modules, native tests and eleven HTTP groups. Screenshots supplied by the owner demonstrate a real broken-image defect; previous asset presence/build checks did not verify successful binary HTTP delivery.


U10 outcome: original image request reproduced as HTTP 500. Pinned Jac's default `send_static_file` raises `NotImplementedError`; the project adapter now serves only five explicit PNG names using binary bytes and image/png, without modifying the installed runtime or accepting arbitrary file paths. All five assets return 200, exact original bytes and correct MIME; a missing image returns 404; traversal protections remain intact. Five affected Jac modules check successfully, 54 native tests pass (0.318s), eleven actual HTTP groups pass, native client rebuild succeeds. Owner screenshots confirm prior clock/theme/panel rendering, not the new image fix. Independent browser control remains blocked by Work settings.

## U11 — owner-requested judge audit and reference-style README

Plan: read AI-Hackathon-Trial README at reference commit 3262015, use its organisation without copying unsupported claims; re-run pinned entry/check/native/HTTP operations, measure source composition, inspect actual graph/planner/UI/data, distinguish official PDF rules from the pasted older architecture checklist, and publish a candid report plus an accurate README. Application source remains unchanged for this audit. Acceptance: reproducible measurements, file:line evidence, six criterion estimates, prioritised low-risk plan and a 150-second demo script. Status: DONE — README, docs/judge-audit-2026-10-17.md, current runtime contracts and script updated. Application source unchanged; 18 checks/54 native/11 HTTP passed again. Eligibility denominator/provenance, current video and hosted/browser verification remain open as explicitly reported.
