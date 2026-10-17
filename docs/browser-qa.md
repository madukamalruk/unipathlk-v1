# Local browser QA — core journey evidence

Checked on 17 October 2026. The core local browser journeys below were completed by the root/UI verification run. This document records those verified run notes and selected actual CUA captures; it is not a claim of all-device coverage, full accessibility compliance or production readiness.

The application uses Python 3.12, Jac 0.16.7 and byLLM 0.6.19. The final genuine AI-assisted browser journey used the local adapter build on port 8004. This is distinct from the separate key-free backend/HTTP regression server and is not a deployed-site check. Current confirmed automated counts belong in [the test matrix](test-matrix.md).

## Completed local checks

| Journey | Observed result | Evidence and scope |
| --- | --- | --- |
| Desktop business/accounting | A Commerce profile with an accounting goal returned business/accountancy discovery results. Subject-term alignment was visible; results remained within the selected field. | [Business results](screenshots/business-results.jpg). Alignment is editorial discovery vocabulary, not a professional or admission assurance. |
| O/L English clarification | Missing O/L English produced a relevant question. Submitting an F-grade answer triggered fresh evaluation and changed the route results for the known English condition. | The [AI activity capture](screenshots/ai-assisted-activity.jpg) shows the missing-English question. The F-grade update was observed during the interaction; the still capture alone does not show both states. |
| Claim evidence | Expanding Sources & claim checks showed separate source links, status labels and check dates. A verified programme identity coexisted with unreviewed admission information. | [Expanded evidence](screenshots/claim-evidence.jpg). Programme existence does not establish fees, selection, recognition or an open intake. |
| Incomplete-cost stress | The real-catalogue stress journey retained unknown/not-confirmed values when essential costs were missing, rather than presenting fabricated numeric totals. | Verified interaction; baseline [business evidence view](screenshots/claim-evidence.jpg) also shows unknown costs. No screenshot of a numeric real-cost estimate is asserted. |
| Genuine AI-assisted planning | The port-8004 request displayed AI-assisted planning with server rule checks and actual search_alternatives, evaluate_candidates and ask_student activity. The captured request had no fallback banner. | [Actual AI activity](screenshots/ai-assisted-activity.jpg). This verifies the observed request, not a general model reliability or latency guarantee. |
| Mobile hospitality | The core mobile check used a 390px viewport. Profile/results content and hospitality route information were usable in the narrow layout. | [Mobile hospitality](screenshots/mobile-hospitality.jpg). The exported capture is the actual observed app view; this is not a device-matrix audit. |
| Dark theme and keyboard | The mobile theme switched to dark, and keyboard access/visible focus were checked on the core controls. | [Dark mobile view](screenshots/mobile-dark.jpg). A full WCAG or assistive-technology audit is not claimed. |
| Fictional multi-stage finance | With LKR 2,000 savings and LKR 5,000 monthly budget, the fictional Foundation → Diploma → Top-Up route showed LKR 54,000 total, zero initial savings gap and 12 months, conditional on stage completion and relocation. | [Fictional multi-stage result](screenshots/fictional-multistage.jpg). These are software test fixtures, not real programmes or fee quotations. |
| Fictional direct finance | The same fictional profile showed LKR 84,000 total and a LKR 22,000 initial savings gap for the direct route, labelled as not fitting the current inputs. | [Fictional direct result](screenshots/fictional-direct.jpg). It is a deliberately hand-checkable contrast, not a market comparison. |
| Network error and retry | A failed connection produced a user-facing error/retry state. Retrying recovered the journey while retaining profile information. | Verified interaction. No fabricated success was shown while the request was unavailable. |
| Stale-result guard | Editing inputs marked prior results as needing an update; stress actions required a current submitted profile. Re-evaluation used the updated profile. | Verified interaction. The client also uses request revision tickets; this observation is not an exhaustive browser race-condition test. |

## Actual screenshot set

The eight images in [screenshots/](screenshots/) were copied byte-for-byte from the selected local CUA captures. They are actual application views, not generated mockups. No credentials or configuration screens are included.

- [Desktop home](screenshots/desktop-home.jpg)
- [Business results](screenshots/business-results.jpg)
- [Claim evidence](screenshots/claim-evidence.jpg)
- [AI-assisted activity](screenshots/ai-assisted-activity.jpg)
- [Mobile hospitality](screenshots/mobile-hospitality.jpg)
- [Mobile dark theme](screenshots/mobile-dark.jpg)
- [Fictional multi-stage result](screenshots/fictional-multistage.jpg)
- [Fictional direct result](screenshots/fictional-direct.jpg)

The activity image was replaced only after a genuine successful browser AI request. Its content reports AI-assisted planning; the source filename alone was not treated as evidence.

## Prepared walkthrough

[demo-walkthrough.mp4](https://github.com/madukamalruk/unipathlk-v1/blob/main/docs/demo-walkthrough.mp4) is a **150-second captioned walkthrough assembled from nine captured local app views, with no audio**. It is not a continuous screen recording and does not show live clicks between still views. [Video notes](https://github.com/madukamalruk/unipathlk-v1/blob/main/docs/demo-video-notes.md) disclose each source scene and its limits. Metadata checks establish H.264, 1920×1080, 12fps and no audio stream; encoded scene frames were visually reviewed.

The video and screenshots retain the important distinctions: the real catalogue is a 31-programme, 12-field discovery sample; complete real costs remain unknown; the financial examples are explicitly fictional; and a programme listing does not guarantee admission, registration or a career.

## Remaining boundaries

The public repository and walkthrough are published on GitHub. Source composition has been measured, while the organiser’s counting method is unconfirmed. The planner fix passed clean checking and 35 native tests; all seven authoritative HTTP checks passed on the latest typing-fix revision; hosted Linux CI [run #2](https://github.com/madukamalruk/unipathlk-v2/actions/runs/39014838908) passed for source commit `a5ff6d5`. Hosting is deferred by the user until local review, and event submission remains separate release work. These local browser checks do not verify institutional selection, current complete fees, professional recognition, every transfer, all browsers/devices or distributed load behavior. A source/build change should trigger rechecking of the affected journeys.

Publication: [repository](https://github.com/madukamalruk/unipathlk-v1), [captioned walkthrough](https://github.com/madukamalruk/unipathlk-v1/blob/main/docs/demo-walkthrough.mp4), [pitch PDF](https://github.com/madukamalruk/unipathlk-v1/blob/main/docs/pitch-deck.pdf). Initial published commit: `d2f41e823edb7f940b32d0d3de24ab5d6290fb46`. Final event submission remains pending. Hosting is deferred by the user until local review.
