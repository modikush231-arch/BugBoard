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
import com.Grownited.entity.ProjectStatusEntity;
import com.Grownited.repository.ProjectRepository;
import com.Grownited.repository.ProjectStatusRepositary;


@Controller
public class ProjectController {

	@Autowired
	ProjectRepository projectRepository;
	
	@Autowired
	ProjectStatusRepositary projectStatusRepositary;
	
	@GetMapping("projectList")
	public String Project(Model model) {
		List<ProjectEntity> projectList=projectRepository.findAll();
		List<ProjectStatusEntity> statusList = projectStatusRepositary.findAll();
		model.addAttribute("projectList",projectList);
		 model.addAttribute("statusList", statusList);
		return "Project";
	}
	@PostMapping("saveProject")
	public String SaveProject(ProjectEntity projectEntity) {

	    projectEntity.setTotalUtilizedHours(0);

	    // default status = Not Started
	    projectEntity.setProjectStatusId(2);

	    projectRepository.save(projectEntity);

	    return "redirect:/projectList";
	}
	   @GetMapping("/viewProject/{projectId}")
	    public String viewProject(@PathVariable Integer projectId, Model model) {
	        Optional<ProjectEntity> projectOpt = projectRepository.findById(projectId);

	        if (projectOpt.isPresent()) {
	            model.addAttribute("project", projectOpt.get());
	            // Add this line to pass status list
	            List<ProjectStatusEntity> statusList = projectStatusRepositary.findAll();
	            model.addAttribute("statusList", statusList);
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
