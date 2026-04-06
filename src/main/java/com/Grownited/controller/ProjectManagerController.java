package com.Grownited.controller;

import java.util.List;
import java.util.Optional;
import java.util.Set;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.stream.Collectors; // NEW import

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
import com.Grownited.service.StatusSyncService;

import jakarta.servlet.http.HttpSession;

@Controller
public class ProjectManagerController {

    @Autowired
    ProjectRepository projectRepository;

    @Autowired
    ProjectStatusRepositary projectStatusRepositary;

    @Autowired
    ModuleRepositary moduleRepositary;

    @Autowired
    TaskRepository taskRepository;

    @Autowired
    TaskUserRepository taskUserRepository;

    @Autowired
    UserRepository userRepository;

    @Autowired
    ProjectUserRepository projectUserRepository;
    
    @Autowired
    private StatusSyncService statusSyncService;

    // ==================== DASHBOARD ====================
    @GetMapping("/ProjectManagerDashboard")
    public String projectManagerDashboard(Model model, HttpSession session) {
        UserEntity user = (UserEntity) session.getAttribute("dbuser");
        if (user == null) return "redirect:/login";

        Integer pmId = user.getUserId();
        List<ProjectUserEntity> projectUsers = projectUserRepository.findByUserId(pmId);
        List<Integer> projectIds = projectUsers.stream()
                .map(ProjectUserEntity::getProjectId)
                .toList();

        long totalProjects = projectRepository.countByProjectIdIn(projectIds);
        long ongoingProjects = projectRepository.countByProjectStatusIdInAndProjectIdIn(List.of(2, 3, 4), projectIds);
        long totalTasks = taskRepository.countByProjectIdIn(projectIds);
        // ✅ FIXED: Use correct status strings
        long pendingTasks = taskRepository.countByStatusNotInAndProjectIdIn(List.of("Completed", "Verified"), projectIds);

        long lead = projectRepository.countByProjectStatusIdAndProjectIdIn(1, projectIds);
        long notStarted = projectRepository.countByProjectStatusIdAndProjectIdIn(2, projectIds);
        long hold = projectRepository.countByProjectStatusIdAndProjectIdIn(3, projectIds);
        long progress = projectRepository.countByProjectStatusIdAndProjectIdIn(4, projectIds);
        long completed = projectRepository.countByProjectStatusIdAndProjectIdIn(5, projectIds);

        // ✅ RECENT ACTIVITIES (from task_user updates, with real time ago)
        List<Map<String, Object>> recentActivities = new ArrayList<>();
        List<TaskUserEntity> recentAssignments = taskUserRepository.findTop10ByOrderByUpdatedDateDesc();
        for (TaskUserEntity tu : recentAssignments) {
            TaskEntity task = taskRepository.findById(tu.getTaskId()).orElse(null);
            if (task == null) continue;
            Map<String, Object> activity = new HashMap<>();
            activity.put("type", "task_updated");
            activity.put("message", "Task \"" + task.getTitle() + "\" status changed to " + tu.getTaskStatus());
            activity.put("timeAgo", getTimeAgo(tu.getUpdatedDate()));
            recentActivities.add(activity);
        }

        // Recent Projects with progress
        List<ProjectEntity> recentProjects = projectRepository.findTop5ByProjectIdInOrderByProjectIdDesc(projectIds);
        List<ProjectStatusEntity> statusList = projectStatusRepositary.findAll();
        for (ProjectEntity project : recentProjects) {
            long taskCount = taskRepository.countByProjectId(project.getProjectId());
            int progressValue = 0;
            if (project.getProjectStatusId() == 5) progressValue = 100;
            else if (project.getProjectStatusId() == 4) progressValue = 60;
            else if (project.getProjectStatusId() == 3) progressValue = 30;
            else if (project.getProjectStatusId() == 2) progressValue = 10;
            project.setProgress(progressValue);
            project.setTaskCount((int) taskCount);
        }

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
        model.addAttribute("statusList", statusList);

        return "ProjectManagerDashboard";
    }

    // Helper to calculate time ago
    private String getTimeAgo(java.time.LocalDateTime dateTime) {
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
    // ==================== PROJECTS ====================
    @GetMapping("projectListPM")
    public String projectListPM(Model model, HttpSession session,
                                @RequestParam(value = "status", required = false, defaultValue = "all") String statusFilter,
                                @RequestParam(value = "search", required = false) String searchTerm,
                                @RequestParam(value = "page", required = false, defaultValue = "1") int page,
                                @RequestParam(value = "size", required = false, defaultValue = "10") int size) {
        UserEntity user = (UserEntity) session.getAttribute("dbuser");
        if (user == null) {
            return "redirect:/login";
        }
        
        Integer pmId = user.getUserId();
        List<ProjectUserEntity> projectUsers = projectUserRepository.findByUserId(pmId);
        List<Integer> projectIds = projectUsers.stream()
                .map(ProjectUserEntity::getProjectId)
                .toList();
        
        List<ProjectEntity> allProjects = projectRepository.findByProjectIdIn(projectIds);
        
        // Apply search filter
        List<ProjectEntity> searchedProjects = allProjects;
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            String searchLower = searchTerm.trim().toLowerCase();
            searchedProjects = allProjects.stream()
                    .filter(p -> (p.getTitle() != null && p.getTitle().toLowerCase().contains(searchLower)) ||
                                (p.getDescription() != null && p.getDescription().toLowerCase().contains(searchLower)))
                    .toList();
            model.addAttribute("searchTerm", searchTerm);
        }
        
        // Apply status filter
        List<ProjectEntity> filteredProjects = searchedProjects;
        if (!"all".equals(statusFilter) && statusFilter != null) {
            int statusId = Integer.parseInt(statusFilter);
            filteredProjects = searchedProjects.stream()
                    .filter(p -> p.getProjectStatusId() == statusId)
                    .toList();
        }
        
        // Get all modules and tasks for counts
        List<ModuleEntity> allModules = moduleRepositary.findByProjectIdIn(projectIds);
        List<TaskEntity> allTasks = taskRepository.findByProjectIdIn(projectIds);

        // Pagination
        int totalItems = filteredProjects.size();
        int totalPages = (int) Math.ceil((double) totalItems / size);
        if (page < 1) page = 1;
        if (page > totalPages && totalPages > 0) page = totalPages;
        int start = (page - 1) * size;
        int end = Math.min(start + size, totalItems);
        List<ProjectEntity> projectList = filteredProjects.subList(start, end);

        List<ProjectStatusEntity> statusList = projectStatusRepositary.findAll();

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

        return "ProjectPM";
    }

    @GetMapping("/viewProjectPM/{projectId}")
    public String viewProjectPM(@PathVariable Integer projectId, Model model) {
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
            
            return "ViewProjectPM";
        }
        return "redirect:/projectListPM";
    }

    @GetMapping("editProjectPM/{projectId}")
    public String editProjectPM(@PathVariable Integer projectId, Model model) {
        ProjectEntity project = projectRepository.findById(projectId).orElse(null);
        model.addAttribute("project", project);
        model.addAttribute("statusList", projectStatusRepositary.findAll());
        return "PMUpdateProject";
    }

    @PostMapping("updateProjectPM")
    public String updateProjectPM(ProjectEntity projectEntity) {
        ProjectEntity project = projectRepository.findById(projectEntity.getProjectId()).orElse(null);
        if (project != null) {
            project.setProjectStatusId(projectEntity.getProjectStatusId());
            projectRepository.save(project);
        }
        return "redirect:/projectListPM";
    }

    @GetMapping("projectModules/{projectId}")
    public String projectModules(@PathVariable Integer projectId, Model model,
                                 @RequestParam(value = "page", required = false, defaultValue = "1") int page,
                                 @RequestParam(value = "size", required = false, defaultValue = "10") int size) {
        Optional<ProjectEntity> projectOpt = projectRepository.findById(projectId);
        if (projectOpt.isPresent()) {
            ProjectEntity project = projectOpt.get();
            model.addAttribute("project", project);
            
            List<ModuleEntity> allModules = moduleRepositary.findByProjectId(projectId);
            
            long inProgressCount = allModules.stream().filter(m -> "InProgress".equals(m.getStatus())).count();
            long completedCount = allModules.stream().filter(m -> "Completed".equals(m.getStatus())).count();
            long pendingCount = allModules.stream().filter(m -> "PendingTesting".equals(m.getStatus())).count();
            
            int totalItems = allModules.size();
            int totalPages = (int) Math.ceil((double) totalItems / size);
            if (page < 1) page = 1;
            if (page > totalPages && totalPages > 0) page = totalPages;
            
            int start = (page - 1) * size;
            int end = Math.min(start + size, totalItems);
            List<ModuleEntity> moduleList = allModules.subList(start, end);
            
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
            
            return "ProjectModules";
        }
        return "redirect:/projectListPM";
    }

    @GetMapping("moduleTasks/{moduleId}")
    public String moduleTasks(@PathVariable Integer moduleId, Model model,
                              @RequestParam(value = "page", required = false, defaultValue = "1") int page,
                              @RequestParam(value = "size", required = false, defaultValue = "10") int size) {
        Optional<ModuleEntity> moduleOpt = moduleRepositary.findById(moduleId);
        if (moduleOpt.isPresent()) {
            ModuleEntity module = moduleOpt.get();
            model.addAttribute("module", module);
            
            List<TaskEntity> allTasks = taskRepository.findByModuleId(moduleId);
            
            long inProgressTaskCount = allTasks.stream().filter(t -> "InProgress".equals(t.getStatus())).count();
            long completedTaskCount = allTasks.stream().filter(t -> "Completed".equals(t.getStatus())).count();
            long defectTaskCount = allTasks.stream().filter(t -> "Defect".equals(t.getStatus())).count();
            
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
            
            return "ModuleTasks";
        }
        return "redirect:/moduleListPM";
    }

    // ==================== MODULES ====================
    @GetMapping("moduleListPM")
    public String moduleListPM(Model model, HttpSession session,
                               @RequestParam(value = "status", required = false, defaultValue = "all") String statusFilter,
                               @RequestParam(value = "search", required = false) String searchTerm,
                               @RequestParam(value = "page", required = false, defaultValue = "1") int page,
                               @RequestParam(value = "size", required = false, defaultValue = "10") int size) {
        UserEntity user = (UserEntity) session.getAttribute("dbuser");
        if (user == null) {
            return "redirect:/login";
        }
        
        Integer pmId = user.getUserId();
        List<ProjectUserEntity> projectUsers = projectUserRepository.findByUserId(pmId);
        List<Integer> projectIds = projectUsers.stream()
                .map(ProjectUserEntity::getProjectId)
                .toList();
        
        List<ModuleEntity> allModules = moduleRepositary.findByProjectIdIn(projectIds);
        
        // Apply search filter
        List<ModuleEntity> searchedModules = allModules;
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            String searchLower = searchTerm.trim().toLowerCase();
            searchedModules = allModules.stream()
                    .filter(m -> (m.getModuleName() != null && m.getModuleName().toLowerCase().contains(searchLower)) ||
                                (m.getDescription() != null && m.getDescription().toLowerCase().contains(searchLower)))
                    .toList();
            model.addAttribute("searchTerm", searchTerm);
        }
        
        // Apply status filter
        List<ModuleEntity> filteredModules = searchedModules;
        if (!"all".equals(statusFilter) && statusFilter != null) {
            filteredModules = searchedModules.stream()
                    .filter(m -> statusFilter.equals(m.getStatus()))
                    .toList();
        }
        
        // Get task counts for each module
        for (ModuleEntity module : filteredModules) {
            long taskCount = taskRepository.countByModuleId(module.getModuleId());
            module.setTaskCount((int) taskCount);
        }
        
        // Pagination
        int totalItems = filteredModules.size();
        int totalPages = (int) Math.ceil((double) totalItems / size);
        if (page < 1) page = 1;
        if (page > totalPages && totalPages > 0) page = totalPages;
        int start = (page - 1) * size;
        int end = Math.min(start + size, totalItems);
        List<ModuleEntity> moduleList = filteredModules.subList(start, end);
        
        List<ProjectEntity> projectList = projectRepository.findByProjectIdIn(projectIds);
        List<ProjectStatusEntity> statusList = projectStatusRepositary.findAll();
        
        // Counts for filter cards
        long totalCount = allModules.size();
        long inProgressCount = allModules.stream().filter(m -> "InProgress".equals(m.getStatus())).count();
        long completedCount = allModules.stream().filter(m -> "Completed".equals(m.getStatus())).count();
        long pendingTestingCount = allModules.stream().filter(m -> "PendingTesting".equals(m.getStatus())).count();
        
        model.addAttribute("moduleList", moduleList);
        model.addAttribute("projectList", projectList);
        model.addAttribute("statusList", statusList);
        model.addAttribute("totalCount", totalCount);
        model.addAttribute("inProgressCount", inProgressCount);
        model.addAttribute("completedCount", completedCount);
        model.addAttribute("pendingTestingCount", pendingTestingCount);
        model.addAttribute("statusFilter", statusFilter);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("pageSize", size);
        model.addAttribute("totalItems", totalItems);
        
        return "ModulePM";
    }
    
    @GetMapping("/viewModulePM/{moduleId}")
    public String viewModulePM(@PathVariable("moduleId") Integer moduleId, Model model) {
        Optional<ModuleEntity> moduleOpt = moduleRepositary.findById(moduleId);
        if (moduleOpt.isPresent()) {
            ModuleEntity module = moduleOpt.get();
            model.addAttribute("module", module);
            List<ProjectEntity> projectList = projectRepository.findAll();
            List<ProjectStatusEntity> statusList = projectStatusRepositary.findAll();
            model.addAttribute("projectList", projectList);
            model.addAttribute("statusList", statusList);
            return "ViewModulePM";
        }
        return "redirect:/moduleListPM";
    }
    
    @GetMapping("editModulePM/{moduleId}")
    public String editModulePM(@PathVariable Integer moduleId, Model model, HttpSession session) {
        UserEntity user = (UserEntity) session.getAttribute("dbuser");
        if (user == null) {
            return "redirect:/login";
        }
        
        Optional<ModuleEntity> moduleOpt = moduleRepositary.findById(moduleId);
        if (moduleOpt.isPresent()) {
            ModuleEntity module = moduleOpt.get();
            
            // Verify access
            Integer pmId = user.getUserId();
            List<ProjectUserEntity> projectUsers = projectUserRepository.findByUserId(pmId);
            List<Integer> projectIds = projectUsers.stream()
                    .map(ProjectUserEntity::getProjectId)
                    .toList();
            
            if (!projectIds.contains(module.getProjectId())) {
                return "redirect:/moduleListPM?error=Access denied";
            }
            
            model.addAttribute("module", module);
            List<ProjectEntity> projectList = projectRepository.findByProjectIdIn(projectIds);
            model.addAttribute("projectList", projectList);
            return "UpdateModulePM";
        }
        return "redirect:/moduleListPM";
    }
    
    @PostMapping("updateModulePM")
    public String updateModulePM(@RequestParam("moduleId") Integer moduleId,
                                 @RequestParam("moduleName") String moduleName,
                                 @RequestParam("projectId") Integer projectId,
                                 @RequestParam(value = "description", required = false) String description,
                                 @RequestParam(value = "docURL", required = false) String docURL,
                                 @RequestParam("status") String status,
                                 @RequestParam("estimatedHours") Integer estimatedHours,
                                 HttpSession session) {
        
        UserEntity user = (UserEntity) session.getAttribute("dbuser");
        if (user == null) {
            return "redirect:/login";
        }
        
        // Verify access
        Integer pmId = user.getUserId();
        List<ProjectUserEntity> projectUsers = projectUserRepository.findByUserId(pmId);
        List<Integer> projectIds = projectUsers.stream()
                .map(ProjectUserEntity::getProjectId)
                .toList();
        
        if (!projectIds.contains(projectId)) {
            return "redirect:/moduleListPM?error=Access denied";
        }
        
        Optional<ModuleEntity> moduleOpt = moduleRepositary.findById(moduleId);
        if (moduleOpt.isPresent()) {
            ModuleEntity module = moduleOpt.get();
            module.setModuleName(moduleName);
            module.setProjectId(projectId);
            module.setDescription(description);
            module.setDocURL(docURL);
            module.setStatus(status);
            module.setEstimatedHours(estimatedHours);
            moduleRepositary.save(module);
        }
        return "redirect:/moduleListPM?success=Module updated successfully";
    }

    @PostMapping("saveModulePM")
    public String saveModulePM(ModuleEntity moduleEntity, HttpSession session) {
        UserEntity user = (UserEntity) session.getAttribute("dbuser");
        if (user == null) {
            return "redirect:/login";
        }
        
        // Verify the project belongs to this PM
        Integer pmId = user.getUserId();
        List<ProjectUserEntity> projectUsers = projectUserRepository.findByUserId(pmId);
        List<Integer> projectIds = projectUsers.stream()
                .map(ProjectUserEntity::getProjectId)
                .toList();
        
        if (!projectIds.contains(moduleEntity.getProjectId())) {
            return "redirect:/moduleListPM?error=You don't have permission for this project";
        }
        
        moduleEntity.setTotalUtilizedHours(0);
        moduleRepositary.save(moduleEntity);
        return "redirect:/moduleListPM?success=Module created successfully";
    }

    // ==================== TASKS ====================
    @GetMapping("taskListPM")
    public String taskListPM(Model model, HttpSession session,
                             @RequestParam(value = "status", required = false, defaultValue = "all") String statusFilter,
                             @RequestParam(value = "search", required = false) String searchTerm,
                             @RequestParam(value = "page", required = false, defaultValue = "1") int page,
                             @RequestParam(value = "size", required = false, defaultValue = "10") int size) {
        UserEntity user = (UserEntity) session.getAttribute("dbuser");
        if (user == null) {
            return "redirect:/login";
        }
        
        Integer pmId = user.getUserId();
        List<ProjectUserEntity> projectUsers = projectUserRepository.findByUserId(pmId);
        List<Integer> projectIds = projectUsers.stream()
                .map(ProjectUserEntity::getProjectId)
                .toList();
        
        List<TaskEntity> allTasks = taskRepository.findByProjectIdIn(projectIds);
        
        // Apply search filter
        List<TaskEntity> searchedTasks = allTasks;
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            String searchLower = searchTerm.trim().toLowerCase();
            searchedTasks = allTasks.stream()
                    .filter(t -> (t.getTitle() != null && t.getTitle().toLowerCase().contains(searchLower)) ||
                                (t.getDescription() != null && t.getDescription().toLowerCase().contains(searchLower)))
                    .toList();
            model.addAttribute("searchTerm", searchTerm);
        }
        
        // Apply status filter
        List<TaskEntity> filteredTasks = searchedTasks;
        if (!"all".equals(statusFilter) && statusFilter != null) {
            filteredTasks = searchedTasks.stream()
                    .filter(t -> statusFilter.equals(t.getStatus()))
                    .toList();
        }
        
        // Pagination
        int totalItems = filteredTasks.size();
        int totalPages = (int) Math.ceil((double) totalItems / size);
        if (page < 1) page = 1;
        if (page > totalPages && totalPages > 0) page = totalPages;
        int start = (page - 1) * size;
        int end = Math.min(start + size, totalItems);
        List<TaskEntity> taskList = filteredTasks.subList(start, end);
        
        List<ProjectEntity> projectList = projectRepository.findByProjectIdIn(projectIds);
        List<ModuleEntity> moduleList = moduleRepositary.findByProjectIdIn(projectIds);
        List<ProjectStatusEntity> statusList = projectStatusRepositary.findAll();
        
        // Counts for filter cards
        long totalCount = allTasks.size();
        long assignedCount = allTasks.stream().filter(t -> "Assigned".equals(t.getStatus())).count();
        long inProgressCount = allTasks.stream().filter(t -> "InProgress".equals(t.getStatus())).count();
        long pendingTestingCount = allTasks.stream().filter(t -> "PendingTesting".equals(t.getStatus())).count();
        long defectCount = allTasks.stream().filter(t -> "Defect".equals(t.getStatus())).count();
        long completedCount = allTasks.stream().filter(t -> "Completed".equals(t.getStatus())).count();
        
        model.addAttribute("taskList", taskList);
        model.addAttribute("projectList", projectList);
        model.addAttribute("moduleList", moduleList);
        model.addAttribute("statusList", statusList);
        model.addAttribute("totalCount", totalCount);
        model.addAttribute("assignedCount", assignedCount);
        model.addAttribute("inProgressCount", inProgressCount);
        model.addAttribute("pendingTestingCount", pendingTestingCount);
        model.addAttribute("defectCount", defectCount);
        model.addAttribute("completedCount", completedCount);
        model.addAttribute("statusFilter", statusFilter);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("pageSize", size);
        model.addAttribute("totalItems", totalItems);
        
        return "TaskPM";
    }
    
    @PostMapping("saveTaskPM")
    public String saveTaskPM(TaskEntity taskEntity, HttpSession session) {
        UserEntity user = (UserEntity) session.getAttribute("dbuser");
        if (user == null) {
            return "redirect:/login";
        }
        
        // Verify the project belongs to this PM
        Integer pmId = user.getUserId();
        List<ProjectUserEntity> projectUsers = projectUserRepository.findByUserId(pmId);
        List<Integer> projectIds = projectUsers.stream()
                .map(ProjectUserEntity::getProjectId)
                .toList();
        
        if (!projectIds.contains(taskEntity.getProjectId())) {
            return "redirect:/taskListPM?error=You don't have permission for this project";
        }
        
        taskEntity.setTotalUtilizedHours(0);
        taskRepository.save(taskEntity);
        
        // Update module status after adding a new task
        updateModuleStatus(taskEntity.getModuleId());
        // Optionally update project status
        // updateProjectStatus(taskEntity.getProjectId());
        
        return "redirect:/taskListPM?success=Task created successfully";
    }
    
    @GetMapping("/viewTaskPM/{taskId}")
    public String viewTaskPM(@PathVariable Integer taskId, Model model, HttpSession session) {
        UserEntity user = (UserEntity) session.getAttribute("dbuser");
        if (user == null) {
            return "redirect:/login";
        }
        
        Optional<TaskEntity> taskOpt = taskRepository.findById(taskId);
        if (taskOpt.isPresent()) {
            TaskEntity task = taskOpt.get();
            
            // Verify access
            Integer pmId = user.getUserId();
            List<ProjectUserEntity> projectUsers = projectUserRepository.findByUserId(pmId);
            List<Integer> projectIds = projectUsers.stream()
                    .map(ProjectUserEntity::getProjectId)
                    .toList();
            
            if (!projectIds.contains(task.getProjectId())) {
                return "redirect:/taskListPM?error=Access denied";
            }
            
            model.addAttribute("task", task);
            List<ProjectEntity> projectList = projectRepository.findAll();
            List<ProjectStatusEntity> statusList = projectStatusRepositary.findAll();
            List<ModuleEntity> moduleList = moduleRepositary.findAll();
            model.addAttribute("projectList", projectList);
            model.addAttribute("statusList", statusList);
            model.addAttribute("moduleList", moduleList);
            return "ViewTaskPM";
        }
        return "redirect:/taskListPM";
    }
    
    @GetMapping("editTaskPM/{taskId}")
    public String editTaskPM(@PathVariable Integer taskId, Model model, HttpSession session) {
        UserEntity user = (UserEntity) session.getAttribute("dbuser");
        if (user == null) {
            return "redirect:/login";
        }
        
        Optional<TaskEntity> taskOpt = taskRepository.findById(taskId);
        if (taskOpt.isPresent()) {
            TaskEntity task = taskOpt.get();
            
            // Verify access
            Integer pmId = user.getUserId();
            List<ProjectUserEntity> projectUsers = projectUserRepository.findByUserId(pmId);
            List<Integer> projectIds = projectUsers.stream()
                    .map(ProjectUserEntity::getProjectId)
                    .toList();
            
            if (!projectIds.contains(task.getProjectId())) {
                return "redirect:/taskListPM?error=Access denied";
            }
            
            model.addAttribute("task", task);
            
            ProjectEntity project = projectRepository.findById(task.getProjectId()).orElse(null);
            model.addAttribute("projectName", project != null ? project.getTitle() : "");
            
            ModuleEntity module = moduleRepositary.findById(task.getModuleId()).orElse(null);
            model.addAttribute("moduleName", module != null ? module.getModuleName() : "");
            
            return "UpdateTaskPM";
        }
        return "redirect:/taskListPM";
    }
    
    @PostMapping("updateTaskPM")
    public String updateTaskPM(@RequestParam("taskId") Integer taskId,
                               @RequestParam("status") String status,
                               @RequestParam(value = "docURL", required = false) String docURL,
                               HttpSession session) {
        UserEntity user = (UserEntity) session.getAttribute("dbuser");
        if (user == null) {
            return "redirect:/login";
        }
        
        Optional<TaskEntity> taskOpt = taskRepository.findById(taskId);
        if (taskOpt.isPresent()) {
            TaskEntity task = taskOpt.get();
            
            // Verify access
            Integer pmId = user.getUserId();
            List<ProjectUserEntity> projectUsers = projectUserRepository.findByUserId(pmId);
            List<Integer> projectIds = projectUsers.stream()
                    .map(ProjectUserEntity::getProjectId)
                    .toList();
            
            if (!projectIds.contains(task.getProjectId())) {
                return "redirect:/taskListPM?error=Access denied";
            }
            
            task.setStatus(status);
            if (docURL != null && !docURL.isEmpty()) {
                task.setDocURL(docURL);
            }
            taskRepository.save(task);
            
            // Update module status after task status change
            updateModuleStatus(task.getModuleId());
            // Optionally update project status
            // updateProjectStatus(task.getProjectId());
        }
        return "redirect:/taskListPM?success=Task updated successfully";
    }
    
    @PostMapping("deleteTaskPM")
    public String deleteTaskPM(@RequestParam("taskId") Integer taskId, HttpSession session) {
        UserEntity user = (UserEntity) session.getAttribute("dbuser");
        if (user == null) {
            return "redirect:/login";
        }
        
        Optional<TaskEntity> taskOpt = taskRepository.findById(taskId);
        if (taskOpt.isPresent()) {
            TaskEntity task = taskOpt.get();
            
            // Verify access
            Integer pmId = user.getUserId();
            List<ProjectUserEntity> projectUsers = projectUserRepository.findByUserId(pmId);
            List<Integer> projectIds = projectUsers.stream()
                    .map(ProjectUserEntity::getProjectId)
                    .toList();
            
            if (projectIds.contains(task.getProjectId())) {
                // First delete task assignments
                taskUserRepository.deleteByTaskId(taskId);
                // Then delete task
                taskRepository.delete(task);
                // Update module status after task deletion
                updateModuleStatus(task.getModuleId());
                // Optionally update project status
                // updateProjectStatus(task.getProjectId());
            }
        }
        return "redirect:/taskListPM?success=Task deleted successfully";
    }

    // ==================== TASK ASSIGNMENTS ====================
    @GetMapping("taskUserListPM")
    public String taskUserListPM(Model model, HttpSession session,
                                 @RequestParam(value = "search", required = false) String searchTerm,
                                 @RequestParam(value = "page", required = false, defaultValue = "1") int page,
                                 @RequestParam(value = "size", required = false, defaultValue = "10") int size) {
        
        UserEntity user = (UserEntity) session.getAttribute("dbuser");
        if (user == null) {
            return "redirect:/login";
        }
        
        Integer pmId = user.getUserId();
        
        // 1. Get all projects assigned to this PM
        List<ProjectUserEntity> projectUsers = projectUserRepository.findByUserId(pmId);
        List<Integer> projectIds = projectUsers.stream()
                .map(ProjectUserEntity::getProjectId)
                .toList();
        
        if (projectIds.isEmpty()) {
            model.addAttribute("taskUserList", new ArrayList<>());
            model.addAttribute("totalItems", 0);
            model.addAttribute("totalPages", 0);
            model.addAttribute("userList", userRepository.findByRole("developer"));
            model.addAttribute("userListTester", userRepository.findByRole("tester"));
            model.addAttribute("allUsers", userRepository.findAll());
            model.addAttribute("taskList", new ArrayList<>());
            return "TaskUserPM";
        }
        
        // 2. Get all tasks from these projects
        List<TaskEntity> pmTasks = taskRepository.findByProjectIdIn(projectIds);
        List<Integer> taskIds = pmTasks.stream()
                .map(TaskEntity::getTaskId)
                .toList();
        
        if (taskIds.isEmpty()) {
            model.addAttribute("taskUserList", new ArrayList<>());
            model.addAttribute("totalItems", 0);
            model.addAttribute("totalPages", 0);
            model.addAttribute("userList", userRepository.findByRole("developer"));
            model.addAttribute("userListTester", userRepository.findByRole("tester"));
            model.addAttribute("allUsers", userRepository.findAll());
            model.addAttribute("taskList", pmTasks);
            return "TaskUserPM";
        }
        
        // 3. Get task assignments only for these tasks (PM-specific)
        List<TaskUserEntity> allTaskUsers = taskUserRepository.findByTaskIdIn(taskIds);
        
        // 4. Compute unassigned tasks for the modal
        Set<Integer> assignedTaskIds = allTaskUsers.stream()
                .map(TaskUserEntity::getTaskId)
                .collect(Collectors.toSet());
        
        List<TaskEntity> unassignedTasks = pmTasks.stream()
                .filter(task -> !assignedTaskIds.contains(task.getTaskId()))
                .collect(Collectors.toList());
        
        // 5. Apply search filter if present
        List<TaskUserEntity> filteredTaskUsers = allTaskUsers;
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            String searchLower = searchTerm.trim().toLowerCase();
            filteredTaskUsers = allTaskUsers.stream()
                    .filter(tu -> {
                        String taskTitle = pmTasks.stream()
                                .filter(t -> t.getTaskId().equals(tu.getTaskId()))
                                .map(TaskEntity::getTitle)
                                .findFirst()
                                .orElse("");
                        
                        String userName = userRepository.findById(tu.getUserId())
                                .map(u -> u.getFirst_name() + " " + u.getLast_name())
                                .orElse("");
                        
                        return taskTitle.toLowerCase().contains(searchLower) ||
                               userName.toLowerCase().contains(searchLower) ||
                               (tu.getComments() != null && tu.getComments().toLowerCase().contains(searchLower)) ||
                               (tu.getTaskStatus() != null && tu.getTaskStatus().toLowerCase().contains(searchLower));
                    })
                    .toList();
            model.addAttribute("searchTerm", searchTerm);
        }
        
        // 6. Pagination
        int totalItems = filteredTaskUsers.size();
        int totalPages = (int) Math.ceil((double) totalItems / size);
        if (page < 1) page = 1;
        if (page > totalPages && totalPages > 0) page = totalPages;
        int start = (page - 1) * size;
        int end = Math.min(start + size, totalItems);
        List<TaskUserEntity> taskUserList = filteredTaskUsers.subList(start, end);
        
        // Get users for dropdowns
        List<UserEntity> userList = userRepository.findByRole("developer");
        List<UserEntity> userListTester = userRepository.findByRole("tester");
        List<UserEntity> allUsers = userRepository.findAll();
        
        model.addAttribute("taskUserList", taskUserList);
        model.addAttribute("userList", userList);
        model.addAttribute("userListTester", userListTester);
        model.addAttribute("allUsers", allUsers);
        model.addAttribute("taskList", pmTasks);
        model.addAttribute("unassignedTasks", unassignedTasks); // NEW attribute for modal
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("pageSize", size);
        model.addAttribute("totalItems", totalItems);
        
        return "TaskUserPM";
    }

    @PostMapping("saveTaskUserPM")
    public String saveTaskUserPM(@RequestParam("taskId") Integer taskId,
                                 @RequestParam("developerId") Integer developerId,
                                 @RequestParam("testerId") Integer testerId,
                                 @RequestParam("assignStatus") Integer assignStatus,
                                 @RequestParam(value = "utilizedHours", required = false, defaultValue = "0") Integer utilizedHours,
                                 @RequestParam(value = "devComment", required = false) String devComment,
                                 @RequestParam(value = "testerComment", required = false) String testerComment,
                                 HttpSession session) {
        
        UserEntity user = (UserEntity) session.getAttribute("dbuser");
        if (user == null) {
            return "redirect:/login";
        }
        
        // Check if this task belongs to a project managed by this PM
        TaskEntity task = taskRepository.findById(taskId).orElse(null);
        if (task == null) {
            return "redirect:/taskUserListPM?error=Task not found";
        }
        
        Integer pmId = user.getUserId();
        List<ProjectUserEntity> projectUsers = projectUserRepository.findByUserId(pmId);
        List<Integer> projectIds = projectUsers.stream()
                .map(ProjectUserEntity::getProjectId)
                .toList();
        
        if (!projectIds.contains(task.getProjectId())) {
            return "redirect:/taskUserListPM?error=You don't have permission to assign this task";
        }
        
        // Delete existing assignments for this task (to avoid duplicates)
        taskUserRepository.deleteByTaskId(taskId);
        
        // Save DEVELOPER assignment
        TaskUserEntity dev = new TaskUserEntity();
        dev.setTaskId(taskId);
        dev.setUserId(developerId);
        dev.setAssignStatus(assignStatus);
        dev.setTaskStatus("Assigned");
        dev.setUtilizedHours(utilizedHours);
        dev.setComments(devComment != null ? devComment : "");
        taskUserRepository.save(dev);
        
        // Save TESTER assignment (only if different from developer)
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
        
        // Sync task and module status using the reusable method
        syncTaskAndModuleStatus(taskId);
        
        return "redirect:/taskUserListPM?success=Task assigned successfully";
    }

    @GetMapping("/viewTaskUserPM/{taskUserId}")
    public String viewTaskUserPM(@PathVariable Integer taskUserId, Model model, HttpSession session) {
        UserEntity user = (UserEntity) session.getAttribute("dbuser");
        if (user == null) {
            return "redirect:/login";
        }
        
        TaskUserEntity taskUser = taskUserRepository.findById(taskUserId).orElse(null);
        if (taskUser == null) {
            return "redirect:/taskUserListPM?error=Assignment not found";
        }
        
        // Verify this assignment belongs to a task in PM's projects
        TaskEntity task = taskRepository.findById(taskUser.getTaskId()).orElse(null);
        if (task == null) {
            return "redirect:/taskUserListPM?error=Task not found";
        }
        
        Integer pmId = user.getUserId();
        List<ProjectUserEntity> projectUsers = projectUserRepository.findByUserId(pmId);
        List<Integer> projectIds = projectUsers.stream()
                .map(ProjectUserEntity::getProjectId)
                .toList();
        
        if (!projectIds.contains(task.getProjectId())) {
            return "redirect:/taskUserListPM?error=Access denied";
        }
        
        model.addAttribute("taskUser", taskUser);
        model.addAttribute("taskList", taskRepository.findAll());
        model.addAttribute("userList", userRepository.findAll());
        return "ViewTaskUserPM";
    }

    @GetMapping("editTaskUserPM/{taskUserId}")
    public String editTaskUserPM(@PathVariable Integer taskUserId, Model model, HttpSession session) {
        UserEntity user = (UserEntity) session.getAttribute("dbuser");
        if (user == null) {
            return "redirect:/login";
        }
        
        TaskUserEntity taskUser = taskUserRepository.findById(taskUserId).orElse(null);
        if (taskUser == null) {
            return "redirect:/taskUserListPM?error=Assignment not found";
        }
        
        // Verify access
        TaskEntity task = taskRepository.findById(taskUser.getTaskId()).orElse(null);
        if (task == null) {
            return "redirect:/taskUserListPM?error=Task not found";
        }
        
        Integer pmId = user.getUserId();
        List<ProjectUserEntity> projectUsers = projectUserRepository.findByUserId(pmId);
        List<Integer> projectIds = projectUsers.stream()
                .map(ProjectUserEntity::getProjectId)
                .toList();
        
        if (!projectIds.contains(task.getProjectId())) {
            return "redirect:/taskUserListPM?error=Access denied";
        }
        
        model.addAttribute("taskUser", taskUser);
        
        TaskEntity taskEntity = taskRepository.findById(taskUser.getTaskId()).orElse(null);
        model.addAttribute("taskTitle", taskEntity != null ? taskEntity.getTitle() : "");
        
        UserEntity assignedUser = userRepository.findById(taskUser.getUserId()).orElse(null);
        if (assignedUser != null) {
            model.addAttribute("userName", assignedUser.getFirst_name() + " " + assignedUser.getLast_name());
            model.addAttribute("userRole", assignedUser.getRole());
        }
        return "UpdateTaskUserPM";
    }

    @PostMapping("updateTaskUserPM")
    public String updateTaskUserPM(@RequestParam("taskUserId") Integer taskUserId,
                                   @RequestParam("taskStatus") String taskStatus,
                                   @RequestParam("assignStatus") Integer assignStatus,
                                   @RequestParam(value = "utilizedHours", required = false) Integer utilizedHours,
                                   @RequestParam(value = "comments", required = false) String comments,
                                   HttpSession session) {
        
        UserEntity user = (UserEntity) session.getAttribute("dbuser");
        if (user == null) {
            return "redirect:/login";
        }
        
        TaskUserEntity taskUser = taskUserRepository.findById(taskUserId).orElse(null);
        if (taskUser == null) {
            return "redirect:/taskUserListPM?error=Assignment not found";
        }
        
        // Verify access
        TaskEntity task = taskRepository.findById(taskUser.getTaskId()).orElse(null);
        if (task != null) {
            Integer pmId = user.getUserId();
            List<ProjectUserEntity> projectUsers = projectUserRepository.findByUserId(pmId);
            List<Integer> projectIds = projectUsers.stream()
                    .map(ProjectUserEntity::getProjectId)
                    .toList();
            
            if (!projectIds.contains(task.getProjectId())) {
                return "redirect:/taskUserListPM?error=Access denied";
            }
        }
        
        if (taskUser != null) {
            taskUser.setTaskStatus(taskStatus);
            taskUser.setAssignStatus(assignStatus);
            if (utilizedHours != null) {
                taskUser.setUtilizedHours(utilizedHours);
            }
            if (comments != null) {
                taskUser.setComments(comments);
            }
            taskUserRepository.save(taskUser);
        }
        
        // Sync task and module status using the reusable method
        syncTaskAndModuleStatus(taskUser.getTaskId());
        
        return "redirect:/taskUserListPM?success=Assignment updated successfully";
    }

    @GetMapping("deleteTaskUserPM/{taskId}")
    public String deleteTaskUserPM(@PathVariable Integer taskId, HttpSession session) {
        UserEntity user = (UserEntity) session.getAttribute("dbuser");
        if (user == null) {
            return "redirect:/login";
        }
        
        // Verify the task belongs to PM's projects before deletion
        TaskEntity task = taskRepository.findById(taskId).orElse(null);
        if (task != null) {
            Integer pmId = user.getUserId();
            List<ProjectUserEntity> projectUsers = projectUserRepository.findByUserId(pmId);
            List<Integer> projectIds = projectUsers.stream()
                    .map(ProjectUserEntity::getProjectId)
                    .toList();
            
            if (projectIds.contains(task.getProjectId())) {
                taskUserRepository.deleteByTaskId(taskId);
                
                // After deleting assignments, the task status should be reset to "Assigned"
                // and module status updated
                syncTaskAndModuleStatus(taskId);
            }
        }
        return "redirect:/taskUserListPM?success=Assignments deleted successfully";
    }
    
    // ==================== HELPER METHODS ====================
    
    /**
     * Combines developer and tester statuses into a single overall task status.
     */
    private String getCombinedTaskStatus(TaskUserEntity dev, TaskUserEntity tester) {
        if (dev == null && tester == null) return "Assigned";
        
        String devStatus = dev != null ? dev.getTaskStatus() : null;
        String testerStatus = tester != null ? tester.getTaskStatus() : null;
        
        // Both completed successfully
        if ("Completed".equals(devStatus) && "Verified".equals(testerStatus)) {
            return "Completed";
        }
        // Defect found
        if ("Defect".equals(devStatus) || "Defect".equals(testerStatus)) {
            return "Defect";
        }
        // Tester is testing
        if ("InProgress".equals(testerStatus) && "PendingTesting".equals(devStatus)) {
            return "InProgress";
        }
        // Ready for testing
        if ("PendingTesting".equals(devStatus) && ("NotStarted".equals(testerStatus) || "InProgress".equals(testerStatus))) {
            return "PendingTesting";
        }
        // Developer working
        if ("InProgress".equals(devStatus)) {
            return "InProgress";
        }
        // Initial state
        if ("Assigned".equals(devStatus) && "NotStarted".equals(testerStatus)) {
            return "Assigned";
        }
        return "Assigned";
    }
    
    /**
     * Reusable method to sync the overall task status and module status for a given task.
     */
    private void syncTaskAndModuleStatus(Integer taskId) {
        TaskEntity task = taskRepository.findById(taskId).orElse(null);
        if (task == null) return;
        List<TaskUserEntity> assignments = taskUserRepository.findByTaskId(taskId);
        TaskUserEntity dev = assignments.stream()
                .filter(tu -> isDeveloper(tu.getUserId()))
                .findFirst().orElse(null);
        TaskUserEntity tester = assignments.stream()
                .filter(tu -> isTester(tu.getUserId()))
                .findFirst().orElse(null);
        String combinedStatus = getCombinedTaskStatus(dev, tester);
        task.setStatus(combinedStatus);
        taskRepository.save(task);
        updateModuleStatus(task.getModuleId());
        // ✅ AUTO‑UPDATE PROJECT STATUS
        updateProjectStatus(task.getProjectId());
    }
    
    /**
     * Recalculates and updates the status of a module based on its tasks.
     */
    private void updateModuleStatus(Integer moduleId) {
        List<TaskEntity> tasks = taskRepository.findByModuleId(moduleId);
        if (tasks.isEmpty()) return;
        
        boolean allCompleted = tasks.stream().allMatch(t -> "Completed".equals(t.getStatus()));
        boolean anyDefect = tasks.stream().anyMatch(t -> "Defect".equals(t.getStatus()));
        boolean anyInProgress = tasks.stream().anyMatch(t -> "InProgress".equals(t.getStatus()));
        boolean anyPendingTesting = tasks.stream().anyMatch(t -> "PendingTesting".equals(t.getStatus()));
        
        String moduleStatus;
        if (allCompleted) {
            moduleStatus = "Completed";
        } else if (anyDefect) {
            moduleStatus = "Defect";
        } else if (anyInProgress) {
            moduleStatus = "InProgress";
        } else if (anyPendingTesting) {
            moduleStatus = "PendingTesting";
        } else {
            moduleStatus = "Assigned";
        }
        
        ModuleEntity module = moduleRepositary.findById(moduleId).orElse(null);
        if (module != null && !moduleStatus.equals(module.getStatus())) {
            module.setStatus(moduleStatus);
            moduleRepositary.save(module);
        }
    }
    
    /**
     * Optional: updates project status based on its modules.
     * You can call this after module status changes.
     */
    private void updateProjectStatus(Integer projectId) {
        List<ModuleEntity> modules = moduleRepositary.findByProjectId(projectId);
        if (modules.isEmpty()) return;
        boolean allCompleted = modules.stream().allMatch(m -> "Completed".equals(m.getStatus()));
        boolean anyDefect = modules.stream().anyMatch(m -> "Defect".equals(m.getStatus()));
        boolean anyInProgress = modules.stream().anyMatch(m -> "InProgress".equals(m.getStatus()));
        int newStatusId;
        if (allCompleted) newStatusId = 5;
        else if (anyDefect) newStatusId = 3;
        else if (anyInProgress) newStatusId = 4;
        else newStatusId = 2;
        ProjectEntity project = projectRepository.findById(projectId).orElse(null);
        if (project != null && project.getProjectStatusId() != newStatusId) {
            project.setProjectStatusId(newStatusId);
            projectRepository.save(project);
        }
    }

   
    
    private boolean isDeveloper(Integer userId) {
        UserEntity user = userRepository.findById(userId).orElse(null);
        return user != null && "developer".equals(user.getRole());
    }
    
    private boolean isTester(Integer userId) {
        UserEntity user = userRepository.findById(userId).orElse(null);
        return user != null && "tester".equals(user.getRole());
    }
}