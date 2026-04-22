<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="pageTitle" value="My Profile" scope="request" />

<%-- Header and Sidebar based on role --%>
<c:choose>
    <c:when test="${not empty sessionScope.dbuser and sessionScope.dbuser.role == 'system_admin'}">
        <c:set var="activeNav" value="profile" scope="request" />
        <jsp:include page="adminheader.jsp" />
        <jsp:include page="adminsidebar.jsp" />
    </c:when>
    <c:when test="${sessionScope.dbuser.role == 'project_manager'}">
        <c:set var="activeNav" value="profile" scope="request" />
        <jsp:include page="ProjectManagerHeader.jsp" />
        <jsp:include page="ProjectManagerSidebar.jsp" />
    </c:when>
    <c:when test="${sessionScope.dbuser.role == 'developer'}">
        <c:set var="activeNav" value="profile" scope="request" />
        <jsp:include page="DeveloperHeader.jsp" />
        <jsp:include page="DeveloperSidebar.jsp" />
    </c:when>
    <c:when test="${sessionScope.dbuser.role == 'tester'}">
        <c:set var="activeNav" value="profile" scope="request" />
        <jsp:include page="TesterHeader.jsp" />
        <jsp:include page="TesterSidebar.jsp" />
    </c:when>
    <c:otherwise>
        <%-- Default fallback for any other role --%>
        <jsp:include page="DeveloperHeader.jsp" />
        <jsp:include page="DeveloperSidebar.jsp" />
    </c:otherwise>
</c:choose>

<main class="main-content" id="mainContent">
    <div class="container mt-4">
        
        <!-- Page Header -->
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h1 class="h2 text-white mb-2">
                    <i class="bi bi-person-circle me-2" style="color: var(--primary-color);"></i>
                    My Profile
                </h1>
                <p class="text-secondary mb-0">View and manage your personal information</p>
            </div>
            <div class="d-flex gap-2">
                <button class="btn btn-primary" onclick="enableEdit()" id="editBtn">
                    <i class="bi bi-pencil-square me-2"></i>Edit Profile
                </button>
                <button class="btn btn-outline-secondary" onclick="location.reload()">
                    <i class="bi bi-arrow-clockwise"></i>
                </button>
            </div>
        </div>

        <div class="row g-4">
            <!-- Profile Card -->
            <div class="col-lg-4">
                <div class="glass-card p-4 text-center">
                    <!-- Profile Image -->
                    <div class="position-relative d-inline-block">
                        <c:choose>
                            <c:when test="${not empty user.profilePicURL}">
                                <img src="${user.profilePicURL}" 
                                     class="rounded-circle border border-primary border-3" 
                                     style="width: 150px; height: 150px; object-fit: cover;">
                            </c:when>
                            <c:otherwise>
                                <div class="rounded-circle d-flex align-items-center justify-content-center mx-auto"
                                     style="width: 150px; height: 150px; background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));">
                                    <i class="bi bi-person-fill text-white" style="font-size: 4rem;"></i>
                                </div>
                            </c:otherwise>
                        </c:choose>
                        
                        <!-- Status Badge -->
                        <div class="position-absolute bottom-0 end-0">
                            <c:choose>
                                <c:when test="${user.is_active}">
                                    <span class="badge bg-success rounded-pill p-2">
                                        <i class="bi bi-check-circle-fill me-1"></i>Active
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-secondary rounded-pill p-2">
                                        <i class="bi bi-x-circle-fill me-1"></i>Inactive
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    
                    <h3 class="mt-4 mb-1 text-white">${user.first_name} ${user.last_name}</h3>
                    <p class="text-primary mb-3">
                        <i class="bi bi-briefcase me-1"></i>
                        <c:choose>
                            <c:when test="${user.role == 'system_admin'}">System Administrator</c:when>
                            <c:when test="${user.role == 'project_manager'}">Project Manager</c:when>
                            <c:when test="${user.role == 'developer'}">Developer</c:when>
                            <c:when test="${user.role == 'tester'}">QA Tester</c:when>
                            <c:otherwise>${user.role}</c:otherwise>
                        </c:choose>
                    </p>
                    
                    <div class="row g-3 mt-2">
                        <div class="col-6">
                            <div class="bg-dark p-2 rounded">
                                <small class="text-secondary d-block">Member Since</small>
                                <strong class="text-white">
                                    <c:choose>
                                        <c:when test="${not empty formattedCreatedDate}">
                                            ${formattedCreatedDate}
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-secondary">N/A</span>
                                        </c:otherwise>
                                    </c:choose>
                                </strong>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="bg-dark p-2 rounded">
                                <small class="text-secondary d-block">User ID</small>
                                <strong class="text-white">#${user.userId}</strong>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Personal Information Card -->
            <div class="col-lg-8">
                <div class="glass-card p-4">
                    <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom border-secondary">
                        <h5 class="text-white mb-0">
                            <i class="bi bi-info-circle me-2" style="color: var(--primary-color);"></i>
                            Personal Information
                        </h5>
                        <span class="badge bg-primary-subtle text-primary border border-primary-subtle">
                            <i class="bi bi-shield-check me-1"></i>Verified
                        </span>
                    </div>
                    
                    <!-- View Mode -->
                    <div id="viewMode">
                        <div class="row g-4">
                            <div class="col-md-6">
                                <label class="text-secondary small mb-1">First Name</label>
                                <div class="text-white fw-medium">
                                    <i class="bi bi-person me-2 text-secondary"></i>
                                    <c:choose>
                                        <c:when test="${not empty user.first_name}">${user.first_name}</c:when>
                                        <c:otherwise><span class="text-secondary">Not provided</span></c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label class="text-secondary small mb-1">Last Name</label>
                                <div class="text-white fw-medium">
                                    <i class="bi bi-person me-2 text-secondary"></i>
                                    <c:choose>
                                        <c:when test="${not empty user.last_name}">${user.last_name}</c:when>
                                        <c:otherwise><span class="text-secondary">Not provided</span></c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label class="text-secondary small mb-1">Email Address</label>
                                <div class="text-white fw-medium">
                                    <i class="bi bi-envelope me-2 text-secondary"></i>
                                    <c:choose>
                                        <c:when test="${not empty user.email}">${user.email}</c:when>
                                        <c:otherwise><span class="text-secondary">Not provided</span></c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label class="text-secondary small mb-1">Mobile Number</label>
                                <div class="text-white fw-medium">
                                    <i class="bi bi-phone me-2 text-secondary"></i>
                                    <c:choose>
                                        <c:when test="${not empty user.mobile}">${user.mobile}</c:when>
                                        <c:otherwise><span class="text-secondary">Not provided</span></c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label class="text-secondary small mb-1">Gender</label>
                                <div class="text-white fw-medium">
                                    <c:choose>
                                        <c:when test="${user.gender == 'male'}">
                                            <i class="bi bi-gender-male me-2 text-secondary"></i>Male
                                        </c:when>
                                        <c:when test="${user.gender == 'female'}">
                                            <i class="bi bi-gender-female me-2 text-secondary"></i>Female
                                        </c:when>
                                        <c:when test="${not empty user.gender}">
                                            <i class="bi bi-gender-ambiguous me-2 text-secondary"></i>${user.gender}
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-secondary">Not provided</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label class="text-secondary small mb-1">Qualification</label>
                                <div class="text-white fw-medium">
                                    <i class="bi bi-mortarboard me-2 text-secondary"></i>
                                    <c:choose>
                                        <c:when test="${not empty userDetails.qualification}">${userDetails.qualification}</c:when>
                                        <c:otherwise><span class="text-secondary">Not provided</span></c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            
                            <div class="col-12 mt-2">
                                <hr class="border-secondary my-2">
                                <h6 class="text-white mb-3">
                                    <i class="bi bi-geo-alt me-2" style="color: var(--primary-color);"></i>
                                    Location
                                </h6>
                            </div>
                            
                            <div class="col-md-4">
                                <label class="text-secondary small mb-1">City</label>
                                <div class="text-white fw-medium">
                                    <i class="bi bi-building me-2 text-secondary"></i>
                                    <c:choose>
                                        <c:when test="${not empty userDetails.city}">${userDetails.city}</c:when>
                                        <c:otherwise><span class="text-secondary">Not provided</span></c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <label class="text-secondary small mb-1">State</label>
                                <div class="text-white fw-medium">
                                    <i class="bi bi-map me-2 text-secondary"></i>
                                    <c:choose>
                                        <c:when test="${not empty userDetails.state}">${userDetails.state}</c:when>
                                        <c:otherwise><span class="text-secondary">Not provided</span></c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <label class="text-secondary small mb-1">Country</label>
                                <div class="text-white fw-medium">
                                    <i class="bi bi-flag me-2 text-secondary"></i>
                                    <c:choose>
                                        <c:when test="${not empty userDetails.country}">${userDetails.country}</c:when>
                                        <c:otherwise><span class="text-secondary">Not provided</span></c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Edit Mode (Hidden by default) -->
                    <form id="editMode" style="display: none;" action="updateProfile" method="post" enctype="multipart/form-data">
                        <div class="row g-4">
                            <div class="col-md-6">
                                <label class="form-label text-secondary">First Name</label>
                                <input type="text" name="first_name" class="form-control bg-dark text-white border-secondary" 
                                       value="${user.first_name}">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label text-secondary">Last Name</label>
                                <input type="text" name="last_name" class="form-control bg-dark text-white border-secondary" 
                                       value="${user.last_name}">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label text-secondary">Email</label>
                                <input type="email" name="email" class="form-control bg-dark text-white border-secondary" 
                                       value="${user.email}">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label text-secondary">Mobile</label>
                                <input type="text" name="mobile" class="form-control bg-dark text-white border-secondary" 
                                       value="${user.mobile}">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label text-secondary">Gender</label>
                                <select name="gender" class="form-select bg-dark text-white border-secondary">
                                    <option value="male" ${user.gender == 'male' ? 'selected' : ''}>Male</option>
                                    <option value="female" ${user.gender == 'female' ? 'selected' : ''}>Female</option>
                                    <option value="other" ${user.gender == 'other' ? 'selected' : ''}>Other</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label text-secondary">Qualification</label>
                                <input type="text" name="qualification" class="form-control bg-dark text-white border-secondary" 
                                       value="${userDetails.qualification}">
                            </div>
                            <div class="col-md-12">
                                <label class="form-label text-secondary">Profile Picture</label>
                                <input type="file" name="profilePic" class="form-control bg-dark text-white border-secondary">
                                <small class="text-secondary">Leave empty to keep current picture</small>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label text-secondary">City</label>
                                <input type="text" name="city" class="form-control bg-dark text-white border-secondary" 
                                       value="${userDetails.city}">
                            </div>
                            <div class="col-md-4">
                                <label class="form-label text-secondary">State</label>
                                <input type="text" name="state" class="form-control bg-dark text-white border-secondary" 
                                       value="${userDetails.state}">
                            </div>
                            <div class="col-md-4">
                                <label class="form-label text-secondary">Country</label>
                                <input type="text" name="country" class="form-control bg-dark text-white border-secondary" 
                                       value="${userDetails.country}">
                            </div>
                            <div class="col-12 mt-3">
                                <hr class="border-secondary">
                                <div class="d-flex gap-2 justify-content-end">
                                    <button type="button" class="btn btn-secondary" onclick="cancelEdit()">
                                        <i class="bi bi-x-circle me-2"></i>Cancel
                                    </button>
                                    <button type="submit" class="btn btn-success">
                                        <i class="bi bi-check-circle me-2"></i>Save Changes
                                    </button>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
                
                <!-- Recent Activity Card -->
                <div class="glass-card p-4 mt-4">
                    <h5 class="text-white mb-3">
                        <i class="bi bi-clock-history me-2" style="color: var(--primary-color);"></i>
                        Recent Activity
                    </h5>
                    <div class="table-responsive">
                        <table class="table table-borderless">
                            <tbody>
                                <c:if test="${not empty formattedCreatedDate}">
                                    <tr>
                                        <td class="text-secondary"><i class="bi bi-calendar-check me-2"></i>Member Since</td>
                                        <td class="text-white">${formattedCreatedDate}</td>
                                    </tr>
                                </c:if>
                                <c:if test="${user.role == 'developer'}">
                                     <tr>
                                        <td class="text-secondary"><i class="bi bi-check-circle me-2"></i>Tasks Completed</td>
                                        <td class="text-white">${completedTasksCount} tasks</td>
                                     </tr>
                                </c:if>
                                 <c:if test="${user.role == 'tester'}">
                                     <tr>
                                        <td class="text-secondary"><i class="bi bi-check-circle me-2"></i>Tasks Verified</td>
                                        <td class="text-white">${verifiedTasksCount} tasks</td>
                                     </tr>
                                </c:if>
                                <c:if test="${user.role == 'project_manager'}">
                                     <tr>
                                        <td class="text-secondary"><i class="bi bi-kanban me-2"></i>Projects Managed</td>
                                        <td class="text-white">${projectsCount} projects</td>
                                     </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<script>
function enableEdit() {
    document.getElementById('viewMode').style.display = 'none';
    document.getElementById('editMode').style.display = 'block';
    document.getElementById('editBtn').style.display = 'none';
}

function cancelEdit() {
    document.getElementById('viewMode').style.display = 'block';
    document.getElementById('editMode').style.display = 'none';
    document.getElementById('editBtn').style.display = 'inline-flex';
}
</script>

<%-- Footer based on role --%>
<c:choose>
    <c:when test="${sessionScope.dbuser.role == 'system_admin'}">
        <jsp:include page="adminfooter.jsp" />
    </c:when>
    <c:when test="${sessionScope.dbuser.role == 'project_manager'}">
        <jsp:include page="ProjectManagerFooter.jsp" />
    </c:when>
    <c:when test="${sessionScope.dbuser.role == 'developer'}">
        <jsp:include page="DeveloperFooter.jsp" />
    </c:when>
    <c:when test="${sessionScope.dbuser.role == 'tester'}">
        <jsp:include page="TesterFooter.jsp" />
    </c:when>
    <c:otherwise>
        <%-- Default footer for unknown roles (should not happen) --%>
        <jsp:include page="DefaultFooter.jsp" />
    </c:otherwise>
</c:choose>