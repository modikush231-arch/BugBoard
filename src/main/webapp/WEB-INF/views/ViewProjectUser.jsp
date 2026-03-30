<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- Set page title and active sidebar item --%>
<c:set var="pageTitle" value="Assignment Details" scope="request" />
<c:set var="activeNav" value="projectUser" scope="request" />

<%-- Include global header --%>
<jsp:include page="adminheader.jsp" />

<%-- Include sidebar --%>
<jsp:include page="adminsidebar.jsp" />

    <%-- MAIN CONTENT --%>
    <main class="main-content" id="mainContent">

        <!-- Back button -->
        <div class="mb-4">
            <a href="../projectUserList" class="text-decoration-none text-secondary hover-text-primary">
                <i class="bi bi-arrow-left-circle me-1"></i> Back to Project User List
            </a>
        </div>

        <div class="row justify-content-center">
            <div class="col-lg-8">

                <!-- Assignment details card -->
                <div class="glass-card p-4">
                    <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom border-secondary">
                        <h4 class="mb-0 text-white">
                            <i class="bi bi-person-badge me-2" style="color: var(--primary-color);"></i>Assignment Details
                        </h4>
                        <span class="badge bg-primary-subtle text-primary border border-primary-subtle status-badge">
                            ID: #${projectUser.projectUserId}
                        </span>
                    </div>

                    <div class="row g-4">
                        <!-- Project -->
                        <div class="col-md-6">
                            <label class="detail-label text-secondary">
                                <i class="bi bi-kanban me-1"></i> PROJECT
                            </label>
                            <p class="detail-value text-white fw-bold fs-5">
                                <c:forEach var="project" items="${projectList}">
                                    <c:if test="${project.projectId == projectUser.projectId}">
                                        ${project.title}
                                    </c:if>
                                </c:forEach>
                            </p>
                        </div>

                        <!-- User (Manager) -->
                        <div class="col-md-6">
                            <label class="detail-label text-secondary">
                                <i class="bi bi-person me-1"></i> MANAGER
                            </label>
                            <p class="detail-value text-white fw-bold fs-5">
                                <c:forEach var="user" items="${userList}">
                                    <c:if test="${user.userId == projectUser.userId}">
                                        ${user.first_name} ${user.last_name}
                                    </c:if>
                                </c:forEach>
                            </p>
                        </div>

                        <hr class="my-2 border-secondary">

                        <!-- Assignment Status -->
                        <div class="col-md-6">
                            <label class="detail-label text-secondary">
                                <i class="bi bi-check-circle me-1"></i> STATUS
                            </label>
                            <p class="detail-value">
                                <c:choose>
                                    <c:when test="${projectUser.assignStatus == 1}">
                                        <span class="badge-success status-badge">Assigned</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge-danger status-badge">Revoked</span>
                                    </c:otherwise>
                                </c:choose>
                            </p>
                        </div>

                        <!-- (Optional) you can add more fields like assigned date if available -->
                    </div>

                    <hr class="my-4 border-secondary">

                    <!-- Action buttons -->
                    <div class="d-flex justify-content-end gap-3">
                        <a href="editProjectUser/${projectUser.projectUserId}" class="btn btn-warning px-4">
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

<%-- Include footer --%>
<jsp:include page="adminfooter.jsp" />

<%-- Delete confirmation script --%>
<script>
    function confirmDelete() {
        if (confirm("Are you sure you want to remove this assignment permanently?")) {
            window.location.href = "../deleteProjectUser/${projectUser.projectUserId}";
        }
    }
</script>