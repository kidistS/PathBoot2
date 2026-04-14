package no.gov.ai.pathboot.pathboot;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class PathbootApplication {

	public static void main(String[] args) {
		SpringApplication.run(PathbootApplication.class, args);

        System.out.println("Path Boot Application started successfully!");
	}

}
