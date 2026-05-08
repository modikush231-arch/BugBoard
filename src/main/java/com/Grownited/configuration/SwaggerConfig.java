package com.Grownited.configuration;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.Components;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.info.Contact;
import io.swagger.v3.oas.models.security.SecurityRequirement;
import io.swagger.v3.oas.models.security.SecurityScheme;

@Configuration
public class SwaggerConfig {

    @Bean
    public OpenAPI customOpenAPI() {
    	return new OpenAPI()
                .info(new Info()
                        .title("Student Management API") //project name
                        .description("API documentation for the Student Management System") //project description
                        .version("1.0")
                        .contact(new Contact()
                                .name("Aman Gupta") // your name
                                .email("contact@engineerscodinghub.com") // your email so if api is not work send mail on your email
                        )
                )
                // Add security requirement for JWT
                .addSecurityItem(new SecurityRequirement().addList("BearerAuth"))

                // Define the security scheme
                .components(new Components()
                        .addSecuritySchemes("BearerAuth",
                                new SecurityScheme()
                                        .name("Authorization")
                                        .type(SecurityScheme.Type.HTTP)
                                        .scheme("bearer")
                                        .bearerFormat("JWT")
                        )
                );

    }
}