<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="pageTitle" value="Project Details - ${project.title}" scope="request" />
<c:set var="activeNav" value="projects" scope="request" />

<jsp:include page="adminheader.jsp" />
<jsp:include page="adminsidebar.jsp" />

<main class="main-content" id="mainContent">
    <!-- ✅ FIXED: Back button goes to projectListPM -->
    <div class="mb-4">
        <a href="../projectList" class="text-decoration-none text-secondary">
            <i class="bi bi-arrow-left-circle me-1"></i> Back to Projects
        </a>
    </div>
    
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="glass-card p-4">
                <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom border-secondary">
                    <h4 class="text-white">
                        <i class="bi bi-kanban me-2"></i>Project Details
                    </h4>
                    <span class="badge bg-primary">ID: #${project.projectId}</span>
                </div>
                
                <div class="row g-4">
                    <!-- Project Title -->
                    <div class="col-12">
                        <label class="text-secondary">Project Title</label>
                        <p class="text-white fw-bold fs-4">${project.title}</p>
                    </div>
                    
                    <!-- Description -->
                    <div class="col-12">
                        <label class="text-secondary">Description</label>
                        <p class="text-white-50">${project.description}</p>
                    </div>
                    
                    <!-- Status and Progress Row -->
                    <div class="col-md-6">
                        <label class="text-secondary">Status</label>
                        <p>
                            <c:forEach var="s" items="${statusList}">
                                    <c:if test="${s.projectStatusId == project.projectStatusId}">
                                        <span class="badge 
                                            <c:choose>
                                                <c:when test="${s.status == 'Lead'}">bg-purple</c:when>
                                                <c:when test="${s.status == 'NotStarted'}">bg-secondary</c:when>
                                                <c:when test="${s.status == 'InProgress'}">bg-primary</c:when>
                                                <c:when test="${s.status == 'Hold'}">bg-warning text-dark</c:when>
                                                <c:when test="${s.status == 'Completed'}">bg-success</c:when>
                                            </c:choose>
                                        ">${s.status}</span>
                                    </c:if>
                                </c:forEach>
                        </p>
                    </div>
                    
                    <div class="col-md-6">
                        <label class="text-secondary">Progress</label>
                        <c:set var="progressValue" value="0" />
                        <c:choose>
                            <c:when test="${project.projectStatusId == 1}"><c:set var="progressValue" value="5" /></c:when>
                            <c:when test="${project.projectStatusId == 2}"><c:set var="progressValue" value="10" /></c:when>
                            <c:when test="${project.projectStatusId == 3}"><c:set var="progressValue" value="30" /></c:when>
                            <c:when test="${project.projectStatusId == 4}"><c:set var="progressValue" value="60" /></c:when>
                            <c:when test="${project.projectStatusId == 5}"><c:set var="progressValue" value="100" /></c:when>
                        </c:choose>
                        <div class="d-flex align-items-center">
                            <div class="progress flex-grow-1 me-2" style="height:8px;">
                                <div class="progress-bar 
                                    <c:choose>
                                        <c:when test="${progressValue == 100}">bg-success</c:when>
                                        <c:when test="${progressValue >= 60}">bg-primary</c:when>
                                        <c:when test="${progressValue >= 30}">bg-warning</c:when>
                                        <c:when test="${progressValue >= 10}">bg-secondary</c:when>
                                        <c:when test="${progressValue >= 5}">bg-purple</c:when>
                                        <c:otherwise>bg-secondary</c:otherwise>
                                    </c:choose>
                                " style="width: ${progressValue}%"></div>
                            </div>
                            <span class="text-white fw-bold">${progressValue}%</span>
                        </div>
                    </div>
                    
                    <!-- Dates -->
                    <div class="col-md-6">
                        <label class="text-secondary"><i class="bi bi-calendar-event me-1"></i> Start Date</label>
                        <p class="text-white">${project.projectStartDate}</p>
                    </div>
                    
                    <div class="col-md-6">
                        <label class="text-secondary"><i class="bi bi-calendar-check me-1"></i> Completion Date</label>
                        <p class="text-white">${project.projectCompletionDate != null ? project.projectCompletionDate : 'Not set'}</p>
                    </div>
                    
                    <!-- Hours -->
                    <div class="col-md-6">
                        <label class="text-secondary"><i class="bi bi-clock me-1"></i> Estimated Hours</label>
                        <p class="text-white fw-bold">${project.estimatedHours} hrs</p>
                    </div>
                    
                    <div class="col-md-6">
                        <label class="text-secondary"><i class="bi bi-hourglass-split me-1"></i> Utilized Hours</label>
                        <p class="text-warning fw-bold">${project.totalUtilizedHours} hrs</p>
                    </div>
                    
                    <!-- Modules Summary Section -->
                    <div class="col-12 mt-3">
                        <hr class="border-secondary my-2">
                        <h6 class="text-white mb-3">
                            <i class="bi bi-collection me-2" style="color: var(--primary-color);"></i>
                            Modules Overview
                        </h6>
                        
                        <c:set var="moduleCount" value="0" />
                        <c:set var="completedModuleCount" value="0" />
                        <c:set var="inProgressModuleCount" value="0" />
                        <c:set var="pendingModuleCount" value="0" />
                        <c:set var="assignedModuleCount" value="0" />
                        
                        <c:forEach var="module" items="${moduleList}">
                            <c:if test="${module.projectId == project.projectId}">
                                <c:set var="moduleCount" value="${moduleCount + 1}" />
                                <c:choose>
                                    <c:when test="${module.status == 'Completed'}">
                                        <c:set var="completedModuleCount" value="${completedModuleCount + 1}" />
                                    </c:when>
                                    <c:when test="${module.status == 'InProgress'}">
                                        <c:set var="inProgressModuleCount" value="${inProgressModuleCount + 1}" />
                                    </c:when>
                                    <c:when test="${module.status == 'PendingTesting'}">
                                        <c:set var="pendingModuleCount" value="${pendingModuleCount + 1}" />
                                    </c:when>
                                    <c:when test="${module.status == 'Assigned'}">
                                        <c:set var="assignedModuleCount" value="${assignedModuleCount + 1}" />
                                    </c:when>
                                </c:choose>
                            </c:if>
                        </c:forEach>
                        
                        <div class="row g-3">
                            <div class="col-2">
                                <div class="bg-dark p-2 rounded text-center">
                                    <div class="text-secondary small">Total</div>
                                    <div class="text-white fs-4 fw-bold">${moduleCount}</div>
                                </div>
                            </div>
                            <div class="col-2">
                                <div class="bg-dark p-2 rounded text-center">
                                    <div class="text-secondary small">Assigned</div>
                                    <div class="text-info fs-4 fw-bold">${assignedModuleCount}</div>
                                </div>
                            </div>
                            <div class="col-2">
                                <div class="bg-dark p-2 rounded text-center">
                                    <div class="text-secondary small">In Progress</div>
                                    <div class="text-primary fs-4 fw-bold">${inProgressModuleCount}</div>
                                </div>
                            </div>
                            <div class="col-2">
                                <div class="bg-dark p-2 rounded text-center">
                                    <div class="text-secondary small">Pending Review</div>
                                    <div class="text-warning fs-4 fw-bold">${pendingModuleCount}</div>
                                </div>
                            </div>
                            <div class="col-2">
                                <div class="bg-dark p-2 rounded text-center">
                                    <div class="text-secondary small">Completed</div>
                                    <div class="text-success fs-4 fw-bold">${completedModuleCount}</div>
                                </div>
                            </div>
                        </div>
                        
                     
                    </div>
                    
                    <!-- Documentation -->
                    <div class="col-12 mt-3">
                        <label class="text-secondary">Documentation</label>
                        <div class="mt-2">
                            <c:choose>
                                <c:when test="${not empty project.docURL}">
                                    <a href="${project.docURL}" target="_blank" class="btn btn-outline-info">
                                        <i class="bi bi-file-earmark-text me-1"></i> Open Documentation
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <p class="text-secondary">No documentation provided</p>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
                
                <hr class="my-4 border-secondary">
                <div class="d-flex justify-content-end gap-2">
                    <a href="../editProjectAdmin/${project.projectId}" class="btn btn-warning">
                        <i class="bi bi-pencil-square me-1"></i> Edit
                    </a>
                    <a href="../projectModulesAdmin/${project.projectId}" class="btn btn-info">
                        <i class="bi bi-collection me-1"></i> View Modules
                    </a>
                    <a href="../projectList" class="btn btn-secondary">
                        <i class="bi bi-arrow-left me-1"></i> Back
                    </a>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="adminfooter.jsp" />