package com.Grownited.controller;

import java.util.List;
import java.util.Optional;
import java.util.Set;
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

import jakarta.annotation.PostConstruct;

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
    public String projectUserList(Model model,
                                  @RequestParam(value = "search", required = false) String searchTerm,
                                  @RequestParam(value = "page", defaultValue = "1") int page,
                                  @RequestParam(value = "size", defaultValue = "10") int size) {
        
        List<ProjectUserEntity> allAssignments = projectUserRepository.findAll();
        List<ProjectEntity> allProjects = projectRepository.findAll();
        List<UserEntity> allManagers = userRepository.findByRole("project_manager");
        
        // Compute unassigned projects for modal
        Set<Integer> assignedProjectIds = allAssignments.stream()
                .map(ProjectUserEntity::getProjectId)
                .collect(Collectors.toSet());
        List<ProjectEntity> unassignedProjects = allProjects.stream()
                .filter(p -> !assignedProjectIds.contains(p.getProjectId()))
                .collect(Collectors.toList());
        
        // Search filter (project title or manager name)
        List<ProjectUserEntity> filtered = allAssignments;
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            String term = searchTerm.trim().toLowerCase();
            filtered = allAssignments.stream()
                    .filter(pu -> {
                        String projectTitle = allProjects.stream()
                                .filter(p -> p.getProjectId().equals(pu.getProjectId()))
                                .map(ProjectEntity::getTitle)
                                .findFirst().orElse("");
                        String managerName = allManagers.stream()
                                .filter(u -> u.getUserId().equals(pu.getUserId()))
                                .map(u -> u.getFirst_name() + " " + u.getLast_name())
                                .findFirst().orElse("");
                        return projectTitle.toLowerCase().contains(term) ||
                               managerName.toLowerCase().contains(term);
                    })
                    .collect(Collectors.toList());
            model.addAttribute("searchTerm", searchTerm);
        }
        
        // Pagination
        int totalItems = filtered.size();
        int totalPages = (int) Math.ceil((double) totalItems / size);
        if (page < 1) page = 1;
        if (page > totalPages && totalPages > 0) page = totalPages;
        int start = (page - 1) * size;
        int end = Math.min(start + size, totalItems);
        List<ProjectUserEntity> paginatedList = filtered.subList(start, end);
        
        model.addAttribute("projectUserList", paginatedList);
        model.addAttribute("projectList", allProjects);
        model.addAttribute("userList", allManagers);
        model.addAttribute("unassignedProjects", unassignedProjects);
        model.addAttribute("projectStatusList", projectStatusRepositary.findAll());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("pageSize", size);
        model.addAttribute("totalItems", totalItems);
        
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
 
 @PostMapping("/updateProjectUser")
 public String updateProjectUser(@RequestParam("projectUserId") Integer projectUserId,
                                  @RequestParam("projectId") Integer projectId,
                                  @RequestParam("userId") Integer userId,
                                  @RequestParam("assignStatus") Integer assignStatus) {
     Optional<ProjectUserEntity> opt = projectUserRepository.findById(projectUserId);
     if (opt.isPresent()) {
         ProjectUserEntity pu = opt.get();
         pu.setProjectId(projectId);
         pu.setUserId(userId);
         pu.setAssignStatus(assignStatus);
         projectUserRepository.save(pu);
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
 
 @PostConstruct
 public void cleanOrphanedProjectUsers() {
     List<ProjectUserEntity> all = projectUserRepository.findAll();
     List<Integer> existingProjectIds = projectRepository.findAll().stream()
             .map(ProjectEntity::getProjectId)
             .collect(Collectors.toList());
     for (ProjectUserEntity pu : all) {
         if (!existingProjectIds.contains(pu.getProjectId())) {
             projectUserRepository.delete(pu);
         }
     }
 }
}
