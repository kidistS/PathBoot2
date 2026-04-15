package no.gov.ai.pathboot.pathboot.core;

import no.gov.ai.pathboot.pathboot.api.dto.ChatRequest;
import no.gov.ai.pathboot.pathboot.api.dto.ChatResponse;
import no.gov.ai.pathboot.pathboot.api.dto.SourceSnippet;
import no.gov.ai.pathboot.pathboot.model.GovDomain;
import no.gov.ai.pathboot.pathboot.model.Message;
import no.gov.ai.pathboot.pathboot.model.RetrievedDocument;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.util.List;

@Service
public class OrchestratorService {

    private final SessionMemoryService sessionMemoryService;
    private final LanguageService languageService;
    private final DomainRouter domainRouter;
    private final RagService ragService;
    private final AgentFactory agentFactory;

    public OrchestratorService(
            SessionMemoryService sessionMemoryService,
            LanguageService languageService,
            DomainRouter domainRouter,
            RagService ragService,
            AgentFactory agentFactory
    ) {
        this.sessionMemoryService = sessionMemoryService;
        this.languageService = languageService;
        this.domainRouter = domainRouter;
        this.ragService = ragService;
        this.agentFactory = agentFactory;
    }

    public ChatResponse answer(ChatRequest request) {
        String sessionId = sessionMemoryService.ensureSession(request.getSessionId());
        String language = languageService.resolveLanguage(request.getLanguage(), request.getQuestion());

        sessionMemoryService.appendUserMessage(sessionId, request.getQuestion());
        GovDomain domain = domainRouter.route(request.getQuestion());

        List<Message> history = sessionMemoryService.getMessages(sessionId);
        List<RetrievedDocument> docs = ragService.retrieve(domain, request.getQuestion(), 3);

        String response = agentFactory.createAgent().answer(domain, language, request.getQuestion(), history, docs);
        sessionMemoryService.appendAssistantMessage(sessionId, response);

        List<SourceSnippet> sources = docs.stream()
                .map(doc -> new SourceSnippet(doc.title(), doc.sourceUrl(), doc.score()))
                .toList();

        return new ChatResponse(sessionId, language, domain, response, sources, Instant.now());
    }
}

