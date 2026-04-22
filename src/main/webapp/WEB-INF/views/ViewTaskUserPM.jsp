<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="pageTitle" value="Assignment Details" scope="request" />
<c:set var="activeNav" value="taskUser" scope="request" />

<jsp:include page="ProjectManagerHeader.jsp" />
<jsp:include page="ProjectManagerSidebar.jsp" />

<main class="main-content" id="mainContent">
    <div class="mb-4">
        <a href="javascript:history.back()" class="text-decoration-none text-secondary">
            <i class="bi bi-arrow-left-circle"></i> Back to Assignments
        </a>
    </div>
    
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="glass-card p-4">
                <div class="d-flex justify-content-between align-items-center mb-4 border-bottom border-secondary pb-2">
                    <h4 class="text-white">
                        <i class="bi bi-person-check me-2"></i>Assignment Details
                    </h4>
                    <span class="badge bg-primary">ID : #${taskUser.taskUserId}</span>
                </div>
                
                <div class="row g-4">
                    <div class="col-md-6">
                        <label class="text-secondary">Task</label>
                        <p class="text-white fw-bold fs-5">
                            <c:forEach var="task" items="${taskList}">
                                <c:if test="${task.taskId == taskUser.taskId}">${task.title}</c:if>
                            </c:forEach>
                        </p>
                    </div>
                    
                    <div class="col-md-6">
                        <label class="text-secondary">Assigned User</label>
                        <p class="text-white fw-bold fs-5">
                            <c:forEach var="user" items="${userList}">
                                <c:if test="${user.userId == taskUser.userId}">${user.first_name} ${user.last_name}</c:if>
                            </c:forEach>
                        </p>
                    </div>
                    
                    <div class="col-md-6">
                        <label class="text-secondary">Role</label>
                        <p>
                            <c:forEach var="user" items="${userList}">
                                <c:if test="${user.userId == taskUser.userId}">
                                    <c:choose>
                                        <c:when test="${user.role == 'developer'}">
                                            <span class="badge bg-primary">Developer</span>
                                        </c:when>
                                        <c:when test="${user.role == 'tester'}">
                                            <span class="badge bg-warning text-dark">Tester</span>
                                        </c:when>
                                    </c:choose>
                                </c:if>
                            </c:forEach>
                        </p>
                    </div>
                    
                    <div class="col-md-6">
                        <label class="text-secondary">Task Status</label>
                        <p class="text-info fw-bold">${taskUser.taskStatus}</p>
                    </div>
                    
                    <div class="col-md-6">
                        <label class="text-secondary">Comment</label>
                        <p class="text-white">${taskUser.comments}</p>
                    </div>
                    
                    <div class="col-md-6">
                        <label class="text-secondary">Utilized Hours</label>
                        <p class="text-warning fw-bold">${taskUser.utilizedHours} hrs</p>
                    </div>
                    
                    <div class="col-md-6">
                        <label class="text-secondary">Assignment Status</label>
                        <p>
                            <c:choose>
                                <c:when test="${taskUser.assignStatus == 1}">
                                    <span class="badge bg-success">Assigned</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-danger">Revoked</span>
                                </c:otherwise>
                            </c:choose>
                        </p>
                    </div>
                </div>
                
                <hr class="my-4 border-secondary">
                <div class="d-flex justify-content-end gap-3">
                    <a href="../editTaskUserPM/${taskUser.taskUserId}" class="btn btn-warning">
                        <i class="bi bi-pencil"></i> Edit
                    </a>
                    <a href="../deleteTaskUserPM/${taskUser.taskId}" class="btn btn-danger"
                       onclick="return confirm('Delete all assignments for this task?')">
                        <i class="bi bi-trash"></i> Delete
                    </a>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="adminfooter.jsp"/>