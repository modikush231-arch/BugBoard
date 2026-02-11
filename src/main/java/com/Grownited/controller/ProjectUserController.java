package com.Grownited.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.Grownited.entity.ProjectUserEntity;
import com.Grownited.repository.ProjectUserRepository;

@Controller
public class ProjectUserController {

	@Autowired
	ProjectUserRepository projectUserRepository;
	
	@GetMapping("/projectUser")
	public String ProjectUser() {
		return "ProjectUser";
	}
	
	@PostMapping("/saveProjectUser")
	public String saveProjectUser(ProjectUserEntity projectUserEntity) {
		projectUserRepository.save(projectUserEntity);
		return "AdminDashboard";
	}
	
	
	
}
