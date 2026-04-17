package no.gov.ai.pathboot.pathboot.core;

import no.gov.ai.pathboot.pathboot.model.GovDomain;
import no.gov.ai.pathboot.pathboot.model.Message;
import no.gov.ai.pathboot.pathboot.model.RetrievedDocument;

import java.util.List;

public interface GovDomainAgent {
    String answer(GovDomain domain, String language, String question, List<Message> history, List<RetrievedDocument> contextDocs);
}

