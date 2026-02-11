package com.Grownited.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.Grownited.entity.UserTypeEntity;
import com.Grownited.repository.UserTypeRepository;

@Controller
public class UserTypeController {

	@Autowired
	UserTypeRepository userTypeRepository;
	
	@GetMapping("newUserType")
	public String NewUserType() {
		return "NewUserType";
	}
	
	@PostMapping("saveUserType")
	public String SaveUserType(UserTypeEntity userTypeEntity) {
		userTypeRepository.save(userTypeEntity);
		return "AdminDashboard";
	}
}
