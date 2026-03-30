package com.Grownited.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.Grownited.repository.ProjectRepository;
import com.Grownited.repository.TaskRepository;



@Controller
public class AdminController {
	
	@Autowired
	ProjectRepository projectRepository;
	
	@Autowired
	TaskRepository taskRepository;
	

	@GetMapping("AdminDashboard")
	public String AdminDashboard(Model model) {
		 long totalProjects = projectRepository.count();
		    long ongoingProjects = projectRepository.countByProjectStatusIdIn(List.of(3,4));
		    long totalTasks = taskRepository.count();
		    long pendingTasks = taskRepository.countByStatusNotIn(List.of("5", "1"));

		    model.addAttribute("totalProjects", totalProjects);
		    model.addAttribute("ongoingProjects", ongoingProjects);
		    model.addAttribute("totalTasks", totalTasks);
		    model.addAttribute("pendingTasks", pendingTasks);

		    long lead = projectRepository.countByProjectStatusId(1);
		    long notStarted = projectRepository.countByProjectStatusId(2);
		    long hold = projectRepository.countByProjectStatusId(3);
		    long progress = projectRepository.countByProjectStatusId(4);
		    long completed = projectRepository.countByProjectStatusId(5);

		    model.addAttribute("leadProjects", lead);
		    model.addAttribute("notStartedProjects", notStarted);
		    model.addAttribute("holdProjects", hold);
		    model.addAttribute("progressProjects", progress);
		    model.addAttribute("completedProjects", completed);
	    return "AdminDashboard";
	}
	
}
