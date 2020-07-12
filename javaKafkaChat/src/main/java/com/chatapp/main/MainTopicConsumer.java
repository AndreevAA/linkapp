package com.chatapp.main;

import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Component;
import java.util.ArrayList;
import java.util.List;

@Component
public class MainTopicConsumer {

    private final List<String> messages = new ArrayList<>();

    @KafkaListener(topics = "mainTopic", groupId = "kafka-sandbox")
    public void listen(String message) {

        synchronized (messages) {

            messages.add(message);
        }
    }

    public List<String> getMessages() {

        return messages;
    }
}