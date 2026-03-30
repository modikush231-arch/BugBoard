package com;

import java.util.HashMap;
import java.util.Map;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;

import com.cloudinary.Cloudinary;

@SpringBootApplication
public class BugBoardApplication {

	public static void main(String[] args) {
		SpringApplication.run(BugBoardApplication.class, args);
	}

	@Bean 
	PasswordEncoder	getPasswordEncoder(){
		return new BCryptPasswordEncoder();
	}
	
	@Bean
	Cloudinary getCloudinary() {
		Map<String, String> config = new HashMap<>();
		config.put("cloud_name", "ddo2rvrvd");
		config.put("api_key", "548873737964715");
		config.put("api_secret", "L-34GmizIweTaY-PLbysrLsqX5M");
		return new Cloudinary(config);
	}
}
	