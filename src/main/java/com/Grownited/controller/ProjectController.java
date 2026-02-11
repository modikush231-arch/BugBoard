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
import com.Grownited.repository.ProjectRepository;
import com.Grownited.repository.ProjectStatusRepositary;


@Controller
public class ProjectController {

	@Autowired
	ProjectRepository projectRepository;
	
	
	@GetMapping("projectList")
	public String Project(Model model) {
		List<ProjectEntity> projectList=projectRepository.findAll();
		model.addAttribute("projectList",projectList);
		return "Project";
	}
	
	@PostMapping("saveProject")
	public String SaveProject(ProjectEntity projectEntity) {
		projectRepository.save(projectEntity);

		return "redirect:/projectList";
	}
	   @GetMapping("/viewProject/{projectId}")
	    public String viewProject(@PathVariable Integer projectId, Model model) {
	        Optional<ProjectEntity> projectOpt = projectRepository.findById(projectId);

	        if (projectOpt.isPresent()) {
	            model.addAttribute("project", projectOpt.get());
	            return "ViewProject"; // ViewProject.jsp
	        }

	        return "redirect:/projectList";
	    }
	   
	   @GetMapping("deleteProject/{projectId}")
		public String deleteProject(@PathVariable Integer projectId) {
			projectRepository.deleteById(projectId);
			
			return "redirect:/projectList";//do not open jsp , open another url -> listHackathon
		}


	
	
}
