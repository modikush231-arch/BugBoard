<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="pageTitle" value="Task Details - ${task.title}" scope="request" />
<c:set var="activeNav" value="tasks" scope="request" />

<jsp:include page="adminheader.jsp" />
<jsp:include page="adminsidebar.jsp" />

<main class="main-content" id="mainContenert">
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
                        <i class="bi bi-list-task me-2"></i>Task Details
                    </h4>
                    <span class="badge bg-primary">ID: #${task.taskId}</span>
                </div>
                
                <div class="row g-4">
                    <div class="col-md-6">
                        <label class="text-secondary">Task Title</label>
                        <p class="text-white fw-bold fs-4">${task.title}</p>
                    </div>
                    
                    <div class="col-md-6">
                        <label class="text-secondary">Module Name</label>
                        <p class="text-white">
                            <c:forEach var="m" items="${moduleList}">
                                <c:if test="${m.moduleId == task.moduleId}">${m.moduleName}</c:if>
                            </c:forEach>
                        </p>
                    </div>
                    
                    <div class="col-md-6">
                        <label class="text-secondary">Project Name</label>
                        <p class="text-white">
                            <c:forEach var="p" items="${projectList}">
                                <c:if test="${p.projectId == task.projectId}">${p.title}</c:if>
                            </c:forEach>
                        </p>
                    </div>
                    
                    <div class="col-md-6">
                        <label class="text-secondary">Status</label>
                        <p>
                            <c:choose>
                                <c:when test="${task.status == 'Assigned'}">
                                    <span class="badge bg-info fs-6 p-2">Assigned</span>
                                </c:when>
                                <c:when test="${task.status == 'InProgress'}">
                                    <span class="badge bg-primary fs-6 p-2">In Progress</span>
                                </c:when>
                                <c:when test="${task.status == 'PendingTesting'}">
                                    <span class="badge bg-warning text-dark fs-6 p-2">Pending Review</span>
                                </c:when>
                                <c:when test="${task.status == 'Completed'}">
                                    <span class="badge bg-success fs-6 p-2">Completed</span>
                                </c:when>
                                <c:when test="${task.status == 'Defect'}">
                                    <span class="badge bg-danger fs-6 p-2">Defect</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-secondary fs-6 p-2">${task.status}</span>
                                </c:otherwise>
                            </c:choose>
                        </p>
                    </div>
                    
                    <div class="col-12">
                        <label class="text-secondary">Description</label>
                        <p class="text-white-50">${task.description}</p>
                    </div>
                    
                    <div class="col-md-6">
                        <label class="text-secondary"><i class="bi bi-clock me-1"></i> Estimated Hours</label>
                        <p class="text-white">${task.estimatedHours} hrs</p>
                    </div>
                    
                    <div class="col-md-6">
                        <label class="text-secondary"><i class="bi bi-hourglass-split me-1"></i> Utilized Hours</label>
                        <p class="text-warning">${task.totalUtilizedHours} hrs</p>
                    </div>
                    
                    <div class="col-12">
                        <label class="text-secondary">Documentation</label>
                        <div>
                            <c:choose>
                                <c:when test="${not empty task.docURL}">
                                    <a href="${task.docURL}" target="_blank" class="btn btn-outline-info btn-sm">
                                        <i class="bi bi-file-earmark-text me-1"></i> Open Document
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <p class="text-secondary">No documentation</p>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
                
                <hr class="my-4 border-secondary">
                <div class="d-flex justify-content-end">
                    <a href="../editTask/${task.taskId}" class="btn btn-warning">
                        <i class="bi bi-pencil-square me-1"></i> Edit
                    </a>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="adminfooter.jsp" />