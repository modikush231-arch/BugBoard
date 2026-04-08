<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="pageTitle" value="Assignment Details" scope="request" />
<c:set var="activeNav" value="projectUser" scope="request" />

<jsp:include page="adminheader.jsp" />
<jsp:include page="adminsidebar.jsp" />

<main class="main-content" id="mainContent">
    <div class="mb-4">
        <a href="/projectUserList" class="text-decoration-none text-secondary hover-text-primary">
            <i class="bi bi-arrow-left-circle me-1"></i> Back to Manager Assignment List
        </a>
    </div>

    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="glass-card p-4">
                <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom border-secondary">
                    <h4 class="mb-0 text-white">
                        <i class="bi bi-person-badge me-2" style="color: var(--primary-color);"></i>Assignment Details
                    </h4>
                    <span class="badge bg-primary-subtle text-primary border">ID: #${projectUser.projectUserId}</span>
                </div>

                <div class="row g-4">
                    <!-- Project -->
                    <div class="col-md-6">
                        <label class="detail-label text-secondary">PROJECT</label>
                        <p class="detail-value text-white fw-bold fs-5">
                            <c:forEach var="p" items="${projectList}">
                                <c:if test="${p.projectId == projectUser.projectId}">
                                    ${p.title}
                                    <!-- Resolve project status -->
                                    <c:forEach var="ps" items="${projectStatusList}">
                                        <c:if test="${ps.projectStatusId == p.projectStatusId}">
                                            <span class="badge ms-2 
                                                <c:choose>
                                                    <c:when test="${ps.status == 'Lead'}">bg-purple</c:when>
                                                    <c:when test="${ps.status == 'NotStarted'}">bg-secondary</c:when>
                                                    <c:when test="${ps.status == 'InProgress'}">bg-primary</c:when>
                                                    <c:when test="${ps.status == 'Hold'}">bg-warning text-dark</c:when>
                                                    <c:when test="${ps.status == 'Completed'}">bg-success</c:when>
                                                </c:choose>
                                            ">${ps.status}</span>
                                        </c:if>
                                    </c:forEach>
                                </c:if>
                            </c:forEach>
                        </p>
                    </div>

                    <!-- Manager -->
                    <div class="col-md-6">
                        <label class="detail-label text-secondary">MANAGER</label>
                        <p class="detail-value text-white fw-bold fs-5">
                            <c:forEach var="u" items="${userList}">
                                <c:if test="${u.userId == projectUser.userId}">
                                    ${u.first_name} ${u.last_name}
                                </c:if>
                            </c:forEach>
                        </p>
                    </div>

                    <hr class="my-2 border-secondary">

                    <!-- Assignment Status -->
                    <div class="col-md-6">
                        <label class="detail-label text-secondary">ASSIGNMENT STATUS</label>
                        <p class="detail-value">
                            <c:choose>
                                <c:when test="${projectUser.assignStatus == 1}">
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
                    <a href="/editProjectUser/${projectUser.projectUserId}" class="btn btn-warning px-4">
                        <i class="bi bi-pencil-square"></i> Edit
                    </a>
                    <button class="btn btn-outline-danger px-4" onclick="confirmDelete()">
                        <i class="bi bi-trash"></i> Delete
                    </button>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="adminfooter.jsp" />

<script>
    function confirmDelete() {
        if (confirm("Delete this assignment? This will also remove the manager from all related tasks, modules, and task assignments.")) {
            window.location.href = "/deleteProjectUser/${projectUser.projectUserId}";
        }
    }
</script>