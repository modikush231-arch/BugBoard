package com.Grownited.controller;

import java.util.List;
import java.util.Optional;

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
import com.Grownited.repository.ModuleRepositary;
import com.Grownited.repository.ProjectRepository;
import com.Grownited.repository.ProjectStatusRepositary;

@Controller
public class ModuleController {

    @Autowired
    ModuleRepositary moduleRepositary;

    @Autowired
    ProjectRepository projectRepository;

    @Autowired
    ProjectStatusRepositary projectStatusRepositary;

    @GetMapping("moduleList")
    public String moduleList(Model model) {
        List<ModuleEntity> moduleList = moduleRepositary.findAll();
        List<ProjectEntity> projectList = projectRepository.findAll();
        List<ProjectStatusEntity> statusList = projectStatusRepositary.findAll();
        model.addAttribute("moduleList", moduleList);
        model.addAttribute("projectList", projectList);
        model.addAttribute("statusList", statusList);
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
    public String editModule(@PathVariable Integer moduleId, Model model) {
        Optional<ModuleEntity> opt = moduleRepositary.findById(moduleId);
        if (opt.isPresent()) {
            model.addAttribute("module", opt.get());
            model.addAttribute("projectList", projectRepository.findAll());
            model.addAttribute("statusList", projectStatusRepositary.findAll());
            return "EditModule";
        }
        return "redirect:/moduleList";
    }

    @PostMapping("updateModule")
    public String updateModule(@RequestParam("moduleId") Integer moduleId,
                               @RequestParam("moduleName") String moduleName,
                               @RequestParam("projectId") Integer projectId,
                               @RequestParam("description") String description,
                               @RequestParam("docURL") String docURL,
                               @RequestParam("status") String status,
                               @RequestParam("estimatedHours") Integer estimatedHours) {
        Optional<ModuleEntity> opt = moduleRepositary.findById(moduleId);
        if (opt.isPresent()) {
            ModuleEntity m = opt.get();
            m.setModuleName(moduleName);
            m.setProjectId(projectId);
            m.setDescription(description);
            m.setDocURL(docURL);
            m.setStatus(status);
            m.setEstimatedHours(estimatedHours);
            moduleRepositary.save(m);
        }
        return "redirect:/moduleList";
    }

    @GetMapping("deleteModule/{moduleId}")
    public String deleteModule(@PathVariable Integer moduleId) {
        moduleRepositary.deleteById(moduleId);
        return "redirect:/moduleList";
    }
}