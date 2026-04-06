<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- Set page title and active sidebar item --%>
<c:set var="pageTitle" value="Task Management" scope="request" />
<c:set var="activeNav" value="tasks" scope="request" />

<%-- Include global header (opens <html>, <head>, navbar) --%>
<jsp:include page="adminheader.jsp" />

<%-- Include sidebar --%>
<jsp:include page="adminsidebar.jsp" />

    <%-- MAIN CONTENT (starts with .main-content) --%>
    <main class="main-content" id="mainContent">

        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1 class="h2 text-white mb-0">
                <i class="bi bi-list-task me-2" style="color: var(--primary-color);"></i>Task Management
            </h1>
            <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#taskModal">
                <i class="bi bi-plus-circle me-2"></i>Add New Task
            </button>
        </div>

        <!-- Search Box -->
        <div class="mb-4 d-flex justify-content-end">
            <div class="col-md-4">
                <div class="input-group">
                    <span class="input-group-text bg-transparent border-secondary text-secondary">
                        <i class="bi bi-search"></i>
                    </span>
                    <input type="text" id="searchInput" 
                           class="form-control bg-transparent text-white border-secondary"
                           placeholder="Search tasks..." 
                           onkeyup="filterTable()">
                </div>
            </div>
        </div>

        <!-- Task Table Card -->
        <div class="glass-card p-4">
            <div class="table-responsive">
                <table class="table table-hover mb-0" id="taskTable" style="--bs-table-bg: transparent;">
                    <thead>
                        <tr>
                            <th class="text-secondary">SrNo</th>
                            <th class="text-secondary">Task</th>
                            <th class="text-secondary">Module Name</th>                            
                            <th class="text-secondary">Project Name</th>                            
                            <th class="text-secondary">Description</th>
                            <th class="text-secondary">Doc URL</th>
                            <th class="text-secondary">Status</th>                            
                            <th class="text-secondary">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="task" items="${taskList}" varStatus="status">
                            <tr>
                                <td class="text-white">${status.index + 1}</td>
                                <td class="text-white fw-medium">${task.title}</td>
                                <td class="text-white fw-medium">
                                  <c:forEach var="moduleEntity" items="${moduleList}">								    
								        <c:if test="${moduleEntity.moduleId == task.moduleId}">								        
								            ${moduleEntity.moduleName}								            
								        </c:if>								        
								    </c:forEach>	
								</td>
                                <td class="text-white fw-medium">
								    <c:forEach var="title" items="${projectList}">
								        <c:if test="${title.projectId == task.projectId}">
								            ${title.title}
								        </c:if>
								    </c:forEach>
								</td>                                
                                <td class="text-white-50">${task.description}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty task.docURL}">
                                            <a href="${task.docURL}" target="_blank" 
                                               class="btn btn-sm btn-info text-white">
                                                <i class="bi bi-file-earmark-text me-1"></i>View Doc
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-secondary">N/A</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
							<td class="text-white fw-medium">
    <c:choose>
        <c:when test="${task.status == 'Assigned'}"><span class="badge bg-info">Assigned</span></c:when>
        <c:when test="${task.status == 'InProgress'}"><span class="badge bg-primary">In Progress</span></c:when>
        <c:when test="${task.status == 'PendingTesting'}"><span class="badge bg-warning text-dark">Pending Review</span></c:when>
        <c:when test="${task.status == 'Completed'}"><span class="badge bg-success">Completed</span></c:when>
        <c:when test="${task.status == 'Defect'}"><span class="badge bg-danger">Defect</span></c:when>
        <c:when test="${task.status == 'Verified'}"><span class="badge bg-success">Verified</span></c:when>
        <c:otherwise><span class="badge bg-secondary">${task.status}</span></c:otherwise>
    </c:choose>
</td>                               
                                <td>
                                    <div class="d-flex gap-2 justify-content">
                                        <a href="viewTask/${task.taskId}" 
                                           class="btn btn-sm btn-primary btn-custom">
                                            <i class="bi bi-eye"></i> View
                                        </a>
                                        <a href="editTask/${task.taskId}" 
                                           class="btn btn-sm btn-warning btn-custom">
                                            <i class="bi bi-pencil"></i> Update
                                        </a>
                                        <a href="deleteTask/${task.taskId}" 
                                           class="btn btn-sm btn-danger btn-custom"
                                           onclick="return confirm('Are you sure you want to delete this task?')">
                                            <i class="bi bi-trash"></i> Delete
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Add / Update Modal (Dark Theme) -->
        <div class="modal fade" id="taskModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content bg-dark text-white border-secondary">

                    <div class="modal-header border-secondary">
                           <h5 class="modal-title text-white fw-bold">
        <i class="bi bi-plus-square-fill me-2 text-success"></i>
        Add Task
    </h5>
                        <button type="button" class="btn-close btn-close-white" 
                                data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>

                    <form action="saveTask" method="post">
                        <div class="modal-body">
                            <div class="row g-3">

                                <div class="col-md-6">
                                    <label class="form-label text-secondary">Task</label>
                                    <input type="text" name="title" 
                                           class="form-control bg-transparent text-white border-secondary" required>
                                </div>

                                <div class="col-md-6">
								    <label class="form-label text-secondary">Module Name</label>								
								<select name="moduleId"
								        class="form-select bg-dark text-white border-secondary"
								        required>								
								    <option value="">Select Module Name</option>								
								    <c:forEach var="moduleName" items="${moduleList}">
								        <option value="${moduleName.moduleId}">
								            ${moduleName.moduleName}
								        </option>
								    </c:forEach>								
								</select>								
								</div>
                                
                                <div class="col-md-6">
								    <label class="form-label text-secondary">Project Name</label>								
								<select name="projectId"
								        class="form-select bg-dark text-white border-secondary"
								        required>								
								    <option value="">Select Project Name</option>								
								    <c:forEach var="title" items="${projectList}">
								        <option value="${title.projectId}">
								            ${title.title}
								        </option>
								    </c:forEach>								
								</select>								
								</div>
								
								<div class="col-md-6">
								    <label class="form-label text-secondary">Status</label>								
								    <select name="status" class="form-select bg-dark text-white border-secondary" required>								
								        <option value="">Select Status</option>								
								        <c:forEach var="statusEntity" items="${statusList}">
								            <option value="${statusEntity.projectStatusId}">
								                ${statusEntity.status}
								            </option>
								        </c:forEach>								
								    </select>								
								</div>

                                <div class="col-md-12">
                                    <label class="form-label text-secondary">Description</label>
                                    <textarea name="description" 
                                              class="form-control bg-transparent text-white border-secondary" 
                                              rows="3"></textarea>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label text-secondary">Document URL</label>
                                    <input type="url" name="docURL" 
                                           class="form-control bg-transparent text-white border-secondary">
                                </div>

								  <div class="col-md-6">
                                    <label class="form-label text-secondary">Estimated Hours</label>
                                    <input type="number" name="estimatedHours" class="form-control bg-transparent text-white border-secondary" required>
                                </div>
								
                            </div>
                        </div>

                        <div class="modal-footer border-secondary">
                            <button type="submit" class="btn btn-success">
                                <i class="bi bi-check-circle me-2"></i>Save Task
                            </button>
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                                <i class="bi bi-x-circle me-2"></i>Cancel
                            </button>
                        </div>
                    </form>

                </div>
            </div>
        </div>

    </main>

<%-- Include footer (closes .main-content, contains Bootstrap JS and common scripts) --%>
<jsp:include page="adminfooter.jsp" />

<%-- Page‑specific search filter script --%>
<script>
function filterTable() {
    const input = document.getElementById("searchInput").value.toLowerCase();
    const table = document.getElementById("taskTable");
    const rows = table.getElementsByTagName("tr");

    for (let i = 1; i < rows.length; i++) {
        const rowText = rows[i].innerText.toLowerCase();
        rows[i].style.display = rowText.indexOf(input) > -1 ? "" : "none";
    }
}
</script>

<%-- No duplicate CSS/JS – everything is provided by the global includes --%>