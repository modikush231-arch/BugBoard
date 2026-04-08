package com.Grownited.controller;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.Grownited.entity.ModuleEntity;
import com.Grownited.entity.ProjectEntity;
import com.Grownited.entity.ProjectUserEntity;
import com.Grownited.entity.TaskEntity;
import com.Grownited.entity.TaskUserEntity;
import com.Grownited.entity.UserEntity;
import com.Grownited.repository.ModuleRepositary;
import com.Grownited.repository.ProjectRepository;
import com.Grownited.repository.ProjectStatusRepositary;
import com.Grownited.repository.ProjectUserRepository;
import com.Grownited.repository.TaskRepository;
import com.Grownited.repository.TaskUserRepository;
import com.Grownited.repository.UserRepository;

@Controller
public class ProjectUserController {

    @Autowired
    ProjectUserRepository projectUserRepository;

    @Autowired
    ProjectRepository projectRepository;
    
    @Autowired
    TaskUserRepository taskUserRepository;
    
    @Autowired 
    TaskRepository taskRepository;
    
    @Autowired 
    ModuleRepositary moduleRepositary;
    
    @Autowired
    ProjectStatusRepositary projectStatusRepositary;

    @Autowired
    UserRepository userRepository;

    @GetMapping("/projectUserList")
    public String projectUserList(Model model) {
        List<ProjectUserEntity> projectUserList = projectUserRepository.findAll();
        List<ProjectEntity> allProjects = projectRepository.findAll();
        
        // Get IDs of projects that already have an assignment entry
        List<Integer> assignedProjectIds = projectUserList.stream()
                .map(ProjectUserEntity::getProjectId)
                .distinct()
                .collect(Collectors.toList());
        
        // Filter out already assigned projects
        List<ProjectEntity> unassignedProjects = allProjects.stream()
                .filter(p -> !assignedProjectIds.contains(p.getProjectId()))
                .collect(Collectors.toList());
        
        model.addAttribute("projectUserList", projectUserList);
        model.addAttribute("projectList", allProjects);
        model.addAttribute("unassignedProjects", unassignedProjects);   // for the assign modal
        model.addAttribute("userList", userRepository.findByRole("project_manager"));
        model.addAttribute("projectStatusList", projectStatusRepositary.findAll());
        
        return "ProjectUser";
    }

    @PostMapping("/saveProjectUser")
    public String saveProjectUser(ProjectUserEntity projectUserEntity) {
        projectUserRepository.save(projectUserEntity);
        return "redirect:/projectUserList";
    }


 // Update viewProjectUser
 @GetMapping("/viewProjectUser/{projectUserId}")
 public String viewProjectUser(@PathVariable Integer projectUserId, Model model) {
     Optional<ProjectUserEntity> opt = projectUserRepository.findById(projectUserId);
     if (opt.isPresent()) {
         model.addAttribute("projectUser", opt.get());
         model.addAttribute("projectList", projectRepository.findAll());
         model.addAttribute("userList", userRepository.findAll());
         model.addAttribute("projectStatusList", projectStatusRepositary.findAll()); // ADD THIS
         return "ViewProjectUser";
     }
     return "redirect:/projectUserList";
 }

 // Update editProjectUser
 @GetMapping("editProjectUser/{projectUserId}")
 public String editProjectUser(@PathVariable Integer projectUserId, Model model) {
     Optional<ProjectUserEntity> opt = projectUserRepository.findById(projectUserId);
     if (opt.isPresent()) {
         ProjectUserEntity current = opt.get();
         
         // Get all project IDs that are assigned to any manager (excluding current assignment)
         List<Integer> assignedProjectIds = projectUserRepository.findAll().stream()
                 .filter(pu -> !pu.getProjectUserId().equals(projectUserId))
                 .map(ProjectUserEntity::getProjectId)
                 .distinct()
                 .collect(Collectors.toList());
         
         // Available projects = all projects except those already assigned elsewhere
         List<ProjectEntity> availableProjects = projectRepository.findAll().stream()
                 .filter(p -> !assignedProjectIds.contains(p.getProjectId()))
                 .collect(Collectors.toList());
         
         model.addAttribute("projectUser", current);
         model.addAttribute("availableProjectsForEdit", availableProjects);
         model.addAttribute("userList", userRepository.findByRole("project_manager"));
         return "EditProjectUser";
     }
     return "redirect:/projectUserList";
 }

 @GetMapping("deleteProjectUser/{projectUserId}")
 public String deleteProjectUser(@PathVariable Integer projectUserId) {
     Optional<ProjectUserEntity> opt = projectUserRepository.findById(projectUserId);
     if (opt.isPresent()) {
         ProjectUserEntity pu = opt.get();
         Integer projectId = pu.getProjectId();
         Integer managerId = pu.getUserId();
         
         // Get all tasks for this project
         List<TaskEntity> projectTasks = taskRepository.findByProjectId(projectId);
         
         // Remove this manager from all those tasks (via task_user table)
         for (TaskEntity task : projectTasks) {
             taskUserRepository.deleteByTaskIdAndUserId(task.getTaskId(), managerId);
         }
         
         // Delete the project-manager assignment
         projectUserRepository.delete(pu);
     }
     return "redirect:/projectUserList";
 }
}