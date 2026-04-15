package no.gov.ai.pathboot.pathboot;

import no.gov.ai.pathboot.pathboot.config.AiProperties;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.properties.EnableConfigurationProperties;

@SpringBootApplication
@EnableConfigurationProperties(AiProperties.class)
public class PathbootApplication {

	public static void main(String[] args) {
		SpringApplication.run(PathbootApplication.class, args);
	}

}
