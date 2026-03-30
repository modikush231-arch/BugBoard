<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- Set page title and active sidebar item --%>
<c:set var="pageTitle" value="Task Details - ${task.title}" scope="request" />
<c:set var="activeNav" value="tasks" scope="request" />

<%-- Include global header (opens <html>, <head>, navbar) --%>
<jsp:include page="adminheader.jsp" />

<%-- Include sidebar --%>
<jsp:include page="adminsidebar.jsp" />

    <%-- MAIN CONTENT (starts with .main-content) --%>
    <main class="main-content" id="mainContent">

        <!-- Back button with icon -->
        <div class="mb-4">
            <a href="../taskList" class="text-decoration-none text-secondary hover-text-primary">
                <i class="bi bi-arrow-left-circle me-1"></i> Back to Task List
            </a>
        </div>

        <div class="row justify-content-center">
            <div class="col-lg-8">

                <!-- Task details card -->
                <div class="glass-card p-4">
                    <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom border-secondary">
                        <h4 class="mb-0 text-white">
                            <i class="bi bi-list-task me-2" style="color: var(--primary-color);"></i>Task Specifications
                        </h4>
                        <span class="badge bg-primary-subtle text-primary border border-primary-subtle status-badge">
                            ID: #${task.taskId}
                        </span>
                    </div>

                    <div class="row g-4">
                        <div class="col-md-6">
                            <label class="detail-label text-secondary">TASK TITLE</label>
                            <p class="detail-value text-white fw-bold fs-4">${task.title}</p>
                        </div>
                   <div class="col-md-6">
						    <label class="detail-label text-secondary">
						        <i class="bi bi-info-circle me-1"></i>Module NAME
						    </label>
						<p class="detail-value text-white">
						    <c:forEach var="moduleName" items="${moduleList}">
						        <c:if test="${moduleName.moduleId == task.moduleId}">
						            ${moduleName.moduleName}
						        </c:if>
						    </c:forEach>
						</p>
				    </div>
                	<div class="col-6">
						    <label class="detail-label text-secondary">
						        <i class="bi bi-info-circle me-1"></i> PROJECT NAME
						    </label>
						<p class="detail-value text-white">
						    <c:forEach var="title" items="${projectList}">
						        <c:if test="${title.projectId == task.projectId}">
						            ${title.title}
						        </c:if>
						    </c:forEach>
						</p>
						</div>
						  	<div class="col-md-6">
						    <label class="detail-label text-secondary">
						        <i class="bi bi-info-circle me-1"></i> Status
						    </label>
						<p class="detail-value text-white">
						    <c:forEach var="statusEntity" items="${statusList}">								    
								        <c:if test="${statusEntity.projectStatusId == task.status}">								        
								            ${statusEntity.status}								            
								        </c:if>								        
								    </c:forEach>
						</p>
						</div>
                        
                        <div class="col-md-6">
                            <label class="detail-label text-secondary">DESCRIPTION</label>
                            <p class="detail-value text-white-50">${task.description}</p>
                        </div>

                        <hr class="my-2 border-secondary">

                        <div class="col-md-6">
                            <label class="detail-label text-secondary">
                                <i class="bi bi-clock me-1"></i> ESTIMATED HOURS
                            </label>
                            <p class="detail-value text-white">${task.estimatedHours} hrs</p>
                        </div>
                        <div class="col-md-6">
                            <label class="detail-label text-secondary">
                                <i class="bi bi-hourglass-split me-1"></i> UTILIZED HOURS
                            </label>
                            <p class="detail-value text-warning fw-semibold">${task.totalUtilizedHours} hrs</p>
                        </div>

                        <div class="col-12 mt-3">
                            <label class="detail-label text-secondary">DOCUMENTATION</label>
                            <div class="mt-2">
                                <c:choose>
                                    <c:when test="${not empty task.docURL}">
                                        <a href="${task.docURL}" target="_blank" 
                                           class="btn btn-outline-info btn-sm px-3">
                                            <i class="bi bi-file-earmark-text me-1"></i> Open Document Link
                                        </a>
                                    </c:when>
                                    <c:otherwise>
                                        <p class="text-secondary mb-0">No documentation provided.</p>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>

                    <hr class="my-4 border-secondary">

                    <!-- Action buttons -->
                    <div class="d-flex justify-content-end gap-3">
                        <a href="editTask/${task.taskId}" class="btn btn-warning px-4">
                            <i class="bi bi-pencil-square me-1"></i> Edit
                        </a>
                        <button class="btn btn-outline-danger px-4" onclick="confirmDelete()">
                            <i class="bi bi-trash me-1"></i> Delete
                        </button>
                    </div>
                </div>
            </div>
        </div>

    </main>

<%-- Include footer (closes .main-content, contains Bootstrap JS and common scripts) --%>
<jsp:include page="adminfooter.jsp" />

<%-- Page‑specific delete confirmation script --%>
<script>
    function confirmDelete() {
        if (confirm("Are you sure you want to remove this task permanently?")) {
            window.location.href = "../deleteTask/${task.taskId}";
        }
    }
</script>

<%-- No duplicate CSS/JS – everything is provided by the global includes --%>