<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="Task Assignment Details" scope="request" />
<c:set var="activeNav" value="taskUser" scope="request" />

<jsp:include page="DeveloperHeader.jsp" />
<jsp:include page="DeveloperSidebar.jsp" />

<main class="main-content" id="mainContent">
    <!-- Back button -->
    <div class="mb-4">
        <a href="javascript:history.back()" class="text-decoration-none text-secondary hover-text-primary">
            <i class="bi bi-arrow-left-circle me-1"></i> Back to Assignments
        </a>
    </div>

    <div class="row">
        <!-- Main Details Card -->
        <div class="col-lg-8 mb-4">
            <div class="glass-card p-4">
                <!-- Header -->
                <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom border-secondary">
                    <h4 class="mb-0 text-white">
                        <i class="bi bi-person-check me-2" style="color: var(--primary-color);"></i>Assignment Details
                    </h4>
                    <span class="badge bg-primary-subtle text-primary border border-primary-subtle">
                        ID: #${taskUser.taskUserId}
                    </span>
                </div>

                <!-- Task Information -->
                <div class="row g-4">
                    <div class="col-md-6">
                        <label class="text-secondary small mb-1">TASK NAME</label>
                        <div class="text-white fw-medium fs-5">
                            <c:out value="${task.title}" default="N/A" />
                        </div>
                    </div>

                    <div class="col-md-6">
                        <label class="text-secondary small mb-1">PROJECT NAME</label>
                        <div class="text-white">
                            <c:out value="${project.title}" default="N/A" />
                        </div>
                    </div>

                    <div class="col-md-6">
                        <label class="text-secondary small mb-1">ASSIGNED TO</label>
                        <div class="text-white">
                            <c:set var="foundUser" value="false" />
                            <c:forEach var="user" items="${allUsers}">
                                <c:if test="${user.userId == taskUser.userId}">
                                    <c:set var="foundUser" value="true" />
                                    <span class="fw-medium">${user.first_name} ${user.last_name}</span>
                                    <span class="badge bg-primary ms-2">${user.role}</span>
                                </c:if>
                            </c:forEach>
                            <c:if test="${!foundUser}">
                                <span class="text-secondary">Unknown User (ID: ${taskUser.userId})</span>
                            </c:if>
                        </div>
                    </div>

                    <div class="col-md-6">
                        <label class="text-secondary small mb-1">ASSIGNMENT STATUS</label>
                        <div>
                            <c:choose>
                                <c:when test="${taskUser.assignStatus == 1}">
                                    <span class="badge bg-success fs-6 p-2">
                                        <i class="bi bi-check-circle me-1"></i>Active
                                    </span>
                                </c:when>
                                <c:when test="${taskUser.assignStatus == 0}">
                                    <span class="badge bg-danger fs-6 p-2">
                                        <i class="bi bi-x-circle me-1"></i>Revoked
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-secondary fs-6 p-2">Unknown</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <div class="col-md-6">
                        <label class="text-secondary small mb-1">TASK STATUS</label>
                        <div>
                            <c:choose>
                                <c:when test="${taskUser.taskStatus == 'Assigned'}">
                                    <span class="badge bg-info fs-6 p-2">${taskUser.taskStatus}</span>
                                </c:when>
                                <c:when test="${taskUser.taskStatus == 'InProgress'}">
                                    <span class="badge bg-primary fs-6 p-2">${taskUser.taskStatus}</span>
                                </c:when>
                                <c:when test="${taskUser.taskStatus == 'PendingTesting'}">
                                    <span class="badge bg-warning text-dark fs-6 p-2">${taskUser.taskStatus}</span>
                                </c:when>
                                <c:when test="${taskUser.taskStatus == 'Completed'}">
                                    <span class="badge bg-success fs-6 p-2">${taskUser.taskStatus}</span>
                                </c:when>
                                <c:when test="${taskUser.taskStatus == 'Defect'}">
                                    <span class="badge bg-danger fs-6 p-2">${taskUser.taskStatus}</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-secondary fs-6 p-2">${taskUser.taskStatus}</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <div class="col-md-6">
                        <label class="text-secondary small mb-1">HOURS WORKED</label>
                        <div class="text-white">
                            <c:choose>
                                <c:when test="${not empty taskUser.utilizedHours}">
                                    <span class="fw-medium">${taskUser.utilizedHours}</span> hrs
                                </c:when>
                                <c:otherwise>
                                    <span class="text-secondary">Not logged</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <div class="col-12">
                        <label class="text-secondary small mb-1">COMMENT HISTORY</label>
                        <div class="bg-dark p-3 rounded border border-secondary">
                            <c:choose>
                                <c:when test="${not empty taskUser.comments}">
                                    <div class="text-white-50" style="white-space: pre-line; font-family: monospace;">
                                        <c:out value="${taskUser.comments}" />
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <p class="text-secondary mb-0 text-center py-3">
                                        <i class="bi bi-chat-dots fs-1 d-block mb-2"></i>
                                        No comments added yet
                                    </p>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

                <!-- Action Buttons -->
                <hr class="my-4 border-secondary">
                <div class="d-flex justify-content-end gap-3">
                    <a href="../updateTaskStatusDeveloper/${taskUser.taskUserId}" 
                       class="btn btn-warning px-4">
                        <i class="bi bi-pencil-square me-2"></i>Update Status
                    </a>
                    <a href="../taskUserListDeveloper" class="btn btn-secondary px-4">
                        <i class="bi bi-arrow-left me-2"></i>Back
                    </a>
                </div>
            </div>
        </div>

        <!-- Side Information Card -->
        <div class="col-lg-4 mb-4">
            <div class="glass-card p-4">
                <h5 class="text-white mb-3">
                    <i class="bi bi-info-circle me-2" style="color: var(--primary-color);"></i>Assignment Summary
                </h5>
                
                <div class="mb-3">
                    <label class="text-secondary small mb-1">Task</label>
                    <div class="text-white fw-medium">
                        <c:out value="${task.title}" default="N/A" />
                    </div>
                </div>
                
                <div class="mb-3">
                    <label class="text-secondary small mb-1">Project</label>
                    <div class="text-white">
                        <c:out value="${project.title}" default="N/A" />
                    </div>
                </div>
                
                <div class="mb-3">
                    <label class="text-secondary small mb-1">Assigned To</label>
                    <div class="text-white">
                        <c:forEach var="user" items="${allUsers}">
                            <c:if test="${user.userId == taskUser.userId}">
                                ${user.first_name} ${user.last_name}
                            </c:if>
                        </c:forEach>
                    </div>
                </div>
                
                <div class="mb-3">
                    <label class="text-secondary small mb-1">Current Status</label>
                    <div>
                        <c:choose>
                            <c:when test="${taskUser.taskStatus == 'Assigned'}">
                                <span class="badge bg-info">${taskUser.taskStatus}</span>
                            </c:when>
                            <c:when test="${taskUser.taskStatus == 'InProgress'}">
                                <span class="badge bg-primary">${taskUser.taskStatus}</span>
                            </c:when>
                            <c:when test="${taskUser.taskStatus == 'PendingTesting'}">
                                <span class="badge bg-warning text-dark">${taskUser.taskStatus}</span>
                            </c:when>
                            <c:when test="${taskUser.taskStatus == 'Completed'}">
                                <span class="badge bg-success">${taskUser.taskStatus}</span>
                            </c:when>
                            <c:when test="${taskUser.taskStatus == 'Defect'}">
                                <span class="badge bg-danger">${taskUser.taskStatus}</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-secondary">${taskUser.taskStatus}</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
                
                <hr class="border-secondary my-3">
                
                <h6 class="text-white mb-2">Quick Actions</h6>
                <div class="d-grid gap-2">
                    <a href="../updateTaskStatusDeveloper/${taskUser.taskUserId}" 
                       class="btn btn-outline-warning">
                        <i class="bi bi-pencil me-2"></i>Update Status
                    </a>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Debug Info (Remove in production) -->
    <c:if test="${empty taskUser}">
        <div class="alert alert-danger mt-3">
            <strong>Error:</strong> No assignment data found!
        </div>
    </c:if>
</main>

<jsp:include page="ProjectManagerFooter.jsp" />