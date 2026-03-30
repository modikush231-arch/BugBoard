package com.Grownited.controller;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;


import com.Grownited.entity.ProjectEntity;

import com.Grownited.entity.ProjectUserEntity;

import com.Grownited.entity.UserEntity;
import com.Grownited.repository.ProjectRepository;
import com.Grownited.repository.ProjectUserRepository;
import com.Grownited.repository.UserRepository;

@Controller
public class ProjectUserController {

	
	@Autowired
	ProjectUserRepository projectUserRepository;
	
	@Autowired
	ProjectRepository projectRepository;
	
	@Autowired
	UserRepository userRepository;
	
	
	
	@GetMapping("/projectUserList")
	public String ProjectUser(Model model) {
		List<ProjectUserEntity> projectUserList=projectUserRepository.findAll();
		List<ProjectEntity> projectList=projectRepository.findAll();
		List<UserEntity> userList=userRepository.findByRole("project_manager");
		
		model.addAttribute("projectUserList",projectUserList);
		model.addAttribute("projectList", projectList);
		model.addAttribute("userList", userList);
		
		
		return "ProjectUser";
	}

	@PostMapping("/saveProjectUser")
	public String saveProjectUser(ProjectUserEntity projectUserEntity) {
		projectUserRepository.save(projectUserEntity);
		return "redirect:/projectUserList";
	}
	

    // View single assignment (NEW)
    @GetMapping("/viewProjectUser/{projectUserId}")
    public String viewProjectUser(@PathVariable Integer projectUserId, Model model) {
        Optional<ProjectUserEntity> optional = projectUserRepository.findById(projectUserId);
        if (optional.isPresent()) {
            model.addAttribute("projectUser", optional.get());
            // Also need lists to resolve names (project title, user name)
            model.addAttribute("projectList", projectRepository.findAll());
            model.addAttribute("userList", userRepository.findAll());
            return "ViewProjectUser"; // The detail page
        } else {
            // Redirect if not found
            return "redirect:/projectUserList";
        }
    }
	
	
	   @GetMapping("deleteProjectUser/{projectUserId}") 
		public String deleteProjectUser(@PathVariable Integer projectUserId) {
			projectUserRepository.deleteById(projectUserId);
			return "redirect:/projectUserList";//do not open jsp , open another url -> taskList
		}

	}

