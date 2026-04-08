package com.Grownited.controller;

import java.util.*;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.Grownited.entity.*;
import com.Grownited.repository.*;

@Controller
public class TaskUserController {

    @Autowired
    TaskUserRepository taskUserRepository;

    @Autowired
    UserRepository userRepository;

    @Autowired
    TaskRepository taskRepository;

    // List all task assignments with pagination, search, and modal data
    @GetMapping("taskUserList")
    public String taskUserList(Model model,
                               @RequestParam(value = "search", required = false) String searchTerm,
                               @RequestParam(value = "page", defaultValue = "1") int page,
                               @RequestParam(value = "size", defaultValue = "10") int size) {

        // 1. Fetch all assignments, tasks, users
        List<TaskUserEntity> allAssignments = taskUserRepository.findAll();
        List<TaskEntity> allTasks = taskRepository.findAll();
        List<UserEntity> allUsers = userRepository.findAll();

        // 2. Compute unassigned tasks for modal (tasks not linked to any assignment)
        Set<Integer> assignedTaskIds = allAssignments.stream()
                .map(TaskUserEntity::getTaskId)
                .collect(Collectors.toSet());
        List<TaskEntity> unassignedTasks = allTasks.stream()
                .filter(t -> !assignedTaskIds.contains(t.getTaskId()))
                .collect(Collectors.toList());

        // 3. Search filter (task title, user name, status, comment)
        List<TaskUserEntity> filtered = allAssignments;
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            String term = searchTerm.trim().toLowerCase();
            filtered = allAssignments.stream()
                .filter(tu -> {
                    String taskTitle = getTaskTitle(tu.getTaskId(), allTasks);
                    String userName = getUserFullName(tu.getUserId(), allUsers);
                    return taskTitle.toLowerCase().contains(term) ||
                           userName.toLowerCase().contains(term) ||
                           (tu.getTaskStatus() != null && tu.getTaskStatus().toLowerCase().contains(term)) ||
                           (tu.getComments() != null && tu.getComments().toLowerCase().contains(term));
                })
                .collect(Collectors.toList());
            model.addAttribute("searchTerm", searchTerm);
        }

        // 4. Pagination
        int totalItems = filtered.size();
        int totalPages = (int) Math.ceil((double) totalItems / size);
        if (page < 1) page = 1;
        if (page > totalPages && totalPages > 0) page = totalPages;
        int start = (page - 1) * size;
        int end = Math.min(start + size, totalItems);
        List<TaskUserEntity> paginatedList = filtered.subList(start, end);

        // 5. Prepare dropdowns for modal (developers and testers)
        List<UserEntity> developers = allUsers.stream()
                .filter(u -> "developer".equalsIgnoreCase(u.getRole()))
                .collect(Collectors.toList());
        List<UserEntity> testers = allUsers.stream()
                .filter(u -> "tester".equalsIgnoreCase(u.getRole()))
                .collect(Collectors.toList());

        // 6. Add attributes to model
        model.addAttribute("taskUserList", paginatedList);
        model.addAttribute("taskList", allTasks);
        model.addAttribute("allUsers", allUsers);
        model.addAttribute("unassignedTasks", unassignedTasks);
        model.addAttribute("userList", developers);      // for modal developer dropdown
        model.addAttribute("userListTester", testers);   // for modal tester dropdown

        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("pageSize", size);
        model.addAttribute("totalItems", totalItems);

        return "TaskUser";
    }

    // Helper to get task title
    private String getTaskTitle(Integer taskId, List<TaskEntity> tasks) {
        return tasks.stream()
                .filter(t -> t.getTaskId().equals(taskId))
                .map(TaskEntity::getTitle)
                .findFirst()
                .orElse("");
    }

    // Helper to get user full name
    private String getUserFullName(Integer userId, List<UserEntity> users) {
        return users.stream()
                .filter(u -> u.getUserId().equals(userId))
                .map(u -> u.getFirst_name() + " " + u.getLast_name())
                .findFirst()
                .orElse("Unknown");
    }

    // Save new assignment (developer + tester)
    @PostMapping("saveTaskUser")
    public String saveTaskUser(@RequestParam("taskId") Integer taskId,
                               @RequestParam("developerId") Integer developerId,
                               @RequestParam("testerId") Integer testerId,
                               @RequestParam("assignStatus") Integer assignStatus,
                               @RequestParam(value = "utilizedHours", defaultValue = "0") Integer utilizedHours,
                               @RequestParam(value = "devComment", required = false) String devComment,
                               @RequestParam(value = "testerComment", required = false) String testerComment) {

        // Remove any existing assignments for this task (avoid duplicates)
        taskUserRepository.deleteByTaskId(taskId);

        // Developer assignment
        TaskUserEntity dev = new TaskUserEntity();
        dev.setTaskId(taskId);
        dev.setUserId(developerId);
        dev.setAssignStatus(assignStatus);
        dev.setTaskStatus("Assigned");
        dev.setUtilizedHours(utilizedHours);
        dev.setComments(devComment != null ? devComment : "");
        taskUserRepository.save(dev);

        // Tester assignment (if different from developer)
        if (!developerId.equals(testerId)) {
            TaskUserEntity tester = new TaskUserEntity();
            tester.setTaskId(taskId);
            tester.setUserId(testerId);
            tester.setAssignStatus(assignStatus);
            tester.setTaskStatus("NotStarted");
            tester.setUtilizedHours(utilizedHours);
            tester.setComments(testerComment != null ? testerComment : "");
            taskUserRepository.save(tester);
        }

        return "redirect:/taskUserList";
    }

    // View single assignment
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
            TaskUserEntity tu = opt.get();
            model.addAttribute("taskUser", tu);
            
            // Fetch task title
            taskRepository.findById(tu.getTaskId()).ifPresent(task -> 
                model.addAttribute("taskTitle", task.getTitle())
            );
            
            // Fetch assigned user name and role
            userRepository.findById(tu.getUserId()).ifPresent(user -> {
                model.addAttribute("userName", user.getFirst_name() + " " + user.getLast_name());
                model.addAttribute("userRole", user.getRole());
            });
            
            return "UpdateTaskUser";
        }
        return "redirect:/taskUserList";
    }

    // Update single assignment
    @PostMapping("updateTaskUser")
    public String updateTaskUser(@RequestParam("taskUserId") Integer taskUserId,
                                 @RequestParam("assignStatus") Integer assignStatus,
                                 @RequestParam("taskStatus") String taskStatus,
                                 @RequestParam(value = "utilizedHours", required = false) Integer utilizedHours,
                                 @RequestParam(value = "comments", required = false) String comments) {
        Optional<TaskUserEntity> opt = taskUserRepository.findById(taskUserId);
        if (opt.isPresent()) {
            TaskUserEntity tu = opt.get();
            tu.setAssignStatus(assignStatus);
            tu.setTaskStatus(taskStatus);
            if (utilizedHours != null) tu.setUtilizedHours(utilizedHours);
            if (comments != null) tu.setComments(comments);
            taskUserRepository.save(tu);
        }
        return "redirect:/taskUserList";
    }

    // Delete all assignments for a task
    @GetMapping("deleteTaskUser/{taskId}")
    public String deleteTaskUser(@PathVariable Integer taskId) {
        taskUserRepository.deleteByTaskId(taskId);
        return "redirect:/taskUserList";
    }
}