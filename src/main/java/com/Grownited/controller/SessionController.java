package com.Grownited.controller;

import java.time.LocalDateTime;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.Grownited.entity.UserEntity;
import com.Grownited.repository.UserRepository;

@Controller
public class SessionController {
	
	@Autowired
	UserRepository userRepository;
	
	@GetMapping("/signup")
	public String openSignupPage() {
		return "Signup";
	}

	
	@PostMapping("/rlogin")
	public String openRLoginPage(String newPassword) {
		System.out.println("Updated Password: "+newPassword);
		return "Login";
	}
	
	@GetMapping("/login")
	public String openLoginPage() {
		return "Login";
	}
	
	
	@PostMapping("/sendResetLink")
	public String openSendResetLinkPage() {
		return "ResetPass";
	}

	
	@GetMapping("/forgetPass")
	public String openForgetPassword() {
		return "ForgetPass";
	}
	
	@PostMapping("/register")
	public String register(UserEntity userEntity) {
		
		System.out.println("First Name: "+userEntity.getFirst_name());
		System.out.println("Last Name: "+userEntity.getLast_name());

		
		userEntity.setRole("User");
		userEntity.setIs_active(true);
		userEntity.setCreated_at(LocalDateTime.now());
		
		userRepository.save(userEntity);
		return "Login";
	}
	
	
}