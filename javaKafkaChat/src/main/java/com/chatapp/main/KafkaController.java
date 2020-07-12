package com.chatapp.main;

import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import java.util.List;
import com.chatapp.main.MainTopicConsumer;

@RestController
public class KafkaController {

    private KafkaTemplate<String, String> template;
    private MainTopicConsumer mainTopicConsumer;

    public KafkaController(KafkaTemplate<String, String> template, MainTopicConsumer mainTopicConsumer) {
        
    	this.template = template;
        this.mainTopicConsumer = mainTopicConsumer;
    }

    @GetMapping("/chatapp/produce")
    public void produce(@RequestParam String message) {
        
    	template.send("mainTopic", message);
    }

    @GetMapping("/chatapp/messages")
    public List<String> getMessages() {

        return mainTopicConsumer.getMessages();
    }
}