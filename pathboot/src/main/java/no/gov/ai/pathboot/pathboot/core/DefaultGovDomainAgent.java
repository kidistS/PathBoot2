package no.gov.ai.pathboot.pathboot.core;

import no.gov.ai.pathboot.pathboot.model.GovDomain;
import no.gov.ai.pathboot.pathboot.model.Message;
import no.gov.ai.pathboot.pathboot.model.RetrievedDocument;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.stream.Collectors;

@Component
public class DefaultGovDomainAgent implements GovDomainAgent {

    private final LlmClient llmClient;

    public DefaultGovDomainAgent(LlmClient llmClient) {
        this.llmClient = llmClient;
    }

    @Override
    public String answer(
            GovDomain domain,
            String language,
            String question,
            List<Message> history,
            List<RetrievedDocument> contextDocs
    ) {
        String prompt = buildPrompt(domain, language, question, history, contextDocs);
        return llmClient.generate(prompt, language);
    }

    private String buildPrompt(
            GovDomain domain,
            String language,
            String question,
            List<Message> history,
            List<RetrievedDocument> contextDocs
    ) {
        String historyLines = history.stream()
                .skip(Math.max(0, history.size() - 6))
                .map(message -> message.role() + ": " + message.text())
                .collect(Collectors.joining("\n"));

        String docs = contextDocs.stream()
                .map(doc -> "- " + doc.title() + ": " + doc.content() + " (" + doc.sourceUrl() + ")")
                .collect(Collectors.joining("\n"));

        return """
                You are GovAI Assistant for Norway public services.
                Domain: %s
                Respond in language code: %s
                Give a concise, practical answer with clear next steps and mention uncertainty when needed.

                Conversation history:
                %s

                Retrieved context:
                %s

                User question:
                %s
                """.formatted(domain, language, historyLines, docs, question);
    }
}

