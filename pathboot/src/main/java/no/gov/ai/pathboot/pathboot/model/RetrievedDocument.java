package no.gov.ai.pathboot.pathboot.model;

public record RetrievedDocument(
        GovDomain domain,
        String title,
        String content,
        String sourceUrl,
        double score
) {
}

