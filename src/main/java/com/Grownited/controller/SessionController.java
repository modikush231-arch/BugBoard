package com.Grownited.controller;

import java.util.Optional;
import java.util.Random;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.Grownited.entity.UserEntity;
import com.Grownited.repository.UserRepository;
import com.Grownited.service.MailerService;

import jakarta.servlet.http.HttpSession;

@Controller
public class SessionController {

    @Autowired
    UserRepository userRepository;
    
    @Autowired
    MailerService mailerService;
    
    @Autowired
    PasswordEncoder passwordEncoder;
    
 	@GetMapping("/")
    public String home() {
        return "redirect:/login";
    }
	
    @GetMapping("/login")
    public String openLoginPage() {
        return "Login";
    }
    
    @PostMapping("/authenticate")
	public String authenticate(String email, String password, Model model, HttpSession session) {
		Optional<UserEntity> op = userRepository.findByEmail(email);

		if (op.isPresent()) {
			
			UserEntity dbUser = op.get();
	
		//if (dbUser.getPassword().equals(password)) {

			if (passwordEncoder.matches(password, dbUser.getPassword())) {
				
				session.setAttribute("dbuser", dbUser);
			
				if (dbUser.getRole().equals("system_admin")) 
				{
					return "redirect:/AdminDashboard";// url '
				}
				else if (dbUser.getRole().equals("project_manager"))
				{
					return "redirect:/ProjectManagerDashboard";// url '
				} 
				else if (dbUser.getRole().equals("developer"))
				{
					return "redirect:/DeveloperDashboard";
				}
				else if (dbUser.getRole().equals("tester"))
				{
					return "redirect:/TesterDashboard";
				}
			}
		}
		
		
		model.addAttribute("error","Invalid Credentials");

		
		return "Login";
	}

    @GetMapping("/forgetPass")
    public String openForgetPassword() {
        return "ForgetPass";
    }
    
    // STEP 1: Send OTP
    @PostMapping("/sendResetLink")
    public String sendResetLink(String email, Model model) {
    	
    	Optional<UserEntity> optionalUser = userRepository.findByEmail(email);

        if (!optionalUser.isPresent()) {
            model.addAttribute("error", "Email not registered");
            return "ForgetPass";
        }

        UserEntity dbUser = optionalUser.get();

        // Generate 6-digit OTP
   
        int otp = 1000 + new Random().nextInt(9000);

        dbUser.setOtp(String.valueOf(otp));
        userRepository.save(dbUser);

        // Send OTP
        mailerService.sendOtp(email, String.valueOf(otp));

        model.addAttribute("email", email);
        model.addAttribute("success", "OTP sent to your email");

        return "ResetPass";
   }

    // STEP 2: Update password
    @PostMapping("/updatePassword")
    public String updatePassword(String email,
            String otp,
            String newPassword,
            Model model) {
			
			Optional<UserEntity> optionalUser = userRepository.findByEmail(email);
			
			if (optionalUser.isEmpty()) {
			model.addAttribute("error", "User not found");
			return "ResetPass";
			}
			
			UserEntity user = optionalUser.get();
			
			// OTP check
			if (user.getOtp() == null || !user.getOtp().equals(otp)) {
			// Clear OTP from DB if wrong
			user.setOtp(null);
			userRepository.save(user);
			
			model.addAttribute("email", email);
			model.addAttribute("error", "Invalid or expired OTP");
			return "ResetPass";
			}
			
			// Encode new password
			String encodedPassword = passwordEncoder.encode(newPassword);
			user.setPassword(encodedPassword);
			
			// Clear OTP after successful reset
			user.setOtp(null);
			userRepository.save(user);
			
			model.addAttribute("success", "Password updated successfully");
			return "Login";
			}
}
