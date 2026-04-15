package no.gov.ai.pathboot.pathboot.api;

import no.gov.ai.pathboot.pathboot.api.dto.SessionView;
import no.gov.ai.pathboot.pathboot.core.SessionMemoryService;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/sessions")
public class SessionController {

    private final SessionMemoryService sessionMemoryService;

    public SessionController(SessionMemoryService sessionMemoryService) {
        this.sessionMemoryService = sessionMemoryService;
    }

    @GetMapping("/{sessionId}")
    public SessionView getSession(@PathVariable String sessionId) {
        return new SessionView(sessionId, sessionMemoryService.getMessages(sessionId));
    }

    @DeleteMapping("/{sessionId}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void clearSession(@PathVariable String sessionId) {
        sessionMemoryService.clearSession(sessionId);
    }
}

