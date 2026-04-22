package com.Grownited.controller;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.Grownited.entity.TaskUserEntity;
import com.Grownited.entity.UserDetailsEntity;
import com.Grownited.entity.UserEntity;
import com.Grownited.repository.TaskUserRepository;
import com.Grownited.repository.UserDetailsRepositary;
import com.Grownited.repository.UserRepository;
import com.Grownited.service.MailerService;
import com.cloudinary.Cloudinary;

import jakarta.servlet.http.HttpSession;

@Controller
public class UserController {
    
    @Autowired
    UserRepository userRepository;
    
    @Autowired
    UserDetailsRepositary userDetailsRepositary;
    
    @Autowired
    TaskUserRepository taskUserRepository;
    
    @Autowired
    MailerService mailerService;
    
    @Autowired
    Cloudinary cloudinary;
    
    @Autowired
    PasswordEncoder passwordEncoder;

    @GetMapping("UserList")
    public String UserList(Model model) {
        List<UserEntity> userList = userRepository.findAll();
        model.addAttribute("userList", userList);
        return "User"; 
    }
    
    @PostMapping("saveUser")
    public String SaveUser(UserEntity userEntity,
                           UserDetailsEntity userDetailsEntity,
                           @RequestParam(value = "profilePic", required = false) MultipartFile profilePic) {

        userEntity.setIs_active(true);
        userEntity.setCreated_at(LocalDateTime.now());

        // PASSWORD ENCODE
        String plainPassword = userEntity.getPassword();
        String encodedPassword = passwordEncoder.encode(plainPassword);
        userEntity.setPassword(encodedPassword);

        // CLOUDINARY IMAGE UPLOAD
        try {
            if (profilePic != null && !profilePic.isEmpty()) {
                Map map = cloudinary.uploader().upload(profilePic.getBytes(), null);
                String profilePicURL = map.get("secure_url").toString();
                userEntity.setProfilePicURL(profilePicURL);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }

        // SAVE USER
        UserEntity savedUser = userRepository.save(userEntity);

        // SAVE USER DETAILS
        userDetailsEntity.setUserId(savedUser.getUserId().toString());
        userDetailsRepositary.save(userDetailsEntity);

        // SEND EMAIL WITH PLAIN PASSWORD
        mailerService.sendWelcomeMail(savedUser, plainPassword);

        return "redirect:/UserList";
    }
    
    @GetMapping("/profile")
    public String viewProfile(HttpSession session, Model model) {

        UserEntity dbuser = (UserEntity) session.getAttribute("dbuser");

        if (dbuser != null) {

            // fetch latest data from DB
            Optional<UserEntity> userOpt = userRepository.findById(dbuser.getUserId());

            if (userOpt.isPresent()) {

                UserEntity user = userOpt.get();
                model.addAttribute("user", user);

                // fetch user details
                UserDetailsEntity userDetails = userDetailsRepositary.findByUserId(user.getUserId().toString());
                model.addAttribute("userDetails", userDetails);

                // Calculate completed tasks count for developers and testers
                long completedTasksCount = 0;
                if ("developer".equals(user.getRole())) {
                    List<TaskUserEntity> taskUsers = taskUserRepository.findByUserId(user.getUserId());
                    completedTasksCount = taskUsers.stream()
                            .filter(tu -> "Completed".equals(tu.getTaskStatus()))
                            .count();
                }
                model.addAttribute("completedTasksCount", completedTasksCount);
                
                long verifiedTasksCount = 0;
                if ("tester".equals(user.getRole())) {
                    List<TaskUserEntity> taskUsers = taskUserRepository.findByUserId(user.getUserId());
                    verifiedTasksCount = taskUsers.stream()
                            .filter(tu -> "Verified".equals(tu.getTaskStatus()))
                            .count();
                }
                model.addAttribute("verifiedTasksCount", verifiedTasksCount);
                // ✅ Format dates in controller (not JSP)
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MMM yyyy");
                String formattedCreatedDate = "";
                if (user.getCreated_at() != null) {
                    formattedCreatedDate = user.getCreated_at().format(formatter);
                }
                model.addAttribute("formattedCreatedDate", formattedCreatedDate);

                return "Profile";
            }
        }

        return "redirect:/login";
    }
    
    @GetMapping("/viewUser/{userId}")
    public String viewUser(@PathVariable("userId") Integer userId, Model model) {
        
        Optional<UserEntity> userOpt = userRepository.findById(userId);

        if (userOpt.isPresent()) {
            
            UserEntity user = userOpt.get();
            model.addAttribute("user", user);

            UserDetailsEntity userDetails = userDetailsRepositary.findByUserId(userId.toString());

            if (userDetails != null) {
                model.addAttribute("userDetails", userDetails);
            } else {
                model.addAttribute("userDetails", new UserDetailsEntity());
            }
            
            // Calculate completed tasks count
            long completedTasksCount = 0;
            if ("developer".equals(user.getRole()) || "tester".equals(user.getRole())) {
                List<TaskUserEntity> taskUsers = taskUserRepository.findByUserId(user.getUserId());
                completedTasksCount = taskUsers.stream()
                        .filter(tu -> "Completed".equals(tu.getTaskStatus()))
                        .count();
            }
            model.addAttribute("completedTasksCount", completedTasksCount);
            
            // Format created date
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MMM yyyy");
            String formattedCreatedDate = "";
            if (user.getCreated_at() != null) {
                formattedCreatedDate = user.getCreated_at().format(formatter);
            }
            model.addAttribute("formattedCreatedDate", formattedCreatedDate);
            
            return "ViewUser";
        }

        return "redirect:/UserList";
    }
 // Edit User - Show form
    @GetMapping("editUser/{userId}")
    public String editUser(@PathVariable Integer userId, Model model) {
        Optional<UserEntity> userOpt = userRepository.findById(userId);
        if (userOpt.isPresent()) {
            UserEntity user = userOpt.get();
            model.addAttribute("user", user);
            
            UserDetailsEntity userDetails = userDetailsRepositary.findByUserId(userId.toString());
            if (userDetails != null) {
                model.addAttribute("userDetails", userDetails);
            } else {
                model.addAttribute("userDetails", new UserDetailsEntity());
            }
            return "EditUser";
        }
        return "redirect:/UserList";
    }

    // Update User (Admin)
    @PostMapping("updateUser")
    public String updateUser(@RequestParam("userId") Integer userId,
                             @RequestParam("first_name") String firstName,
                             @RequestParam("last_name") String lastName,
                             @RequestParam("email") String email,
                             @RequestParam("mobile") String mobile,
                             @RequestParam("gender") String gender,
                             @RequestParam("role") String role,
                             @RequestParam("is_active") boolean isActive,
                             @RequestParam(value = "qualification", required = false) String qualification,
                             @RequestParam(value = "city", required = false) String city,
                             @RequestParam(value = "state", required = false) String state,
                             @RequestParam(value = "country", required = false) String country,
                             @RequestParam(value = "profilePic", required = false) MultipartFile profilePic) {
        
        Optional<UserEntity> opt = userRepository.findById(userId);
        if (opt.isPresent()) {
            UserEntity user = opt.get();
            user.setFirst_name(firstName);
            user.setLast_name(lastName);
            user.setEmail(email);
            user.setMobile(mobile);
            user.setGender(gender);
            user.setRole(role);
            user.setIs_active(isActive);
            
            // Update profile picture if new file provided
            if (profilePic != null && !profilePic.isEmpty()) {
                try {
                    Map map = cloudinary.uploader().upload(profilePic.getBytes(), null);
                    String profilePicURL = map.get("secure_url").toString();
                    user.setProfilePicURL(profilePicURL);
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
            userRepository.save(user);
            
            // Update user details
            UserDetailsEntity userDetails = userDetailsRepositary.findByUserId(userId.toString());
            if (userDetails == null) {
                userDetails = new UserDetailsEntity();
                userDetails.setUserId(userId.toString());
            }
            userDetails.setQualification(qualification);
            userDetails.setCity(city);
            userDetails.setState(state);
            userDetails.setCountry(country);
            userDetailsRepositary.save(userDetails);
        }
        return "redirect:/UserList";
    }
    
    @GetMapping("deleteUser/{userId}")
    public String deleteUser(@PathVariable Integer userId) {
        
        UserDetailsEntity userDetails = userDetailsRepositary.findByUserId(userId.toString());

        if(userDetails != null) {
            userDetailsRepositary.delete(userDetails);
        }
        
        userRepository.deleteById(userId);
        return "redirect:/UserList";
    }
    
    @PostMapping("updateProfile")
    public String updateProfile(HttpSession session,
                                @RequestParam("first_name") String firstName,
                                @RequestParam("last_name") String lastName,
                                @RequestParam("email") String email,
                                @RequestParam("mobile") String mobile,
                                @RequestParam("gender") String gender,
                                @RequestParam(value = "qualification", required = false) String qualification,
                                @RequestParam(value = "city", required = false) String city,
                                @RequestParam(value = "state", required = false) String state,
                                @RequestParam(value = "country", required = false) String country,
                                @RequestParam(value = "profilePic", required = false) MultipartFile profilePic) {
        
        UserEntity dbuser = (UserEntity) session.getAttribute("dbuser");
        
        if (dbuser == null) {
            return "redirect:/login";
        }
        
        Optional<UserEntity> userOpt = userRepository.findById(dbuser.getUserId());
        
        if (userOpt.isPresent()) {
            UserEntity user = userOpt.get();
            
            // Update user fields
            user.setFirst_name(firstName);
            user.setLast_name(lastName);
            user.setEmail(email);
            user.setMobile(mobile);
            user.setGender(gender);
            // Note: created_at should not be updated
            
            // Update profile picture if provided
            if (profilePic != null && !profilePic.isEmpty()) {
                try {
                    Map map = cloudinary.uploader().upload(profilePic.getBytes(), null);
                    String profilePicURL = map.get("secure_url").toString();
                    user.setProfilePicURL(profilePicURL);
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
            
            userRepository.save(user);
            
            // Update user details
            UserDetailsEntity userDetails = userDetailsRepositary.findByUserId(user.getUserId().toString());
            if (userDetails != null) {
                userDetails.setQualification(qualification);
                userDetails.setCity(city);
                userDetails.setState(state);
                userDetails.setCountry(country);
                userDetailsRepositary.save(userDetails);
            }
            
            // Update session
            session.setAttribute("dbuser", user);
        }
        
        return "redirect:/profile";
    }
    
}