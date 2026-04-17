package no.gov.ai.pathboot.pathboot.model;

import java.time.Instant;

public record Message(MessageRole role, String text, Instant timestamp) {
}

