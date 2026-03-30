package com.Grownited.entity;

import java.time.LocalDateTime;
import jakarta.persistence.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

@Entity
@Table(name = "taskUsers")
public class TaskUserEntity {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer taskUserId;
    
    private Integer userId;
    private Integer taskId;
    private Integer assignStatus;
    
    @Column(length = 5000)
    private String comments;
    
    private String taskStatus;
    private Integer utilizedHours;
    
    // Developer timer
    private LocalDateTime inProgressStartTime;
    
    // ✅ NEW: Tester timer fields
    private LocalDateTime testingStartTime;
    private LocalDateTime testingEndTime;
    
    // Track total time in seconds for accuracy
    private Long totalTimeSeconds;
    
    @CreationTimestamp
    @Column(name = "created_date", updatable = false)
    private LocalDateTime createdDate;
    
    @UpdateTimestamp
    @Column(name = "updated_date")
    private LocalDateTime updatedDate;

    // Getters and Setters
    public Integer getTaskUserId() {
        return taskUserId;
    }
    public void setTaskUserId(Integer taskUserId) {
        this.taskUserId = taskUserId;
    }
    
    public Integer getUserId() {
        return userId;
    }
    public void setUserId(Integer userId) {
        this.userId = userId;
    }
    
    public Integer getTaskId() {
        return taskId;
    }
    public void setTaskId(Integer taskId) {
        this.taskId = taskId;
    }
    
    public Integer getAssignStatus() {
        return assignStatus;
    }
    public void setAssignStatus(Integer assignStatus) {
        this.assignStatus = assignStatus;
    }
    
    public String getComments() {
        return comments;
    }
    public void setComments(String comments) {
        this.comments = comments;
    }
    
    public String getTaskStatus() {
        return taskStatus;
    }
    public void setTaskStatus(String taskStatus) {
        this.taskStatus = taskStatus;
    }
    
    public Integer getUtilizedHours() {
        return utilizedHours;
    }
    public void setUtilizedHours(Integer utilizedHours) {
        this.utilizedHours = utilizedHours;
    }
    
    // Developer timer getter/setter
    public LocalDateTime getInProgressStartTime() {
        return inProgressStartTime;
    }
    public void setInProgressStartTime(LocalDateTime inProgressStartTime) {
        this.inProgressStartTime = inProgressStartTime;
    }
    
    // ✅ NEW: Tester timer getters/setters
    public LocalDateTime getTestingStartTime() {
        return testingStartTime;
    }
    public void setTestingStartTime(LocalDateTime testingStartTime) {
        this.testingStartTime = testingStartTime;
    }
    
    public LocalDateTime getTestingEndTime() {
        return testingEndTime;
    }
    public void setTestingEndTime(LocalDateTime testingEndTime) {
        this.testingEndTime = testingEndTime;
    }
    
    public Long getTotalTimeSeconds() {
        return totalTimeSeconds;
    }
    public void setTotalTimeSeconds(Long totalTimeSeconds) {
        this.totalTimeSeconds = totalTimeSeconds;
    }
    
    public LocalDateTime getCreatedDate() {
        return createdDate;
    }
    public void setCreatedDate(LocalDateTime createdDate) {
        this.createdDate = createdDate;
    }
    
    public LocalDateTime getUpdatedDate() {
        return updatedDate;
    }
    public void setUpdatedDate(LocalDateTime updatedDate) {
        this.updatedDate = updatedDate;
    }
}