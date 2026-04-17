package no.gov.ai.pathboot.pathboot.core;

import no.gov.ai.pathboot.pathboot.model.GovDomain;
import no.gov.ai.pathboot.pathboot.model.RetrievedDocument;
import org.springframework.stereotype.Service;

import java.util.Comparator;
import java.util.List;
import java.util.Locale;
import java.util.Set;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

@Service
public class RagService {

    private static final Pattern SPLIT_PATTERN = Pattern.compile("\\W+");

    private static final List<RetrievedDocument> KNOWLEDGE_BASE = List.of(
            new RetrievedDocument(
                    GovDomain.NAV,
                    "NAV unemployment benefits",
                    "To apply for unemployment benefits (dagpenger), register as a job seeker, submit documentation of previous income, and report activity every 14 days.",
                    "https://www.nav.no/dagpenger",
                    0.0
            ),
            new RetrievedDocument(
                    GovDomain.TAX,
                    "Tax card and annual tax return",
                    "People working in Norway need a tax deduction card. Check and submit the annual tax return and report deductions before the deadline.",
                    "https://www.skatteetaten.no/en/",
                    0.0
            ),
            new RetrievedDocument(
                    GovDomain.IMMIGRATION,
                    "UDI residence permit guidance",
                    "Residence permit applications are handled by UDI. Requirements vary by permit type, and applicants should prepare identity, housing, and income documentation.",
                    "https://www.udi.no/en/",
                    0.0
            ),
            new RetrievedDocument(
                    GovDomain.GENERAL,
                    "Public service portal",
                    "Norway's public services are available digitally through relevant agency portals. Always verify deadlines and official requirements before submitting an application.",
                    "https://www.norge.no/en",
                    0.0
            )
    );

    public List<RetrievedDocument> retrieve(GovDomain domain, String question, int topK) {
        Set<String> queryTokens = tokenize(question);

        return KNOWLEDGE_BASE.stream()
                .filter(doc -> doc.domain() == domain || doc.domain() == GovDomain.GENERAL)
                .map(doc ->
                        new RetrievedDocument(
                                doc.domain(),
                                doc.title(),
                                doc.content(),
                                doc.sourceUrl(),
                                score(queryTokens, doc.content())
                        )
                )
                .sorted(Comparator.comparingDouble(RetrievedDocument::score).reversed())
                .limit(topK)
                .collect(Collectors.toList());
    }

    private double score(Set<String> queryTokens, String text) {
        if (queryTokens.isEmpty()) {
            return 0.0;
        }
        Set<String> textTokens = tokenize(text);
        long overlap = queryTokens.stream().filter(textTokens::contains).count();
        return overlap / (double) queryTokens.size();
    }

    private Set<String> tokenize(String text) {
        if (text == null || text.isBlank()) {
            return Set.of();
        }
        return SPLIT_PATTERN.splitAsStream(text.toLowerCase(Locale.ROOT))
                .filter(token -> !token.isBlank())
                .collect(Collectors.toSet());
    }
}

