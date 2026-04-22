package com.Grownited.controller;

import java.util.List;
import java.util.Optional;
import java.time.Duration;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
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
import com.Grownited.entity.TaskEntity;
import com.Grownited.entity.TaskUserEntity;
import com.Grownited.entity.UserEntity;
import com.Grownited.repository.ModuleRepositary;
import com.Grownited.repository.ProjectRepository;
import com.Grownited.repository.ProjectStatusRepositary;
import com.Grownited.repository.TaskRepository;
import com.Grownited.repository.TaskUserRepository;
import com.Grownited.repository.UserRepository;
import com.Grownited.service.StatusSyncService;

import jakarta.servlet.http.HttpSession;


@Controller
public class DeveloperController {
	@Autowired
	ProjectRepository projectRepository;
	
	@Autowired
	TaskRepository taskRepository;
	
	@Autowired
	ProjectStatusRepositary projectStatusRepositary;
	
	@Autowired
	UserRepository userRepository;
	
	@Autowired
	TaskUserRepository taskUserRepository;
	
	@Autowired
	ModuleRepositary moduleRepositary;

	@Autowired
	private StatusSyncService statusSyncService;
	
	@GetMapping("/DeveloperDashboard")
	public String DeveloperDashboard(Model model, HttpSession session) {
	    UserEntity user = (UserEntity) session.getAttribute("dbuser");
	    
	    if (user == null) {
	        return "redirect:/login";
	    }
	    
	    Integer devId = user.getUserId();
	    
	    // Get developer's task assignments
	    List<TaskUserEntity> taskUserList = taskUserRepository.findByUserId(devId);
	    List<Integer> taskIds = taskUserList.stream()
	            .map(TaskUserEntity::getTaskId)
	            .toList();
	    
	    List<TaskEntity> taskList = taskRepository.findByTaskIdIn(taskIds);
	    
	    // Get unique project IDs from tasks
	    List<Integer> projectIds = taskList.stream()
	            .map(TaskEntity::getProjectId)
	            .distinct()
	            .toList();
	    
	    // Get projects
	    List<ProjectEntity> projects = projectRepository.findByProjectIdIn(projectIds);
	    
	    // Statistics
	    long totalProjects = projectIds.size();
	    long totalTasks = taskList.size();
	    
	    long pendingTasks = taskUserList.stream()
	            .filter(tu -> !"Completed".equals(tu.getTaskStatus()) && 
	                          !"Verified".equals(tu.getTaskStatus()))
	            .count();
	    
	    long ongoingProjects = projects.stream()
	            .filter(p -> p.getProjectStatusId() != 5)
	            .count();
	    
	    // Initialize counters
	    long assignedCount = 0;
	    long inProgressCount = 0;
	    long pendingTestingCount = 0;
	    long completedCount = 0;
	    long defectCount = 0;
	    
	    // Count statuses
	    for (TaskUserEntity tu : taskUserList) {
	        String status = tu.getTaskStatus();
	        
	        if (status == null) continue;
	        
	        if (status.equalsIgnoreCase("assigned")) {
	            assignedCount++;
	        }
	        else if (status.equalsIgnoreCase("inprogress") || status.equalsIgnoreCase("in progress")) {
	            inProgressCount++;
	        }
	        else if (status.equalsIgnoreCase("pendingtesting") || status.equalsIgnoreCase("pending testing")) {
	            pendingTestingCount++;
	        }
	        else if (status.equalsIgnoreCase("completed")) {
	            completedCount++;
	        }
	        else if (status.equalsIgnoreCase("defect")) {
	            defectCount++;
	        }
	    }
	    
	    // Prepare chart data
	    List<String> statusLabels = new ArrayList<>();
	    List<Long> statusData = new ArrayList<>();
	    
	    if (assignedCount > 0) {
	        statusLabels.add("Assigned");
	        statusData.add(assignedCount);
	    }
	    if (inProgressCount > 0) {
	        statusLabels.add("In Progress");
	        statusData.add(inProgressCount);
	    }
	    if (pendingTestingCount > 0) {
	        statusLabels.add("Pending Testing");
	        statusData.add(pendingTestingCount);
	    }
	    if (completedCount > 0) {
	        statusLabels.add("Completed");
	        statusData.add(completedCount);
	    }
	    if (defectCount > 0) {
	        statusLabels.add("Defect");
	        statusData.add(defectCount);
	    }
	    
	    // Recent activities (last 7 days)
	    LocalDateTime sevenDaysAgo = LocalDateTime.now().minusDays(7);
	    
	    List<Map<String, Object>> recentActivities = new ArrayList<>();
	    List<TaskUserEntity> recentTaskUsers = taskUserList.stream()
	            .filter(tu -> tu.getUpdatedDate() != null)
	            .filter(tu -> tu.getUpdatedDate().isAfter(sevenDaysAgo))
	            .sorted((a, b) -> b.getUpdatedDate().compareTo(a.getUpdatedDate()))
	            .limit(10)
	            .toList();
	    
	    for (TaskUserEntity tu : recentTaskUsers) {
	        Map<String, Object> activity = new HashMap<>();
	        TaskEntity task = taskRepository.findById(tu.getTaskId()).orElse(null);
	        if (task != null) {
	            activity.put("taskTitle", task.getTitle());
	            activity.put("taskStatus", tu.getTaskStatus());
	            activity.put("timeAgo", getTimeAgo(tu.getUpdatedDate()));
	            activity.put("activityMessage", getActivityMessage(tu.getTaskStatus()));
	            recentActivities.add(activity);
	        }
	    }
	    
	    // NEW: Pending tasks list (only Assigned, InProgress, PendingTesting, Defect) - like Tester dashboard
	    List<Map<String, Object>> pendingTaskList = new ArrayList<>();
	    for (TaskEntity task : taskList) {
	        TaskUserEntity tu = taskUserList.stream()
	                .filter(t -> t.getTaskId().equals(task.getTaskId()))
	                .findFirst().orElse(null);
	        if (tu != null) {
	            String status = tu.getTaskStatus();
	            // Exclude Completed and Verified
	            if (!"Completed".equals(status) && !"Verified".equals(status)) {
	                Map<String, Object> taskMap = new HashMap<>();
	                taskMap.put("taskId", task.getTaskId());
	                taskMap.put("taskTitle", task.getTitle());
	                ProjectEntity project = projectRepository.findById(task.getProjectId()).orElse(null);
	                taskMap.put("projectName", project != null ? project.getTitle() : "N/A");
	                taskMap.put("taskStatus", status);
	                pendingTaskList.add(taskMap);
	            }
	        }
	    }
	    // Limit to 5 for display
	    pendingTaskList = pendingTaskList.stream().limit(5).toList();
	    
	    // Recent tasks for table (kept for other uses, but not used in dashboard anymore)
	    List<Map<String, Object>> recentTasks = new ArrayList<>();
	    for (TaskEntity task : taskList.stream().limit(5).toList()) {
	        Map<String, Object> taskMap = new HashMap<>();
	        taskMap.put("taskId", task.getTaskId());
	        taskMap.put("taskTitle", task.getTitle());
	        
	        ProjectEntity project = projectRepository.findById(task.getProjectId()).orElse(null);
	        taskMap.put("projectName", project != null ? project.getTitle() : "N/A");
	        
	        TaskUserEntity tu = taskUserList.stream()
	                .filter(t -> t.getTaskId().equals(task.getTaskId()))
	                .findFirst().orElse(null);
	        taskMap.put("taskStatus", tu != null ? tu.getTaskStatus() : "N/A");
	        
	        recentTasks.add(taskMap);
	    }
	    
	    // Recent defects for summary card
	    List<Map<String, Object>> recentDefects = new ArrayList<>();
	    List<TaskUserEntity> defectTasks = taskUserList.stream()
	            .filter(tu -> "Defect".equals(tu.getTaskStatus()))
	            .sorted((a, b) -> {
	                if (a.getUpdatedDate() == null && b.getUpdatedDate() == null) return 0;
	                if (a.getUpdatedDate() == null) return 1;
	                if (b.getUpdatedDate() == null) return -1;
	                return b.getUpdatedDate().compareTo(a.getUpdatedDate());
	            })
	            .limit(5)
	            .toList();
	    
	    for (TaskUserEntity tu : defectTasks) {
	        Map<String, Object> defect = new HashMap<>();
	        TaskEntity task = taskRepository.findById(tu.getTaskId()).orElse(null);
	        if (task != null) {
	            defect.put("taskId", task.getTaskId());
	            defect.put("taskTitle", task.getTitle());
	            
	            String latestComment = "";
	            if (tu.getComments() != null) {
	                String[] lines = tu.getComments().split("\n");
	                if (lines.length > 0) {
	                    latestComment = lines[lines.length - 1];
	                    if (latestComment.length() > 60) {
	                        latestComment = latestComment.substring(0, 57) + "...";
	                    }
	                }
	            }
	            defect.put("comment", latestComment);
	            recentDefects.add(defect);
	        }
	    }
	    
	    // Add all attributes to model
	    model.addAttribute("totalProjects", totalProjects);
	    model.addAttribute("ongoingProjects", ongoingProjects);
	    model.addAttribute("totalTasks", totalTasks);
	    model.addAttribute("pendingTasks", pendingTasks);
	    
	    model.addAttribute("assignedCount", assignedCount);
	    model.addAttribute("inProgressCount", inProgressCount);
	    model.addAttribute("pendingTestingCount", pendingTestingCount);
	    model.addAttribute("completedCount", completedCount);
	    model.addAttribute("defectCount", defectCount);
	    
	    model.addAttribute("statusLabels", statusLabels);
	    model.addAttribute("statusCounts", statusData);
	    
	    model.addAttribute("recentActivities", recentActivities);
	    model.addAttribute("recentTasks", recentTasks);
	    model.addAttribute("pendingTaskList", pendingTaskList);  // NEW
	    model.addAttribute("recentDefects", recentDefects);
	    
	    return "DeveloperDashboard";
	}
	
	@GetMapping("taskListDeveloper")
	public String taskListDeveloper(Model model, HttpSession session,
	                                @RequestParam(value = "status", required = false, defaultValue = "all") String statusFilter,
	                                @RequestParam(value = "page", required = false, defaultValue = "1") int page,
	                                @RequestParam(value = "size", required = false, defaultValue = "10") int size) {

	    UserEntity user = (UserEntity) session.getAttribute("dbuser");

	    if (user == null) {
	        return "redirect:/login";
	    }

	    Integer devId = user.getUserId();

	    // Get all task-user mapping for this developer
	    List<TaskUserEntity> allTaskUsers = taskUserRepository.findByUserId(devId);

	    // Apply status filter
	    List<TaskUserEntity> filteredTasks = allTaskUsers;
	    if (!"all".equals(statusFilter) && statusFilter != null) {
	        filteredTasks = allTaskUsers.stream()
	                .filter(tu -> statusFilter.equals(tu.getTaskStatus()))
	                .toList();
	    }

	    // Calculate pagination
	    int totalItems = filteredTasks.size();
	    int totalPages = (int) Math.ceil((double) totalItems / size);
	    if (page < 1) page = 1;
	    if (page > totalPages && totalPages > 0) page = totalPages;

	    int start = (page - 1) * size;
	    int end = Math.min(start + size, totalItems);

	    List<TaskUserEntity> taskUserPage = filteredTasks.subList(start, end);

	    // Extract taskIds
	    List<Integer> taskIds = taskUserPage.stream()
	            .map(TaskUserEntity::getTaskId)
	            .toList();

	    // Get tasks
	    List<TaskEntity> taskList = taskRepository.findByTaskIdIn(taskIds);

	    // Extract projectIds and moduleIds
	    List<Integer> projectIds = taskList.stream()
	            .map(TaskEntity::getProjectId)
	            .distinct()
	            .toList();

	    List<Integer> moduleIds = taskList.stream()
	            .map(TaskEntity::getModuleId)
	            .distinct()
	            .toList();

	    // Fetch related data
	    List<ProjectEntity> projectList = projectRepository.findByProjectIdIn(projectIds);
	    List<ModuleEntity> moduleList = moduleRepositary.findByModuleIdIn(moduleIds);

	    // Create a map of taskId -> TaskUserEntity for easy lookup
	    Map<Integer, TaskUserEntity> taskUserMap = new HashMap<>();
	    for (TaskUserEntity tu : allTaskUsers) {
	        taskUserMap.put(tu.getTaskId(), tu);
	    }

	    // Format dates for table
	    Map<Integer, String> formattedDates = new HashMap<>();
	    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MMM dd, HH:mm");
	    for (TaskUserEntity tu : allTaskUsers) {
	        if (tu.getUpdatedDate() != null) {
	            formattedDates.put(tu.getTaskUserId(), tu.getUpdatedDate().format(formatter));
	        } else {
	            formattedDates.put(tu.getTaskUserId(), "-");
	        }
	    }

	    // Counts for filter cards
	    long totalCount = allTaskUsers.size();
	    long assignedCount = allTaskUsers.stream().filter(tu -> "Assigned".equals(tu.getTaskStatus())).count();
	    long inProgressCount = allTaskUsers.stream().filter(tu -> "InProgress".equals(tu.getTaskStatus())).count();
	    long pendingTestingCount = allTaskUsers.stream().filter(tu -> "PendingTesting".equals(tu.getTaskStatus())).count();
	    long completedCount = allTaskUsers.stream().filter(tu -> "Completed".equals(tu.getTaskStatus())).count();
	    long defectCount = allTaskUsers.stream().filter(tu -> "Defect".equals(tu.getTaskStatus())).count();

	    model.addAttribute("taskList", taskList);
	    model.addAttribute("projectList", projectList);
	    model.addAttribute("moduleList", moduleList);
	    model.addAttribute("taskUserMap", taskUserMap);
	    model.addAttribute("formattedDates", formattedDates);
	    model.addAttribute("totalCount", totalCount);
	    model.addAttribute("assignedCount", assignedCount);
	    model.addAttribute("inProgressCount", inProgressCount);
	    model.addAttribute("pendingTestingCount", pendingTestingCount);
	    model.addAttribute("completedCount", completedCount);
	    model.addAttribute("defectCount", defectCount);
	    model.addAttribute("statusFilter", statusFilter);
	    model.addAttribute("currentPage", page);
	    model.addAttribute("totalPages", totalPages);
	    model.addAttribute("pageSize", size);
	    model.addAttribute("totalItems", totalItems);

	    return "TaskDeveloper";
	}
	
	@GetMapping("/viewTaskDeveloper/{taskId}")
	public String viewTask(@PathVariable Integer taskId, Model model, HttpSession session) {
	    
	    UserEntity user = (UserEntity) session.getAttribute("dbuser");
	    
	    if (user == null) {
	        return "redirect:/login";
	    }
	    
	    Integer devId = user.getUserId();
	    
	    Optional<TaskEntity> taskOpt = taskRepository.findById(taskId);

	    if (taskOpt.isPresent()) {
	        TaskEntity task = taskOpt.get();
	        model.addAttribute("task", task);
	        
	        // Get only this developer's assignment for this task
	        TaskUserEntity taskUser = null;
	        List<TaskUserEntity> taskUserList = taskUserRepository.findByTaskId(taskId);
	        for (TaskUserEntity tu : taskUserList) {
	            if (tu.getUserId().equals(devId)) {
	                taskUser = tu;
	                break;
	            }
	        }
	        
	        // Get all users for displaying names
	        List<UserEntity> allUsers = userRepository.findAll();
	        
	        // Get project and module details
	        List<ProjectEntity> projectList = projectRepository.findAll();
	        List<ModuleEntity> moduleList = moduleRepositary.findAll();
	        List<ProjectStatusEntity> statusList = projectStatusRepositary.findAll();
	        
	        // Get project for this task
	        ProjectEntity project = projectRepository.findById(task.getProjectId()).orElse(null);
	        
	        // Format dates for display
	        String formattedCreatedDate = "";
	        String formattedUpdatedDate = "";
	        String formattedInProgressTime = "";
	        
	        if (taskUser != null) {
	            if (taskUser.getCreatedDate() != null) {
	                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MMM dd, yyyy HH:mm");
	                formattedCreatedDate = taskUser.getCreatedDate().format(formatter);
	            }
	            
	            if (taskUser.getUpdatedDate() != null) {
	                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MMM dd, yyyy HH:mm");
	                formattedUpdatedDate = taskUser.getUpdatedDate().format(formatter);
	            }
	            
	            if (taskUser.getInProgressStartTime() != null) {
	                DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm");
	                formattedInProgressTime = taskUser.getInProgressStartTime().format(timeFormatter);
	            }
	        }
	        
	        model.addAttribute("taskUser", taskUser);
	        model.addAttribute("allUsers", allUsers);
	        model.addAttribute("projectList", projectList);
	        model.addAttribute("project", project);
	        model.addAttribute("moduleList", moduleList);
	        model.addAttribute("statusList", statusList);
	        model.addAttribute("formattedCreatedDate", formattedCreatedDate);
	        model.addAttribute("formattedUpdatedDate", formattedUpdatedDate);
	        model.addAttribute("formattedInProgressTime", formattedInProgressTime);
	        
	        return "ViewTaskDeveloper"; 
	    }

	    return "redirect:/taskListDeveloper";
	}
	
	@GetMapping("updateTaskStatusDeveloper/{taskUserId}")
	public String showUpdateTaskStatus(@PathVariable Integer taskUserId, Model model, HttpSession session) {
	    
	    UserEntity user = (UserEntity) session.getAttribute("dbuser");
	    
	    if (user == null) {
	        return "redirect:/login";
	    }
	    
	    // Get the task assignment
	    TaskUserEntity taskUser = taskUserRepository.findById(taskUserId).orElse(null);
	    
	    if (taskUser == null) {
	        return "redirect:/taskListDeveloper";
	    }
	    
	    // Verify this assignment belongs to the logged-in developer
	    if (!taskUser.getUserId().equals(user.getUserId())) {
	        return "redirect:/taskListDeveloper";
	    }
	    
	    // Get task details
	    TaskEntity task = taskRepository.findById(taskUser.getTaskId()).orElse(null);
	    
	    // Get project details
	    ProjectEntity project = null;
	    if (task != null) {
	        project = projectRepository.findById(task.getProjectId()).orElse(null);
	    }
	    
	    model.addAttribute("taskUser", taskUser);
	    model.addAttribute("task", task);
	    model.addAttribute("project", project);
	    
	    return "UpdateTaskStatusDeveloper";
	}

	  // =============== UPDATE STATUS POST ===============
    @PostMapping("updateTaskStatusDeveloper/{taskUserId}")
    public String updateTaskStatus(@PathVariable Integer taskUserId,
                                   @RequestParam("taskStatus") String taskStatus,
                                   @RequestParam(value = "comments", required = false) String comments,
                                   HttpSession session) {
        UserEntity user = (UserEntity) session.getAttribute("dbuser");
        if (user == null) return "redirect:/login";

        TaskUserEntity devTaskUser = taskUserRepository.findById(taskUserId).orElse(null);
        if (devTaskUser != null && devTaskUser.getUserId().equals(user.getUserId())) {
            String currentStatus = devTaskUser.getTaskStatus();
            LocalDateTime now = LocalDateTime.now();
            boolean isValidTransition = false;

            // Case 1: Assigned -> InProgress
            if ("Assigned".equals(currentStatus) && "InProgress".equals(taskStatus)) {
                devTaskUser.setInProgressStartTime(now);
                devTaskUser.setTaskStatus(taskStatus);
                isValidTransition = true;
                comments = "Started working on this task";
            }
            // Case 2: InProgress -> PendingTesting (Developer marks ready for testing)
            else if ("InProgress".equals(currentStatus) && "PendingTesting".equals(taskStatus)) {
                if (devTaskUser.getInProgressStartTime() != null) {
                    Duration duration = Duration.between(devTaskUser.getInProgressStartTime(), now);
                    long milliseconds = duration.toMillis();
                    double hoursWorked = milliseconds / (1000.0 * 60 * 60);
                    int hoursToAdd = (int) Math.round(hoursWorked);
                    if (hoursToAdd < 1 && hoursWorked > 0) hoursToAdd = 1;
                    int currentHours = devTaskUser.getUtilizedHours() != null ? devTaskUser.getUtilizedHours() : 0;
                    devTaskUser.setUtilizedHours(currentHours + hoursToAdd);
                    devTaskUser.setInProgressStartTime(null);
                    comments = String.format("Worked for %.1f hours. Ready for testing.", hoursWorked);
                }
                devTaskUser.setTaskStatus(taskStatus);
                isValidTransition = true;

                // Update TESTER's status to "PendingTesting"
                List<TaskUserEntity> allAssignments = taskUserRepository.findByTaskId(devTaskUser.getTaskId());
                for (TaskUserEntity assignment : allAssignments) {
                    UserEntity assignedUser = userRepository.findById(assignment.getUserId()).orElse(null);
                    if (assignedUser != null && "tester".equals(assignedUser.getRole())) {
                        assignment.setTaskStatus("PendingTesting");
                        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
                        String timestamp = now.format(formatter);
                        String testerComment = "[" + timestamp + "] Developer marked task as ready for testing.";
                        String existingTesterComments = assignment.getComments();
                        if (existingTesterComments == null || existingTesterComments.isEmpty()) {
                            assignment.setComments(testerComment);
                        } else {
                            assignment.setComments(existingTesterComments + "\n" + testerComment);
                        }
                        taskUserRepository.save(assignment);
                        break;
                    }
                }
            }
            // Case 3: Defect -> InProgress (fixing defect)
            else if ("Defect".equals(currentStatus) && "InProgress".equals(taskStatus)) {
                devTaskUser.setInProgressStartTime(now);
                devTaskUser.setTaskStatus(taskStatus);
                isValidTransition = true;
                comments = "Started fixing defect";
            }

            if (isValidTransition) {
                if (comments != null && !comments.trim().isEmpty()) {
                    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
                    String timestamp = now.format(formatter);
                    String newComment = "[" + timestamp + "] " + comments.trim();
                    String existingComments = devTaskUser.getComments();
                    if (existingComments == null || existingComments.isEmpty()) {
                        devTaskUser.setComments(newComment);
                    } else {
                        devTaskUser.setComments(existingComments + "\n" + newComment);
                    }
                }
                taskUserRepository.save(devTaskUser);

                // NEW: sync task and module status after update
                statusSyncService.syncTaskAndModuleStatus(devTaskUser.getTaskId());
            }
        }
        return "redirect:/taskListDeveloper";
    }
	
	// ==================== HELPER METHODS ====================
	
	// Helper method to get activity message
	private String getActivityMessage(String taskStatus) {
	    switch (taskStatus) {
	        case "Completed":
	            return "Task completed and ready for testing";
	        case "InProgress":
	            return "Started working on this task";
	        case "PendingTesting":
	            return "Task marked as ready for QA";
	        case "Defect":
	            return "Defect found, needs fixing";
	        case "Assigned":
	            return "Task assigned to you";
	        default:
	            return "Status updated";
	    }
	}
	
	// Helper method to calculate time ago
	private String getTimeAgo(LocalDateTime dateTime) {
	    if (dateTime == null) {
	        return "Recently";
	    }
	    
	    LocalDateTime now = LocalDateTime.now();
	    Duration duration = Duration.between(dateTime, now);
	    
	    long seconds = duration.getSeconds();
	    long minutes = seconds / 60;
	    long hours = minutes / 60;
	    long days = hours / 24;
	    
	    if (seconds < 60) {
	        return "Just now";
	    } else if (minutes < 60) {
	        return minutes + " minute" + (minutes != 1 ? "s" : "") + " ago";
	    } else if (hours < 24) {
	        return hours + " hour" + (hours != 1 ? "s" : "") + " ago";
	    } else if (days < 7) {
	        return days + " day" + (days != 1 ? "s" : "") + " ago";
	    } else {
	        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MMM dd");
	        return dateTime.format(formatter);
	    }
	}
}