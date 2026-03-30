<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="pageTitle" value="Task Details - ${task.title}" scope="request" />
<c:set var="activeNav" value="tasks" scope="request" />

<jsp:include page="DeveloperHeader.jsp" />
<jsp:include page="DeveloperSidebar.jsp" />

<main class="main-content" id="mainContent">
    <!-- Back button -->
    <div class="mb-4">
        <a href="../taskListDeveloper" class="text-decoration-none text-secondary hover-text-primary">
            <i class="bi bi-arrow-left-circle me-1"></i> Back to Tasks
        </a>
    </div>

    <div class="row">
        <!-- Task Details Section -->
        <div class="col-lg-8 mb-4">
            <div class="glass-card p-4">
                <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom border-secondary">
                    <h4 class="mb-0 text-white">
                        <i class="bi bi-info-circle me-2" style="color: var(--primary-color);"></i>Task Details
                    </h4>
                    <span class="badge bg-primary-subtle text-primary border border-primary-subtle">
                        <i class="bi bi-hash me-1"></i>Task #${task.taskId}
                    </span>
                </div>

                <div class="row g-4">
                    <div class="col-md-6">
                        <label class="text-secondary small mb-1">Task Name</label>
                        <div class="text-white fw-bold fs-5">${task.title}</div>
                    </div>
                    <div class="col-md-6">
                        <label class="text-secondary small mb-1">Module</label>
                        <div class="text-white">
                            <c:forEach var="module" items="${moduleList}">
                                <c:if test="${module.moduleId == task.moduleId}">
                                    ${module.moduleName}
                                </c:if>
                            </c:forEach>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <label class="text-secondary small mb-1">Project</label>
                        <div class="text-white">
                            <c:forEach var="p" items="${projectList}">
                                <c:if test="${p.projectId == task.projectId}">
                                    ${p.title}
                                </c:if>
                            </c:forEach>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <label class="text-secondary small mb-1">Current Status</label>
                        <div>
                            <c:choose>
                                <c:when test="${taskUser.taskStatus == 'Assigned'}">
                                    <span class="badge bg-info fs-6 p-2">Assigned</span>
                                </c:when>
                                <c:when test="${taskUser.taskStatus == 'InProgress'}">
                                    <span class="badge bg-primary fs-6 p-2">In Progress</span>
                                </c:when>
                                <c:when test="${taskUser.taskStatus == 'PendingTesting'}">
                                    <span class="badge bg-warning text-dark fs-6 p-2">Pending Review</span>
                                </c:when>
                                <c:when test="${taskUser.taskStatus == 'Completed'}">
                                    <span class="badge bg-success fs-6 p-2">Completed</span>
                                </c:when>
                                <c:when test="${taskUser.taskStatus == 'Defect'}">
                                    <span class="badge bg-danger fs-6 p-2">Defect Found</span>
                                </c:when>
                            </c:choose>
                        </div>
                    </div>
                    <div class="col-12">
                        <label class="text-secondary small mb-1">Description</label>
                        <div class="bg-dark p-3 rounded border border-secondary">
                            <p class="text-white-50 mb-0">${task.description}</p>
                        </div>
                    </div>

                    <div class="col-12">
                        <hr class="border-secondary">
                        <div class="row">
                            <div class="col-md-6">
                                <label class="text-secondary small">
                                    <i class="bi bi-clock me-1"></i> Estimated Hours
                                </label>
                                <p class="text-white fw-bold">${task.estimatedHours} hrs</p>
                            </div>
                            <div class="col-md-6">
                                <label class="text-secondary small">
                                    <i class="bi bi-hourglass-split me-1"></i> Hours Worked
                                </label>
                                <p class="text-warning fw-bold">
                                    <c:choose>
                                        <c:when test="${not empty taskUser.utilizedHours}">
                                            <c:set var="totalMinutes" value="${taskUser.utilizedHours}" />
                                            <c:choose>
                                                <c:when test="${totalMinutes < 60}">
                                                    ${totalMinutes} minutes
                                                </c:when>
                                                <c:otherwise>
                                                    <fmt:formatNumber value="${totalMinutes / 60}" maxFractionDigits="1" /> hrs
                                                </c:otherwise>
                                            </c:choose>
                                        </c:when>
                                        <c:otherwise>0 hrs</c:otherwise>
                                    </c:choose>
                                </p>
                            </div>
                        </div>
                    </div>

                    <!-- Documentation -->
                    <div class="col-12">
                        <label class="text-secondary small mb-1">Documentation</label>
                        <div class="mt-2">
                            <c:choose>
                                <c:when test="${not empty task.docURL}">
                                    <a href="${task.docURL}" target="_blank" class="btn btn-outline-info btn-sm">
                                        <i class="bi bi-file-earmark-text me-1"></i> View Documentation
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <p class="text-secondary mb-0">No documentation provided</p>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Comments Section -->
            <div class="glass-card p-4 mt-4">
                <h5 class="text-white mb-3">
                    <i class="bi bi-chat-dots me-2" style="color: var(--primary-color);"></i>
                    Comments
                </h5>
                <div class="bg-dark p-3 rounded border border-secondary" style="max-height: 250px; overflow-y: auto;">
                    <c:choose>
                        <c:when test="${not empty taskUser.comments}">
                            <p class="text-white-50 small mb-0" style="white-space: pre-line;">
                                ${taskUser.comments}
                            </p>
                        </c:when>
                        <c:otherwise>
                            <p class="text-secondary small mb-0">No comments yet</p>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <!-- Assignment Details & Actions -->
        <div class="col-lg-4 mb-4">
            <!-- Assignment Card -->
            <div class="glass-card p-4">
                <h5 class="text-white mb-3">
                    <i class="bi bi-person-check me-2" style="color: var(--primary-color);"></i>
                    Assignment Details
                </h5>
                
                <c:choose>
                    <c:when test="${not empty taskUser}">
                        <div class="mb-3">
                            <label class="text-secondary small mb-1">Assigned To</label>
                            <p class="text-white fw-medium">${sessionScope.dbuser.first_name} ${sessionScope.dbuser.last_name}</p>
                        </div>
                        <div class="mb-3">
                            <label class="text-secondary small mb-1">Assignment Status</label>
                            <p>
                                <c:choose>
                                    <c:when test="${taskUser.assignStatus == 1}">
                                        <span class="badge bg-success">Active</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-danger">Revoked</span>
                                    </c:otherwise>
                                </c:choose>
                            </p>
                        </div>
                        <div class="mb-3">
                            <label class="text-secondary small mb-1">Created</label>
                            <p class="text-white">
                                <c:choose>
                                    <c:when test="${not empty formattedCreatedDate}">
                                        ${formattedCreatedDate}
                                    </c:when>
                                    <c:otherwise>Just now</c:otherwise>
                                </c:choose>
                            </p>
                        </div>
                        <div class="mb-3">
                            <label class="text-secondary small mb-1">Last Updated</label>
                            <p class="text-white">
                                <c:choose>
                                    <c:when test="${not empty formattedUpdatedDate}">
                                        ${formattedUpdatedDate}
                                    </c:when>
                                    <c:otherwise>Just now</c:otherwise>
                                </c:choose>
                            </p>
                        </div>
                        
                        <!-- Timer Status -->
                        <c:if test="${taskUser.taskStatus == 'InProgress' and not empty formattedInProgressTime}">
                            <div class="bg-dark p-2 rounded border border-secondary mt-3">
                                <div class="d-flex align-items-center">
                                    <i class="bi bi-play-circle-fill text-success me-2"></i>
                                    <div>
                                        <span class="text-secondary small">Timer started at</span>
                                        <p class="text-white mb-0">${formattedInProgressTime}</p>
                                    </div>
                                </div>
                            </div>
                        </c:if>
                    </c:when>
                    <c:otherwise>
                        <p class="text-secondary text-center">No assignment details available</p>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Action Buttons -->
            <div class="glass-card p-4 mt-4">
                <h5 class="text-white mb-3">
                    <i class="bi bi-gear me-2" style="color: var(--primary-color);"></i>
                    Actions
                </h5>
                <div class="d-grid gap-2">
                    <c:if test="${not empty taskUser}">
                        <c:choose>
                            <c:when test="${taskUser.taskStatus == 'Assigned'}">
                                <a href="${pageContext.request.contextPath}/updateTaskStatusDeveloper/${taskUser.taskUserId}" 
                                   class="btn btn-primary">
                                    <i class="bi bi-play-circle me-2"></i>Start Working
                                </a>
                            </c:when>
                            <c:when test="${taskUser.taskStatus == 'InProgress'}">
                                <a href="${pageContext.request.contextPath}/updateTaskStatusDeveloper/${taskUser.taskUserId}" 
                                   class="btn btn-warning">
                                    <i class="bi bi-check-circle me-2"></i>Mark as Ready for Review
                                </a>
                            </c:when>
                            <c:when test="${taskUser.taskStatus == 'Defect'}">
                                <a href="${pageContext.request.contextPath}/updateTaskStatusDeveloper/${taskUser.taskUserId}" 
                                   class="btn btn-danger">
                                    <i class="bi bi-bug me-2"></i>Fix Defect
                                </a>
                            </c:when>
                            <c:when test="${taskUser.taskStatus == 'PendingTesting'}">
                                <a href="#" class="btn btn-secondary disabled">
                                    <i class="bi bi-clock-history me-2"></i>Waiting for QA Review
                                </a>
                                <small class="text-secondary text-center mt-2">Task is with tester for verification</small>
                            </c:when>
                            <c:when test="${taskUser.taskStatus == 'Completed'}">
                                <a href="#" class="btn btn-success disabled">
                                    <i class="bi bi-check-circle me-2"></i>Task Completed
                                </a>
                                <small class="text-secondary text-center mt-2">Verified by tester</small>
                            </c:when>
                        </c:choose>
                    </c:if>
                    <a href="../taskListDeveloper" class="btn btn-secondary">
                        <i class="bi bi-arrow-left me-2"></i>Back to Tasks
                    </a>
                </div>
            </div>

            <!-- Tips Card -->
            <div class="glass-card p-4 mt-4">
                <h6 class="text-white mb-3">
                    <i class="bi bi-lightbulb me-2 text-warning"></i>Development Tips
                </h6>
                <ul class="text-secondary small mb-0">
                    <li>Click "Start Working" to begin tracking your time</li>
                    <li>Add comments to document your progress</li>
                    <li>Mark as "Ready for Review" when done</li>
                    <li>Fix defects promptly when reported by tester</li>
                </ul>
            </div>
        </div>
    </div>
</main>

<jsp:include page="DeveloperFooter.jsp" />