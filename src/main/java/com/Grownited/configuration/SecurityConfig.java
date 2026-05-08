package com.Grownited.configuration;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            // Disable Spring Security's built-in form login entirely
            .formLogin(form -> form.disable())

            // Disable HTTP Basic popup (browser username/password dialog)
            .httpBasic(basic -> basic.disable())

            // Allow ALL requests — your AuthFilter handles session-based auth
            .authorizeHttpRequests(auth -> auth
                .anyRequest().permitAll()
            )

            // Disable CSRF so your POST forms (/authenticate, /saveModule etc.) work
            .csrf(csrf -> csrf.disable());

        return http.build();
    }
}