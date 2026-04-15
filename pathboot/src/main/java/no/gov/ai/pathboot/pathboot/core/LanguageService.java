package no.gov.ai.pathboot.pathboot.core;

import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.Locale;
import java.util.Set;

@Service
public class LanguageService {

    private static final Set<String> NORWEGIAN_HINTS = Set.of(
            "hvordan", "hva", "hjelp", "skatt", "arbeid", "opphold", "ytelse"
    );

    public String resolveLanguage(String requestedLanguage, String question) {
        if (StringUtils.hasText(requestedLanguage)) {
            return requestedLanguage.trim().toLowerCase(Locale.ROOT);
        }
        return detectLanguage(question);
    }

    public String detectLanguage(String text) {
        if (!StringUtils.hasText(text)) {
            return "en";
        }

        String normalized = text.toLowerCase(Locale.ROOT);
        if (normalized.matches(".*[\\u1200-\\u137f].*")) {
            return "am";
        }

        if (normalized.matches(".*[æøå].*")) {
            return "no";
        }

        for (String token : normalized.split("\\W+")) {
            if (NORWEGIAN_HINTS.contains(token)) {
                return "no";
            }
        }

        return "en";
    }
}

