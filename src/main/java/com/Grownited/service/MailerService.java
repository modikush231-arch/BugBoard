package com.Grownited.service;

import java.nio.charset.StandardCharsets;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.core.io.ResourceLoader;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import com.Grownited.entity.UserEntity;


import jakarta.mail.internet.MimeMessage;

@Service
public class MailerService {

	@Autowired
	JavaMailSender javaMailSender;
	
	@Autowired
	private ResourceLoader resourceLoader;
	
	public void sendWelcomeMail(UserEntity user, String plainPassword) {

	    MimeMessage message = javaMailSender.createMimeMessage();
	    Resource resource = resourceLoader.getResource("classpath:templates/WelcomeMail.html");

	    try {

	        String html = new String(resource.getInputStream().readAllBytes(), StandardCharsets.UTF_8);

	        String body = html
	                .replace("${name}", user.getFirst_name())
	                .replace("${email}", user.getEmail())
	                .replace("${password}", plainPassword)
	                .replace("${loginUrl}", "http://localhost:9797/login")
	                .replace("${companyName}", "BugBoard");

	        MimeMessageHelper helper = new MimeMessageHelper(message, true);

	        helper.setTo(user.getEmail());
	        helper.setSubject("BugBoard Account Created");
	        helper.setText(body, true);

	        javaMailSender.send(message);

	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	}
	
    public void sendOtp(String toEmail, String otp) {

    	 try {
    	        MimeMessage message = javaMailSender.createMimeMessage();
    	        MimeMessageHelper helper = new MimeMessageHelper(message, true);
    	        
    	        helper.setTo(toEmail);
    	        helper.setSubject("Your BugBoard Password Reset OTP");
    	        
    	        // You can use a simple HTML string here
    	        String content = "<h3>Password Reset Request</h3>" +
    	                         "<p>Use the following OTP to reset your password:</p>" +
    	                         "<h2 style='color:#007bff;'>" + otp + "</h2>" +
    	                         "<p>This code will expire soon.</p>";
    	        
    	        helper.setText(content, true);
    	        javaMailSender.send(message);
    	    } catch (Exception e) {
    	        e.printStackTrace();
    	    }
    }
	
}
