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
import com.Grownited.entity.TaskEntity;
import com.Grownited.repository.TaskRepository;

import jakarta.persistence.GeneratedValue;

@Controller
public class TaskController {

	@Autowired
	TaskRepository taskRepository;
	
	@GetMapping("taskList")
	public String Module(Model model) {
	List<TaskEntity> taskList=taskRepository.findAll();
	model.addAttribute("taskList",taskList);
		return "Task";
	}
	
	@PostMapping("saveTask")
	public String SaveTask(TaskEntity taskEntity) {
		taskRepository.save(taskEntity);
		return "redirect:/taskList";
	}
	
	@GetMapping("/viewTask/{taskId}")
    public String viewTask(@PathVariable Integer taskId, Model model) {
        Optional<TaskEntity> taskOpt = taskRepository.findById(taskId);

        if (taskOpt.isPresent()) {
            model.addAttribute("task", taskOpt.get());
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
