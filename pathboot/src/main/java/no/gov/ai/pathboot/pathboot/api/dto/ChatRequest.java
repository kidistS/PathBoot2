package no.gov.ai.pathboot.pathboot.api.dto;

import jakarta.validation.constraints.NotBlank;

public class ChatRequest {

    private String sessionId;

    @NotBlank
    private String question;

    private String language;

    public String getSessionId() {
        return sessionId;
    }

    public void setSessionId(String sessionId) {
        this.sessionId = sessionId;
    }

    public String getQuestion() {
        return question;
    }

    public void setQuestion(String question) {
        this.question = question;
    }

    public String getLanguage() {
        return language;
    }

    public void setLanguage(String language) {
        this.language = language;
    }
}

