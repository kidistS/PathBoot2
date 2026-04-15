package no.gov.ai.pathboot.pathboot.api.dto;

import no.gov.ai.pathboot.pathboot.model.GovDomain;

import java.time.Instant;
import java.util.List;

public record ChatResponse(
        String sessionId,
        String language,
        GovDomain domain,
        String answer,
        List<SourceSnippet> sources,
        Instant timestamp
) {
}

