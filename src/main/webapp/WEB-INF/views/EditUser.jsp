<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="pageTitle" value="Edit User - ${user.first_name} ${user.last_name}" scope="request" />
<c:set var="activeNav" value="users" scope="request" />

<jsp:include page="adminheader.jsp" />
<jsp:include page="adminsidebar.jsp" />

<main class="main-content" id="mainContent">
    <div class="mb-4">
        <a href="javascript:history.back()" class="text-decoration-none text-secondary">
            <i class="bi bi-arrow-left-circle me-1"></i> Back to User List
        </a>
    </div>

    <div class="row justify-content-center">
        <div class="col-lg-10">
            <div class="glass-card p-4">
                <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom border-secondary">
                    <h4 class="mb-0 text-white">
                        <i class="bi bi-pencil-square me-2" style="color: var(--primary-color);"></i>Edit User
                    </h4>
                    <span class="badge bg-primary">ID: #${user.userId}</span>
                </div>

                <form action="../updateUser" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="userId" value="${user.userId}">

                    <div class="row g-4">
                        <!-- Profile Picture Column -->
                        <div class="col-md-3 text-center">
                            <c:choose>
                                <c:when test="${not empty user.profilePicURL}">
                                    <img src="${user.profilePicURL}" id="profilePreview"
                                         class="mb-3"
                                         style="width: 150px; height: 150px; border-radius: 50%; object-fit: cover; border: 3px solid var(--primary-color);">
                                </c:when>
                                <c:otherwise>
                                    <div id="profilePreviewDiv" class="mx-auto mb-3 d-flex align-items-center justify-content-center"
                                         style="width: 150px; height: 150px; border-radius: 50%; background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));">
                                        <i class="bi bi-person-fill text-white" style="font-size: 4rem;"></i>
                                    </div>
                                    <img id="profilePreview" style="display: none; width: 150px; height: 150px; border-radius: 50%; object-fit: cover; border: 3px solid var(--primary-color);">
                                </c:otherwise>
                            </c:choose>
                            <div class="mt-2">
                                <label class="btn btn-outline-secondary btn-sm">
                                    <i class="bi bi-camera me-1"></i> Change Photo
                                    <input type="file" name="profilePic" accept="image/*" style="display: none;" onchange="previewImage(this)">
                                </label>
                            </div>
                        </div>

                        <!-- User Details Column -->
                        <div class="col-md-9">
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label class="form-label text-secondary">First Name *</label>
                                    <input type="text" name="first_name" class="form-control bg-dark text-white border-secondary"
                                           value="${user.first_name}" required>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label text-secondary">Last Name *</label>
                                    <input type="text" name="last_name" class="form-control bg-dark text-white border-secondary"
                                           value="${user.last_name}" required>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label text-secondary">Email *</label>
                                    <input type="email" name="email" class="form-control bg-dark text-white border-secondary"
                                           value="${user.email}" required>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label text-secondary">Mobile *</label>
                                    <input type="tel" name="mobile" pattern="[0-9]{10}" class="form-control bg-dark text-white border-secondary"
                                           value="${user.mobile}" required>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label text-secondary">Gender</label>
                                    <select name="gender" class="form-select bg-dark text-white border-secondary" required>
                                        <option value="Male" ${user.gender == 'Male' ? 'selected' : ''}>Male</option>
                                        <option value="Female" ${user.gender == 'Female' ? 'selected' : ''}>Female</option>
                                        <option value="Other" ${user.gender == 'Other' ? 'selected' : ''}>Other</option>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label text-secondary">Role *</label>
                                    <select name="role" class="form-select bg-dark text-white border-secondary" required>
                                        <option value="system_admin" ${user.role == 'system_admin' ? 'selected' : ''}>System Admin</option>
                                        <option value="project_manager" ${user.role == 'project_manager' ? 'selected' : ''}>Project Manager</option>
                                        <option value="developer" ${user.role == 'developer' ? 'selected' : ''}>Developer</option>
                                        <option value="tester" ${user.role == 'tester' ? 'selected' : ''}>Tester</option>
                                    </select>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label text-secondary">Status</label>
                                    <select name="is_active" class="form-select bg-dark text-white border-secondary">
                                        <option value="true" ${user.is_active ? 'selected' : ''}>Active</option>
                                        <option value="false" ${!user.is_active ? 'selected' : ''}>Inactive</option>
                                    </select>
                                </div>

                                <hr class="my-2 border-secondary">

                                <div class="col-md-6">
                                    <label class="form-label text-secondary">Qualification</label>
                                    <select name="qualification" class="form-select bg-dark text-white border-secondary">
                                        <option value="">-- Select --</option>
                                        <option value="High School" ${userDetails.qualification == 'High School' ? 'selected' : ''}>High School</option>
                                        <option value="Diploma" ${userDetails.qualification == 'Diploma' ? 'selected' : ''}>Diploma</option>
                                        <option value="Bachelor's Degree" ${userDetails.qualification == "Bachelor's Degree" ? 'selected' : ''}>Bachelor's Degree</option>
                                        <option value="Master's Degree" ${userDetails.qualification == "Master's Degree" ? 'selected' : ''}>Master's Degree</option>
                                        <option value="PhD" ${userDetails.qualification == 'PhD' ? 'selected' : ''}>PhD</option>
                                        <option value="Other" ${userDetails.qualification == 'Other' ? 'selected' : ''}>Other</option>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label text-secondary">City</label>
                                    <input type="text" name="city" class="form-control bg-dark text-white border-secondary"
                                           value="${userDetails.city}">
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label text-secondary">State</label>
                                    <input type="text" name="state" class="form-control bg-dark text-white border-secondary"
                                           value="${userDetails.state}">
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label text-secondary">Country</label>
                                    <select name="country" class="form-select bg-dark text-white border-secondary">
                                        <option value="">-- Select --</option>
                                        <option value="India" ${userDetails.country == 'India' ? 'selected' : ''}>India</option>
                                        <option value="United States" ${userDetails.country == 'United States' ? 'selected' : ''}>United States</option>
                                        <option value="Canada" ${userDetails.country == 'Canada' ? 'selected' : ''}>Canada</option>
                                        <option value="United Kingdom" ${userDetails.country == 'United Kingdom' ? 'selected' : ''}>United Kingdom</option>
                                        <option value="Australia" ${userDetails.country == 'Australia' ? 'selected' : ''}>Australia</option>
                                        <option value="Germany" ${userDetails.country == 'Germany' ? 'selected' : ''}>Germany</option>
                                        <option value="France" ${userDetails.country == 'France' ? 'selected' : ''}>France</option>
                                        <option value="Japan" ${userDetails.country == 'Japan' ? 'selected' : ''}>Japan</option>
                                        <option value="China" ${userDetails.country == 'China' ? 'selected' : ''}>China</option>
                                        <option value="Other" ${userDetails.country == 'Other' ? 'selected' : ''}>Other</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                    </div>

                    <hr class="my-4 border-secondary">
                    <div class="d-flex justify-content-end gap-3">
                        <button type="submit" class="btn btn-success px-4">
                            <i class="bi bi-check-circle me-1"></i> Update User
                        </button>
                        <a href="../UserList" class="btn btn-secondary px-4">
                            <i class="bi bi-x-circle me-1"></i> Cancel
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</main>

<jsp:include page="adminfooter.jsp" />

<script>
    function previewImage(input) {
        if (input.files && input.files[0]) {
            var reader = new FileReader();
            reader.onload = function(e) {
                var preview = document.getElementById('profilePreview');
                var previewDiv = document.getElementById('profilePreviewDiv');
                preview.src = e.target.result;
                preview.style.display = 'block';
                if (previewDiv) previewDiv.style.display = 'none';
            }
            reader.readAsDataURL(input.files[0]);
        }
    }
</script>

<style>
    .glass-card {
        background: rgba(255, 255, 255, 0.05);
        backdrop-filter: blur(10px);
        border-radius: 12px;
        border: 1px solid rgba(255, 255, 255, 0.1);
    }
    .form-control:focus, .form-select:focus {
        background-color: #2c2c3a !important;
        color: white !important;
        border-color: var(--primary-color) !important;
        box-shadow: 0 0 0 0.2rem rgba(13, 110, 253, 0.25);
    }
</style>