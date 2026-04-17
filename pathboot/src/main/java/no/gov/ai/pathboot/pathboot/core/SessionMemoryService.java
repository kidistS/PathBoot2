package no.gov.ai.pathboot.pathboot.core;

import no.gov.ai.pathboot.pathboot.config.AiProperties;
import no.gov.ai.pathboot.pathboot.model.Message;
import no.gov.ai.pathboot.pathboot.model.MessageRole;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.time.Instant;
import java.util.ArrayDeque;
import java.util.Deque;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;

@Service
public class SessionMemoryService {

    private final Map<String, Deque<Message>> sessions = new ConcurrentHashMap<>();
    private final int sessionHistorySize;

    public SessionMemoryService(AiProperties properties) {
        this.sessionHistorySize = properties.getSessionHistorySize();
    }

    public String ensureSession(String incomingSessionId) {
        String sessionId = StringUtils.hasText(incomingSessionId)
                ? incomingSessionId.trim()
                : UUID.randomUUID().toString();
        sessions.computeIfAbsent(sessionId, key -> new ArrayDeque<>());
        return sessionId;
    }

    public List<Message> getMessages(String sessionId) {
        Deque<Message> deque = sessions.get(sessionId);
        if (deque == null) {
            return List.of();
        }
        return List.copyOf(deque);
    }

    public void appendUserMessage(String sessionId, String text) {
        appendMessage(sessionId, MessageRole.USER, text);
    }

    public void appendAssistantMessage(String sessionId, String text) {
        appendMessage(sessionId, MessageRole.ASSISTANT, text);
    }

    public void clearSession(String sessionId) {
        sessions.remove(sessionId);
    }

    private void appendMessage(String sessionId, MessageRole role, String text) {
        Deque<Message> deque = sessions.computeIfAbsent(sessionId, key -> new ArrayDeque<>());
        deque.addLast(new Message(role, text, Instant.now()));
        while (deque.size() > sessionHistorySize) {
            deque.removeFirst();
        }
    }
}

