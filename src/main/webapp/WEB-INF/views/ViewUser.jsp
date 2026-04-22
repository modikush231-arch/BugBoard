<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- Set page title and active sidebar item --%>
<c:set var="pageTitle" value="User Details - ${user.first_name} ${user.last_name}" scope="request" />
<c:set var="activeNav" value="users" scope="request" />

<%-- Include global header (opens <html>, <head>, navbar) --%>
<jsp:include page="adminheader.jsp" />

<%-- Include sidebar --%>
<jsp:include page="adminsidebar.jsp" />

    <%-- MAIN CONTENT (starts with .main-content) --%>
    <main class="main-content" id="mainContent">

        <!-- Back button with icon -->
        <div class="mb-4">
            <a href="javascript:history.back()" class="text-decoration-none text-secondary hover-text-primary">
                <i class="bi bi-arrow-left-circle me-1"></i> Back to User List
            </a>
        </div>

        <div class="row justify-content-center">
            <div class="col-lg-10">

                <!-- User details card -->
                <div class="glass-card p-4">
                    <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom border-secondary">
                        <h4 class="mb-0 text-white">
                            <i class="bi bi-person-badge me-2" style="color: var(--primary-color);"></i>User Details
                        </h4>
                        <span class="badge bg-primary-subtle text-primary border border-primary-subtle status-badge">
                            ID: #${user.userId}
                        </span>
                    </div>

                    <div class="row g-4">
                        <!-- Profile Picture Column -->
                        <div class="col-md-3 text-center">
                            <c:choose>
                                <c:when test="${not empty user.profilePicURL}">
                                    <img src="${user.profilePicURL}" alt="Profile Picture" 
                                         class="profile-img-large mb-3"
                                         style="width: 150px; height: 150px; border-radius: 50%; object-fit: cover; border: 3px solid var(--primary-color);">
                                </c:when>
                                <c:otherwise>
                                    <div class="mx-auto mb-3 d-flex align-items-center justify-content-center"
                                         style="width: 150px; height: 150px; border-radius: 50%; background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));">
                                        <i class="bi bi-person-fill text-white" style="font-size: 4rem;"></i>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <!-- User Details Column -->
                        <div class="col-md-9">
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label class="detail-label text-secondary">FIRST NAME</label>
                                    <p class="detail-value text-white">${user.first_name}</p>
                                </div>
                                <div class="col-md-6">
                                    <label class="detail-label text-secondary">LAST NAME</label>
                                    <p class="detail-value text-white">${user.last_name}</p>
                                </div>

                                <div class="col-md-6">
                                    <label class="detail-label text-secondary">
                                        <i class="bi bi-envelope me-1"></i> EMAIL
                                    </label>
                                    <p class="detail-value text-white-50">${user.email}</p>
                                </div>
                                <div class="col-md-6">
                                    <label class="detail-label text-secondary">
                                        <i class="bi bi-phone me-1"></i> MOBILE
                                    </label>
                                    <p class="detail-value text-white-50">${user.mobile}</p>
                                </div>

                                <div class="col-md-6">
                                    <label class="detail-label text-secondary">
                                        <i class="bi bi-gender-ambiguous me-1"></i> GENDER
                                    </label>
                                    <p class="detail-value text-white-50">${user.gender}</p>
                                </div>
                                <div class="col-md-6">
                                    <label class="detail-label text-secondary">
                                        <i class="bi bi-briefcase me-1"></i> ROLE
                                    </label>
                                    <p class="detail-value text-white-50">${user.role}</p>
                                </div>

                                <div class="col-md-6">
                                    <label class="detail-label text-secondary">
                                        <i class="bi bi-check-circle me-1"></i> STATUS
                                    </label>
                                    <p class="detail-value">
                                        <c:choose>
                                            <c:when test="${user.is_active}">
                                                <span class="badge-success status-badge">Active</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge-danger status-badge">Inactive</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </p>
                                </div>
                                <div class="col-md-6">
                                    <label class="detail-label text-secondary">
                                        <i class="bi bi-calendar-plus me-1"></i> CREATED AT
                                    </label>
                                    <p class="detail-value text-white-50">${user.created_at}</p>
                                </div>

                                <hr class="my-2 border-secondary">

                                <div class="col-md-6">
                                    <label class="detail-label text-secondary">
                                        <i class="bi bi-award me-1"></i> QUALIFICATION
                                    </label>
                                    <p class="detail-value text-white-50">${userDetails.qualification}</p>
                                </div>
                                <div class="col-md-6">
                                    <label class="detail-label text-secondary">
                                        <i class="bi bi-building me-1"></i> CITY
                                    </label>
                                    <p class="detail-value text-white-50">${userDetails.city}</p>
                                </div>

                                <div class="col-md-6">
                                    <label class="detail-label text-secondary">
                                        <i class="bi bi-geo-alt me-1"></i> STATE
                                    </label>
                                    <p class="detail-value text-white-50">${userDetails.state}</p>
                                </div>
                                <div class="col-md-6">
                                    <label class="detail-label text-secondary">
                                        <i class="bi bi-globe me-1"></i> COUNTRY
                                    </label>
                                    <p class="detail-value text-white-50">${userDetails.country}</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <hr class="my-4 border-secondary">

                    <!-- Action buttons -->
                    <div class="d-flex justify-content-end gap-3">
                        <a href="../editUser/${user.userId}" class="btn btn-warning px-4">
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
        if (confirm("Are you sure you want to remove this user permanently?")) {
            window.location.href = "../deleteUser/${user.userId}";
        }
    }
</script>

<%-- No duplicate CSS/JS – everything is provided by the global includes --%>