package com.Grownited.controller;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.Grownited.entity.ProjectEntity;
import com.Grownited.entity.TaskEntity;
import com.Grownited.entity.TaskUserEntity;
import com.Grownited.repository.ProjectRepository;
import com.Grownited.repository.TaskRepository;
import com.Grownited.repository.TaskUserRepository;

@Controller
public class AdminController {

    @Autowired
    private ProjectRepository projectRepository;

    @Autowired
    private TaskRepository taskRepository;

    @Autowired
    private TaskUserRepository taskUserRepository;

    @GetMapping("/AdminDashboard")
    public String adminDashboard(Model model) {
        // ---------- Statistics ----------
        long totalProjects = projectRepository.count();
        long ongoingProjects = projectRepository.countByProjectStatusIdIn(List.of(3, 4));
        long totalTasks = taskRepository.count();
        // ✅ Fixed: exclude tasks with status "Completed" or "Verified"
        long pendingTasks = taskRepository.countByStatusNotIn(List.of("Completed", "Verified"));

        // Project status counts (for pie chart)
        long lead = projectRepository.countByProjectStatusId(1);
        long notStarted = projectRepository.countByProjectStatusId(2);
        long hold = projectRepository.countByProjectStatusId(3);
        long progress = projectRepository.countByProjectStatusId(4);
        long completed = projectRepository.countByProjectStatusId(5);

        // ---------- Recent Activities (from TaskUser updates) ----------
        List<Map<String, Object>> recentActivities = new ArrayList<>();
        List<TaskUserEntity> recentAssignments = taskUserRepository.findTop10ByOrderByUpdatedDateDesc();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MMM dd, HH:mm");
        for (TaskUserEntity tu : recentAssignments) {
            TaskEntity task = taskRepository.findById(tu.getTaskId()).orElse(null);
            if (task == null) continue;
            Map<String, Object> activity = new HashMap<>();
            activity.put("type", "task_updated");
            activity.put("message", "Task \"" + task.getTitle() + "\" status changed to " + tu.getTaskStatus());
            String timeAgo = getTimeAgo(tu.getUpdatedDate());
            activity.put("timeAgo", timeAgo);
            recentActivities.add(activity);
        }

        // ---------- Recent Projects (last 5) ----------
        // ✅ Use the new repository method
        List<ProjectEntity> recentProjects = projectRepository.findTop5ByOrderByProjectIdDesc();

        model.addAttribute("totalProjects", totalProjects);
        model.addAttribute("ongoingProjects", ongoingProjects);
        model.addAttribute("totalTasks", totalTasks);
        model.addAttribute("pendingTasks", pendingTasks);

        model.addAttribute("leadProjects", lead);
        model.addAttribute("notStartedProjects", notStarted);
        model.addAttribute("holdProjects", hold);
        model.addAttribute("progressProjects", progress);
        model.addAttribute("completedProjects", completed);

        model.addAttribute("recentActivities", recentActivities);
        model.addAttribute("recentProjects", recentProjects);

        return "AdminDashboard";
    }

    private String getTimeAgo(LocalDateTime dateTime) {
        if (dateTime == null) return "Recently";
        java.time.Duration duration = java.time.Duration.between(dateTime, java.time.LocalDateTime.now());
        long seconds = duration.getSeconds();
        long minutes = seconds / 60;
        long hours = minutes / 60;
        long days = hours / 24;
        if (seconds < 60) return "Just now";
        if (minutes < 60) return minutes + " minute" + (minutes > 1 ? "s" : "") + " ago";
        if (hours < 24) return hours + " hour" + (hours > 1 ? "s" : "") + " ago";
        if (days < 7) return days + " day" + (days > 1 ? "s" : "") + " ago";
        return dateTime.format(java.time.format.DateTimeFormatter.ofPattern("MMM dd"));
    }
}