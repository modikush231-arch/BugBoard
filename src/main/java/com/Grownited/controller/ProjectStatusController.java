package com.Grownited.controller;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.Grownited.entity.ProjectStatusEntity;
import com.Grownited.repository.ProjectStatusRepositary;

@Controller
public class ProjectStatusController {

    @Autowired
    ProjectStatusRepositary projectStatusRepositary;

    // LIST PAGE
    @GetMapping("projectStatusList")
    public String projectStatus(Model model) {
        List<ProjectStatusEntity> projectStatusList = projectStatusRepositary.findAll();
        model.addAttribute("projectStatusList", projectStatusList);
        return "ProjectStatus";   // ✅ Make sure JSP name is ProjectStatusList.jsp
    }

    // SAVE (ADD + UPDATE)
    @PostMapping("saveStatus")
    public String saveStatus(ProjectStatusEntity projectStatusEntity) {
        projectStatusRepositary.save(projectStatusEntity);
        return "redirect:/projectStatusList";
    }


    // DELETE
    @GetMapping("/deleteProjectStatus/{projectStatusId}")
    public String deleteProjectStatus(@PathVariable Integer projectStatusId) {
        projectStatusRepositary.deleteById(projectStatusId);
        return "redirect:/projectStatusList";
    }
}
