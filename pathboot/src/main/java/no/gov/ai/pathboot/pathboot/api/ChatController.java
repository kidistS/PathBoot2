package no.gov.ai.pathboot.pathboot.api;

import jakarta.validation.Valid;
import no.gov.ai.pathboot.pathboot.api.dto.ChatRequest;
import no.gov.ai.pathboot.pathboot.api.dto.ChatResponse;
import no.gov.ai.pathboot.pathboot.core.OrchestratorService;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/chat")
public class ChatController {

    private final OrchestratorService orchestratorService;

    public ChatController(OrchestratorService orchestratorService) {
        this.orchestratorService = orchestratorService;
    }

    @PostMapping
    public ChatResponse chat(@Valid @RequestBody ChatRequest request) {
        return orchestratorService.answer(request);
    }
}

