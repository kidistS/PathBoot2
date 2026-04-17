package no.gov.ai.pathboot.pathboot.api.dto;

import no.gov.ai.pathboot.pathboot.model.Message;

import java.util.List;

public record SessionView(String sessionId, List<Message> messages) {
}

