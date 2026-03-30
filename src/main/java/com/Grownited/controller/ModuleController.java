package com.Grownited.controller;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;

import com.Grownited.entity.ModuleEntity;
import com.Grownited.entity.ProjectEntity;
import com.Grownited.entity.ProjectStatusEntity;
import com.Grownited.repository.ModuleRepositary;
import com.Grownited.repository.ProjectRepository;
import com.Grownited.repository.ProjectStatusRepositary;

@Controller
public class ModuleController {

	@Autowired
	ModuleRepositary moduleRepositary;
	
	@Autowired
	ProjectRepository projectRepository;
	
	@Autowired
	ProjectStatusRepositary projectStatusRepositary;
	
	
	@GetMapping("moduleList")
	public String Module(Model model) {
	List<ModuleEntity> moduleList=moduleRepositary.findAll();
	List<ProjectEntity> projectList=projectRepository.findAll();
	List<ProjectStatusEntity> statusList = projectStatusRepositary.findAll();


	model.addAttribute("moduleList",moduleList);
	model.addAttribute("projectList", projectList);
	model.addAttribute("statusList", statusList);
		return "Module";
	}
	
	@PostMapping("saveModule")
	public String SaveModule(ModuleEntity moduleEntity) {
		moduleEntity.setTotalUtilizedHours(0);
		moduleRepositary.save(moduleEntity);
		return "redirect:/moduleList";
	}
	

	 @GetMapping("/viewModule/{moduleId}")
	    public String viewModule(@PathVariable("moduleId") Integer moduleId, Model model) {

	        Optional<ModuleEntity> moduleOpt = moduleRepositary.findById(moduleId);

	        if (moduleOpt.isPresent()) {
	            model.addAttribute("module", moduleOpt.get());
	            List<ProjectEntity> projectList = projectRepository.findAll();
	            List<ProjectStatusEntity> statusList = projectStatusRepositary.findAll();
	            model.addAttribute("projectList", projectList);
	            model.addAttribute("statusList",statusList);
	            return "ViewModule"; // JSP page name: ViewModule.jsp
	        } else {
	            // handle module not found
	            model.addAttribute("errorMessage", "Module not found with ID: " + moduleId);
	            return "redirect:/moduleList"; // redirect back to module list
	        }
	    }
	 
	  @GetMapping("deleteModule/{moduleId}")
			public String deleteModule(@PathVariable Integer moduleId) {
				moduleRepositary.deleteById(moduleId);
				
				return "redirect:/moduleList";//do not open jsp , open another url -> listHackathon
			}
	
}