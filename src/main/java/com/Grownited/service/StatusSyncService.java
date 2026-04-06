package com.Grownited.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.Grownited.entity.ModuleEntity;
import com.Grownited.entity.TaskEntity;
import com.Grownited.entity.TaskUserEntity;
import com.Grownited.entity.UserEntity;
import com.Grownited.repository.ModuleRepositary;
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

    /**
     * Combines developer and tester statuses into a single overall task status.
     */
    public String getCombinedTaskStatus(TaskUserEntity dev, TaskUserEntity tester) {
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
     * Recalculates and updates the overall task status and the module status.
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

        // Update module status
        updateModuleStatus(task.getModuleId());
    }

    /**
     * Recalculates and updates the status of a module based on its tasks.
     */
    public void updateModuleStatus(Integer moduleId) {
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

    private boolean isDeveloper(Integer userId) {
        UserEntity user = userRepository.findById(userId).orElse(null);
        return user != null && "developer".equals(user.getRole());
    }

    private boolean isTester(Integer userId) {
        UserEntity user = userRepository.findById(userId).orElse(null);
        return user != null && "tester".equals(user.getRole());
    }
}