package no.gov.ai.pathboot.pathboot.core;

import org.springframework.stereotype.Component;

@Component
public class AgentFactory {

    private final GovDomainAgent defaultGovDomainAgent;

    public AgentFactory(GovDomainAgent defaultGovDomainAgent) {
        this.defaultGovDomainAgent = defaultGovDomainAgent;
    }

    public GovDomainAgent createAgent() {
        return defaultGovDomainAgent;
    }
}

