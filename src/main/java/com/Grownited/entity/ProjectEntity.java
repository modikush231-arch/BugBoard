package com.Grownited.entity;

import java.time.LocalDate;
import java.util.List;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.persistence.Transient;

@Entity
@Table(name = "projects")
public class ProjectEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer projectId;
    
    private String title;
    private String description;
    private Integer projectStatusId;
    private String docURL;
    private Integer estimatedHours;
    private Integer totalUtilizedHours;
    private LocalDate projectStartDate;
    private LocalDate projectCompletionDate;
    
    // Transient fields for UI display
    @Transient
    private Integer progress;
    
    @Transient
    private Integer taskCount;
    
    @Transient
    private Integer moduleCount;
    
    // Getters and Setters
    public Integer getProjectId() {
        return projectId;
    }
    public void setProjectId(Integer projectId) {
        this.projectId = projectId;
    }
    public String getTitle() {
        return title;
    }
    public void setTitle(String title) {
        this.title = title;
    }
    public String getDescription() {
        return description;
    }
    public void setDescription(String description) {
        this.description = description;
    }
    public Integer getProjectStatusId() {
        return projectStatusId;
    }
    public void setProjectStatusId(Integer projectStatusId) {
        this.projectStatusId = projectStatusId;
    }
    public String getDocURL() {
        return docURL;
    }
    public void setDocURL(String docURL) {
        this.docURL = docURL;
    }
    public Integer getEstimatedHours() {
        return estimatedHours;
    }
    public void setEstimatedHours(Integer estimatedHours) {
        this.estimatedHours = estimatedHours;
    }
    public Integer getTotalUtilizedHours() {
        return totalUtilizedHours;
    }
    public void setTotalUtilizedHours(Integer totalUtilizedHours) {
        this.totalUtilizedHours = totalUtilizedHours;
    }
    public LocalDate getProjectStartDate() {
        return projectStartDate;
    }
    public void setProjectStartDate(LocalDate projectStartDate) {
        this.projectStartDate = projectStartDate;
    }
    public LocalDate getProjectCompletionDate() {
        return projectCompletionDate;
    }
    public void setProjectCompletionDate(LocalDate projectCompletionDate) {
        this.projectCompletionDate = projectCompletionDate;
    }
    public Integer getProgress() {
        return progress;
    }
    public void setProgress(Integer progress) {
        this.progress = progress;
    }
    public Integer getTaskCount() {
        return taskCount;
    }
    public void setTaskCount(Integer taskCount) {
        this.taskCount = taskCount;
    }
    public Integer getModuleCount() {
        return moduleCount;
    }
    public void setModuleCount(Integer moduleCount) {
        this.moduleCount = moduleCount;
    }
}