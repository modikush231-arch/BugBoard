package com.Grownited.entity;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name="taskUsers")
public class TaskUserEntity {
@Id
@GeneratedValue(strategy=GenerationType.IDENTITY)
private Integer taskUserId;
private Integer userId;
private Integer taskId;
private String assignStatus;
private Integer statusId;
private Integer utilizedHours;

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
public String getAssignStatus() {
	return assignStatus;
}
public void setAssignStatus(String assignStatus) {
	this.assignStatus = assignStatus;
}
public Integer getStatusId() {
	return statusId;
}
public void setStatusId(Integer statusId) {
	this.statusId = statusId;
}
public Integer getUtilizedHours() {
	return utilizedHours;
}
public void setUtilizedHours(Integer utilizedHours) {
	this.utilizedHours = utilizedHours;
}

}
