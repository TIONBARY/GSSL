package com.drdoc.BackEnd;

import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@EnableScheduling
public class BackEndApplication {
    public static final String APPLICATION_LOCATIONS = "spring.config.location="
            + "classpath:application.yml,"
            + "classpath:aws.yml";

	public static void main(String[] args) {
		new SpringApplicationBuilder(BackEndApplication.class)
        .properties(APPLICATION_LOCATIONS)
        .run(args);;
	}

}
