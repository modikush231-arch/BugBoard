package com.Grownited.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.Grownited.entity.ModuleEntity;
import com.Grownited.entity.TaskEntity;
import com.Grownited.entity.TaskUserEntity;
import com.Grownited.entity.UserEntity;
import com.Grownited.entity.ProjectEntity;
import com.Grownited.entity.ProjectStatusEntity;
import com.Grownited.repository.ModuleRepositary;
import com.Grownited.repository.ProjectRepository;
import com.Grownited.repository.ProjectStatusRepositary;
import com.Grownited.repository.TaskRepository;
import com.Grownited.repository.TaskUserRepository;
import com.Grownited.repository.UserRepository;

@Service
public class StatusSyncService {

    @Autowired
    private TaskRepository taskRepository;

    @Autowired
    private TaskUserRepository taskUserRepository;

    @Autowired
    private ModuleRepositary moduleRepositary;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private ProjectRepository projectRepository;

    @Autowired
    private ProjectStatusRepositary projectStatusRepositary;

    /**
     * Combines developer and tester individual statuses into a single overall task status.
     */
    public String getCombinedTaskStatus(TaskUserEntity dev, TaskUserEntity tester) {
        if (dev == null && tester == null) return "Assigned";
        String devStatus    = dev    != null ? dev.getTaskStatus()    : null;
        String testerStatus = tester != null ? tester.getTaskStatus() : null;

        // Both completed successfully
        if ("Completed".equals(devStatus) && "Verified".equals(testerStatus)) {
            return "Completed";
        }
        // Defect found by either party
        if ("Defect".equals(devStatus) || "Defect".equals(testerStatus)) {
            return "Defect";
        }
        // Tester is actively testing
        if ("InProgress".equals(testerStatus) && "PendingTesting".equals(devStatus)) {
            return "InProgress";
        }
        // Developer finished, waiting for tester
        if ("PendingTesting".equals(devStatus)
                && ("NotStarted".equals(testerStatus) || "InProgress".equals(testerStatus))) {
            return "PendingTesting";
        }
        // Developer is working
        if ("InProgress".equals(devStatus)) {
            return "InProgress";
        }
        // Initial / just-assigned state
        if ("Assigned".equals(devStatus) && "NotStarted".equals(testerStatus)) {
            return "Assigned";
        }
        return "Assigned";
    }

    /**
     * Recalculates and persists the overall task status, then propagates the
     * change up to the module and project.
     */
    public void syncTaskAndModuleStatus(Integer taskId) {
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

        // Propagate up the hierarchy
        updateModuleStatus(task.getModuleId());
    }

    /**
     * Recalculates and persists the status of a module based on its tasks,
     * then propagates the change up to the project.
     */
    public void updateModuleStatus(Integer moduleId) {
        List<TaskEntity> tasks = taskRepository.findByModuleId(moduleId);
        if (tasks.isEmpty()) return;

        boolean allCompleted      = tasks.stream().allMatch(t -> "Completed".equals(t.getStatus()));
        boolean anyDefect         = tasks.stream().anyMatch(t -> "Defect".equals(t.getStatus()));
        boolean anyInProgress     = tasks.stream().anyMatch(t -> "InProgress".equals(t.getStatus()));
        boolean anyPendingTesting = tasks.stream().anyMatch(t -> "PendingTesting".equals(t.getStatus()));

        String moduleStatus;
        if (allCompleted)           moduleStatus = "Completed";
        else if (anyDefect)         moduleStatus = "Defect";
        else if (anyInProgress)     moduleStatus = "InProgress";
        else if (anyPendingTesting) moduleStatus = "PendingTesting";
        else                        moduleStatus = "Assigned";

        ModuleEntity module = moduleRepositary.findById(moduleId).orElse(null);
        if (module == null) return;

        if (!moduleStatus.equals(module.getStatus())) {
            module.setStatus(moduleStatus);
            moduleRepositary.save(module);
        }

        // Always propagate to project (module may have changed or another module
        // already changed; either way the project status must be recalculated).
        updateProjectStatus(module.getProjectId());
    }

    /**
     * Recalculates and persists the project status based on the current state of
     * all its modules.
     *
     * Status priority (highest wins):
     *   Defect > InProgress > PendingTesting > Assigned > Completed (only when ALL modules done)
     */
    public void updateProjectStatus(Integer projectId) {
        if (projectId == null) return;

        List<ModuleEntity> modules = moduleRepositary.findByProjectId(projectId);
        if (modules == null || modules.isEmpty()) return;

        boolean allCompleted      = modules.stream().allMatch(m -> "Completed".equals(m.getStatus()));
        boolean anyDefect         = modules.stream().anyMatch(m -> "Defect".equals(m.getStatus()));
        boolean anyInProgress     = modules.stream().anyMatch(m -> "InProgress".equals(m.getStatus()));
        boolean anyPendingTesting = modules.stream().anyMatch(m -> "PendingTesting".equals(m.getStatus()));

        String targetStatusName;
        if (allCompleted)           targetStatusName = "Completed";
        else if (anyDefect)         targetStatusName = "Defect";
        else if (anyInProgress)     targetStatusName = "InProgress";
        else if (anyPendingTesting) targetStatusName = "PendingTesting";
        else                        targetStatusName = "Assigned";

        // Look up the status row by name so we are never hard-coding IDs.
        ProjectStatusEntity statusEntity = projectStatusRepositary.findByStatus(targetStatusName);
        if (statusEntity == null) return; // safety guard — status must exist in DB

        ProjectEntity project = projectRepository.findById(projectId).orElse(null);
        if (project == null) return;

        if (!statusEntity.getProjectStatusId().equals(project.getProjectStatusId())) {
            project.setProjectStatusId(statusEntity.getProjectStatusId());
            projectRepository.save(project);
        }
    }

    // ── helper methods ──────────────────────────────────────────────────────────

    private boolean isDeveloper(Integer userId) {
        UserEntity user = userRepository.findById(userId).orElse(null);
        return user != null && "developer".equals(user.getRole());
    }

    private boolean isTester(Integer userId) {
        UserEntity user = userRepository.findById(userId).orElse(null);
        return user != null && "tester".equals(user.getRole());
    }
}