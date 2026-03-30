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
import com.Grownited.entity.TaskEntity;
import com.Grownited.repository.ModuleRepositary;
import com.Grownited.repository.ProjectRepository;
import com.Grownited.repository.ProjectStatusRepositary;
import com.Grownited.repository.TaskRepository;


@Controller
public class TaskController {

	@Autowired
	TaskRepository taskRepository;
	
	@Autowired
	ProjectRepository projectRepository;
	
	@Autowired
	ProjectStatusRepositary projectStatusRepositary;
	
	@Autowired
	ModuleRepositary moduleRepositary;
	
	@GetMapping("taskList")
	public String Module(Model model) {
	List<TaskEntity> taskList=taskRepository.findAll();
	List<ProjectEntity> projectList=projectRepository.findAll();
	List<ProjectStatusEntity> statusList = projectStatusRepositary.findAll();
	List<ModuleEntity> moduleList = moduleRepositary.findAll();
	model.addAttribute("taskList",taskList);
	model.addAttribute("projectList", projectList);
	model.addAttribute("statusList", statusList);
	model.addAttribute("moduleList",moduleList);
		return "Task";
	}
	
	@PostMapping("saveTask")
	public String SaveTask(TaskEntity taskEntity) {
		taskEntity.setTotalUtilizedHours(0);
		taskRepository.save(taskEntity);
		return "redirect:/taskList";
	}
	
	@GetMapping("/viewTask/{taskId}")
    public String viewTask(@PathVariable Integer taskId, Model model) {
        Optional<TaskEntity> taskOpt = taskRepository.findById(taskId);

        if (taskOpt.isPresent()) {
            model.addAttribute("task", taskOpt.get());
            List<ProjectEntity> projectList = projectRepository.findAll();
            List<ProjectStatusEntity> statusList = projectStatusRepositary.findAll();
            List<ModuleEntity> moduleList = moduleRepositary.findAll();            
            model.addAttribute("projectList", projectList);
            model.addAttribute("statusList",statusList);
            model.addAttribute("moduleList",moduleList);
            return "ViewTask"; 
        }

        return "redirect:/taskList";
    }
   
   @GetMapping("deleteTask/{taskId}")
	public String deleteTask(@PathVariable Integer taskId) {
		taskRepository.deleteById(taskId);
		
		return "redirect:/taskList";//do not open jsp , open another url -> taskList
	}

}
