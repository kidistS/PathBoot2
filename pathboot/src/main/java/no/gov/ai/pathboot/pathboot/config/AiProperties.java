package no.gov.ai.pathboot.pathboot.config;

import org.springframework.boot.context.properties.ConfigurationProperties;

@ConfigurationProperties(prefix = "govai")
public class AiProperties {

    private final Ollama ollama = new Ollama();
    private int sessionHistorySize = 20;

    public Ollama getOllama() {
        return ollama;
    }

    public int getSessionHistorySize() {
        return sessionHistorySize;
    }

    public void setSessionHistorySize(int sessionHistorySize) {
        this.sessionHistorySize = sessionHistorySize;
    }

    public static class Ollama {
        private String baseUrl;
        private String model;

        public String getBaseUrl() {
            return baseUrl;
        }

        public void setBaseUrl(String baseUrl) {
            this.baseUrl = baseUrl;
        }

        public String getModel() {
            return model;
        }

        public void setModel(String model) {
            this.model = model;
        }
    }
}

