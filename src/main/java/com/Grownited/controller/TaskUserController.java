package com.Grownited.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.Grownited.entity.TaskUserEntity;
import com.Grownited.repository.TaskUserRepository;

@Controller
public class TaskUserController {

	@Autowired
	TaskUserRepository taskUserRepository;
	
	@GetMapping("taskUser")
	public String TaskUser() {
		return "TaskUser";
	}
	
	@PostMapping("saveTaskUser")
	public String SaveTaskUser(TaskUserEntity taskUserEntity) {
		taskUserRepository.save(taskUserEntity);
		return "AdminDashboard";
	}
}
