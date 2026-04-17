# GovAI Assistant Backend (MVP)

This module implements a Spring Boot API for a local-first GovAI assistant focused on NAV, tax, and immigration guidance in Norway.

## What is included

- Multilingual request handling (`en`, `no`, `am` detection fallback)
- Domain routing (`NAV`, `TAX`, `IMMIGRATION`, `GENERAL`)
- Lightweight in-memory RAG retrieval from seeded government guidance snippets
- Session-based memory (in-memory)
- Ollama client integration for local model inference (`mistral` by default)
- REST endpoints for chat, sessions, and health checks

## API endpoints

- `POST /api/v1/chat`
- `GET /api/v1/sessions/{sessionId}`
- `DELETE /api/v1/sessions/{sessionId}`
- `GET /api/v1/health`

## Quick start

```bash
mvn clean test
mvn spring-boot:run
```

Example chat request:

```json
{
  "question": "How do I apply for unemployment benefits in Norway?",
  "language": "en"
}
```

## Configuration

See `src/main/resources/application.yaml`:

- `govai.session-history-size`
- `govai.ollama.base-url`
- `govai.ollama.model`

If Ollama is unavailable, the service returns a graceful fallback message instead of failing the request.

