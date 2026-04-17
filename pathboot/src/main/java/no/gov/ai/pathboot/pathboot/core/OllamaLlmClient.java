package no.gov.ai.pathboot.pathboot.core;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import no.gov.ai.pathboot.pathboot.config.AiProperties;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestClient;

import java.util.Map;

@Component
public class OllamaLlmClient implements LlmClient {

    private final RestClient restClient;
    private final AiProperties properties;
    private final ObjectMapper objectMapper;

    public OllamaLlmClient(RestClient.Builder restClientBuilder, AiProperties properties, ObjectMapper objectMapper) {
        this.properties = properties;
        this.objectMapper = objectMapper;
        this.restClient = restClientBuilder.baseUrl(properties.getOllama().getBaseUrl()).build();
    }

    @Override
    public String generate(String prompt, String language) {
        try {
            String responseBody = restClient.post()
                    .uri("/api/generate")
                    .body(Map.of(
                            "model", properties.getOllama().getModel(),
                            "prompt", prompt,
                            "stream", false
                    ))
                    .retrieve()
                    .body(String.class);

            if (responseBody == null || responseBody.isBlank()) {
                return fallback(language);
            }

            JsonNode root = objectMapper.readTree(responseBody);
            JsonNode responseNode = root.get("response");
            if (responseNode == null || responseNode.asText().isBlank()) {
                return fallback(language);
            }
            return responseNode.asText().trim();
        } catch (Exception ignored) {
            return fallback(language);
        }
    }

    private String fallback(String language) {
        return switch (language) {
            case "no" -> "Jeg fant relevant veiledning, men AI-tjenesten er utilgjengelig akkurat naa. Proev igjen om litt.";
            case "am" -> "ተገቢ መመሪያ አግኝቻለሁ፣ ነገር ግን በአሁኑ ጊዜ የአርቲፊሻል ኢንተሊጀንስ አገልግሎት በመስጠት ላይ አይደለም ። እባክዎ በቅርቡ እንደገና ይሞክሩ።";
            default -> "I found relevant guidance, but the local AI service is currently unavailable. Please try again shortly.";
        };
    }
}

