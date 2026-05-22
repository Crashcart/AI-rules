# Hiring Code Test Bank
version: 1.0 | owner: HIRING MANAGER (Jordan Reyes)

Pre-qualification tests run before the scenario interview. Candidates who score below 10/20 do not advance to the scenario stage. Each test is designed to complete in 30–60 minutes and reveal real craft — not textbook knowledge.

Scoring dimensions (same rubric as `hiring/process.md`, applied to code output):
- **Correctness** (1–5): Does the implementation handle all required cases?
- **Code Quality** (1–5): Is it tight, minimal, well-named? No unnecessary verbosity.
- **Error Handling** (1–5): Are failure modes covered — network errors, edge cases, malformed input?
- **Performance** (1–5): Is the approach efficient? No busy loops, unnecessary allocations, or blocking calls where async is required?

**Pass threshold:** 10/20 minimum to advance to the scenario interview.

---

## Infrastructure

### Cloud Engineer
**Task:** Write a Terraform module that provisions a VPC with:
- One public subnet per AZ (minimum 2 AZs)
- One private subnet per AZ
- Internet Gateway for public subnets
- NAT Gateway in the first public subnet for private subnet egress
- A security group that allows HTTP/HTTPS inbound and denies all other inbound by default

Requirements: no hardcoded region, all CIDR blocks as variables with sensible defaults, outputs for VPC ID, subnet IDs, and security group ID.

**Strong output:** Uses `for_each` over AZ list (not hardcoded AZ names), `cidrsubnet()` for CIDR calculation, no `count` where `for_each` is more appropriate, all outputs typed.

**Weak output:** Hardcoded AZs, hardcoded CIDRs, missing outputs, `aws_security_group_rule` resources instead of inline rules where inline is cleaner.

---

### SRE
**Task:** Write a Python function `calculate_burn_rate(prometheus_url, slo_target, window_minutes)` that:
1. Queries the Prometheus HTTP API for the error rate over the given window
2. Computes the burn rate against the SLO target (error_rate / (1 - slo_target))
3. Returns a `BurnRate` dataclass with: `rate`, `budget_remaining_pct`, `window_minutes`, `ts`
4. Raises a typed `PrometheusQueryError` if the query fails

Requirements: typed, uses `httpx` (not `requests`), no external dependencies beyond `httpx`.

**Strong output:** Uses `dataclass(frozen=True)` for return type, custom exception inheriting from `ValueError`, properly handles Prometheus JSON error responses (`.status != "success"`), correct burn rate formula.

**Weak output:** Catches all exceptions silently, returns a dict instead of a typed object, missing the error-response handling, uses `requests.get` (blocking in async contexts).

---

### DevOps Pipeline Engineer
**Task:** Write a GitHub Actions workflow that:
1. Runs on pull requests targeting `main`
2. Runs tests in parallel across Node 18, 20, and 22
3. Runs a lint step (only once, not per Node version)
4. Deploys to staging ONLY when all tests pass AND the PR is labeled `deploy-preview`
5. On deploy failure: posts a comment on the PR with the failed step name

Requirements: uses `actions/checkout@v4`, no shell scripts longer than 3 lines in the `run` block (extract to `.github/scripts/` if needed), the deploy job must have `environment: staging`.

**Strong output:** Uses matrix strategy correctly, `needs:` dependency chain, `if: contains(github.event.pull_request.labels.*.name, 'deploy-preview')`, the failure comment uses `github-script`, `environment:` on the deploy job.

**Weak output:** Sequential jobs instead of matrix, deploy fires without checking labels, no failure notification, hardcoded environment names.

---

## Backend

### Backend Developer
**Task:** Implement a Go (or Node.js/TypeScript) function `listOrders(userID, cursor, limit)` that:
1. Fetches orders for a user from a PostgreSQL table using cursor-based pagination
2. Returns `{ items: Order[], next_cursor: string | null }`
3. The cursor encodes the last seen `created_at + id` (stable sort, handles ties)
4. Handles: invalid cursor (returns 400), limit > 100 (caps at 100), empty result (returns `next_cursor: null`)

Requirements: parameterized queries only (no string concatenation), the cursor must be opaque to the caller (base64-encoded JSON is fine), no ORM.

**Strong output:** Cursor is base64(JSON({ts, id})), query uses `(created_at, id) > ($cursor_ts, $cursor_id)` with a composite index hint in a comment, fetches `limit + 1` rows to determine if there's a next page without a COUNT query, returns typed response.

**Weak output:** Uses OFFSET pagination (slow on large tables), cursor is plaintext ID, no cap on limit, COUNT query for next_cursor detection.

---

### Fullstack Developer
**Task:** Build a Node.js/Express endpoint `GET /api/jobs/:id/status` that:
1. Streams Server-Sent Events (SSE) for a long-running job's status updates
2. Polls a Redis key `job:{id}:status` every 2 seconds
3. Sends a `done` event and closes the stream when status is `completed` or `failed`
4. Closes the stream cleanly when the client disconnects
5. Handles missing job IDs with a proper SSE error event (not an HTTP error — the stream is already open)

Requirements: uses `ioredis`, proper `Content-Type: text/event-stream` headers, `Connection: keep-alive`, no memory leaks on client disconnect.

**Strong output:** Uses `req.on('close', cleanup)` to clear the polling interval, sends `event: error\ndata: {...}` for missing jobs (not `res.status(404)`), sets `Cache-Control: no-cache`, `X-Accel-Buffering: no` for nginx compatibility, typed event payloads.

**Weak output:** No disconnect cleanup (interval runs after client leaves), uses HTTP 404 instead of SSE error event, missing nginx header, polling with `setTimeout` chaining instead of `setInterval`.

---

## Frontend

### Frontend Developer
**Task:** Write a React component `UserList` (TypeScript) that:
1. Fetches `GET /api/users` on mount
2. Shows a skeleton loader while loading (3 placeholder rows)
3. Shows an inline error message with a "Retry" button on failure
4. Shows an empty state with a call-to-action when the array is empty
5. Shows the user list when data is present
6. Each user row has an `aria-label` and the list has `role="list"`

Requirements: uses `React.FC`, custom hook `useUsers()` that returns `{ data, loading, error, refetch }`, no class components, no `useEffect` with missing deps.

**Strong output:** `useUsers` is a separate file, handles the four states (loading/error/empty/data) with distinct UI, `aria-label` on each list item, skeleton uses `aria-busy="true"`, retry calls `refetch()`, no TypeScript `any`.

**Weak output:** All logic inline in the component, missing empty state, missing aria attributes, `useEffect` deps array has `[]` with an `eslint-disable` comment instead of proper dependency management.

---

### Mobile Developer (Android)
**Task:** Write a Kotlin extension function `suspend fun <T> retryWithBackoff(maxAttempts: Int, initialDelay: Long, block: suspend () -> T): T` that:
1. Retries `block` up to `maxAttempts` times on `IOException` or `HttpException`
2. Uses exponential backoff starting at `initialDelay` milliseconds (doubles each attempt)
3. Rethrows the last exception when all attempts are exhausted
4. Does NOT retry on `CancellationException` — it must propagate immediately

Requirements: uses `kotlinx.coroutines.delay`, typed, handles `CancellationException` correctly (rethrow without retry).

**Strong output:** `try/catch` that re-throws `CancellationException` before checking retry eligibility, uses `delay(initialDelay * 2.0.pow(attempt).toLong())`, returns the result of `block()` on success, last attempt rethrows the exception (not wraps it).

**Weak output:** Catches `Exception` without re-throwing `CancellationException` (breaks coroutine cancellation), uses `Thread.sleep` instead of `delay`, wraps the last exception in a new exception type.

---

### Mobile Developer (iOS)
**Task:** Write a Swift async function `fetchUser(id: String) async throws -> User` that:
1. Makes a network request to `GET /api/users/{id}`
2. Defines a typed `NetworkError` enum with cases: `notFound`, `serverError(Int)`, `decodingFailed(Error)`, `invalidURL`
3. Returns a decoded `User` struct
4. Does NOT use any Objective-C era APIs (`URLSessionDataDelegate`, completion handlers)

Requirements: uses `URLSession.shared.data(for:)`, `JSONDecoder`, `Codable` for `User`, throws the correct `NetworkError` case for each HTTP status code range.

**Strong output:** Uses `guard let url = URL(string: ...)` → throws `.invalidURL`, checks `httpResponse.statusCode` and maps 404 → `.notFound`, 500+ → `.serverError(code)`, wraps decoder errors in `.decodingFailed(e)`, `User` is a `Codable` struct with `CodingKeys` if needed.

**Weak output:** Force-unwraps the URL, returns `nil` instead of throwing, uses a single `catch` that swallows all errors, mixes completion-handler APIs with async/await.

---

## Design (Work Sample)

### UI Designer
**Task:** You are given a component spec for a "notification badge" — a small count indicator that appears on icon buttons. The spec includes: default state (count > 0) with a red circle and white text, and that's it.

Write a component checklist — not Figma frames, but a written list — identifying:
1. Every missing state that must be defined before implementation
2. Every token that must exist in the design system for this component
3. The hand-off requirements for the developer

**Strong output:** Missing states listed: `count = 0` (hidden or empty), `count > 99` (shows "99+"), `loading` (spinner or skeleton), `error` (failure to load count); tokens named: `color.feedback.error.500` (badge background), `color.text.on-error` (text), `spacing.badge.padding`, `typography.badge.size`, `border-radius.badge`; hand-off: exported token JSON, Figma frames for each state, reduced-motion fallback if badge animates in.

**Weak output:** Lists only a few states, uses hardcoded hex values instead of token names, no hand-off checklist.

---

### UX Designer
**Task:** Write a user story and three acceptance criteria for this scenario: "Users frequently abandon the checkout flow because they don't realize they need to create an account before paying."

Requirements: user story in standard format (`As a [user], I want [goal], so that [benefit]`), acceptance criteria are testable (Given/When/Then format), at least one criterion addresses the specific abandonment reason identified.

**Strong output:** Story addresses the friction point directly (e.g., "As a returning visitor, I want to check out without creating an account first, so that I can complete my purchase without a registration barrier"); ACs are testable and cover: guest checkout path, account creation as opt-in after purchase, and the scenario where the user does want an account.

**Weak output:** Story is too generic ("As a user, I want to buy things"), ACs are not testable ("the checkout should be easy"), does not address the specific abandonment cause.

---

## Data / ML

### Data Engineer
**Task:** Write a Python function `load_orders(source_conn, dest_conn, batch_date: date) -> LoadResult` that:
1. Extracts orders from `source_conn` (PostgreSQL) for the given `batch_date`
2. Upserts them into `dest_conn` (PostgreSQL) using `INSERT ... ON CONFLICT DO UPDATE`
3. Returns a `LoadResult` dataclass with `rows_extracted`, `rows_upserted`, `rows_skipped`, `batch_date`
4. Is idempotent — running it twice for the same `batch_date` must not create duplicates or change row counts

Requirements: uses `psycopg2`, parameterized queries, the upsert key is `order_id`, `rows_skipped` is rows where the source data is identical to the destination (no update needed).

**Strong output:** Uses `psycopg2.extras.execute_values` for batch upsert, `ON CONFLICT (order_id) DO UPDATE SET ... WHERE dest.updated_at < excluded.updated_at` (only updates if newer), `rows_skipped` computed from `xmax = 0` check (PostgreSQL-specific: `xmax = 0` means no update occurred in the upsert), result is a frozen dataclass.

**Weak output:** Uses individual INSERT per row, no conflict handling, re-reads the table to count skipped rows (extra query), or uses TRUNCATE+INSERT (not idempotent if source data changes mid-run).

---

### ML Engineer
**Task:** Write a PyTorch training loop function `train(model, train_loader, val_loader, optimizer, epochs, patience)` that:
1. Trains for up to `epochs` epochs
2. Validates after each epoch
3. Implements early stopping: stop if validation loss does not improve for `patience` consecutive epochs
4. Saves the best model weights (lowest val loss) and restores them at the end
5. Returns a `TrainHistory` dataclass with `train_losses`, `val_losses`, `best_epoch`

Requirements: uses `model.train()` and `model.eval()` correctly, uses `torch.no_grad()` for validation, saves weights with `copy.deepcopy(model.state_dict())` (not to disk).

**Strong output:** `patience` counter resets on improvement, saves state dict on improvement (`best_state = copy.deepcopy(model.state_dict())`), restores with `model.load_state_dict(best_state)` after training ends, `model.eval()` before validation, `model.train()` before training loop, `torch.no_grad()` context in validation.

**Weak output:** Saves to disk instead of memory, forgets to restore best weights at the end, `model.train()` not called before training loop, patience counter never resets.

---

### AI Prompt Engineer
**Task:** Write a complete system prompt for a customer support chatbot that handles billing disputes. The prompt must include:
1. A defined persona and tone
2. Explicit refusal patterns (what the bot must never say or do)
3. An escalation trigger (when to hand off to a human)
4. A structured response format for dispute resolutions

Requirements: no placeholder text, the prompt must be self-contained and usable as written, escalation path must be a concrete action (not "suggest the user contact support" — that is circular).

**Strong output:** Persona is specific and grounded, refusals list concrete things (no PII collection, no promises about refund outcomes, no legal advice, no discussing other customers' accounts), escalation trigger is specific (e.g., "if the user mentions fraud, legal action, or the dispute value exceeds $500, immediately stop and say: [exact script]"), resolution format has clear structure (acknowledgment → action taken → timeline → reference number).

**Weak output:** Generic "be helpful" persona, vague refusals ("don't say anything harmful"), escalation is "suggest contacting support" (circular), no structured output format.

---

## Quality

### QA Engineer
**Task:** Write a Playwright (TypeScript) test suite for a login form with:
1. Happy path: valid email + password → redirect to `/dashboard`
2. Invalid password: valid email + wrong password → inline error message visible, no redirect
3. Empty fields: submit with no input → field-level validation errors on both fields
4. Network failure: simulate offline → graceful error message (not a browser error page)

Requirements: uses `test.describe`, `page.getByRole` and `page.getByTestId` (not `page.$`), network failure uses `page.route('**/api/login', route => route.abort())`, each test is independent (no shared state between tests).

**Strong output:** Uses `page.getByRole('button', { name: 'Log in' })` (not brittle selectors), validation error assertions check `aria-invalid="true"` on inputs, network test uses `page.route()` correctly, each test has its own `page` (uses `test.beforeEach` with `page.goto` to reset state), assertions use `await expect(...).toBeVisible()` (not manual waits).

**Weak output:** Uses `page.$('#submit')` CSS selectors, network test uses `page.setOfflineMode(true)` (deprecated), tests share state, assertions use `page.waitForTimeout(1000)`.

---

### QA Manual (Exploratory)
**Task:** Write a test charter for an exploratory testing session on a shopping cart feature. The charter must specify:
1. Target: what specifically is being explored
2. Resources: what test data and environments are needed
3. Risks: what could go wrong that this session is designed to surface
4. Time box: how long the session runs
5. At least 5 specific test ideas (not test cases — ideas that guide exploration)

**Strong output:** Target is specific ("Explore cart state persistence when a user navigates away and returns"), risks are specific failure modes ("items may be lost if session expires mid-browse", "quantity changes may not persist across page reload"), test ideas are exploratory ("add item → navigate to product page → use browser back button → verify cart count"), time box is realistic (60–90 minutes).

**Weak output:** Target is too broad ("test the shopping cart"), test ideas are scripted test cases not exploratory prompts, no time box, risks are generic ("bugs").

---

### QA Automation
**Task:** Write a pytest fixture `db_session` (scope: function) that:
1. Creates a test database with the schema from `schema.sql`
2. Yields a SQLAlchemy `Session` for the test to use
3. Rolls back all changes after each test (does not drop and recreate the DB)
4. Works in parallel test execution (each test gets an isolated transaction, not an isolated database)

Requirements: uses `pytest.fixture(scope="function")`, uses `session.begin_nested()` (savepoint) for isolation within a single DB, `yield` the session after setting up the savepoint, `session.rollback()` in the teardown.

**Strong output:** Uses `BEGIN SAVEPOINT` via `session.begin_nested()`, yields the session, calls `session.rollback()` in the finally block (not after yield without try/finally), the fixture is composable (accepts `engine` as a fixture parameter, not hardcoded), works with `pytest-xdist` because it uses savepoints not separate databases.

**Weak output:** Uses `scope="session"` (shared state between tests), drops and recreates the database per test (slow), no teardown, or uses a separate in-memory SQLite DB that doesn't match production schema.

---

## Security

### Security Engineer (AppSec)
**Task:** Write a Python function `review_auth_endpoint(source_code: str) -> list[Finding]` that statically scans a code snippet for authentication vulnerabilities. The function must detect:
1. Hardcoded credentials (regex: `password\s*=\s*["'][^"']+["']`)
2. Missing rate limiting (absence of any rate-limit decorator or middleware reference)
3. JWT verification without algorithm pinning (`jwt.decode` without `algorithms=` parameter)
4. Timing-safe comparison missing for secrets (`==` instead of `hmac.compare_digest`)

Returns a list of `Finding(severity, line_number, description)` dataclasses.

Requirements: `Finding` is a frozen dataclass, line numbers are accurate (1-indexed), severity is a `Severity` enum (CRITICAL, HIGH, MEDIUM, LOW), no false negatives on the provided test cases.

**Strong output:** Uses `re.finditer` with line tracking (counts `\n` before match position), correct regex for each pattern, `Severity` is an `IntEnum` for ordering, `Finding` is frozen, returns empty list on clean code (not None).

**Weak output:** `severity` is a string, line numbers are wrong or missing, regex matches across line boundaries unexpectedly, returns None instead of empty list.

---

### Security Engineer (Infra)
**Task:** Write a Terraform module for an S3 bucket with the following controls:
1. Block all public access (all four `block_public_acls` etc. settings = true)
2. Server-side encryption with a customer-managed KMS key (passed as a variable)
3. Access logging to a separate logging bucket (passed as a variable)
4. Versioning enabled
5. A bucket policy that denies `s3:GetObject` unless the request uses `aws:SecureTransport` (HTTPS only)

Requirements: no ACLs (use bucket ownership controls instead), the KMS key ARN and logging bucket are variables with validation, all settings use the current AWS provider resources (no deprecated `aws_s3_bucket` combined resource).

**Strong output:** Uses separate `aws_s3_bucket_*` resources (versioning, public_access_block, server_side_encryption_configuration, logging, ownership_controls), the deny policy uses `"Condition": {"Bool": {"aws:SecureTransport": "false"}}`, KMS variable has `validation` block checking for `arn:aws:kms:` prefix, `aws_s3_bucket_ownership_controls` with `BucketOwnerEnforced`.

**Weak output:** Uses deprecated `aws_s3_bucket` `acl` attribute, missing the HTTPS-only policy, no validation on the KMS ARN variable, sets ACL instead of ownership controls.

---

## Streaming / Media

### Audio/Streaming Engineer
**Task:** Write a Python class `StreamMonitor` that:
1. Polls an Icecast `/status-json.xsl` endpoint every 5 seconds
2. Detects source dropout (HTTP error OR empty/missing `source` key in the response)
3. On dropout: switches `active_url` to the pre-configured fallback URL and emits a structured JSON log event
4. Implements reconnect to primary with exponential backoff (base 2s, max 5 attempts)
5. On successful reconnect: switches `active_url` back to primary and emits a recovery log event

Requirements: async Python (`asyncio` + `aiohttp`), structured JSON to stdout via `print(..., flush=True)`, no external deps beyond `aiohttp`, handles both `dict` and `list` forms of the Icecast `source` field.

**Strong output:** `content_type=None` on `resp.json()` (Icecast returns `text/xml` content type despite JSON body), `raise_for_status()` before parsing, handles `source` as dict (single mount) or list (multiple mounts), retry count increments only when in fallback state, POLL_INTERVAL and backoff are class constants (not magic numbers), log events include `ts` and relevant URLs.

**Weak output:** No timeout on HTTP requests, bare `except:` without logging, forgets `content_type=None` (causes `ContentTypeError` in production), increments retry counter on initial dropout (not just during reconnect attempts).

---

## Management (Work Sample)

### Product Manager
**Task:** Write acceptance criteria for this feature: "Users can reset their password via email."

Criteria must be in Given/When/Then format. Must cover: the happy path, the case where the email is not registered, the case where the reset link has expired, and the security requirement that the link is single-use.

**Strong output:** Four distinct ACs, each in proper Given/When/Then, "email not registered" AC does NOT reveal whether the email exists (says "we sent an email if the address matches" — prevents account enumeration), expired link shows a specific actionable error with a "Request new link" CTA, single-use: a second click on the same link shows "link already used."

**Weak output:** Single AC covering only the happy path, no security consideration for account enumeration, expired/used link not addressed.

---

### Project Manager
**Task:** Sprint 3 starts Monday. Two of four developers are blocked on an external API contract. Write a one-page sprint plan that includes: revised capacity, what the blocked developers will work on instead, the escalation path for the external dependency, and a definition of "sprint success" that accounts for the constraint.

**Strong output:** Capacity is explicitly 2 FTEs for blocking work + 2 FTEs for non-blocking work, blocked devs assigned to identified non-blocking tasks (mock-based work, tech debt, documentation, test scaffolding), escalation path names a specific person and a deadline ("if contract not received by Wednesday COB, escalate to [role]"), sprint success redefines "done" for the sprint honestly (not "deliver as if all four devs are unblocked").

**Weak output:** Plans for full four-developer capacity and hopes the contract arrives, no escalation path, "sprint success" is the original delivery goal with no adjustment.

---

### Scrum Master
**Task:** The team's Definition of Done has never been written down. Write one for a team building a web application with a React frontend, Node.js API, and PostgreSQL database. The DoD must be a checklist that any team member can apply independently to determine if a ticket is done.

**Strong output:** Checklist includes: code merged to main (not just PR open), all automated tests passing in CI, no new lint errors, migration applied in staging, feature tested in staging by the author, acceptance criteria confirmed by PM or stakeholder, no new TODO/FIXME comments without linked tickets, documentation updated if user-facing behavior changed, performance regression check if the change touches a hot path.

**Weak output:** Generic checklist ("code is working", "tests pass"), no staging requirement, no PM confirmation, no documentation check.

---

## Documentation

### Technical Writer
**Task:** You are given this code snippet:

```python
@app.route("/api/orders/<order_id>/cancel", methods=["POST"])
def cancel_order(order_id):
    order = Order.query.get(order_id)
    if not order:
        return jsonify({"error": "not_found"}), 404
    if order.status not in ("pending", "processing"):
        return jsonify({"error": "not_cancellable", "current_status": order.status}), 409
    order.status = "cancelled"
    db.session.commit()
    return jsonify({"order_id": order_id, "status": "cancelled"}), 200
```

Write API documentation for this endpoint: method, path, description, path parameters, request body (if any), response schema for each status code, and one usage example with `curl`.

**Strong output:** Documents all three response codes (200, 404, 409), the 409 includes the `current_status` field in the schema, notes that the endpoint requires an authenticated session (even though the code doesn't show it — this is a real-world inference), curl example uses a realistic order ID format, response schemas are in JSON Schema or table format (not prose).

**Weak output:** Only documents the 200 response, omits the `current_status` field from the 409 schema, curl example uses `<order_id>` placeholder without explanation, describes the code rather than the API contract.

---

## Database

### DBA
**Task:** Write a PostgreSQL migration script that adds a `NOT NULL` column `subscription_tier VARCHAR(20) DEFAULT 'free'` to a `users` table with 50 million rows. The migration must:
1. Not lock the table for the duration of the migration
2. Be safe to run in production during business hours
3. Be reversible (include a rollback script)
4. Include validation that the backfill completed before applying the NOT NULL constraint

Requirements: uses PostgreSQL-native zero-downtime migration pattern (add nullable → backfill in batches → add NOT NULL constraint).

**Strong output:**
```sql
-- Step 1: Add nullable (instant, no lock)
ALTER TABLE users ADD COLUMN subscription_tier VARCHAR(20);

-- Step 2: Backfill in batches (low-lock)
DO $$ 
DECLARE batch_size INT := 10000; last_id BIGINT := 0;
BEGIN
  LOOP
    UPDATE users SET subscription_tier = 'free'
    WHERE id > last_id AND subscription_tier IS NULL
    ORDER BY id LIMIT batch_size
    RETURNING MAX(id) INTO last_id;
    EXIT WHEN NOT FOUND;
    PERFORM pg_sleep(0.01);
  END LOOP;
END $$;

-- Step 3: Validate before constraining
DO $$ BEGIN
  IF EXISTS (SELECT 1 FROM users WHERE subscription_tier IS NULL LIMIT 1) THEN
    RAISE EXCEPTION 'Backfill incomplete — NULL rows remain';
  END IF;
END $$;

-- Step 4: Add NOT NULL (fast when no NULLs exist)
ALTER TABLE users ALTER COLUMN subscription_tier SET NOT NULL;
ALTER TABLE users ALTER COLUMN subscription_tier SET DEFAULT 'free';

-- Rollback:
-- ALTER TABLE users DROP COLUMN subscription_tier;
```

**Weak output:** `ALTER TABLE users ADD COLUMN subscription_tier VARCHAR(20) NOT NULL DEFAULT 'free'` (rewrites the entire table, locks for minutes to hours on 50M rows), no batching, no validation before applying the constraint, no rollback.
