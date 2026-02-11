package com.Grownited.entity;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name="projectUsers")
public class ProjectUserEntity {

	@Id
	@GeneratedValue(strategy=GenerationType.IDENTITY)
	private Integer projectUserId;
	private Integer userId;
	private Integer projectId;
	private String assignStatus;
	public Integer getProjectUserId() {
		return projectUserId;
	}
	public void setProjectUserId(Integer projectUserId) {
		this.projectUserId = projectUserId;
	}
	public Integer getUserId() {
		return userId;
	}
	public void setUserId(Integer userId) {
		this.userId = userId;
	}
	public Integer getProjectId() {
		return projectId;
	}
	public void setProjectId(Integer projectId) {
		this.projectId = projectId;
	}
	public String getAssignStatus() {
		return assignStatus;
	}
	public void setAssignStatus(String assignStatus) {
		this.assignStatus = assignStatus;
	}

}
