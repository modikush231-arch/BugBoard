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
import com.Grownited.repository.ProjectUserRepository;
import com.Grownited.repository.TaskRepository;
import com.Grownited.repository.TaskUserRepository;

import jakarta.servlet.http.HttpSession;

@Controller
public class ModuleController {

    @Autowired
    ModuleRepositary moduleRepositary;

    @Autowired
    ProjectRepository projectRepository;

    @Autowired
    ProjectStatusRepositary projectStatusRepositary;
    
    @Autowired
    private TaskRepository taskRepository;
    
    @Autowired
    private TaskUserRepository taskUserRepository;
    
    @Autowired
    private ProjectUserRepository projectUserRepository;

    @GetMapping("moduleList")
    public String moduleList(Model model,
                             @RequestParam(value = "status", required = false, defaultValue = "all") String statusFilter,
                             @RequestParam(value = "search", required = false) String searchTerm,
                             @RequestParam(value = "page", required = false, defaultValue = "1") int page,
                             @RequestParam(value = "size", required = false, defaultValue = "10") int size) {
        
        // 1. Get all modules
        List<ModuleEntity> allModules = moduleRepositary.findAll();
        
        // 2. Apply search filter
        List<ModuleEntity> searchedModules = allModules;
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            String searchLower = searchTerm.trim().toLowerCase();
            searchedModules = allModules.stream()
                    .filter(m -> (m.getModuleName() != null && m.getModuleName().toLowerCase().contains(searchLower)) ||
                                (m.getDescription() != null && m.getDescription().toLowerCase().contains(searchLower)))
                    .collect(Collectors.toList());
            model.addAttribute("searchTerm", searchTerm);
        }
        
        // 3. Apply status filter (status strings: InProgress, Completed, PendingTesting, Assigned)
        List<ModuleEntity> filteredModules = searchedModules;
        if (!"all".equals(statusFilter) && statusFilter != null) {
            filteredModules = searchedModules.stream()
                    .filter(m -> statusFilter.equals(m.getStatus()))
                    .collect(Collectors.toList());
        }
        
        // 4. Compute task counts for each module
        for (ModuleEntity module : filteredModules) {
            long taskCount = taskRepository.countByModuleId(module.getModuleId());
            module.setTaskCount((int) taskCount);
        }
        
        // 5. Pagination
        int totalItems = filteredModules.size();
        int totalPages = (int) Math.ceil((double) totalItems / size);
        if (page < 1) page = 1;
        if (page > totalPages && totalPages > 0) page = totalPages;
        int start = (page - 1) * size;
        int end = Math.min(start + size, totalItems);
        List<ModuleEntity> moduleList = filteredModules.subList(start, end);
        
        // 6. Counts for filter cards
        long totalCount = allModules.size();
        long inProgressCount = allModules.stream().filter(m -> "InProgress".equals(m.getStatus())).count();
        long completedCount = allModules.stream().filter(m -> "Completed".equals(m.getStatus())).count();
        long pendingTestingCount = allModules.stream().filter(m -> "PendingTesting".equals(m.getStatus())).count();
        long assignedCount = allModules.stream().filter(m -> "Assigned".equals(m.getStatus())).count();
        
        // 7. Other data for dropdowns
        List<ProjectEntity> projectList = projectRepository.findAll();
        List<ProjectStatusEntity> statusList = projectStatusRepositary.findAll(); // for project status, not module status
        
        model.addAttribute("moduleList", moduleList);
        model.addAttribute("projectList", projectList);
        model.addAttribute("statusList", statusList);  // for project status (if needed elsewhere)
        model.addAttribute("totalCount", totalCount);
        model.addAttribute("inProgressCount", inProgressCount);
        model.addAttribute("completedCount", completedCount);
        model.addAttribute("pendingTestingCount", pendingTestingCount);
        model.addAttribute("assignedCount", assignedCount);
        model.addAttribute("statusFilter", statusFilter);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("pageSize", size);
        model.addAttribute("totalItems", totalItems);
        
        return "Module";
    }

    @PostMapping("saveModule")
    public String saveModule(ModuleEntity moduleEntity) {
        moduleEntity.setTotalUtilizedHours(0);
        moduleRepositary.save(moduleEntity);
        return "redirect:/moduleList";
    }

    @GetMapping("/viewModule/{moduleId}")
    public String viewModule(@PathVariable Integer moduleId, Model model) {
        Optional<ModuleEntity> opt = moduleRepositary.findById(moduleId);
        if (opt.isPresent()) {
            model.addAttribute("module", opt.get());
            model.addAttribute("projectList", projectRepository.findAll());
            model.addAttribute("statusList", projectStatusRepositary.findAll());
            return "ViewModule";
        }
        return "redirect:/moduleList";
    }

    @GetMapping("editModule/{moduleId}")
    public String editModule(@PathVariable Integer moduleId, Model model, HttpSession session) {

        UserEntity user = (UserEntity) session.getAttribute("dbuser");
        if (user == null) {
            return "redirect:/login";
        }

        // Optional: Check role (recommended)
        if (!user.getRole().equals("system_admin")) {
            return "redirect:/dashboard?error=Unauthorized";
        }

        Optional<ModuleEntity> moduleOpt = moduleRepositary.findById(moduleId);

        if (moduleOpt.isPresent()) {
            ModuleEntity module = moduleOpt.get();

            model.addAttribute("module", module);

            // Admin can see ALL projects
            List<ProjectEntity> projectList = projectRepository.findAll();
            model.addAttribute("projectList", projectList);

            return "UpdateModule";
        }

        return "redirect:/moduleList";
    }    
    @PostMapping("updateModule")
    public String updateModuleAdmin(@RequestParam("moduleId") Integer moduleId,
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

        // Optional: Role check
        if (!user.getRole().equals("ADMIN")) {
            return "redirect:/dashboard?error=Unauthorized";
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

        return "redirect:/moduleList?success=Module updated successfully";
    }


    @GetMapping("deleteModule/{moduleId}")
    public String deleteModule(@PathVariable Integer moduleId,
                               @RequestParam(value = "projectId", required = false) Integer projectId) {
        // 1. Get all tasks belonging to this module
        List<TaskEntity> tasks = taskRepository.findByModuleId(moduleId);
        
        // 2. For each task, delete all task assignments (TaskUserEntity)
        for (TaskEntity task : tasks) {
            taskUserRepository.deleteByTaskId(task.getTaskId());
        }
        
        // 3. Delete all tasks of the module
        taskRepository.deleteAll(tasks);
        
        // 4. Delete the module itself
        moduleRepositary.deleteById(moduleId);
        
        // 5. Redirect back to the project modules page if projectId is provided, else to module list
        if (projectId != null) {
            return "redirect:/projectModulesAdmin/" + projectId;
        }
        return "redirect:/moduleList";
    }
}