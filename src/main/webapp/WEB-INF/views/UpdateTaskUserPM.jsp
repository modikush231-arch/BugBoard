<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="pageTitle" value="Update Assignment" scope="request" />
<c:set var="activeNav" value="taskUser" scope="request" />

<jsp:include page="ProjectManagerHeader.jsp" />
<jsp:include page="ProjectManagerSidebar.jsp" />

<main class="main-content" id="mainContent">
    <div class="mb-4">
        <a href="../taskUserListPM" class="text-decoration-none text-secondary">
            <i class="bi bi-arrow-left-circle me-1"></i> Back to Assignments
        </a>
    </div>
    
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="glass-card p-4">
                <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom border-secondary">
                    <h4 class="text-white">
                        <i class="bi bi-person-check me-2"></i>Update Assignment
                    </h4>
                    <span class="badge bg-primary">Assignment #${taskUser.taskUserId}</span>
                </div>
                
                <form action="../updateTaskUserPM" method="post">
                    <input type="hidden" name="taskUserId" value="${taskUser.taskUserId}">
                    
                    <div class="row g-4">
                        <div class="col-md-6">
                            <label class="form-label text-secondary">Task</label>
                            <input type="text" class="form-control bg-dark text-white border-secondary" 
                                   value="${taskTitle}" readonly>
                        </div>
                        
                        <div class="col-md-6">
                            <label class="form-label text-secondary">Assigned To</label>
                            <input type="text" class="form-control bg-dark text-white border-secondary" 
                                   value="${userName}" readonly>
                        </div>
                        
                        <div class="col-md-6">
                            <label class="form-label text-secondary">Role</label>
                            <input type="text" class="form-control bg-dark text-white border-secondary" 
                                   value="${userRole}" readonly>
                        </div>
                        
                        <div class="col-md-6">
                            <label class="form-label text-secondary">Task Status</label>
                            <select name="taskStatus" class="form-select bg-dark text-white border-secondary" required>
                                <option value="Assigned" ${taskUser.taskStatus == 'Assigned' ? 'selected' : ''}>Assigned</option>
                                <option value="InProgress" ${taskUser.taskStatus == 'InProgress' ? 'selected' : ''}>In Progress</option>
                                <option value="PendingTesting" ${taskUser.taskStatus == 'PendingTesting' ? 'selected' : ''}>Pending Testing</option>
                                <option value="Completed" ${taskUser.taskStatus == 'Completed' ? 'selected' : ''}>Completed</option>
                                <option value="Defect" ${taskUser.taskStatus == 'Defect' ? 'selected' : ''}>Defect</option>
                                <option value="Verified" ${taskUser.taskStatus == 'Verified' ? 'selected' : ''}>Verified</option>
                            </select>
                        </div>
                        
                        <div class="col-md-6">
                            <label class="form-label text-secondary">Assignment Status</label>
                            <select name="assignStatus" class="form-select bg-dark text-white border-secondary" required>
                                <option value="1" ${taskUser.assignStatus == 1 ? 'selected' : ''}>Assigned</option>
                                <option value="0" ${taskUser.assignStatus == 0 ? 'selected' : ''}>Revoked</option>
                            </select>
                        </div>
                        
                        <div class="col-md-6">
                            <label class="form-label text-secondary">Utilized Hours</label>
                            <input type="number" name="utilizedHours" 
                                   class="form-control bg-dark text-white border-secondary" 
                                   value="${taskUser.utilizedHours}" step="0.5" min="0">
                        </div>
                        
                        <div class="col-12">
                            <label class="form-label text-secondary">Comment</label>
                            <textarea name="comments" class="form-control bg-dark text-white border-secondary" 
                                      rows="3">${taskUser.comments}</textarea>
                        </div>
                    </div>
                    
                    <hr class="my-4 border-secondary">
                    <div class="d-flex justify-content-end gap-3">
                        <button type="submit" class="btn btn-success">
                            <i class="bi bi-check-circle me-2"></i>Update Assignment
                        </button>
                        <a href="../taskUserListPM" class="btn btn-secondary">
                            <i class="bi bi-x-circle me-2"></i>Cancel
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</main>

<jsp:include page="adminfooter.jsp" />