<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="pageTitle" value="Update Task" scope="request" />
<c:set var="activeNav" value="tasks" scope="request" />

<jsp:include page="adminheader.jsp" />
<jsp:include page="adminsidebar.jsp" />

<main class="main-content" id="mainContent">
    <div class="mb-4">
        <a href="javascript:history.back()" class="text-decoration-none text-secondary">
            <i class="bi bi-arrow-left-circle me-1"></i> Back to Tasks
        </a>
    </div>
    
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="glass-card p-4">
                <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom border-secondary">
                    <h4 class="text-white">
                        <i class="bi bi-pencil-square me-2"></i>Update Task
                    </h4>
                    <span class="badge bg-primary">Task #${task.taskId}</span>
                </div>
                
                <form action="../updateTask" method="post">
                    <input type="hidden" name="taskId" value="${task.taskId}">
                    
                    <div class="row g-4">
                        <div class="col-md-6">
                            <label class="form-label text-secondary">Task Name</label>
                            <input type="text" class="form-control bg-dark text-white border-secondary" 
                                   value="${task.title}" readonly>
                        </div>
                        
                        <div class="col-md-6">
                            <label class="form-label text-secondary">Project</label>
                            <input type="text" class="form-control bg-dark text-white border-secondary" 
                                   value="${projectName}" readonly>
                        </div>
                        
                        <div class="col-md-6">
                            <label class="form-label text-secondary">Module</label>
                            <input type="text" class="form-control bg-dark text-white border-secondary" 
                                   value="${moduleName}" readonly>
                        </div>
                        
                        <div class="col-md-6">
                            <label class="form-label text-secondary">Estimated Hours</label>
                            <input type="text" class="form-control bg-dark text-white border-secondary" 
                                   value="${task.estimatedHours} hrs" readonly>
                        </div>
                        
                        <div class="col-12">
                            <label class="form-label text-secondary">Description</label>
                            <textarea class="form-control bg-dark text-white border-secondary" 
                                      rows="3" readonly>${task.description}</textarea>
                        </div>
                        
                        <div class="col-md-6">
                            <label class="form-label text-secondary">Status *</label>
                            <select name="status" class="form-select bg-dark text-white border-secondary" required>
                                <option value="Assigned" ${task.status == 'Assigned' ? 'selected' : ''}>Assigned</option>
                                <option value="InProgress" ${task.status == 'InProgress' ? 'selected' : ''}>In Progress</option>
                                <option value="PendingTesting" ${task.status == 'PendingTesting' ? 'selected' : ''}>Pending Testing</option>
                                <option value="Completed" ${task.status == 'Completed' ? 'selected' : ''}>Completed</option>
                                <option value="Defect" ${task.status == 'Defect' ? 'selected' : ''}>Defect</option>
                            </select>
                        </div>
                        
                        <div class="col-md-6">
                            <label class="form-label text-secondary">Document URL</label>
                            <input type="url" name="docURL" class="form-control bg-dark text-white border-secondary" 
                                   value="${task.docURL}">
                        </div>
                    </div>
                    
                    <hr class="my-4 border-secondary">
                    <div class="d-flex justify-content-end gap-3">
                        <button type="submit" class="btn btn-success">
                            <i class="bi bi-check-circle me-2"></i>Update Task
                        </button>
                        <a href="../taskList" class="btn btn-secondary">
                            <i class="bi bi-x-circle me-2"></i>Cancel
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</main>

<jsp:include page="adminfooter.jsp" />