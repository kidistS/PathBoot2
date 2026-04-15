package no.gov.ai.pathboot.pathboot.core;

public interface LlmClient {
    String generate(String prompt, String language);
}

