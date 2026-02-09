package com.Grownited.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.Grownited.entity.ProjectStatusEntity;
import com.Grownited.repository.ProjectStatusRepositary;

@Controller
public class ProjectStatusController {
	
	@Autowired
	ProjectStatusRepositary projectStatusRepositary;
	
	@GetMapping("projectStatus")
	public String projectStatus() {
		
		return "ProjectStatus";
		
	}
	
	@PostMapping("saveStatus")
	public String saveStatus(ProjectStatusEntity projectStatusEntity) {
			
		    projectStatusRepositary.save(projectStatusEntity);
			return "AdminDashboard";
		}
}
	


