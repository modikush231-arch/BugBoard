package com.Grownited.controller;

import java.util.List;
import java.util.Optional;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

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

    // ==================== DASHBOARD ====================
    @GetMapping("/ProjectManagerDashboard")
    public String projectManagerDashboard(Model model, HttpSession session) {
        UserEntity user = (UserEntity) session.getAttribute("dbuser");
        if (user == null) {
            return "redirect:/login";
        }
        
        Integer pmId = user.getUserId();
        List<ProjectUserEntity> projectUsers = projectUserRepository.findByUserId(pmId);
        List<Integer> projectIds = projectUsers.stream()
                .map(ProjectUserEntity::getProjectId)
                .toList();

        // Statistics
        long totalProjects = projectRepository.countByProjectIdIn(projectIds);
        long ongoingProjects = projectRepository.countByProjectStatusIdInAndProjectIdIn(List.of(2, 3, 4), projectIds);
        long totalTasks = taskRepository.countByProjectIdIn(projectIds);
        long pendingTasks = taskRepository.countByStatusNotInAndProjectIdIn(List.of("5", "1"), projectIds);

        long lead = projectRepository.countByProjectStatusIdAndProjectIdIn(1, projectIds);
        long notStarted = projectRepository.countByProjectStatusIdAndProjectIdIn(2, projectIds);
        long hold = projectRepository.countByProjectStatusIdAndProjectIdIn(3, projectIds);
        long progress = projectRepository.countByProjectStatusIdAndProjectIdIn(4, projectIds);
        long completed = projectRepository.countByProjectStatusIdAndProjectIdIn(5, projectIds);

        // Recent Activities
        List<Map<String, Object>> recentActivities = new ArrayList<>();
        List<TaskEntity> recentTasks = taskRepository.findTop5ByProjectIdInOrderByTaskIdDesc(projectIds);
        for (TaskEntity task : recentTasks) {
            Map<String, Object> activity = new HashMap<>();
            activity.put("type", "task_created");
            activity.put("message", "New task created: " + task.getTitle());
            activity.put("timeAgo", "Just now");
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

    // ==================== PROJECTS ====================
    @GetMapping("projectListPM")
    public String projectListPM(Model model, HttpSession session,
                                @RequestParam(value = "status", required = false, defaultValue = "all") String statusFilter,
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
        
        // ✅ Get all modules and tasks for counts
        List<ModuleEntity> allModules = moduleRepositary.findByProjectIdIn(projectIds);
        List<TaskEntity> allTasks = taskRepository.findByProjectIdIn(projectIds);

        // Apply status filter
        List<ProjectEntity> filteredProjects = allProjects;
        if (!"all".equals(statusFilter) && statusFilter != null) {
            int statusId = Integer.parseInt(statusFilter);
            filteredProjects = allProjects.stream()
                    .filter(p -> p.getProjectStatusId() == statusId)
                    .toList();
        }

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
        model.addAttribute("moduleList", allModules);  // ✅ Add for counts
        model.addAttribute("taskList", allTasks);      // ✅ Add for counts
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
            
            // ✅ IMPORTANT: Get modules for this project
            List<ModuleEntity> moduleList = moduleRepositary.findByProjectId(projectId);
            model.addAttribute("moduleList", moduleList);
            
            // ✅ Get tasks for this project (for counts)
            List<TaskEntity> taskList = taskRepository.findByProjectId(projectId);
            model.addAttribute("taskList", taskList);
            
            // Calculate progress
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
 // Add these methods to your ProjectManagerController.java

 // Add these methods to your ProjectManagerController.java

    @GetMapping("projectModules/{projectId}")
    public String projectModules(@PathVariable Integer projectId, Model model,
                                 @RequestParam(value = "page", required = false, defaultValue = "1") int page,
                                 @RequestParam(value = "size", required = false, defaultValue = "10") int size) {
        Optional<ProjectEntity> projectOpt = projectRepository.findById(projectId);
        if (projectOpt.isPresent()) {
            ProjectEntity project = projectOpt.get();
            model.addAttribute("project", project);
            
            List<ModuleEntity> allModules = moduleRepositary.findByProjectId(projectId);
            
            // Calculate stats
            long inProgressCount = allModules.stream().filter(m -> "InProgress".equals(m.getStatus())).count();
            long completedCount = allModules.stream().filter(m -> "Completed".equals(m.getStatus())).count();
            long pendingCount = allModules.stream().filter(m -> "PendingTesting".equals(m.getStatus())).count();
            
            // Pagination
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
            
            // Calculate stats
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
            
            return "ModuleTasks";
        }
        return "redirect:/moduleListPM";
    }    // ==================== MODULES ====================
    @GetMapping("moduleListPM")
    public String moduleListPM(Model model, HttpSession session,
                               @RequestParam(value = "status", required = false, defaultValue = "all") String statusFilter,
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

        // Apply status filter
        List<ModuleEntity> filteredModules = allModules;
        if (!"all".equals(statusFilter) && statusFilter != null) {
            filteredModules = allModules.stream()
                    .filter(m -> statusFilter.equals(m.getStatus()))
                    .toList();
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

    @PostMapping("saveModulePM")
    public String saveModulePM(ModuleEntity moduleEntity) {
        moduleEntity.setTotalUtilizedHours(0);
        moduleRepositary.save(moduleEntity);
        return "redirect:/moduleListPM";
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

    // ==================== TASKS ====================
    @GetMapping("taskListPM")
    public String taskListPM(Model model, HttpSession session,
                             @RequestParam(value = "status", required = false, defaultValue = "all") String statusFilter,
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

        // Apply status filter
        List<TaskEntity> filteredTasks = allTasks;
        if (!"all".equals(statusFilter) && statusFilter != null) {
            filteredTasks = allTasks.stream()
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
    public String saveTaskPM(TaskEntity taskEntity) {
        taskEntity.setTotalUtilizedHours(0);
        taskRepository.save(taskEntity);
        return "redirect:/taskListPM";
    }

    @GetMapping("/viewTaskPM/{taskId}")
    public String viewTaskPM(@PathVariable Integer taskId, Model model) {
        Optional<TaskEntity> taskOpt = taskRepository.findById(taskId);
        if (taskOpt.isPresent()) {
            TaskEntity task = taskOpt.get();
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
    public String editTaskPM(@PathVariable Integer taskId, Model model) {
        Optional<TaskEntity> taskOpt = taskRepository.findById(taskId);
        if (taskOpt.isPresent()) {
            TaskEntity task = taskOpt.get();
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
                               @RequestParam(value = "docURL", required = false) String docURL) {
        Optional<TaskEntity> taskOpt = taskRepository.findById(taskId);
        if (taskOpt.isPresent()) {
            TaskEntity task = taskOpt.get();
            task.setStatus(status);
            if (docURL != null && !docURL.isEmpty()) {
                task.setDocURL(docURL);
            }
            taskRepository.save(task);
        }
        return "redirect:/taskListPM";
    }

    // ==================== TASK ASSIGNMENTS ====================
    @GetMapping("taskUserListPM")
    public String taskUserListPM(Model model) {
        List<TaskUserEntity> taskUserList = taskUserRepository.findAll();
        List<UserEntity> userList = userRepository.findByRole("developer");
        List<UserEntity> userListTester = userRepository.findByRole("tester");
        List<UserEntity> allUsers = userRepository.findAll();
        List<TaskEntity> taskList = taskRepository.findAll();

        model.addAttribute("taskUserList", taskUserList);
        model.addAttribute("userList", userList);
        model.addAttribute("userListTester", userListTester);
        model.addAttribute("allUsers", allUsers);
        model.addAttribute("taskList", taskList);

        return "TaskUserPM";
    }

    @PostMapping("saveTaskUserPM")
    public String saveTaskUserPM(@RequestParam("taskId") Integer taskId,
                                 @RequestParam("developerId") Integer developerId,
                                 @RequestParam("testerId") Integer testerId,
                                 @RequestParam("assignStatus") Integer assignStatus,
                                 @RequestParam(value = "utilizedHours", required = false, defaultValue = "0") Integer utilizedHours,
                                 @RequestParam(value = "devComment", required = false) String devComment,
                                 @RequestParam(value = "testerComment", required = false) String testerComment) {
        
        // Save DEVELOPER assignment
        TaskUserEntity dev = new TaskUserEntity();
        dev.setTaskId(taskId);
        dev.setUserId(developerId);
        dev.setAssignStatus(assignStatus);
        dev.setTaskStatus("Assigned");
        dev.setUtilizedHours(utilizedHours);
        dev.setComments(devComment != null ? devComment : "");
        taskUserRepository.save(dev);

        // Save TESTER assignment
        TaskUserEntity tester = new TaskUserEntity();
        tester.setTaskId(taskId);
        tester.setUserId(testerId);
        tester.setAssignStatus(assignStatus);
        tester.setTaskStatus("NotStarted");
        tester.setUtilizedHours(utilizedHours);
        tester.setComments(testerComment != null ? testerComment : "");
        taskUserRepository.save(tester);

        return "redirect:/taskUserListPM";
    }

    @GetMapping("/viewTaskUserPM/{taskUserId}")
    public String viewTaskUserPM(@PathVariable Integer taskUserId, Model model) {
        TaskUserEntity taskUser = taskUserRepository.findById(taskUserId).orElse(null);
        if (taskUser == null) {
            return "redirect:/taskUserListPM";
        }
        model.addAttribute("taskUser", taskUser);
        model.addAttribute("taskList", taskRepository.findAll());
        model.addAttribute("userList", userRepository.findAll());
        return "ViewTaskUserPM";
    }

    @GetMapping("editTaskUserPM/{taskUserId}")
    public String editTaskUserPM(@PathVariable Integer taskUserId, Model model) {
        TaskUserEntity taskUser = taskUserRepository.findById(taskUserId).orElse(null);
        if (taskUser != null) {
            model.addAttribute("taskUser", taskUser);
            
            TaskEntity task = taskRepository.findById(taskUser.getTaskId()).orElse(null);
            model.addAttribute("taskTitle", task != null ? task.getTitle() : "");
            
            UserEntity user = userRepository.findById(taskUser.getUserId()).orElse(null);
            if (user != null) {
                model.addAttribute("userName", user.getFirst_name() + " " + user.getLast_name());
                model.addAttribute("userRole", user.getRole());
            }
            return "UpdateTaskUserPM";
        }
        return "redirect:/taskUserListPM";
    }

    @PostMapping("updateTaskUserPM")
    public String updateTaskUserPM(@RequestParam("taskUserId") Integer taskUserId,
                                   @RequestParam("taskStatus") String taskStatus,
                                   @RequestParam("assignStatus") Integer assignStatus,
                                   @RequestParam(value = "utilizedHours", required = false) Integer utilizedHours,
                                   @RequestParam(value = "comments", required = false) String comments) {
        TaskUserEntity taskUser = taskUserRepository.findById(taskUserId).orElse(null);
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
        return "redirect:/taskUserListPM";
    }

    @GetMapping("deleteTaskUserPM/{taskId}")
    public String deleteTaskUserPM(@PathVariable Integer taskId) {
        taskUserRepository.deleteByTaskId(taskId);
        return "redirect:/taskUserListPM";
    }
}