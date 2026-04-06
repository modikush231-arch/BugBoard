package com.Grownited.controller;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.Grownited.entity.ProjectEntity;
import com.Grownited.entity.ProjectStatusEntity;
import com.Grownited.repository.ProjectRepository;
import com.Grownited.repository.ProjectStatusRepositary;

@Controller
public class ProjectController {

    @Autowired
    ProjectRepository projectRepository;

    @Autowired
    ProjectStatusRepositary projectStatusRepositary;

    @GetMapping("projectList")
    public String projectList(Model model) {
        List<ProjectEntity> projectList = projectRepository.findAll();
        List<ProjectStatusEntity> statusList = projectStatusRepositary.findAll();
        model.addAttribute("projectList", projectList);
        model.addAttribute("statusList", statusList);
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
            model.addAttribute("project", projectOpt.get());
            model.addAttribute("statusList", projectStatusRepositary.findAll());
            return "ViewProject";
        }
        return "redirect:/projectList";
    }

    @GetMapping("editProject/{projectId}")
    public String editProject(@PathVariable Integer projectId, Model model) {
        Optional<ProjectEntity> projectOpt = projectRepository.findById(projectId);
        if (projectOpt.isPresent()) {
            model.addAttribute("project", projectOpt.get());
            model.addAttribute("statusList", projectStatusRepositary.findAll());
            return "EditProject";
        }
        return "redirect:/projectList";
    }

    @PostMapping("updateProject")
    public String updateProject(@RequestParam("projectId") Integer projectId,
                                @RequestParam("title") String title,
                                @RequestParam("description") String description,
                                @RequestParam("docURL") String docURL,
                                @RequestParam("estimatedHours") Integer estimatedHours,
                                @RequestParam("projectStartDate") String startDateStr,
                                @RequestParam(value = "projectCompletionDate", required = false) String completionDateStr,
                                @RequestParam("projectStatusId") Integer statusId) {
        Optional<ProjectEntity> opt = projectRepository.findById(projectId);
        if (opt.isPresent()) {
            ProjectEntity p = opt.get();
            p.setTitle(title);
            p.setDescription(description);
            p.setDocURL(docURL);
            p.setEstimatedHours(estimatedHours);
            
            // ✅ Convert String to LocalDate
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
            if (startDateStr != null && !startDateStr.isEmpty()) {
                p.setProjectStartDate(LocalDate.parse(startDateStr, formatter));
            }
            if (completionDateStr != null && !completionDateStr.isEmpty()) {
                p.setProjectCompletionDate(LocalDate.parse(completionDateStr, formatter));
            }
            
            p.setProjectStatusId(statusId);
            projectRepository.save(p);
        }
        return "redirect:/projectList";
    }

    @GetMapping("deleteProject/{projectId}")
    public String deleteProject(@PathVariable Integer projectId) {
        projectRepository.deleteById(projectId);
        return "redirect:/projectList";
    }
}