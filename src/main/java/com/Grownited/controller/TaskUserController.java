package com.Grownited.controller;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;


import com.Grownited.entity.ProjectStatusEntity;
import com.Grownited.entity.TaskEntity;
import com.Grownited.entity.TaskUserEntity;
import com.Grownited.entity.UserEntity;
import com.Grownited.repository.ProjectStatusRepositary;
import com.Grownited.repository.TaskRepository;
import com.Grownited.repository.TaskUserRepository;
import com.Grownited.repository.UserRepository;

@Controller
public class TaskUserController {

	@Autowired
	TaskUserRepository taskUserRepository;
	
	@Autowired
	UserRepository userRepository;

	
	@Autowired
	TaskRepository taskRepository;
	
	@GetMapping("taskUserList")
	public String TaskUser(Model model) {

	    List<TaskUserEntity> taskUserList = taskUserRepository.findAll();

	    List<UserEntity> userList = userRepository.findByRole("developer");
	    List<UserEntity> userListTester = userRepository.findByRole("tester");

	    List<UserEntity> allUsers = userRepository.findAll();   // ADD THIS

	    List<TaskEntity> taskList = taskRepository.findAll();

	    model.addAttribute("taskUserList", taskUserList);
	    model.addAttribute("userList", userList);
	    model.addAttribute("userListTester", userListTester);
	    model.addAttribute("allUsers", allUsers);   // ADD THIS
	    model.addAttribute("taskList", taskList);

	    return "TaskUser";
	}
	
	@PostMapping("saveTaskUser")
	public String saveTaskUser(Integer taskId,
	                           Integer developerId,
	                           Integer testerId,
	                           Integer assignStatus,
	                           String status,
	                           Integer utilizedHours,
	                           String devComment,
	                           String testerComment) {

	    TaskUserEntity dev = new TaskUserEntity();
	    dev.setTaskId(taskId);
	    dev.setUserId(developerId);
	    dev.setAssignStatus(assignStatus);
	    dev.setTaskStatus("Assigned");
	    dev.setUtilizedHours(utilizedHours);
	    dev.setComments(devComment);   // ✅ FIX

	    taskUserRepository.save(dev);

	    TaskUserEntity tester = new TaskUserEntity();
	    tester.setTaskId(taskId);
	    tester.setUserId(testerId);
	    tester.setAssignStatus(assignStatus);
	    tester.setTaskStatus("PendingTesting");
	    tester.setUtilizedHours(utilizedHours);
	    tester.setComments(testerComment);   // ✅ FIX

	    taskUserRepository.save(tester);

	    return "redirect:/taskUserList";
	}		
	@GetMapping("/viewTaskUser/{taskUserId}")
	public String viewTaskUser(@PathVariable Integer taskUserId, Model model) {

	    TaskUserEntity taskUser = taskUserRepository.findById(taskUserId).orElse(null);

	    if (taskUser == null) {
	        return "redirect:/taskUserList";
	    }

	    model.addAttribute("taskUser", taskUser);
	    model.addAttribute("taskList", taskRepository.findAll());
	    model.addAttribute("userList", userRepository.findAll());

	    return "ViewTaskUser";
	}
	
    @GetMapping("deleteTaskUser/{taskId}")
    public String deleteTaskUser(@PathVariable Integer taskId)
    {
        taskUserRepository.deleteByTaskId(taskId);
        return "redirect:/taskUserList";
    }
}
