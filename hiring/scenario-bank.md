# Hiring Scenario Bank
version: 1.0 | owner: HIRING MANAGER (Jordan Reyes)

One scenario per role category. Use the scenario that best surfaces the specific gap the team is hiring for. Scenarios are realistic, ambiguous, and require the candidate to make a judgment call — not just follow a procedure.

---

## Infrastructure

### Cloud Engineer
**Setup:** Your Terraform plan output includes a `destroy` action on a production S3 bucket. The ticket that triggered this run says "clean up unused buckets." The bucket name matches a pattern used for legacy environments, but you cannot immediately confirm it is unused — there is no tagging standard and the lifecycle policy was recently removed. The plan is queued to apply in 10 minutes via CI.

**Question:** What do you do?

**Strong answer includes:**
- Immediately blocks the CI run before the plan applies
- Does not delete anything until bucket usage is confirmed (CloudWatch access logs, last-modified timestamp, reference scan)
- Tags the bucket as "under review" pending confirmation
- After the incident: proposes a tagging standard and a mandatory review gate for `destroy` actions in Terraform plans

**Weak answer:** Proceeds with the plan because the ticket says to, or delays without blocking the CI run.

---

### SRE
**Setup:** Your error rate SLO is 99.9% availability (10-minute rolling window). The current error rate has been at 0.15% for 8 minutes. The on-call developer says "it's just a noisy third-party dependency, not a real user impact. Ignore it." The SLO window expires in 2 minutes. If the error rate does not drop below 0.1% in that window, the burn rate for the month trips.

**Question:** What do you do?

**Strong answer includes:**
- Treats the SLO burn as real regardless of perceived root cause — the SLO protects user experience, not internal convenience
- Escalates immediately if they cannot confirm the error source in 2 minutes
- Does not accept "noisy dependency" as a reason to ignore an SLO violation — that explanation is hypothesis, not evidence
- After the incident: if the dependency is genuinely noisy, opens a formal proposal to adjust the SLO or add a circuit breaker — does not just add a permanent ignore rule

**Weak answer:** Trusts the developer's assessment without evidence and lets the SLO burn.

---

### DevOps Pipeline Engineer
**Setup:** A developer opens a ticket asking you to add their personal AWS credentials to the CI pipeline as environment variables so they can test a deployment script locally from the pipeline runner. The pipeline runs on GitHub Actions. They say "it's just temporary."

**Question:** What do you do?

**Strong answer includes:**
- Refuses personal credentials in CI — explains that CI credentials must be scoped to the pipeline's service account, not an individual's access
- Offers to help set up proper role-based access (OIDC for GitHub Actions, or a dedicated CI IAM role)
- Does not add any credentials — temporary is how secrets stay in CI permanently
- Flags this to Security Engineer if the developer pushes back

**Weak answer:** Adds the credentials with a note to "remove later."

---

## Backend

### Backend Developer
**Setup:** You receive a ticket to add a new API endpoint: `GET /users/{user_id}/orders`. It returns a user's complete order history. The ticket has no mention of pagination, rate limiting, or access control. The orders table has 50 million rows and no index on `user_id`. The ticket is marked P1.

**Question:** What is the first thing you do?

**Strong answer includes:**
- Does not write the endpoint before addressing the missing requirements
- Goes back to TECH LEAD (or whoever owns the spec) with three specific blockers: missing pagination spec, missing auth/access control definition, missing index (a full table scan on 50M rows will kill the database)
- Notes the P1 pressure but explains that shipping an endpoint that scans 50M rows unindexed is not shipping — it is creating an incident
- Offers a draft spec with sensible defaults (cursor-based pagination, 100-row limit, index migration) for TECH LEAD to approve or revise

**Weak answer:** Writes the endpoint without pagination, or adds pagination without flagging the index or auth issues.

---

### Fullstack Developer
**Setup:** You are building a feature that needs user preferences stored server-side. The PM says "just put it in localStorage for now." The UX Designer's wireframe shows the preferences appearing consistently across devices. You are the only developer on this task.

**Question:** What do you do?

**Strong answer includes:**
- Identifies the conflict: localStorage is device-local; cross-device consistency requires a server-side store
- Does not implement localStorage and let the inconsistency ship — that is technical debt with a user-visible symptom baked in
- Goes back to PM with the conflict: "the wireframe requires server-side storage; localStorage will break the cross-device requirement; how do you want to scope this?"
- If PM says "ship localStorage now and server-side later," documents the decision explicitly and creates a ticket for the follow-up — does not silently accept inconsistency

**Weak answer:** Implements localStorage and moves on, or implements a full server-side store without flagging the scope change to PM.

---

## Frontend

### Frontend Developer
**Setup:** You pick up a ticket to implement a new notification settings screen. The Figma file has been handed off from UI Designer. The design uses a color `#1A73E8` that does not exist in the design token system. The component — a toggle group — does not exist in the component library. The ticket is due in two days.

**Question:** What do you do before writing a line of code?

**Strong answer includes:**
- Does not hardcode `#1A73E8` — flags the token gap to UI Designer before implementation begins
- Does not build the toggle group in isolation — confirms with UI Designer whether this should be added to the design system or documented as a formal exception
- Does not assume the design is final if required states (disabled, loading, error) are not shown in the Figma frames — asks before building
- Only starts coding once the token is resolved and component scope is clear

**Weak answer:** Hardcodes the color and builds the component for this screen only, with no design system coordination.

---

### Mobile Developer (Android)
**Setup:** You are implementing a new feature that requires reading the user's location in the background (while the app is not in the foreground). The feature works correctly on the Pixel 6 you use for development. QA is testing on a Galaxy A32 (Android 11, mid-range). The feature is not working on the A32.

**Question:** What do you do?

**Strong answer includes:**
- Does not assume the Pixel 6 result is representative — mid-range devices have different battery optimization and background process restrictions
- Checks manufacturer-specific battery optimization settings (Samsung's "Sleeping apps" list is a common culprit)
- Tests on at least one additional mid-range device or emulator profile before declaring the issue resolved
- Documents the device-specific behavior and adds it to the QA test matrix
- If the issue is a known Android OEM restriction: evaluates whether the feature can be redesigned to not require background location, or documents the limitation explicitly in the app

**Weak answer:** Closes the bug as "not reproducible" based on the Pixel 6 result.

---

### Mobile Developer (iOS)
**Setup:** You are implementing push notifications for a new feature. The notifications work correctly in the iOS Simulator. You submit a TestFlight build. The QA tester reports that notifications are not appearing on their iPhone 13 (iOS 16.4). The Simulator was running iOS 17.

**Question:** What do you do?

**Strong answer includes:**
- Does not trust Simulator results for push notifications — Simulator APNs behavior is not production-equivalent
- Checks the APNs certificate / provisioning profile for the correct environment (development vs. production)
- Tests on a physical device immediately — does not iterate on the Simulator
- Checks the iOS version delta: iOS 16.4 vs. 17 may have notification permission API differences — reads the diff
- After resolving: adds physical device testing as a mandatory step in the push notification test plan

**Weak answer:** Insists the feature works because the Simulator showed it working.

---

## Design

### UI Designer
**Setup:** You are designing a new notification settings screen. The UX wireframe shows 12 toggles with no grouping, no section headers, and no indication of priority. The wireframe has no disabled state, no loading state, and no empty state defined. PM wants a high-fidelity mockup by end of week.

**Question:** What do you do before opening Figma?

**Strong answer includes:**
- Does not start in Figma with an incomplete wireframe — goes back to UX Designer with specific missing items: disabled state (what happens when notifications are system-controlled?), loading state (what shows while preferences save?), empty state (first-run experience?)
- Does not accept 12 ungrouped toggles as the final IA — flags the grouping gap to UX Designer, not PM
- Checks whether a toggle component and notification settings pattern already exist in the design system before designing anything new
- Only opens Figma when all 8 required states are defined and the IA makes sense

**Weak answer:** Opens Figma and designs the default state only, leaving the other states for "later."

---

### UX Designer
**Setup:** The PM asks you to add a "confirm before delete" modal to the account deletion flow. They reference three competitor products that do this. No user research is cited. The sprint starts Monday. You have not spoken to any users about this flow.

**Question:** What is your response?

**Strong answer includes:**
- Does not design the modal without understanding the actual user problem
- Asks: what data shows users are accidentally deleting accounts? What does support say about this? Is the issue frequency and severity high enough to add friction to the deletion flow?
- Points out that "competitors do it" is not evidence of effectiveness — it may be cargo-culted from a pattern that doesn't work
- Proposes lightweight research before sprint: 5 user interviews or a review of support tickets for accidental deletion
- If PM confirms the sprint cannot wait: designs the modal but documents the assumption and flags it for validation post-launch

**Weak answer:** Designs the modal because "PM asked for it."

---

## Data / ML

### Data Engineer
**Setup:** A data analyst files a ticket: "the revenue dashboard is showing incorrect numbers." You check the pipeline. The ETL job ran successfully — no errors logged. The dashboard query looks correct. But the numbers are off by approximately 3% compared to the source system.

**Question:** What do you do?

**Strong answer includes:**
- Does not close the ticket because the ETL "ran successfully" — success status means the job completed, not that the data is correct
- Investigates data quality at every stage: source extraction count vs. load count, any dedup logic, timezone handling, currency conversion, any recent schema changes in the source system
- Identifies whether the 3% is consistent (systemic error) or variable (data loss or duplication at a specific step)
- Does not touch the production pipeline until the root cause is confirmed
- After resolution: adds a row-count reconciliation check and a revenue-sum sanity check as pipeline monitoring

**Weak answer:** Concludes the pipeline is working because there are no errors and asks the analyst to check their query.

---

### ML Engineer
**Setup:** Your classification model has 94% validation accuracy. Business stakeholders want 96%. Your manager says "just add more layers to the neural network." The model is already showing signs of overfitting on the validation set (validation loss is higher than training loss).

**Question:** What do you say to your manager?

**Strong answer includes:**
- Explains that adding layers to an overfitting model will make overfitting worse, not better — accuracy will not improve; it will decrease
- Proposes the correct levers: more training data, stronger regularization (dropout, L2), data augmentation, or revisiting the feature engineering
- Presents this as a concrete diagnosis, not just pushback: "validation loss > training loss is the signature of overfitting; adding layers is the wrong tool here; here is what will actually move the needle"
- Does not just add layers to satisfy the manager

**Weak answer:** Adds more layers or agrees to try it without surfacing the overfitting diagnosis.

---

### AI Prompt Engineer
**Setup:** A developer asks you to write a system prompt for a customer support chatbot. Their requirement: "make it helpful, professional, and don't let it say anything bad." The bot will handle billing disputes, account access issues, and refund requests. There is no safety evaluation framework in place and no escalation path defined for situations the bot cannot handle.

**Question:** What do you do before writing the prompt?

**Strong answer includes:**
- Does not write the prompt without a defined escalation path — a bot that handles billing disputes with no human fallback is a liability
- Asks for: the specific failure modes the bot must refuse (PCI data, legal threats, harassment), what "can't handle" looks like and where it routes, what the acceptable hallucination risk is for financial information
- Designs the prompt with explicit refusal patterns, a defined out-of-scope response, and a clear human handoff trigger
- Insists on a red-teaming pass before deployment — not just "make it professional"

**Weak answer:** Writes a helpful-sounding prompt and ships it without safety boundaries or an escalation path.

---

## Quality

### QA Engineer
**Setup:** You file a bug: "checkout flow crashes when coupon code contains a special character (e.g., 'SAVE-20%')." The developer marks it "Cannot Reproduce" and adds a comment: "tested with SAVE20, works fine." You have reproduced the crash three times on your machine, with video evidence.

**Question:** What do you do?

**Strong answer includes:**
- Does not accept "Cannot Reproduce" without a response — provides exact reproduction steps, the test environment spec (OS, browser, app version), and links the video evidence
- Asks the developer to confirm they tested with the special character, not a sanitized version
- If the developer still cannot reproduce: sets up a pairing session to reproduce together — the goal is resolution, not being right
- Does not close the bug; escalates to TECH LEAD if the developer continues to dismiss it after evidence is provided

**Weak answer:** Accepts the "Cannot Reproduce" status or re-files the same bug without addressing the reproduce gap.

---

### QA Manual (Exploratory)
**Setup:** You are doing exploratory testing on a payment flow. The happy path passes: single item, single payment, confirmation email arrives. You discover that submitting the payment form twice in rapid succession (double-click or network delay) creates duplicate orders — two charges appear on the test card. The developer who built the feature is not available.

**Question:** What do you do?

**Strong answer includes:**
- Files a P0/critical bug immediately — duplicate payment charges are a financial and user trust issue
- Documents the exact reproduction steps, the timing window (how fast the double-submit needs to be), and the evidence (two order IDs, two charge records in the test dashboard)
- Does not wait for the developer to be available — escalates to TECH LEAD or whoever is the on-call decision-maker
- Flags that this likely indicates missing idempotency handling on the payment endpoint — names the root cause hypothesis in the ticket so the developer can go straight to the likely fix
- Recommends blocking the release until resolved

**Weak answer:** Files the bug normally and waits, or marks it "not part of the happy path test cases."

---

### QA Automation
**Setup:** Your end-to-end test suite takes 45 minutes to run in CI. The team is pushing 8–10 PRs per day and the feedback loop is killing velocity. A developer suggests "just skip the e2e tests on feature branches and only run them on main." You disagree.

**Question:** What do you propose instead?

**Strong answer includes:**
- Rejects "skip on feature branches" — that moves the regression signal to where it is most expensive to fix
- Diagnoses the 45-minute runtime: identifies the slowest tests, checks for unnecessary waits/sleeps, checks for test isolation issues requiring full environment resets between tests
- Proposes targeted fixes: parallelization, test tagging to run only affected test areas on PRs, moving smoke tests to the fast lane and full suite to merge queue
- The goal is a <10 minute fast lane for PRs with the full suite still running before merge — not eliminating coverage

**Weak answer:** Agrees to skip e2e on feature branches, or proposes a new testing tool without addressing the root cause.

---

## Security

### Security Engineer (AppSec)
**Setup:** A PR adds a new internal API endpoint. The code builds an SQL query using string concatenation with a user-supplied `filter` parameter: `query = "SELECT * FROM logs WHERE level = '" + filter + "'"`. The developer's PR description says: "This endpoint is internal only — it's behind the VPN, not user-facing."

**Question:** What is your review?

**Strong answer includes:**
- Marks this a blocking issue — "internal only" does not make SQL injection acceptable
- Explains specifically why: insider threat, SSRF via a different vulnerability, compromised internal network, or future exposure when internal becomes external
- Requires parameterized queries — not input sanitization, not a regex allowlist
- Does not approve the PR until the fix is in
- Notes this pattern in the security review log so it can be checked for in other PRs

**Weak answer:** Approves with a comment to "consider parameterized queries" or accepts the "internal only" rationale.

---

### Security Engineer (Infra)
**Setup:** A cloud engineer's Terraform PR provisions a new S3 bucket for storing build artifacts. The bucket has `block_public_access = false` to "allow CI to push without role configuration." No bucket policy is defined. The engineer says the bucket won't contain sensitive data.

**Question:** What do you do?

**Strong answer includes:**
- Blocks the PR — `block_public_access = false` with no bucket policy means the bucket is world-readable if any object ACL is set to public
- "Won't contain sensitive data" is an assertion, not a control — build artifacts can contain secrets, credentials in env files, or compiled binaries that reveal application structure
- Requires: `block_public_access = true`, a bucket policy restricting access to the CI role, and server-side encryption
- Offers to help configure OIDC for the CI runner so role assumption works without disabling access controls

**Weak answer:** Approves because "it's just build artifacts."

---

## Streaming / Media

### Audio/Streaming Engineer
**Setup:** Your Discord music bot serves a 24/7 stream sourced from an Icecast mount point. The source stream goes down. Users start hearing silence. The bot's reconnect logic runs but has not successfully reconnected in 30 seconds. You have a backup source pre-configured in Liquidsoap but it has not automatically activated.

**Question:** What do you do, and what do you change after the incident?

**Strong answer includes:**
- Immediate: checks Icecast admin panel for mount point status; manually triggers the Liquidsoap fallback source; confirms audio is flowing to the Discord voice connection before declaring recovery
- Identifies the reconnect failure root cause: is Liquidsoap not detecting the source dropout, or is the fallback trigger misconfigured?
- After the incident: reduces the reconnect timeout from 30s to 5s with exponential backoff; adds silence detection to the Liquidsoap pipeline so fallback triggers automatically on silence, not just on connection loss; adds a Prometheus alert on buffer fill level that fires before the silence reaches users; tests the full failure/recovery cycle in a staging environment

**Weak answer:** Manually restarts the bot without addressing the fallback configuration, or focuses only on the Discord voice connection without diagnosing the Icecast source outage.

---

## Management

### Product Manager
**Setup:** Engineering estimates 8 weeks for a feature you've committed to deliver to key stakeholders in 5 weeks. The engineering estimate is based on a technical spec the team wrote after scoping the full feature. You cannot easily move the stakeholder deadline — it was announced publicly.

**Question:** What do you do?

**Strong answer includes:**
- Does not ask engineering to "just make it work in 5 weeks" — that converts a scope problem into a crunch problem
- Goes back to the stakeholder commitment: is the 5-week date fixed or is there room to negotiate based on a subset of the feature?
- Works with engineering to identify a "5-week slice" — the minimum subset of the feature that delivers the announced value — and a "8-week full version"
- Communicates the trade-off to stakeholders proactively: "here is what ships in 5 weeks; here is what ships in 8"
- Does not hide the gap and hope engineering finds 3 weeks somewhere

**Weak answer:** Pressures engineering to deliver in 5 weeks without scoping down.

---

### Project Manager
**Setup:** Sprint 3 starts Monday. Two of four developers are blocked waiting for API contracts from a partner team. The partner team has not responded to Slack messages in 3 days. Your Sprint 3 velocity plan assumes all four developers are active.

**Question:** What do you do before Monday?

**Strong answer includes:**
- Escalates the partner team dependency to a decision-maker — not another Slack message, a direct escalation to whoever owns that team
- Reforecasts the sprint with two developers — does not plan for four and hope for the best
- Identifies work the two blocked developers can do that does not require the API contracts (mock-based frontend work, documentation, test scaffolding, tech debt)
- Updates the sprint plan to reflect realistic capacity and communicates the change to stakeholders before the sprint starts — not after it ends short

**Weak answer:** Starts the sprint at full capacity and adjusts "when the contracts arrive."

---

### Scrum Master
**Setup:** The development team consistently finishes sprint work early and asks for additional tickets. Sprint velocity is high. However, at every Sprint Review, the team says "there is nothing ready to show" — features are coded but not integrated, or integrated but not deployed to the demo environment, or deployed but with known bugs the team says will "be fixed next sprint."

**Question:** What is happening and what do you do?

**Strong answer includes:**
- Diagnoses the pattern: "done" is being defined as "code merged" rather than "shippable" — the team is completing work by a narrow definition that does not include integration, deployment, and quality
- Does not address this by adding more ceremonies — the problem is a Definition of Done gap
- Facilitates a Definition of Done workshop: works with the team to agree on what "done" means (deployed to staging, passes acceptance criteria, no known P0 bugs, demo-able)
- After the DoD is updated: Sprint Review should have demonstrable work because "done" now requires it
- Does not blame the team — the system created this; fix the system

**Weak answer:** Adds a "demo prep" task to every ticket, or accepts that Sprint Reviews will just not have demos.

---

## Documentation

### Technical Writer
**Setup:** You are documenting a new REST API endpoint. The developer says "just use the code as the spec." The code has no inline comments, the function names are abbreviated, and there are no error codes documented — the endpoint returns HTTP 200 for both success and certain error conditions, with the error described in the response body.

**Question:** What do you do?

**Strong answer includes:**
- Does not accept code-as-spec — code describes implementation, not behavior from the consumer's perspective
- Sets up a structured interview with the developer: what does the endpoint do in plain language, what are the valid inputs, what are the error cases and their response formats, what is the expected behavior on retry?
- Specifically flags the HTTP 200 for errors issue: this is an API design problem that will confuse consumers and needs to be documented prominently even if not fixed (and flagged to BACKEND DEVELOPER for future consideration)
- Writes the documentation from the API consumer's perspective — not the implementer's
- Tests every code example in the documentation against the live endpoint before publishing

**Weak answer:** Documents what the code appears to do without speaking to the developer or testing the examples.

---

## Database

### DBA
**Setup:** A backend developer wants to add an index on the `email` column of the `users` table. The table has 200 million rows and is in production. They want to run the `CREATE INDEX` statement during business hours because a query is running slow in production and users are complaining.

**Question:** What do you say?

**Strong answer includes:**
- Does not allow a blocking `CREATE INDEX` on a 200M-row table during business hours — it will lock the table (or degrade write performance severely) for minutes to hours
- Requires `CREATE INDEX CONCURRENTLY` (PostgreSQL) or the equivalent non-blocking syntax for the relevant database — this builds the index without a table lock, at the cost of taking longer
- Schedules the operation for a low-traffic window even with concurrent build — concurrent indexing on 200M rows still consumes significant I/O
- Checks whether the slow query can be addressed immediately with a query hint or a short-term workaround while the index is built safely
- Reviews the query plan before and after to confirm the index will actually be used

**Weak answer:** Runs `CREATE INDEX` during business hours, or refuses without offering a safe path forward.

---

## Hiring Manager
**Setup:** A role comes to you as HIRING MANAGER with the following request: "We need a DevSecOps engineer who can do security reviews AND deploy the infrastructure they reviewed." This role was requested by the PROJECT MANAGER who says the team is moving too slowly because security reviews are a bottleneck.

**Question:** What is your response?

**Strong answer includes:**
- Identifies the RULE 18 violation immediately: this is a security + implementation combination — the role being proposed would review and deploy the same infrastructure, eliminating independent review
- Does not bring this to the CEO — this is a prohibited combination under RULE 18; it gets closed by HIRING MANAGER, not escalated
- Closes the proposal and goes back to PROJECT MANAGER with the reason in one sentence and the correct alternative: if review is the bottleneck, the fix is process (asynchronous review, faster turnaround SLA for SECURITY ENGINEER Infra) — not a combined role that creates a conflict of interest
- Also applies the algebraic mixing check: DEVOPS ENGINEER + SECURITY ENGINEER Infra in memory can cover deployment + security review as sequential tasks — which is the correct pattern

**Weak answer:** Escalates the proposal to the CEO without flagging the RULE 18 violation, or approves it because "the team needs to move faster."
