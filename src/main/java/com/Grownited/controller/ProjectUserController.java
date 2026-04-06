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

import com.Grownited.entity.ProjectEntity;
import com.Grownited.entity.ProjectUserEntity;
import com.Grownited.entity.UserEntity;
import com.Grownited.repository.ProjectRepository;
import com.Grownited.repository.ProjectUserRepository;
import com.Grownited.repository.UserRepository;

@Controller
public class ProjectUserController {

    @Autowired
    ProjectUserRepository projectUserRepository;

    @Autowired
    ProjectRepository projectRepository;

    @Autowired
    UserRepository userRepository;

    @GetMapping("/projectUserList")
    public String projectUserList(Model model) {
        model.addAttribute("projectUserList", projectUserRepository.findAll());
        model.addAttribute("projectList", projectRepository.findAll());
        model.addAttribute("userList", userRepository.findByRole("project_manager"));
        return "ProjectUser";
    }

    @PostMapping("/saveProjectUser")
    public String saveProjectUser(ProjectUserEntity projectUserEntity) {
        projectUserRepository.save(projectUserEntity);
        return "redirect:/projectUserList";
    }

    @GetMapping("/viewProjectUser/{projectUserId}")
    public String viewProjectUser(@PathVariable Integer projectUserId, Model model) {
        Optional<ProjectUserEntity> opt = projectUserRepository.findById(projectUserId);
        if (opt.isPresent()) {
            model.addAttribute("projectUser", opt.get());
            model.addAttribute("projectList", projectRepository.findAll());
            model.addAttribute("userList", userRepository.findAll());
            return "ViewProjectUser";
        }
        return "redirect:/projectUserList";
    }

    @GetMapping("editProjectUser/{projectUserId}")
    public String editProjectUser(@PathVariable Integer projectUserId, Model model) {
        Optional<ProjectUserEntity> opt = projectUserRepository.findById(projectUserId);
        if (opt.isPresent()) {
            model.addAttribute("projectUser", opt.get());
            model.addAttribute("projectList", projectRepository.findAll());
            model.addAttribute("userList", userRepository.findByRole("project_manager"));
            return "EditProjectUser";
        }
        return "redirect:/projectUserList";
    }

    @PostMapping("updateProjectUser")
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
        projectUserRepository.deleteById(projectUserId);
        return "redirect:/projectUserList";
    }
}