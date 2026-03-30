package com.Grownited.controller;

import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.Duration;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.Grownited.entity.ProjectEntity;
import com.Grownited.entity.TaskEntity;
import com.Grownited.entity.TaskUserEntity;
import com.Grownited.entity.UserEntity;
import com.Grownited.repository.ProjectRepository;
import com.Grownited.repository.TaskRepository;
import com.Grownited.repository.TaskUserRepository;
import com.Grownited.repository.UserRepository;

import jakarta.servlet.http.HttpSession;

@Controller
public class TesterController {

    @Autowired
    private TaskUserRepository taskUserRepository;
    
    @Autowired
    private TaskRepository taskRepository;
    
    @Autowired
    private ProjectRepository projectRepository;
    
    @Autowired
    private UserRepository userRepository;

    @GetMapping("/TesterDashboard")
    public String testerDashboard(Model model, HttpSession session) {
        UserEntity user = (UserEntity) session.getAttribute("dbuser");
        
        if (user == null) {
            return "redirect:/login";
        }
        
        Integer testerId = user.getUserId();
        
        List<TaskUserEntity> taskUserList = taskUserRepository.findByUserId(testerId);
        List<Integer> taskIds = taskUserList.stream()
                .map(TaskUserEntity::getTaskId)
                .toList();
        
        List<TaskEntity> taskList = taskRepository.findByTaskIdIn(taskIds);
        
        List<Integer> projectIds = taskList.stream()
                .map(TaskEntity::getProjectId)
                .distinct()
                .toList();
        
        List<ProjectEntity> projects = projectRepository.findByProjectIdIn(projectIds);
        
        long totalProjects = projectIds.size();
        long pendingTestingCount = taskUserList.stream()
                .filter(tu -> "PendingTesting".equals(tu.getTaskStatus()))
                .count();
        long verifiedCount = taskUserList.stream()
                .filter(tu -> "Verified".equals(tu.getTaskStatus()))
                .count();
        long defectCount = taskUserList.stream()
                .filter(tu -> "Defect".equals(tu.getTaskStatus()))
                .count();
        
        // ✅ Calculate Average Test Time (in minutes)
        double avgTestTime = 0;
        int totalCompletedTasks = 0;
        int totalTestMinutes = 0;
        
        // Only count tasks that have been tested (Verified or Defect)
        List<TaskUserEntity> testedTasks = taskUserList.stream()
                .filter(tu -> "Verified".equals(tu.getTaskStatus()) || "Defect".equals(tu.getTaskStatus()))
                .toList();
        
        totalCompletedTasks = testedTasks.size();
        
        for (TaskUserEntity tu : testedTasks) {
            if (tu.getUtilizedHours() != null && tu.getUtilizedHours() > 0) {
                totalTestMinutes += tu.getUtilizedHours();
            }
        }
        
        if (totalCompletedTasks > 0) {
            avgTestTime = (double) totalTestMinutes / totalCompletedTasks;
        }
        
        // Format avg test time for display
        String formattedAvgTestTime = "";
        if (avgTestTime < 60) {
            formattedAvgTestTime = Math.round(avgTestTime) + " min";
        } else {
            double hours = avgTestTime / 60;
            formattedAvgTestTime = String.format("%.1f", hours) + " hr";
        }
        
     // Total tasks assigned to tester
        int totalTasks = (int) (pendingTestingCount + verifiedCount + defectCount);

        // Tasks that have been tested (completed testing)
        int testedCount = (int) (verifiedCount + defectCount);

        // Test coverage percentage
        int testCoverage = totalTasks > 0 ? (testedCount * 100 / totalTasks) : 0;
        
        // ✅ Get recent defects for defect summary card
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
                defect.put("taskUserId", tu.getTaskUserId());
                defect.put("taskTitle", task.getTitle());
                // Get the latest comment (last line)
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
                
                String timeAgo = getTimeAgo(tu.getUpdatedDate());
                activity.put("timeAgo", timeAgo);
                
                String activityMessage = getActivityMessage(tu.getTaskStatus());
                activity.put("activityMessage", activityMessage);
                
                recentActivities.add(activity);
            }
        }
        
        // Get pending tasks with developer names
        List<Map<String, Object>> pendingTasks = new ArrayList<>();
        for (TaskUserEntity tu : taskUserList) {
            if ("PendingTesting".equals(tu.getTaskStatus())) {
                Map<String, Object> taskMap = new HashMap<>();
                TaskEntity task = taskRepository.findById(tu.getTaskId()).orElse(null);
                if (task != null) {
                    taskMap.put("taskUserId", tu.getTaskUserId());
                    taskMap.put("taskTitle", task.getTitle());
                    
                    ProjectEntity project = projectRepository.findById(task.getProjectId()).orElse(null);
                    taskMap.put("projectName", project != null ? project.getTitle() : "N/A");
                    
                    // Get developer name
                    List<TaskUserEntity> allAssignments = taskUserRepository.findByTaskId(task.getTaskId());
                    String developerName = "Not assigned";
                    for (TaskUserEntity assignment : allAssignments) {
                        UserEntity assignedUser = userRepository.findById(assignment.getUserId()).orElse(null);
                        if (assignedUser != null && "developer".equals(assignedUser.getRole())) {
                            developerName = assignedUser.getFirst_name() + " " + assignedUser.getLast_name();
                            break;
                        }
                    }
                    taskMap.put("developerName", developerName);
                    
                    pendingTasks.add(taskMap);
                }
            }
        }
        
        model.addAttribute("totalProjects", totalProjects);
        model.addAttribute("pendingTestingCount", pendingTestingCount);
        model.addAttribute("verifiedCount", verifiedCount);
        model.addAttribute("defectCount", defectCount);
        model.addAttribute("avgTestTime", formattedAvgTestTime);
        model.addAttribute("testCoverage", testCoverage);
        model.addAttribute("recentActivities", recentActivities);
        model.addAttribute("pendingTasks", pendingTasks);
        model.addAttribute("recentDefects", recentDefects);
        
        return "TesterDashboard";
    }

    // Helper method to get meaningful activity message
    private String getActivityMessage(String taskStatus) {
        switch (taskStatus) {
            case "Verified":
                return "Task verified and marked as complete";
            case "Defect":
                return "Defect reported, needs fixing";
            case "PendingTesting":
                return "Task is ready for testing";
            case "InProgress":
                return "Developer is working on this task";
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
    
    @GetMapping("/taskTester")
    public String taskTester(Model model, HttpSession session,
                             @RequestParam(value = "status", required = false, defaultValue = "all") String statusFilter,
                             @RequestParam(value = "page", required = false, defaultValue = "1") int page,
                             @RequestParam(value = "size", required = false, defaultValue = "10") int size) {
        
        UserEntity user = (UserEntity) session.getAttribute("dbuser");
        
        if (user == null) {
            return "redirect:/login";
        }
        
        Integer testerId = user.getUserId();
        
        // Get ALL tester's assignments
        List<TaskUserEntity> allTesterAssignments = taskUserRepository.findByUserId(testerId);
        
        // Get all task IDs from tester's assignments
        List<Integer> taskIds = allTesterAssignments.stream()
                .map(TaskUserEntity::getTaskId)
                .distinct()
                .toList();
        
        // Get ALL developer assignments for these tasks
        List<TaskUserEntity> allDeveloperAssignments = new ArrayList<>();
        for (Integer taskId : taskIds) {
            List<TaskUserEntity> taskAssignments = taskUserRepository.findByTaskId(taskId);
            for (TaskUserEntity assignment : taskAssignments) {
                UserEntity assignedUser = userRepository.findById(assignment.getUserId()).orElse(null);
                if (assignedUser != null && "developer".equals(assignedUser.getRole())) {
                    allDeveloperAssignments.add(assignment);
                }
            }
        }
        
        // Create a map for quick developer lookup by taskId
        Map<Integer, TaskUserEntity> developerAssignmentMap = new HashMap<>();
        for (TaskUserEntity devAssignment : allDeveloperAssignments) {
            developerAssignmentMap.put(devAssignment.getTaskId(), devAssignment);
        }
        
        // Apply filter to tester assignments
        List<TaskUserEntity> filteredTasks = allTesterAssignments;
        if (!"all".equals(statusFilter) && statusFilter != null) {
            filteredTasks = allTesterAssignments.stream()
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
        
        List<TaskUserEntity> taskUserList = filteredTasks.subList(start, end);
        
        // Get task IDs for current page
        List<Integer> currentTaskIds = taskUserList.stream()
                .map(TaskUserEntity::getTaskId)
                .toList();
        
        // Get tasks
        List<TaskEntity> taskList = taskRepository.findByTaskIdIn(currentTaskIds);
        
        // Get project IDs
        List<Integer> projectIds = taskList.stream()
                .map(TaskEntity::getProjectId)
                .distinct()
                .toList();
        
        List<ProjectEntity> projectList = projectRepository.findByProjectIdIn(projectIds);
        List<UserEntity> allUsers = userRepository.findAll();
        
        // Format dates
        Map<Integer, String> formattedDates = new HashMap<>();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MMM dd, HH:mm");
        
        for (TaskUserEntity tu : allTesterAssignments) {
            if (tu.getUpdatedDate() != null) {
                formattedDates.put(tu.getTaskUserId(), tu.getUpdatedDate().format(formatter));
            } else {
                formattedDates.put(tu.getTaskUserId(), "-");
            }
        }
        
        // Counts for filter cards
        long totalCount = allTesterAssignments.size();
        long pendingCount = allTesterAssignments.stream()
                .filter(tu -> "PendingTesting".equals(tu.getTaskStatus()))
                .count();
        long verifiedCount = allTesterAssignments.stream()
                .filter(tu -> "Verified".equals(tu.getTaskStatus()))
                .count();
        long defectCount = allTesterAssignments.stream()
                .filter(tu -> "Defect".equals(tu.getTaskStatus()))
                .count();
        
        model.addAttribute("taskUserList", taskUserList);
        model.addAttribute("developerAssignmentMap", developerAssignmentMap);
        model.addAttribute("taskList", taskList);
        model.addAttribute("projectList", projectList);
        model.addAttribute("allUsers", allUsers);
        model.addAttribute("formattedDates", formattedDates);
        model.addAttribute("totalCount", totalCount);
        model.addAttribute("pendingCount", pendingCount);
        model.addAttribute("verifiedCount", verifiedCount);
        model.addAttribute("defectCount", defectCount);
        model.addAttribute("statusFilter", statusFilter);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("pageSize", size);
        model.addAttribute("totalItems", totalItems);
        
        return "TaskTester";
    }
    
    @GetMapping("/viewTaskTester/{taskUserId}")
    public String viewTaskTester(@PathVariable Integer taskUserId, Model model, HttpSession session) {
        
        UserEntity user = (UserEntity) session.getAttribute("dbuser");
        
        if (user == null) {
            return "redirect:/login";
        }
        
        TaskUserEntity taskUser = taskUserRepository.findById(taskUserId).orElse(null);
        
        if (taskUser == null) {
            return "redirect:/taskTester";
        }
        
        if (!taskUser.getUserId().equals(user.getUserId())) {
            return "redirect:/taskTester";
        }
        
        TaskEntity task = taskRepository.findById(taskUser.getTaskId()).orElse(null);
        
        ProjectEntity project = null;
        if (task != null) {
            project = projectRepository.findById(task.getProjectId()).orElse(null);
        }
        
        List<UserEntity> allUsers = userRepository.findAll();
        List<TaskUserEntity> allTaskAssignmentsForThisTask = taskUserRepository.findByTaskId(task.getTaskId());
        
        // Format dates in controller (NOT in JSP)
        DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("MMM dd, yyyy HH:mm");
        DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm:ss");
        
        String formattedUpdatedDate = "";
        if (taskUser.getUpdatedDate() != null) {
            formattedUpdatedDate = taskUser.getUpdatedDate().format(dateFormatter);
        }
        
        // Format testing start time
        String formattedTestingStartTime = "";
        if (taskUser.getTestingStartTime() != null) {
            formattedTestingStartTime = taskUser.getTestingStartTime().format(timeFormatter);
        }
        
        // Calculate current testing duration
        String currentTestDuration = "";
        if (taskUser.getTestingStartTime() != null && "PendingTesting".equals(taskUser.getTaskStatus())) {
            Duration duration = Duration.between(taskUser.getTestingStartTime(), LocalDateTime.now());
            long minutes = duration.toMinutes();
            if (minutes < 60) {
                currentTestDuration = minutes + " minute" + (minutes != 1 ? "s" : "");
            } else {
                double hours = minutes / 60.0;
                currentTestDuration = String.format("%.1f", hours) + " hours";
            }
        }
        
        model.addAttribute("taskUser", taskUser);
        model.addAttribute("task", task);
        model.addAttribute("project", project);
        model.addAttribute("allUsers", allUsers);
        model.addAttribute("taskUserList", allTaskAssignmentsForThisTask);
        model.addAttribute("formattedUpdatedDate", formattedUpdatedDate);
        model.addAttribute("formattedTestingStartTime", formattedTestingStartTime);
        model.addAttribute("currentTestDuration", currentTestDuration);
        
        return "ViewTaskTester";
    }
    
    @PostMapping("/updateTestTaskStatus/{taskUserId}")
    public String updateTestTaskStatus(@PathVariable Integer taskUserId,
                                       @RequestParam("taskStatus") String taskStatus,
                                       @RequestParam(value = "comments", required = false) String comments,
                                       HttpSession session) {
        
        UserEntity user = (UserEntity) session.getAttribute("dbuser");
        
        if (user == null) {
            return "redirect:/login";
        }
        
        TaskUserEntity testerTaskUser = taskUserRepository.findById(taskUserId).orElse(null);
        
        if (testerTaskUser != null && testerTaskUser.getUserId().equals(user.getUserId())) {
            
            if ("Verified".equals(taskStatus) || "Defect".equals(taskStatus)) {
                
                String timestamp = new SimpleDateFormat("yyyy-MM-dd HH:mm").format(new Date());
                
                // Calculate hours with decimal precision
                double hoursSpent = 0;
                if (testerTaskUser.getTestingStartTime() != null) {
                    LocalDateTime now = LocalDateTime.now();
                    Duration duration = Duration.between(testerTaskUser.getTestingStartTime(), now);
                    long milliseconds = duration.toMillis();
                    hoursSpent = milliseconds / (1000.0 * 60 * 60);
                    
                    // Only add if there's any time spent
                    if (milliseconds > 0) {
                        int currentMinutes = testerTaskUser.getUtilizedHours() != null ? testerTaskUser.getUtilizedHours() : 0;
                        int minutesToAdd = (int) Math.round(milliseconds / (1000.0 * 60));
                        testerTaskUser.setUtilizedHours(currentMinutes + minutesToAdd);
                    }
                    
                    // Clear test timer
                    testerTaskUser.setTestingStartTime(null);
                    testerTaskUser.setTestingEndTime(LocalDateTime.now());
                }
                
                // 1. Update TESTER's assignment
                testerTaskUser.setTaskStatus(taskStatus);
                
                if (comments != null && !comments.trim().isEmpty()) {
                    // Format hours spent for display
                    String timeInfo = "";
                    if (hoursSpent > 0) {
                        if (hoursSpent < 1) {
                            int minutes = (int) Math.round(hoursSpent * 60);
                            timeInfo = String.format(" (Testing took %d minute%s)", minutes, minutes != 1 ? "s" : "");
                        } else {
                            timeInfo = String.format(" (Testing took %.1f hours)", hoursSpent);
                        }
                    }
                    String newComment = "[" + timestamp + "] TESTER: " + comments.trim() + timeInfo;
                    
                    String existingComments = testerTaskUser.getComments();
                    if (existingComments == null || existingComments.isEmpty()) {
                        testerTaskUser.setComments(newComment);
                    } else {
                        testerTaskUser.setComments(existingComments + "\n" + newComment);
                    }
                }
                
                taskUserRepository.save(testerTaskUser);
                
                // 2. Update DEVELOPER's assignment
                List<TaskUserEntity> allTaskAssignments = taskUserRepository.findByTaskId(testerTaskUser.getTaskId());
                
                for (TaskUserEntity assignment : allTaskAssignments) {
                    UserEntity assignedUser = userRepository.findById(assignment.getUserId()).orElse(null);
                    
                    if (assignedUser != null && "developer".equals(assignedUser.getRole())) {
                        
                        if ("Defect".equals(taskStatus)) {
                            assignment.setTaskStatus("Defect");
                            
                            String timeInfo = "";
                            if (hoursSpent > 0) {
                                if (hoursSpent < 1) {
                                    int minutes = (int) Math.round(hoursSpent * 60);
                                    timeInfo = String.format(" Testing took %d minute%s.", minutes, minutes != 1 ? "s" : "");
                                } else {
                                    timeInfo = String.format(" Testing took %.1f hours.", hoursSpent);
                                }
                            }
                            String devComment = "[" + timestamp + "] Defect found by tester." + timeInfo + " " + (comments != null ? comments.trim() : "");
                            String devExistingComments = assignment.getComments();
                            if (devExistingComments == null || devExistingComments.isEmpty()) {
                                assignment.setComments(devComment);
                            } else {
                                assignment.setComments(devExistingComments + "\n" + devComment);
                            }
                            
                            taskUserRepository.save(assignment);
                        } 
                        else if ("Verified".equals(taskStatus)) {
                            assignment.setTaskStatus("Completed");
                            
                            String timeInfo = "";
                            if (hoursSpent > 0) {
                                if (hoursSpent < 1) {
                                    int minutes = (int) Math.round(hoursSpent * 60);
                                    timeInfo = String.format(" Testing took %d minute%s.", minutes, minutes != 1 ? "s" : "");
                                } else {
                                    timeInfo = String.format(" Testing took %.1f hours.", hoursSpent);
                                }
                            }
                            String devComment = "[" + timestamp + "] Task verified by tester!" + timeInfo;
                            String devExistingComments = assignment.getComments();
                            if (devExistingComments == null || devExistingComments.isEmpty()) {
                                assignment.setComments(devComment);
                            } else {
                                assignment.setComments(devExistingComments + "\n" + devComment);
                            }
                            
                            taskUserRepository.save(assignment);
                        }
                        break;
                    }
                }
            }
        }
        
        return "redirect:/taskTester";
    }
    
    @PostMapping("/startTesting/{taskUserId}")
    public String startTesting(@PathVariable Integer taskUserId, HttpSession session) {
        
        UserEntity user = (UserEntity) session.getAttribute("dbuser");
        
        if (user == null) {
            return "redirect:/login";
        }
        
        TaskUserEntity taskUser = taskUserRepository.findById(taskUserId).orElse(null);
        
        if (taskUser != null && taskUser.getUserId().equals(user.getUserId())) {
            if ("PendingTesting".equals(taskUser.getTaskStatus()) && taskUser.getTestingStartTime() == null) {
                taskUser.setTestingStartTime(LocalDateTime.now());
                taskUserRepository.save(taskUser);
                System.out.println("✅ Testing started for task: " + taskUser.getTaskId());
            }
        }
        
        return "redirect:/viewTaskTester/" + taskUserId;
    }
}