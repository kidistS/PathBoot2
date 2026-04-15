# 🏛️ GovAI Assistant

GovAI Assistant is a local AI-powered government guidance system designed to help citizens—especially immigrants in Norway—understand and navigate public services such as NAV, tax, and immigration. It allows users to ask questions in natural language and receive clear, structured, and multilingual responses powered by a local AI system.

Instead of manually searching through complex government websites, users can interact conversationally:

> “How do I apply for unemployment benefits in Norway?”

and receive step-by-step, context-aware guidance.

---

# 🌍 Purpose & Impact

The system is built to improve **digital inclusion and accessibility**, especially for immigrants who face language barriers and lack understanding of government procedures.

### Key societal benefits:
- 🌍 Makes Norwegian public services easier to understand  
- 🧭 Guides users through NAV, Tax, and Immigration processes  
- 🗣️ Removes language barriers (English, Norwegian, Amharic)  
- 📄 Simplifies complex bureaucratic information  
- ⏱️ Reduces dependency on support centers and waiting time  
- 🧠 Improves integration and digital inclusion for newcomers  

---

# 🧠 How the System Works

The application follows a structured AI pipeline:

1. User sends a question via chat or API  
2. System stores conversation in memory (session-based)  
3. Language is detected and normalized  
4. Domain router identifies category:
   - NAV (welfare)
   - Tax
   - Immigration  
5. A specialized AI agent is created per domain  
6. Relevant government documents are retrieved using RAG (vector search)  
7. Context + chat history + prompt are combined  
8. A local LLM (Mistral via Ollama) generates the response  
9. Output is translated back to the user’s language  
10. Response is stored and returned  

---

# 🏗️ Architecture Overview
User → Spring Boot API → Orchestrator Service→ Domain Router → Agent Factory → Domain Agent 
→ RAG (Vector Search + Embeddings) → Local LLM (Mistral via Ollama)→ Translation Layer → Response


---

# ⚙️ Tech Stack

## Backend
- Java 17  
- Spring Boot  
- REST APIs  

## AI Layer
- :contentReference[oaicite:0]{index=0}  
- :contentReference[oaicite:1]{index=1}  
- Embedding models (nomic-embed-text)  
- Vector search (RAG-based retrieval)  

## AI Techniques
- Retrieval-Augmented Generation (RAG)  
- Semantic search (vector embeddings)  
- Multi-agent architecture  
- Domain-specific prompt engineering  

---

# 💻 Frontend (Recommended)

- React + TypeScript  
- Next.js (App Router)  
- Tailwind CSS  
- Zustand (state management)  
- React Query (API handling)  
- WebSockets / SSE (streaming responses)  

### UI Features:
- ChatGPT-style interface  
- Streaming responses  
- Session-based memory  
- Multilingual support  
- Mobile-first responsive design  

---

# ⚙️ Setup & Run

## 1. Install prerequisites
- Java 17+  
- Maven  
- Git  
- :contentReference[oaicite:2]{index=2}  

---

## 2. Start local LLM
```bash
ollama pull mistral
ollama pull nomic-embed-text
ollama serve

## 3. Run backend
```bash
mvn clean install
mvn spring-boot:run

Backend runs at:
http://localhost:8080

## 4. Frontend
```bash
npm install
npm run dev

Frontend runs at: 
http://localhost:3000


### 
🚀 Summary

GovAI Assistant is a privacy-first, multi-agent AI system that combines retrieval-augmented generation, local LLM inference, and conversational memory to make government services more accessible—especially for immigrants in Norway.

It demonstrates strong expertise in:

AI system design
Backend engineering (Spring Boot)
RAG pipelines
Multi-agent architectures
Local LLM deployment

