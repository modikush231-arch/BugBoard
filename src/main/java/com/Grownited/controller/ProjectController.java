package com.Grownited.controller;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
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
import com.Grownited.entity.ProjectStatusEntity;
import com.Grownited.entity.TaskEntity;
import com.Grownited.repository.ModuleRepositary;
import com.Grownited.repository.ProjectRepository;
import com.Grownited.repository.ProjectStatusRepositary;
import com.Grownited.repository.TaskRepository;

@Controller
public class ProjectController {

    @Autowired
    ProjectRepository projectRepository;

    @Autowired
    ProjectStatusRepositary projectStatusRepositary;

    @Autowired
    ModuleRepositary moduleRepositary;

    @Autowired
    TaskRepository taskRepository;

    @GetMapping("projectList")
    public String projectList(Model model,
                              @RequestParam(value = "status", required = false, defaultValue = "all") String statusFilter,
                              @RequestParam(value = "search", required = false) String searchTerm,
                              @RequestParam(value = "page", required = false, defaultValue = "1") int page,
                              @RequestParam(value = "size", required = false, defaultValue = "10") int size) {

        List<ProjectEntity> allProjects = projectRepository.findAll();
        List<ModuleEntity> allModules = moduleRepositary.findAll();
        List<TaskEntity> allTasks = taskRepository.findAll();
        List<ProjectStatusEntity> statusList = projectStatusRepositary.findAll();

        // Apply search filter
        List<ProjectEntity> searchedProjects = allProjects;
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            String searchLower = searchTerm.trim().toLowerCase();
            searchedProjects = allProjects.stream()
                    .filter(p -> (p.getTitle() != null && p.getTitle().toLowerCase().contains(searchLower)) ||
                                 (p.getDescription() != null && p.getDescription().toLowerCase().contains(searchLower)))
                    .collect(Collectors.toList());
            model.addAttribute("searchTerm", searchTerm);
        }

        // Apply status filter
        List<ProjectEntity> filteredProjects = searchedProjects;
        if (!"all".equals(statusFilter) && statusFilter != null) {
            int statusId = Integer.parseInt(statusFilter);
            filteredProjects = searchedProjects.stream()
                    .filter(p -> p.getProjectStatusId() == statusId)
                    .collect(Collectors.toList());
        }

        // Pagination
        int totalItems = filteredProjects.size();
        int totalPages = (int) Math.ceil((double) totalItems / size);
        if (page < 1) page = 1;
        if (page > totalPages && totalPages > 0) page = totalPages;
        int start = (page - 1) * size;
        int end = Math.min(start + size, totalItems);
        List<ProjectEntity> projectList = filteredProjects.subList(start, end);

        // Counts for filter cards
        long totalCount = allProjects.size();
        long leadCount = allProjects.stream().filter(p -> p.getProjectStatusId() == 1).count();
        long notStartedCount = allProjects.stream().filter(p -> p.getProjectStatusId() == 2).count();
        long progressCount = allProjects.stream().filter(p -> p.getProjectStatusId() == 4).count();
        long holdCount = allProjects.stream().filter(p -> p.getProjectStatusId() == 3).count();
        long completedCount = allProjects.stream().filter(p -> p.getProjectStatusId() == 5).count();

        model.addAttribute("projectList", projectList);
        model.addAttribute("moduleList", allModules);
        model.addAttribute("taskList", allTasks);
        model.addAttribute("statusList", statusList);
        model.addAttribute("totalCount", totalCount);
        model.addAttribute("leadCount", leadCount);
        model.addAttribute("notStartedCount", notStartedCount);
        model.addAttribute("progressCount", progressCount);
        model.addAttribute("holdCount", holdCount);
        model.addAttribute("completedCount", completedCount);
        model.addAttribute("statusFilter", statusFilter);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("pageSize", size);
        model.addAttribute("totalItems", totalItems);

        return "Project";
    }

    @PostMapping("saveProject")
    public String saveProject(ProjectEntity projectEntity) {
        projectEntity.setTotalUtilizedHours(0);
        projectEntity.setProjectStatusId(2); // default Not Started
        projectRepository.save(projectEntity);
        return "redirect:/projectList";
    }

    @GetMapping("/viewProject/{projectId}")
    public String viewProject(@PathVariable Integer projectId, Model model) {
        Optional<ProjectEntity> projectOpt = projectRepository.findById(projectId);
        if (projectOpt.isPresent()) {
            ProjectEntity project = projectOpt.get();
            model.addAttribute("project", project);
            
            List<ModuleEntity> moduleList = moduleRepositary.findByProjectId(projectId);
            model.addAttribute("moduleList", moduleList);
            
            List<TaskEntity> taskList = taskRepository.findByProjectId(projectId);
            model.addAttribute("taskList", taskList);
            
            int progressValue = 0;
            if (project.getProjectStatusId() == 5) progressValue = 100;
            else if (project.getProjectStatusId() == 4) progressValue = 60;
            else if (project.getProjectStatusId() == 3) progressValue = 30;
            else if (project.getProjectStatusId() == 2) progressValue = 10;
            else if (project.getProjectStatusId() == 1) progressValue = 5;
            project.setProgress(progressValue);
            
            long taskCount = taskRepository.countByProjectId(project.getProjectId());
            project.setTaskCount((int) taskCount);
            
            List<ProjectStatusEntity> statusList = projectStatusRepositary.findAll();
            model.addAttribute("statusList", statusList);
            
            return "ViewProject";
        }
        return "redirect:/projectList";
    }


    @GetMapping("editProject/{projectId}")
    public String editProject(@PathVariable Integer projectId, Model model) {
        ProjectEntity project = projectRepository.findById(projectId).orElse(null);
        model.addAttribute("project", project);
        model.addAttribute("statusList", projectStatusRepositary.findAll());
        return "UpdateProject";
    }

    @PostMapping("updateProject")
    public String updateProject(ProjectEntity projectEntity) {
        ProjectEntity project = projectRepository.findById(projectEntity.getProjectId()).orElse(null);
        if (project != null) {
            project.setProjectStatusId(projectEntity.getProjectStatusId());
            projectRepository.save(project);
        }
        return "redirect:/projectList";
    }


    @GetMapping("deleteProject/{projectId}")
    public String deleteProject(@PathVariable Integer projectId) {
        projectRepository.deleteById(projectId);
        return "redirect:/projectList";
    }
    
    @GetMapping("projectModulesAdmin/{projectId}")
    public String projectModulesAdmin(@PathVariable Integer projectId,
                                      @RequestParam(value = "search", required = false) String searchTerm,
                                      @RequestParam(value = "page", required = false, defaultValue = "1") int page,
                                      @RequestParam(value = "size", required = false, defaultValue = "10") int size,
                                      Model model) {
        Optional<ProjectEntity> projectOpt = projectRepository.findById(projectId);
        if (projectOpt.isPresent()) {
            ProjectEntity project = projectOpt.get();
            model.addAttribute("project", project);

            // Get all modules for this project
            List<ModuleEntity> allModules = moduleRepositary.findByProjectId(projectId);

            // ✅ Apply search filter (server-side)
            List<ModuleEntity> searchedModules = allModules;
            if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                String searchLower = searchTerm.trim().toLowerCase();
                searchedModules = allModules.stream()
                        .filter(m -> (m.getModuleName() != null && m.getModuleName().toLowerCase().contains(searchLower)) ||
                                     (m.getDescription() != null && m.getDescription().toLowerCase().contains(searchLower)))
                        .collect(Collectors.toList());
                model.addAttribute("searchTerm", searchTerm);
            }

            // Stats (based on all modules, not filtered)
            long inProgressCount = allModules.stream().filter(m -> "InProgress".equals(m.getStatus())).count();
            long completedCount = allModules.stream().filter(m -> "Completed".equals(m.getStatus())).count();
            long pendingCount = allModules.stream().filter(m -> "PendingTesting".equals(m.getStatus())).count();

            // Pagination (on searched modules)
            int totalItems = searchedModules.size();
            int totalPages = (int) Math.ceil((double) totalItems / size);
            if (page < 1) page = 1;
            if (page > totalPages && totalPages > 0) page = totalPages;
            int start = (page - 1) * size;
            int end = Math.min(start + size, totalItems);
            List<ModuleEntity> moduleList = searchedModules.subList(start, end);

            // Tasks for the project (used to count tasks per module)
            List<TaskEntity> allTasks = taskRepository.findByProjectId(projectId);

            model.addAttribute("moduleList", moduleList);
            model.addAttribute("taskList", allTasks);
            model.addAttribute("moduleCount", allModules.size());
            model.addAttribute("inProgressCount", inProgressCount);
            model.addAttribute("completedCount", completedCount);
            model.addAttribute("pendingCount", pendingCount);
            model.addAttribute("currentPage", page);
            model.addAttribute("totalPages", totalPages);
            model.addAttribute("pageSize", size);
            model.addAttribute("totalItems", totalItems);

            return "ProjectModulesAdmin";
        }
        return "redirect:/projectList";
    }
 // Add to ModuleController.java
    @GetMapping("moduleTasksAdmin/{moduleId}")
    public String moduleTasksAdmin(@PathVariable Integer moduleId,
                                   @RequestParam(value = "page", required = false, defaultValue = "1") int page,
                                   @RequestParam(value = "size", required = false, defaultValue = "10") int size,
                                   Model model) {
        Optional<ModuleEntity> moduleOpt = moduleRepositary.findById(moduleId);
        if (moduleOpt.isPresent()) {
            ModuleEntity module = moduleOpt.get();
            model.addAttribute("module", module);

            List<TaskEntity> allTasks = taskRepository.findByModuleId(moduleId);
            long inProgressTaskCount = allTasks.stream().filter(t -> "InProgress".equals(t.getStatus())).count();
            long completedTaskCount = allTasks.stream().filter(t -> "Completed".equals(t.getStatus())).count();
            long defectTaskCount = allTasks.stream().filter(t -> "Defect".equals(t.getStatus())).count();

            // Pagination
            int totalItems = allTasks.size();
            int totalPages = (int) Math.ceil((double) totalItems / size);
            if (page < 1) page = 1;
            if (page > totalPages && totalPages > 0) page = totalPages;
            int start = (page - 1) * size;
            int end = Math.min(start + size, totalItems);
            List<TaskEntity> taskList = allTasks.subList(start, end);

            model.addAttribute("taskList", taskList);
            model.addAttribute("taskCount", allTasks.size());
            model.addAttribute("inProgressTaskCount", inProgressTaskCount);
            model.addAttribute("completedTaskCount", completedTaskCount);
            model.addAttribute("defectTaskCount", defectTaskCount);
            model.addAttribute("currentPage", page);
            model.addAttribute("totalPages", totalPages);
            model.addAttribute("pageSize", size);
            model.addAttribute("totalItems", totalItems);

            return "ModuleTasksAdmin";
        }
        return "redirect:/moduleList";
    }
}