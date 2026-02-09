package com.Grownited.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.Grownited.entity.ProjectEntity;
import com.Grownited.repository.ProjectRepository;
import com.Grownited.repository.ProjectStatusRepositary;

@Controller
public class ProjectController {

	@Autowired
	ProjectRepository projectRepository;

	
	@GetMapping("projects")
	public String Project() {
		return "Project";
	}
	
	@PostMapping("saveProject")
	public String SaveProject(ProjectEntity projectEntity) {
		projectRepository.save(projectEntity);
		return "AdminDashboard";
	}
	
	
}
