package no.gov.ai.pathboot.pathboot.core;

import no.gov.ai.pathboot.pathboot.model.GovDomain;
import org.springframework.stereotype.Service;

import java.util.EnumMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

@Service
public class DomainRouter {

    private static final Map<GovDomain, List<String>> KEYWORDS = new EnumMap<>(GovDomain.class);

    static {
        KEYWORDS.put(GovDomain.NAV, List.of("nav", "benefit", "benefits", "unemployment", "sick", "ytelse", "dagpenger"));
        KEYWORDS.put(GovDomain.TAX, List.of("tax", "skat", "skatt", "deduction", "fradrag", "income", "selvangivelse"));
        KEYWORDS.put(GovDomain.IMMIGRATION, List.of("udi", "visa", "residence", "immigration", "opphold", "permit", "family reunification"));
    }

    public GovDomain route(String question) {
        if (question == null || question.isBlank()) {
            return GovDomain.GENERAL;
        }

        String typeCastQuestion = question.toLowerCase(Locale.ROOT);
        GovDomain winner = GovDomain.GENERAL;
        int bestScore = 0;

        for (Map.Entry<GovDomain, List<String>> entry : KEYWORDS.entrySet()) {
            int score = 0;
            for (String keyword : entry.getValue()) {
                if (typeCastQuestion.contains(keyword)) {
                    score++;
                }
            }
            if (score > bestScore) {
                bestScore = score;
                winner = entry.getKey();
            }
        }

        return winner;
    }
}

