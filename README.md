# PathBoot2 🇳🇴🤖

> **AI-powered local government assistant for Norway** — helping immigrants navigate NAV, tax, and immigration services through multi-agent LLMs, RAG pipelines, and multilingual support.

---

## Table of Contents

- [Project Overview](#project-overview)
- [MVP Definition](#mvp-definition)
- [Frontend](#frontend)
- [Backend](#backend)
- [DevOps & Infrastructure](#devops--infrastructure)
- [Documentation & Quality](#documentation--quality)
- [Relevant Links](#relevant-links)
- [Final Recommendation](#final-recommendation)

---

## Project Overview

**PathBoot2** is an intelligent, multilingual chatbot platform designed to assist immigrants living in Norway. The system leverages large language models (LLMs) with Retrieval-Augmented Generation (RAG) and a multi-agent architecture to provide accurate, context-aware guidance on:

- 🏛️ **NAV** — Norwegian Labour and Welfare Administration services
- 💰 **Tax** — Norwegian tax registration, reporting, and compliance
- 🛂 **Immigration** — UDI (Directorate of Immigration) processes and requirements

The goal is to lower barriers for immigrants who may struggle with language, bureaucratic complexity, or lack of access to professional guidance.

---

## MVP Definition

The Minimum Viable Product (MVP) focuses on delivering core value quickly with a small, focused feature set.

### ✅ Must Have

- [ ] Multilingual chat interface (Norwegian, English, and at least 2 additional languages)
- [ ] RAG pipeline connected to official Norwegian government sources (NAV, Skatteetaten, UDI)
- [ ] Multi-agent LLM orchestration for routing queries to domain-specific agents
- [ ] Basic user authentication (sign-up / login)
- [ ] Responsive web UI (desktop + mobile)
- [ ] Conversational memory within a session

### 🟡 Should Have

- [ ] Persistent conversation history across sessions
- [ ] Feedback mechanism (thumbs up/down per response)
- [ ] Source citation in responses (linking to official pages)
- [ ] Admin dashboard to monitor usage and queries
- [ ] Document upload support (e.g., upload a letter from NAV for interpretation)

### 💡 Nice to Have

- [ ] Voice input and text-to-speech output
- [ ] Integration with Open Library API for recommended reading
- [ ] Personalised onboarding flow based on user profile (new arrival, working immigrant, student, etc.)
- [ ] Browser extension for inline government website assistance
- [ ] Email digest of recent conversations / reminders

> **Note:** Backlog data entry and task prioritisation have been assisted by **GitHub Copilot** using AI-generated suggestions based on the project summary. All items have been reviewed and validated by the development team.

---

## Frontend

Built with **React** and **Tailwind CSS** for a fast, accessible, and responsive experience.

### Stack

| Technology | Purpose |
|---|---|
| [React](https://react.dev/) | Component-based UI framework |
| [Tailwind CSS](https://tailwindcss.com/docs) | Utility-first CSS styling |
| [React Router](https://reactrouter.com/) | Client-side routing |
| [Axios](https://axios-http.com/) | HTTP client for API calls |
| [i18next](https://www.i18next.com/) | Internationalisation & multilingual support |

### Tasks

#### Must Have
- [ ] Chat UI component with streaming response support
- [ ] Language selector with auto-detection
- [ ] Authentication pages (login, register, forgot password)
- [ ] Responsive layout for mobile and desktop

#### Should Have
- [ ] Conversation history sidebar
- [ ] Feedback widget (per message)
- [ ] Source link cards displayed alongside responses

#### Nice to Have
- [ ] Voice input toggle
- [ ] Dark mode
- [ ] Animated onboarding flow

---

## Backend

Built with **ASP.NET Core** and **Entity Framework Core**, orchestrating multiple AI agents via an LLM API.

### Stack

| Technology | Purpose |
|---|---|
| [ASP.NET Core](https://learn.microsoft.com/en-us/aspnet/core/) | Web API framework |
| [Entity Framework Core](https://learn.microsoft.com/en-us/ef/core/) | ORM for database access |
| [Azure OpenAI Service](https://learn.microsoft.com/en-us/azure/ai-services/openai/) | LLM inference and embeddings |
| [Azure AI Search](https://learn.microsoft.com/en-us/azure/search/) | Vector search for RAG |
| PostgreSQL | Relational data store |
| [SignalR](https://learn.microsoft.com/en-us/aspnet/core/signalr/introduction) | Real-time streaming responses |

### Tasks

#### Must Have
- [ ] RESTful API with versioning (`/api/v1/...`)
- [ ] Multi-agent routing logic (NAV agent, Tax agent, Immigration agent)
- [ ] RAG pipeline: document chunking → embedding → vector retrieval → LLM synthesis
- [ ] JWT-based authentication & authorisation
- [ ] Database schema for users, conversations, messages

#### Should Have
- [ ] Feedback storage and analytics endpoint
- [ ] Rate limiting per user
- [ ] Logging and structured error handling (Serilog)
- [ ] Background job for refreshing government document index

#### Nice to Have
- [ ] Webhook integration with NAV/UDI RSS feeds
- [ ] Document upload endpoint with OCR pre-processing
- [ ] GraphQL API layer

---

## DevOps & Infrastructure

Hosted on **Microsoft Azure** with CI/CD pipelines via **GitHub Actions**.

### Stack

| Technology | Purpose |
|---|---|
| [Azure App Service](https://learn.microsoft.com/en-us/azure/app-service/) | Hosting for frontend & backend |
| [Azure Container Apps](https://learn.microsoft.com/en-us/azure/container-apps/) | Scalable containerised services |
| [Azure OpenAI](https://learn.microsoft.com/en-us/azure/ai-services/openai/) | Managed LLM endpoints |
| [Azure AI Search](https://learn.microsoft.com/en-us/azure/search/) | Vector + keyword search index |
| [GitHub Actions](https://docs.github.com/en/actions) | CI/CD pipelines |
| [Docker](https://docs.docker.com/) | Containerisation |

### Tasks

#### Must Have
- [ ] Dockerfiles for frontend and backend
- [ ] GitHub Actions workflow: build → test → deploy on merge to `main`
- [ ] Environment-specific configuration (dev / staging / prod)
- [ ] Secrets management via Azure Key Vault

#### Should Have
- [ ] Infrastructure as Code (Bicep or Terraform) for Azure resources
- [ ] Staging environment with PR preview deployments
- [ ] Health check endpoints and uptime monitoring (Azure Monitor)

#### Nice to Have
- [ ] Auto-scaling policies based on request volume
- [ ] CDN for static frontend assets (Azure Front Door)
- [ ] Cost alerts and budget thresholds in Azure

---

## Documentation & Quality

### Tasks

#### Must Have
- [ ] `README.md` — project overview and setup instructions *(this file)*
- [ ] `CONTRIBUTING.md` — guide for contributors
- [ ] API documentation (Swagger / OpenAPI auto-generated)
- [ ] Environment variable reference (`.env.example`)

#### Should Have
- [ ] Architecture diagram (C4 or similar)
- [ ] ADR (Architecture Decision Records) for key technology choices
- [ ] Unit tests for core backend services (≥ 70% coverage)
- [ ] Component tests for critical React components

#### Nice to Have
- [ ] End-to-end tests with Playwright or Cypress
- [ ] Storybook component library documentation
- [ ] User research notes and personas

> **AI Copilot Assistance:** GitHub Copilot was used to accelerate initial backlog creation, README drafting, and boilerplate code generation. All AI-generated content has been reviewed, validated, and adapted by the team.

---

## Relevant Links

| Resource | URL |
|---|---|
| 🏛️ NAV (Norwegian Welfare) | [nav.no](https://www.nav.no/) |
| 💰 Skatteetaten (Tax) | [skatteetaten.no](https://www.skatteetaten.no/) |
| 🛂 UDI (Immigration) | [udi.no](https://www.udi.no/) |
| ⚛️ React Documentation | [react.dev](https://react.dev/) |
| 🎨 Tailwind CSS Docs | [tailwindcss.com/docs](https://tailwindcss.com/docs) |
| 🗄️ EF Core Documentation | [learn.microsoft.com/ef/core](https://learn.microsoft.com/en-us/ef/core/) |
| ☁️ Azure Documentation | [learn.microsoft.com/azure](https://learn.microsoft.com/en-us/azure/) |
| 🤖 Azure OpenAI Service | [learn.microsoft.com/azure/ai-services/openai](https://learn.microsoft.com/en-us/azure/ai-services/openai/) |
| 📚 Open Library API | [openlibrary.org/developers/api](https://openlibrary.org/developers/api) |
| 🐙 GitHub Actions Docs | [docs.github.com/actions](https://docs.github.com/en/actions) |
| 🔍 Azure AI Search | [learn.microsoft.com/azure/search](https://learn.microsoft.com/en-us/azure/search/) |

---

## Final Recommendation

PathBoot2 has a strong social impact mission and a technically interesting architecture. To maximise the chances of a successful MVP:

1. **Narrow the scope early.** Focus on one domain (e.g., NAV) first, validate with real users, then expand to Tax and Immigration.
2. **Ground responses in official sources.** The RAG pipeline must index verified Norwegian government pages to avoid hallucinations on legal/bureaucratic topics.
3. **Prioritise language quality.** Partner with native speakers for the Norwegian and Somali/Arabic/Polish/Tigrinya translations to ensure trust with target users.
4. **Measure what matters.** Instrument the feedback loop from day one — track resolution rate, escalation rate, and user satisfaction to guide future iterations.
5. **Use AI Copilot throughout.** GitHub Copilot can significantly accelerate boilerplate, API integration, and test writing — let it handle the scaffolding so the team can focus on the unique AI orchestration logic.

---

*Generated with assistance from GitHub Copilot · Maintained by the PathBoot2 team*
