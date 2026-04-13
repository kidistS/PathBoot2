#!/usr/bin/env bash
# create-kanban-board.sh
#
# Creates GitHub Issues for every backlog item in README.md and
# sets up a GitHub Projects (v2) Kanban board with:
#   - Columns : Backlog | In Progress | Done
#   - Custom field: Priority (Must have / Should have / Nice to have)
#
# Prerequisites:
#   - gh CLI authenticated with a token that has:
#       repo, project scopes (classic token)
#       or: issues:write + projects:write (fine-grained token)
#   - Run from the root of the repository:
#       bash scripts/create-kanban-board.sh
#
# Usage:
#   export GH_TOKEN=<your-token>   # or: gh auth login
#   bash scripts/create-kanban-board.sh

set -euo pipefail

REPO="kidistS/PathBoot2"
PROJECT_TITLE="GovAI Assistant — Kanban Board"
OWNER="kidistS"

# ---------------------------------------------------------------------------
# Helper: create an issue and return its node ID (for Projects v2)
# ---------------------------------------------------------------------------
create_issue() {
  local title="$1"
  local body="$2"
  local label="$3"

  gh issue create \
    --repo "$REPO" \
    --title "$title" \
    --body "$body" \
    --label "$label" \
    --json id,number,nodeId \
    --jq '.nodeId'
}

# ---------------------------------------------------------------------------
# 1. Ensure labels exist
# ---------------------------------------------------------------------------
echo "==> Ensuring labels exist..."
for label_def in \
  "must-have:Must have (MVP):0075ca" \
  "should-have:Should have:e4e669" \
  "nice-to-have:Nice to have:c2e0c6"; do
  IFS=: read -r name desc color <<< "$label_def"
  gh label create "$name" \
    --repo "$REPO" \
    --description "$desc" \
    --color "$color" \
    --force 2>/dev/null || true
done

# ---------------------------------------------------------------------------
# 2. Create the GitHub Project (v2)
# ---------------------------------------------------------------------------
echo "==> Creating GitHub Project..."
PROJECT_URL=$(gh project create \
  --owner "$OWNER" \
  --title "$PROJECT_TITLE" \
  --format json \
  --jq '.url' 2>/dev/null) || {
  echo "  Project may already exist — searching..."
  PROJECT_URL=$(gh project list \
    --owner "$OWNER" \
    --format json \
    --jq ".projects[] | select(.title==\"$PROJECT_TITLE\") | .url")
}
echo "  Project URL: $PROJECT_URL"

PROJECT_NUMBER=$(basename "$PROJECT_URL")

# ---------------------------------------------------------------------------
# 3. Link project to repository
# ---------------------------------------------------------------------------
echo "==> Linking project to repository..."
gh project link "$PROJECT_NUMBER" \
  --owner "$OWNER" \
  --repo "$REPO" 2>/dev/null || true

# ---------------------------------------------------------------------------
# 4. Add Priority single-select field
# ---------------------------------------------------------------------------
echo "==> Adding Priority field..."
gh project field-create "$PROJECT_NUMBER" \
  --owner "$OWNER" \
  --name "Priority" \
  --data-type "SINGLE_SELECT" \
  --single-select-options "Must have,Should have,Nice to have" 2>/dev/null || true

# ---------------------------------------------------------------------------
# 5. Create issues and add to project
# ---------------------------------------------------------------------------
add_to_project() {
  local node_id="$1"
  local priority="$2"

  item_id=$(gh project item-add "$PROJECT_NUMBER" \
    --owner "$OWNER" \
    --url "https://github.com/$REPO/issues/$(
      gh issue list --repo "$REPO" --json nodeId,number \
        --jq ".[] | select(.nodeId==\"$node_id\") | .number"
    )" \
    --format json \
    --jq '.id' 2>/dev/null) || return 0

  # Set Status = Backlog
  gh project item-edit \
    --project-id "$(gh project view "$PROJECT_NUMBER" --owner "$OWNER" --format json --jq '.id')" \
    --id "$item_id" \
    --field-id "$(gh project field-list "$PROJECT_NUMBER" --owner "$OWNER" --format json --jq '.fields[] | select(.name=="Status") | .id')" \
    --single-select-option-id "$(gh project field-list "$PROJECT_NUMBER" --owner "$OWNER" --format json --jq '.fields[] | select(.name=="Status") | .options[] | select(.name=="Backlog") | .id')" \
    2>/dev/null || true

  # Set Priority
  gh project item-edit \
    --project-id "$(gh project view "$PROJECT_NUMBER" --owner "$OWNER" --format json --jq '.id')" \
    --id "$item_id" \
    --field-id "$(gh project field-list "$PROJECT_NUMBER" --owner "$OWNER" --format json --jq '.fields[] | select(.name=="Priority") | .id')" \
    --single-select-option-id "$(gh project field-list "$PROJECT_NUMBER" --owner "$OWNER" --format json --jq ".fields[] | select(.name==\"Priority\") | .options[] | select(.name==\"$priority\") | .id")" \
    2>/dev/null || true
}

echo ""
echo "==> Creating issues..."

# --- Must have (MVP) -----------------------------------------------------------

node_id=$(create_issue \
  "Implement single chat API endpoint with session support" \
  "## Description
Expose a \`POST /api/chat\` endpoint that accepts a user message and session ID, maintains conversation history for that session, and returns an assistant response.

## Acceptance Criteria
- [ ] \`POST /api/chat\` accepts \`{ sessionId, message, language? }\` and returns \`{ answer, sessionId }\`
- [ ] Session history is stored server-side and injected into the prompt on subsequent turns
- [ ] Returns HTTP 400 for missing fields; HTTP 500 with a structured error body on failures
- [ ] \`GET /api/health\` returns \`{ status: \"UP\" }\`
- [ ] Basic request/session logging (request ID, session ID) is present

## Priority
Must have (MVP)

## README Section
Backlog & Priorities → Must have (MVP)" \
  "must-have")
add_to_project "$node_id" "Must have"

node_id=$(create_issue \
  "Build domain router (NAV / Tax / Immigration classification)" \
  "## Description
Implement a classifier that routes incoming questions to the correct domain agent (NAV, Tax, or Immigration) so each agent can apply the most relevant prompt strategy and document set.

## Acceptance Criteria
- [ ] Router correctly classifies at least 80 % of representative test queries per domain
- [ ] Unrecognized queries fall back to a generic response (not an error)
- [ ] Domain selection is logged with the session ID
- [ ] Unit tests cover router logic for all three domains

## Priority
Must have (MVP)

## README Section
Backlog & Priorities → Must have (MVP)" \
  "must-have")
add_to_project "$node_id" "Must have"

node_id=$(create_issue \
  "Implement RAG retrieval with a curated dataset" \
  "## Description
Set up a retrieval-augmented generation pipeline: embed a small curated document set, store vectors, and retrieve the top-k most relevant chunks for each query before prompt composition.

## Acceptance Criteria
- [ ] At least one domain's documents (NAV recommended) are embedded and stored
- [ ] Similarity search returns top-k chunks for a given query
- [ ] Retrieved chunks are injected into the LLM prompt
- [ ] Pipeline is documented (how to add / update documents)

## Priority
Must have (MVP)

## README Section
Backlog & Priorities → Must have (MVP)" \
  "must-have")
add_to_project "$node_id" "Must have"

node_id=$(create_issue \
  "Integrate Ollama (Mistral for chat; embedding model for RAG)" \
  "## Description
Wire up the Spring Boot backend to a locally running Ollama instance, using Mistral for chat completions and \`nomic-embed-text\` (or equivalent) for generating document and query embeddings.

## Acceptance Criteria
- [ ] Chat completions are generated via Ollama Mistral
- [ ] Document and query embeddings are produced via the configured embedding model
- [ ] Model names and Ollama base URL are configurable via environment variables / application properties
- [ ] Service starts cleanly when Ollama is not running, with a clear error message

## Priority
Must have (MVP)

## README Section
Backlog & Priorities → Must have (MVP)" \
  "must-have")
add_to_project "$node_id" "Must have"

node_id=$(create_issue \
  "Add multilingual baseline (EN + NO + AM) via translation or prompting" \
  "## Description
Enable the assistant to accept questions in English, Norwegian, and Amharic and respond in the user's language. Implement either a translation layer or language-specific system prompts.

## Acceptance Criteria
- [ ] Language is detected automatically or accepted as a request parameter
- [ ] Responses are generated / translated in English, Norwegian, and Amharic
- [ ] A test query in each language returns a coherent, on-topic answer
- [ ] Language detection / selection is logged

## Priority
Must have (MVP)

## README Section
Backlog & Priorities → Must have (MVP)" \
  "must-have")
add_to_project "$node_id" "Must have"

node_id=$(create_issue \
  "Add basic logging, error handling, and health endpoint" \
  "## Description
Establish consistent structured logging (request ID, session ID, selected domain) and global error handling so failures return informative responses rather than stack traces.

## Acceptance Criteria
- [ ] \`GET /api/health\` responds with \`200 { status: \"UP\" }\`
- [ ] All requests log: timestamp, request ID, session ID, domain
- [ ] Unhandled exceptions return a structured JSON error (no raw stack traces to clients)
- [ ] Log level is configurable via environment variable

## Priority
Must have (MVP)

## README Section
Backlog & Priorities → Must have (MVP)" \
  "must-have")
add_to_project "$node_id" "Must have"

node_id=$(create_issue \
  "Write minimal unit tests for router and prompt builder" \
  "## Description
Cover the domain router and prompt composition logic with unit tests to catch regressions and establish a test baseline before expanding coverage.

## Acceptance Criteria
- [ ] Unit tests exist for all three domain routing paths
- [ ] Unit tests cover prompt composition with and without retrieved context
- [ ] Tests run with \`./mvnw test\` without requiring a running Ollama instance
- [ ] CI fails if tests fail

## Priority
Must have (MVP)

## README Section
Backlog & Priorities → Must have (MVP)" \
  "must-have")
add_to_project "$node_id" "Must have"

# --- Should have (after MVP) --------------------------------------------------

node_id=$(create_issue \
  "Add streaming responses via Server-Sent Events (SSE)" \
  "## Description
Stream LLM tokens to the client in real time using Server-Sent Events so users see the answer being composed rather than waiting for the full response.

## Acceptance Criteria
- [ ] \`POST /api/chat\` (or a dedicated \`/api/chat/stream\` endpoint) returns an SSE stream
- [ ] Tokens are flushed to the client as they are produced by Ollama
- [ ] Stream closes cleanly on completion or error
- [ ] Frontend SSE client (or Postman) can consume the stream

## Priority
Should have

## README Section
Backlog & Priorities → Should have (after MVP)" \
  "should-have")
add_to_project "$node_id" "Should have"

node_id=$(create_issue \
  "Include source citations for retrieved documents" \
  "## Description
Expose the document chunks used in each RAG retrieval step alongside the answer so users can verify the sources of government guidance.

## Acceptance Criteria
- [ ] API response includes a \`sources\` array: \`[{ title, url, excerpt }]\`
- [ ] Only chunks actually used in the prompt are cited
- [ ] Empty array is returned when no documents were retrieved
- [ ] Frontend (if present) can display citations

## Priority
Should have

## README Section
Backlog & Priorities → Should have (after MVP)" \
  "should-have")
add_to_project "$node_id" "Should have"

node_id=$(create_issue \
  "Implement admin ingestion endpoint and document pipeline" \
  "## Description
Provide a secured \`POST /api/admin/ingest\` endpoint and accompanying documentation so authorised administrators can add or update documents in the vector store without redeploying.

## Acceptance Criteria
- [ ] \`POST /api/admin/ingest\` accepts document payloads and triggers embedding + storage
- [ ] Endpoint is protected (at minimum by a shared secret / API key)
- [ ] Ingestion process is documented (request format, auth, error handling)
- [ ] At least one integration test covers the ingestion flow

## Priority
Should have

## README Section
Backlog & Priorities → Should have (after MVP)" \
  "should-have")
add_to_project "$node_id" "Should have"

node_id=$(create_issue \
  "Add OpenAPI / Swagger documentation" \
  "## Description
Generate interactive API documentation via SpringDoc OpenAPI so developers and integrators can explore and test all endpoints without reading the source code.

## Acceptance Criteria
- [ ] Swagger UI accessible at \`/swagger-ui.html\` (or \`/api/docs\`)
- [ ] All public endpoints are documented with request/response schemas and examples
- [ ] Authentication requirements are noted in the spec
- [ ] OpenAPI JSON/YAML is exported and committed for reference

## Priority
Should have

## README Section
Backlog & Priorities → Should have (after MVP)" \
  "should-have")
add_to_project "$node_id" "Should have"

node_id=$(create_issue \
  "Add Docker and Docker Compose for the full local stack" \
  "## Description
Package the backend in a Dockerfile and provide a Docker Compose file that brings up the backend and Ollama together so developers can run the full stack with a single command.

## Acceptance Criteria
- [ ] \`Dockerfile\` builds and runs the Spring Boot backend
- [ ] \`docker-compose.yml\` starts backend + Ollama with correct networking
- [ ] \`docker compose up\` results in a working \`POST /api/chat\` response
- [ ] README setup instructions reference the Docker workflow

## Priority
Should have

## README Section
Backlog & Priorities → Should have (after MVP)" \
  "should-have")
add_to_project "$node_id" "Should have"

node_id=$(create_issue \
  "Set up CI pipeline with GitHub Actions" \
  "## Description
Automate build verification, unit test execution, and code formatting checks on every push and pull request using GitHub Actions.

## Acceptance Criteria
- [ ] Workflow triggers on push to main and on pull requests
- [ ] Build, unit tests, and lint/format checks are included
- [ ] Badge in README reflects current CI status
- [ ] Failing tests or build errors block merging

## Priority
Should have

## README Section
Backlog & Priorities → Should have (after MVP)" \
  "should-have")
add_to_project "$node_id" "Should have"

# --- Frontend (Should have) ---------------------------------------------------

node_id=$(create_issue \
  "Scaffold Next.js (App Router) + TypeScript frontend" \
  "## Description
Bootstrap the frontend project using Next.js with the App Router and TypeScript so all subsequent UI work has a consistent, typed foundation.

## Acceptance Criteria
- [ ] \`npx create-next-app\` scaffold with TypeScript and App Router committed under \`frontend/\`
- [ ] \`npm run dev\` starts the dev server at \`localhost:3000\`
- [ ] ESLint and Prettier configured and passing
- [ ] Basic folder structure documented in the frontend README

## Priority
Should have

## README Section
Backlog & Priorities → Frontend (Should have)" \
  "should-have")
add_to_project "$node_id" "Should have"

node_id=$(create_issue \
  "Build chat UI with conversation list and session switching" \
  "## Description
Implement the core chat interface: a message thread pane and a sidebar listing past sessions, allowing users to start new conversations or revisit existing ones.

## Acceptance Criteria
- [ ] Message thread renders user and assistant bubbles correctly
- [ ] Sidebar lists sessions with timestamps and previews
- [ ] Selecting a session loads its full history
- [ ] New chat button creates a fresh session

## Priority
Should have

## README Section
Backlog & Priorities → Frontend (Should have)" \
  "should-have")
add_to_project "$node_id" "Should have"

node_id=$(create_issue \
  "Implement SSE client for streaming token responses" \
  "## Description
Wire the frontend to consume the backend's Server-Sent Events stream so tokens appear in real time rather than after the full response has been generated.

## Acceptance Criteria
- [ ] EventSource (or fetch + ReadableStream) consumes the \`/api/chat/stream\` SSE endpoint
- [ ] Tokens are appended to the message bubble as they arrive
- [ ] Stream errors are caught and surfaced as a user-visible error message
- [ ] Connection is properly closed after the stream ends

## Priority
Should have

## README Section
Backlog & Priorities → Frontend (Should have)" \
  "should-have")
add_to_project "$node_id" "Should have"

node_id=$(create_issue \
  "Integrate Zustand state management and React Query data fetching" \
  "## Description
Establish the frontend state architecture using Zustand for global UI state (active session, settings) and React Query for server state and API interactions.

## Acceptance Criteria
- [ ] Zustand store tracks active session ID and UI preferences
- [ ] React Query manages API calls (chat, sessions) with loading / error states
- [ ] No prop-drilling beyond two levels
- [ ] Unit tests cover the Zustand store's core actions

## Priority
Should have

## README Section
Backlog & Priorities → Frontend (Should have)" \
  "should-have")
add_to_project "$node_id" "Should have"

node_id=$(create_issue \
  "Add language selector and i18n wiring (EN/NO/AM) with persisted preference" \
  "## Description
Allow users to choose their preferred language (English, Norwegian, Amharic) from the UI; persist the preference across sessions and pass it to the API on every request.

## Acceptance Criteria
- [ ] Language selector visible in the header / settings panel
- [ ] Selected language is persisted to localStorage
- [ ] Every API request includes the selected language parameter
- [ ] UI labels are internationalised for all three languages

## Priority
Should have

## README Section
Backlog & Priorities → Frontend (Should have)" \
  "should-have")
add_to_project "$node_id" "Should have"

node_id=$(create_issue \
  "Add message actions: copy, regenerate, and thumbs-up/down feedback" \
  "## Description
Surface per-message action buttons so users can copy answers to clipboard, request a regenerated response, or submit quick thumbs-up / thumbs-down feedback.

## Acceptance Criteria
- [ ] Copy button copies the message text to clipboard
- [ ] Regenerate button re-sends the last user message and replaces the assistant reply
- [ ] Thumbs-up / thumbs-down buttons send feedback to \`POST /api/feedback\`
- [ ] Actions are accessible via keyboard

## Priority
Should have

## README Section
Backlog & Priorities → Frontend (Should have)" \
  "should-have")
add_to_project "$node_id" "Should have"

node_id=$(create_issue \
  "Build Sources / citations drawer per assistant message" \
  "## Description
Display the RAG source documents used to generate each answer in an expandable drawer so users can verify guidance against official government sources.

## Acceptance Criteria
- [ ] "Sources" button appears on messages that have retrieved documents
- [ ] Clicking opens a drawer listing each source: title, URL, and excerpt
- [ ] Drawer is accessible and closable via keyboard
- [ ] No drawer is shown when no sources are available

## Priority
Should have

## README Section
Backlog & Priorities → Frontend (Should have)" \
  "should-have")
add_to_project "$node_id" "Should have"

node_id=$(create_issue \
  "Implement error handling UX (timeouts, offline, model errors) with retry" \
  "## Description
Provide clear, actionable error states for network failures, model unavailability, and request timeouts so users are never left with a blank or broken interface.

## Acceptance Criteria
- [ ] Timeout errors show a user-friendly message with a retry button
- [ ] Offline state is detected and surfaced (browser offline event)
- [ ] Model / backend errors show a descriptive message (not a raw error code)
- [ ] Retry re-sends the original request without duplicating the message

## Priority
Should have

## README Section
Backlog & Priorities → Frontend (Should have)" \
  "should-have")
add_to_project "$node_id" "Should have"

node_id=$(create_issue \
  "Perform basic accessibility pass (keyboard navigation, focus states, ARIA)" \
  "## Description
Audit the chat UI for accessibility issues and implement fixes: ensure all interactive elements are reachable by keyboard, have visible focus styles, and include appropriate ARIA labels.

## Acceptance Criteria
- [ ] All interactive elements are focusable and operable via keyboard alone
- [ ] Focus indicators are clearly visible in all themes
- [ ] Chat messages have appropriate ARIA roles (\`role=\"log\"\`, \`aria-live\`)
- [ ] Automated accessibility scan (e.g., axe-core) reports zero critical violations

## Priority
Should have

## README Section
Backlog & Priorities → Frontend (Should have)" \
  "should-have")
add_to_project "$node_id" "Should have"

node_id=$(create_issue \
  "Implement responsive mobile-first layout with Tailwind (chat + sidebar)" \
  "## Description
Style the chat interface and session sidebar using Tailwind CSS with a mobile-first approach so the app is fully usable on small screens and scales gracefully to desktop.

## Acceptance Criteria
- [ ] Chat interface is fully functional on viewports ≥ 320 px wide
- [ ] Sidebar collapses to a drawer / hamburger menu on small screens
- [ ] Layout tested on Chrome DevTools at 375 px, 768 px, and 1440 px
- [ ] No horizontal scroll on any supported viewport

## Priority
Should have

## README Section
Backlog & Priorities → Frontend (Should have)" \
  "should-have")
add_to_project "$node_id" "Should have"

node_id=$(create_issue \
  "Document frontend configuration (NEXT_PUBLIC_API_BASE_URL, etc.)" \
  "## Description
Write clear documentation for all frontend environment variables and configuration options so developers can set up the frontend against any backend instance quickly.

## Acceptance Criteria
- [ ] \`.env.example\` file lists all required variables with descriptions
- [ ] Frontend README section explains each variable and its default
- [ ] Local and production configuration differences are documented
- [ ] Missing required variables cause an explicit startup error with a helpful message

## Priority
Should have

## README Section
Backlog & Priorities → Frontend (Should have)" \
  "should-have")
add_to_project "$node_id" "Should have"

# --- Nice to have (production readiness) ------------------------------------

node_id=$(create_issue \
  "Implement role-based access control for admin ingestion" \
  "## Description
Protect the admin ingestion endpoint with role-based access control so only authorised users can add or update documents in the vector store.

## Acceptance Criteria
- [ ] Admin endpoints require a valid admin role / token
- [ ] Unauthenticated or unauthorised requests receive HTTP 401 / 403
- [ ] Roles are configurable without code changes
- [ ] Security configuration is documented

## Priority
Nice to have

## README Section
Backlog & Priorities → Nice to have (production readiness)" \
  "nice-to-have")
add_to_project "$node_id" "Nice to have"

node_id=$(create_issue \
  "Build feedback capture and evaluation loop" \
  "## Description
Capture thumbs-up / thumbs-down ratings and optional comments from users and store them for offline review, enabling iterative improvement of prompts and the document corpus.

## Acceptance Criteria
- [ ] \`POST /api/feedback\` accepts \`{ sessionId, messageId, rating, comment? }\`
- [ ] Feedback is persisted and retrievable by admins
- [ ] Privacy considerations are documented (what is stored, retention policy)
- [ ] Aggregate ratings are visible in a simple admin report or export

## Priority
Nice to have

## README Section
Backlog & Priorities → Nice to have (production readiness)" \
  "nice-to-have")
add_to_project "$node_id" "Nice to have"

node_id=$(create_issue \
  "Add PII detection and redaction" \
  "## Description
Detect and redact personally identifiable information (names, national ID numbers, addresses) from user messages before they are sent to the LLM or logged, reducing privacy risk.

## Acceptance Criteria
- [ ] Common Norwegian PII patterns (personnummer, name patterns) are detected
- [ ] Detected PII is redacted or anonymised before LLM processing and logging
- [ ] Redaction events are audited (redaction occurred, not the PII itself)
- [ ] Redaction can be toggled per environment via configuration

## Priority
Nice to have

## README Section
Backlog & Priorities → Nice to have (production readiness)" \
  "nice-to-have")
add_to_project "$node_id" "Nice to have"

node_id=$(create_issue \
  "Add observability: metrics and distributed tracing" \
  "## Description
Instrument the backend with Prometheus metrics and distributed tracing (e.g., OpenTelemetry) so the system's performance and error rates can be monitored in production.

## Acceptance Criteria
- [ ] \`GET /api/metrics\` exposes Prometheus-compatible metrics
- [ ] Key metrics tracked: request count, latency (p50/p95/p99), LLM call duration, RAG retrieval time
- [ ] Distributed traces include session ID and domain as attributes
- [ ] Metrics and trace configuration documented

## Priority
Nice to have

## README Section
Backlog & Priorities → Nice to have (production readiness)" \
  "nice-to-have")
add_to_project "$node_id" "Nice to have"

node_id=$(create_issue \
  "Create cloud deployment templates (Azure Container Apps / AKS)" \
  "## Description
Provide infrastructure-as-code templates (ARM, Bicep, or Terraform) for deploying the stack to Azure Container Apps or AKS, enabling scalable cloud deployment when needed.

## Acceptance Criteria
- [ ] At least one cloud deployment template is provided and documented
- [ ] Template includes backend service, networking, and secret management (Azure Key Vault)
- [ ] README deployment section links to and explains the templates
- [ ] Deployment has been validated in at least a dev/staging environment

## Priority
Nice to have

## README Section
Backlog & Priorities → Nice to have (production readiness)" \
  "nice-to-have")
add_to_project "$node_id" "Nice to have"

node_id=$(create_issue \
  "Expand domain coverage and enrich agent tooling (forms, calculators, checklists)" \
  "## Description
Broaden the assistant's usefulness by adding more government service domains and richer agent capabilities such as interactive forms, eligibility calculators, and step-by-step checklists.

## Acceptance Criteria
- [ ] At least one additional domain beyond NAV is fully supported
- [ ] At least one interactive tool (calculator or checklist) is available in an agent
- [ ] New domains and tools are covered by unit and integration tests
- [ ] Documentation updated to reflect the expanded capability

## Priority
Nice to have

## README Section
Backlog & Priorities → Nice to have (production readiness)" \
  "nice-to-have")
add_to_project "$node_id" "Nice to have"

echo ""
echo "==> Done! Issues created and added to project."
echo "    Project: $PROJECT_URL"
echo "    Total issues: 25"
