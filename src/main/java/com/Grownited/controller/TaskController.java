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
import com.Grownited.entity.ProjectStatusEntity;
import com.Grownited.entity.ProjectUserEntity;
import com.Grownited.entity.TaskEntity;
import com.Grownited.entity.UserEntity;
import com.Grownited.repository.ModuleRepositary;
import com.Grownited.repository.ProjectRepository;
import com.Grownited.repository.ProjectStatusRepositary;
import com.Grownited.repository.TaskRepository;
import com.Grownited.repository.TaskUserRepository;

import jakarta.servlet.http.HttpSession;

@Controller
public class TaskController {

    @Autowired
    TaskRepository taskRepository;

    @Autowired
    ProjectRepository projectRepository;

    @Autowired
    ProjectStatusRepositary projectStatusRepositary;

    @Autowired
    ModuleRepositary moduleRepositary;
    
    @Autowired
    TaskUserRepository taskUserRepository;

    @GetMapping("taskList")
    public String taskList(Model model,
                           @RequestParam(value = "status", required = false, defaultValue = "all") String statusFilter,
                           @RequestParam(value = "search", required = false) String searchTerm,
                           @RequestParam(value = "page", required = false, defaultValue = "1") int page,
                           @RequestParam(value = "size", required = false, defaultValue = "10") int size) {
        
        // 1. Get all tasks
        List<TaskEntity> allTasks = taskRepository.findAll();
        
        // 2. Apply search filter
        List<TaskEntity> searchedTasks = allTasks;
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            String searchLower = searchTerm.trim().toLowerCase();
            searchedTasks = allTasks.stream()
                    .filter(t -> (t.getTitle() != null && t.getTitle().toLowerCase().contains(searchLower)) ||
                                (t.getDescription() != null && t.getDescription().toLowerCase().contains(searchLower)))
                    .collect(Collectors.toList());
            model.addAttribute("searchTerm", searchTerm);
        }
        
        // 3. Apply status filter
        List<TaskEntity> filteredTasks = searchedTasks;
        if (!"all".equals(statusFilter) && statusFilter != null) {
            filteredTasks = searchedTasks.stream()
                    .filter(t -> statusFilter.equals(t.getStatus()))
                    .collect(Collectors.toList());
        }
        
        // 4. Pagination
        int totalItems = filteredTasks.size();
        int totalPages = (int) Math.ceil((double) totalItems / size);
        if (page < 1) page = 1;
        if (page > totalPages && totalPages > 0) page = totalPages;
        int start = (page - 1) * size;
        int end = Math.min(start + size, totalItems);
        List<TaskEntity> taskList = filteredTasks.subList(start, end);
        
        // 5. Get lists for dropdowns
        List<ProjectEntity> projectList = projectRepository.findAll();
        List<ModuleEntity> moduleList = moduleRepositary.findAll();
        List<ProjectStatusEntity> statusList = projectStatusRepositary.findAll(); // for project status (not used in task status)
        
        // 6. Counts for filter cards
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
        
        return "Task";
    }

    @PostMapping("saveTask")
    public String saveTask(TaskEntity taskEntity) {
        taskEntity.setTotalUtilizedHours(0);
        taskRepository.save(taskEntity);
        // Update module status after adding a task
        updateModuleStatus(taskEntity.getModuleId());
        return "redirect:/taskList";
    }
    
    @GetMapping("/viewTask/{taskId}")
    public String viewTask(@PathVariable Integer taskId, Model model, HttpSession session) {

        UserEntity user = (UserEntity) session.getAttribute("dbuser");

        if (user == null) {
            return "redirect:/login";
        }

        if (!"system_admin".equals(user.getRole())) {
            return "redirect:/dashboard?error=Unauthorized";
        }

        Optional<TaskEntity> taskOpt = taskRepository.findById(taskId);

        if (taskOpt.isPresent()) {
            TaskEntity task = taskOpt.get();

            model.addAttribute("task", task);
            model.addAttribute("projectList", projectRepository.findAll());
            model.addAttribute("statusList", projectStatusRepositary.findAll());
            model.addAttribute("moduleList", moduleRepositary.findAll());

            return "ViewTask";
        }

        return "redirect:/taskList";
    }


    @GetMapping("editTask/{taskId}")
    public String editTask(@PathVariable Integer taskId, Model model, HttpSession session) {

        UserEntity user = (UserEntity) session.getAttribute("dbuser");

        if (user == null) {
            return "redirect:/login";
        }

        if (!"system_admin".equals(user.getRole())) {
            return "redirect:/dashboard?error=Unauthorized";
        }

        TaskEntity task = taskRepository.findById(taskId)
                .orElse(null);

        if (task == null) {
            return "redirect:/taskList";
        }

        model.addAttribute("task", task);

        model.addAttribute("projectName",
                projectRepository.findById(task.getProjectId())
                        .map(ProjectEntity::getTitle).orElse(""));

        model.addAttribute("moduleName",
                moduleRepositary.findById(task.getModuleId())
                        .map(ModuleEntity::getModuleName).orElse(""));

        return "UpdateTask";
    }
    
    @PostMapping("updateTask")
    public String updateTask(@RequestParam Integer taskId,
                             @RequestParam String status,
                             @RequestParam(required = false) String docURL,
                             HttpSession session) {

        UserEntity user = (UserEntity) session.getAttribute("dbuser");

        if (user == null) {
            return "redirect:/login";
        }

        if (!"system_admin".equals(user.getRole())) {
            return "redirect:/dashboard?error=Unauthorized";
        }

        TaskEntity task = taskRepository.findById(taskId)
                .orElse(null);

        if (task != null) {

            task.setStatus(status);

            if (docURL != null && !docURL.isEmpty()) {
                task.setDocURL(docURL);
            }

            taskRepository.save(task);

            updateModuleStatus(task.getModuleId());
        }

        return "redirect:/taskList?success=Task updated successfully";
    }
    
    @GetMapping("deleteTask/{taskId}")
    public String deleteTask(@PathVariable Integer taskId) {
        // First delete task assignments
        taskUserRepository.deleteByTaskId(taskId);
        // Then delete task
        taskRepository.deleteById(taskId);
        return "redirect:/taskList";
    }
    
    private void updateModuleStatus(Integer moduleId) {
        List<TaskEntity> tasks = taskRepository.findByModuleId(moduleId);
        if (tasks.isEmpty()) return;
        
        boolean allCompleted = tasks.stream().allMatch(t -> "Completed".equals(t.getStatus()));
        boolean anyDefect = tasks.stream().anyMatch(t -> "Defect".equals(t.getStatus()));
        boolean anyInProgress = tasks.stream().anyMatch(t -> "InProgress".equals(t.getStatus()));
        boolean anyPendingTesting = tasks.stream().anyMatch(t -> "PendingTesting".equals(t.getStatus()));
        
        String moduleStatus;
        if (allCompleted) moduleStatus = "Completed";
        else if (anyDefect) moduleStatus = "Defect";
        else if (anyInProgress) moduleStatus = "InProgress";
        else if (anyPendingTesting) moduleStatus = "PendingTesting";
        else moduleStatus = "Assigned";
        
        ModuleEntity module = moduleRepositary.findById(moduleId).orElse(null);
        if (module != null && !moduleStatus.equals(module.getStatus())) {
            module.setStatus(moduleStatus);
            moduleRepositary.save(module);
        }
    }
}