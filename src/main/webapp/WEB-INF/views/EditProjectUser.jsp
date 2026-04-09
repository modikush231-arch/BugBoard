<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="pageTitle" value="Edit Assignment" scope="request" />
<c:set var="activeNav" value="projectUser" scope="request" />

<jsp:include page="adminheader.jsp" />
<jsp:include page="adminsidebar.jsp" />

<main class="main-content" id="mainContent">
    <div class="mb-4">
        <a href="${pageContext.request.contextPath}/projectUserList" class="text-decoration-none text-secondary">
            <i class="bi bi-arrow-left-circle me-1"></i> Back to Assignments
        </a>
    </div>

    <div class="row justify-content-center">
        <div class="col-lg-6">
            <div class="glass-card p-4">
                <h4 class="mb-4 text-white">
                    <i class="bi bi-pencil-square me-2"></i>Edit Manager Assignment
                </h4>

                <form action="${pageContext.request.contextPath}/updateProjectUser" method="post">
                    <input type="hidden" name="projectUserId" value="${projectUser.projectUserId}">

                    <!-- Project -->
                    <div class="mb-3">
                        <label class="form-label text-secondary">Project <span class="text-danger">*</span></label>
                        <select name="projectId" class="form-select bg-dark text-white border-secondary" required>
                            <option value="">Select Project</option>
                            <c:forEach var="p" items="${availableProjectsForEdit}">
                                <option value="${p.projectId}" ${p.projectId == projectUser.projectId ? 'selected' : ''}>
                                    ${p.title}
                                </option>
                            </c:forEach>
                        </select>
                        <small class="text-secondary">Projects already assigned to another manager are hidden.</small>
                    </div>

                    <!-- Manager -->
                    <div class="mb-3">
                        <label class="form-label text-secondary">Project Manager <span class="text-danger">*</span></label>
                        <select name="userId" class="form-select bg-dark text-white border-secondary" required>
                            <option value="">Select Manager</option>
                            <c:forEach var="u" items="${userList}">
                                <option value="${u.userId}" ${u.userId == projectUser.userId ? 'selected' : ''}>
                                    ${u.first_name} ${u.last_name} (${u.email})
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <!-- Assignment Status -->
                    <div class="mb-3">
                        <label class="form-label text-secondary">Assignment Status</label>
                        <select name="assignStatus" class="form-select bg-dark text-white border-secondary" required>
                            <option value="1" ${projectUser.assignStatus == 1 ? 'selected' : ''}>Active</option>
                            <option value="0" ${projectUser.assignStatus == 0 ? 'selected' : ''}>Revoked</option>
                        </select>
                    </div>

                    <div class="d-flex justify-content-end gap-3 mt-4">
                        <button type="submit" class="btn btn-success">
                            <i class="bi bi-check-circle me-2"></i>Update Assignment
                        </button>
                        <a href="${pageContext.request.contextPath}/projectUserList" class="btn btn-secondary">
                            <i class="bi bi-x-circle me-2"></i>Cancel
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</main>

<jsp:include page="adminfooter.jsp" />

<style>
.glass-card {
    background: rgba(255, 255, 255, 0.05);
    backdrop-filter: blur(10px);
    border-radius: 12px;
    border: 1px solid rgba(255, 255, 255, 0.1);
}
<<<<<<< HEAD
</style>
=======
</style>
>>>>>>> 827b48daa80754df09f99e6a22587614bfbb207a
