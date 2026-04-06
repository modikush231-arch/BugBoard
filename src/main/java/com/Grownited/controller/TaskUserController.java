package com.Grownited.controller;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.Grownited.entity.TaskEntity;
import com.Grownited.entity.TaskUserEntity;
import com.Grownited.entity.UserEntity;
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
    public String taskUserList(Model model) {
        model.addAttribute("taskUserList", taskUserRepository.findAll());
        model.addAttribute("userList", userRepository.findByRole("developer"));
        model.addAttribute("userListTester", userRepository.findByRole("tester"));
        model.addAttribute("allUsers", userRepository.findAll());
        model.addAttribute("taskList", taskRepository.findAll());
        return "TaskUser";
    }

    @PostMapping("saveTaskUser")
    public String saveTaskUser(@RequestParam("taskId") Integer taskId,
                               @RequestParam("developerId") Integer developerId,
                               @RequestParam("testerId") Integer testerId,
                               @RequestParam("assignStatus") Integer assignStatus,
                               @RequestParam(value = "utilizedHours", defaultValue = "0") Integer utilizedHours,
                               @RequestParam(value = "devComment", required = false) String devComment,
                               @RequestParam(value = "testerComment", required = false) String testerComment) {

        // Developer assignment
        TaskUserEntity dev = new TaskUserEntity();
        dev.setTaskId(taskId);
        dev.setUserId(developerId);
        dev.setAssignStatus(assignStatus);
        dev.setTaskStatus("Assigned");
        dev.setUtilizedHours(utilizedHours);
        dev.setComments(devComment);
        taskUserRepository.save(dev);

        // Tester assignment
        TaskUserEntity tester = new TaskUserEntity();
        tester.setTaskId(taskId);
        tester.setUserId(testerId);
        tester.setAssignStatus(assignStatus);
        tester.setTaskStatus("NotStarted");
        tester.setUtilizedHours(utilizedHours);
        tester.setComments(testerComment);
        taskUserRepository.save(tester);

        return "redirect:/taskUserList";
    }

    @GetMapping("/viewTaskUser/{taskUserId}")
    public String viewTaskUser(@PathVariable Integer taskUserId, Model model) {
        Optional<TaskUserEntity> opt = taskUserRepository.findById(taskUserId);
        if (opt.isPresent()) {
            model.addAttribute("taskUser", opt.get());
            model.addAttribute("taskList", taskRepository.findAll());
            model.addAttribute("userList", userRepository.findAll());
            return "ViewTaskUser";
        }
        return "redirect:/taskUserList";
    }

    @GetMapping("editTaskUser/{taskUserId}")
    public String editTaskUser(@PathVariable Integer taskUserId, Model model) {
        Optional<TaskUserEntity> opt = taskUserRepository.findById(taskUserId);
        if (opt.isPresent()) {
            model.addAttribute("taskUser", opt.get());
            model.addAttribute("taskList", taskRepository.findAll());
            model.addAttribute("userList", userRepository.findAll());
            return "EditTaskUser";
        }
        return "redirect:/taskUserList";
    }

    @PostMapping("updateTaskUser")
    public String updateTaskUser(@RequestParam("taskUserId") Integer taskUserId,
                                 @RequestParam("taskId") Integer taskId,
                                 @RequestParam("userId") Integer userId,
                                 @RequestParam("assignStatus") Integer assignStatus,
                                 @RequestParam("taskStatus") String taskStatus,
                                 @RequestParam(value = "utilizedHours", required = false) Integer utilizedHours,
                                 @RequestParam(value = "comments", required = false) String comments) {
        Optional<TaskUserEntity> opt = taskUserRepository.findById(taskUserId);
        if (opt.isPresent()) {
            TaskUserEntity tu = opt.get();
            tu.setTaskId(taskId);
            tu.setUserId(userId);
            tu.setAssignStatus(assignStatus);
            tu.setTaskStatus(taskStatus);
            if (utilizedHours != null) tu.setUtilizedHours(utilizedHours);
            if (comments != null) tu.setComments(comments);
            taskUserRepository.save(tu);
        }
        return "redirect:/taskUserList";
    }

    @GetMapping("deleteTaskUser/{taskId}")
    public String deleteTaskUser(@PathVariable Integer taskId) {
        taskUserRepository.deleteByTaskId(taskId);
        return "redirect:/taskUserList";
    }
}