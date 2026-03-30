<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- Set page title and active sidebar item --%>
<c:set var="pageTitle" value="User Management" scope="request" />
<c:set var="activeNav" value="users" scope="request" />

<%-- Include global header (opens <html>, <head>, navbar) --%>
<jsp:include page="adminheader.jsp" />

<%-- Include sidebar --%>
<jsp:include page="adminsidebar.jsp" />

    <%-- MAIN CONTENT (starts with .main-content) --%>
    <main class="main-content" id="mainContent">

        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1 class="h2 text-white mb-0">
                <i class="bi bi-people me-2" style="color: var(--primary-color);"></i>User Management
            </h1>
            <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#userModal">
                <i class="bi bi-person-plus me-2"></i>Add User
            </button>
        </div>

        <!-- Search Box -->
        <div class="mb-4 d-flex justify-content-end">
            <div class="col-md-4">
                <div class="input-group">
                    <span class="input-group-text bg-transparent border-secondary text-secondary">
                        <i class="bi bi-search"></i>
                    </span>
                    <input type="text" id="searchInput" 
                           class="form-control bg-transparent text-white border-secondary"
                           placeholder="Search users..." 
                           onkeyup="filterTable()">
                </div>
            </div>
        </div>

        <!-- User Table Card -->
        <div class="glass-card p-4">
            <div class="table-responsive">
                <table class="table table-hover mb-0" id="userTable" style="--bs-table-bg: transparent;">
                    <thead>
                        <tr>
                            <th class="text-secondary">SrNo</th>
                            <th class="text-secondary">Profile</th>
                            <th class="text-secondary">Full Name</th>
                            <th class="text-secondary">Email</th>
                            <th class="text-secondary">Mobile</th>
                            <th class="text-secondary">Role</th>
                            <th class="text-secondary">Gender</th>
                            <th class="text-secondary">Status</th>
                            <th class="text-secondary">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="user" items="${userList}" varStatus="status">
                            <tr>
                                <td class="text-white">${status.index + 1}</td>

                                <!-- Profile Picture -->
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty user.profilePicURL}">
                                            <img src="${user.profilePicURL}" 
                                                 class="profile-img" 
                                                 style="width: 45px; height: 45px; border-radius: 50%; object-fit: cover;">
                                        </c:when>
                                        <c:otherwise>
                                            <div class="rounded-circle d-flex align-items-center justify-content-center"
                                                 style="width: 45px; height: 45px; background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));">
                                                <i class="bi bi-person-fill text-white"></i>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </td>

                                <td class="text-white fw-medium">${user.first_name} ${user.last_name}</td>
                                <td class="text-white-50">${user.email}</td>
                                <td class="text-white-50">${user.mobile}</td>
                                <td class="text-white-50">${user.role}</td>
                                <td class="text-white-50">${user.gender}</td>

                                <!-- Status Badge -->
                                <td>
                                    <c:choose>
                                        <c:when test="${user.is_active == true}">
                                            <span class="badge-success status-badge">Active</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge-danger status-badge">Inactive</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>

                                <!-- Actions -->
                                <td>
                                    <div class="d-flex gap-2 justify-content-center">
                                        <a href="viewUser/${user.userId}" 
                                           class="btn btn-sm btn-primary btn-custom">
                                            <i class="bi bi-eye"></i> View
                                        </a>
                                        <a href="editUser/${user.userId}" 
                                           class="btn btn-sm btn-warning btn-custom">
                                            <i class="bi bi-pencil"></i> Edit
                                        </a>
                                        <a href="deleteUser/${user.userId}" 
                                           class="btn btn-sm btn-danger btn-custom"
                                           onclick="return confirm('Are you sure you want to delete this user?')">
                                            <i class="bi bi-trash"></i> Delete
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- =============== ADD USER MODAL (Dark Theme) =============== -->
        <div class="modal fade" id="userModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content bg-dark text-white border-secondary">

                    <div class="modal-header border-secondary">
                        <h5 class="modal-title text-white">
                            <i class="bi bi-person-plus-fill me-2" style="color: var(--primary-color);"></i>Add New User
                        </h5>
                        <button type="button" class="btn-close btn-close-white" 
                                data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>

                    <form action="saveUser" method="post" enctype="multipart/form-data">
                        <div class="modal-body">
                            <div class="row g-3">

                                <!-- First Name -->
                                <div class="col-md-6">
                                    <label class="form-label text-secondary">First Name</label>
                                    <input type="text" name="first_name" 
                                           class="form-control bg-transparent text-white border-secondary" required>
                                </div>

                                <!-- Last Name -->
                                <div class="col-md-6">
                                    <label class="form-label text-secondary">Last Name</label>
                                    <input type="text" name="last_name" 
                                           class="form-control bg-transparent text-white border-secondary" required>
                                </div>

                                <!-- Gender -->
                                <div class="col-md-6">
                                    <label class="form-label text-secondary">Gender</label>
                                    <select name="gender" class="form-select bg-transparent text-white border-secondary" required>
                                        <option value="" disabled selected class="text-dark">Select Gender</option>
                                        <option value="Male" class="text-dark">Male</option>
                                        <option value="Female" class="text-dark">Female</option>
                                        <option value="Other" class="text-dark">Other</option>
                                    </select>
                                </div>

                                <!-- Role -->
                                <div class="col-md-6">
                                    <label class="form-label text-secondary">Role</label>
                                    <select name="role" class="form-select bg-transparent text-white border-secondary" required>
                                        <option value="" disabled selected class="text-dark">Select Role</option>
                                        <option value="system_admin" class="text-dark">System Admin</option>
                                        <option value="project_manager" class="text-dark">Project Manager</option>
                                        <option value="developer" class="text-dark">Developer</option>
                                        <option value="tester" class="text-dark">Tester</option>
                                    </select>
                                </div>

                                <!-- Mobile -->
                                <div class="col-md-6">
                                    <label class="form-label text-secondary">Mobile</label>
                                    <input type="tel" name="mobile" 
                                           class="form-control bg-transparent text-white border-secondary" 
                                           pattern="[0-9]{10}" required>
                                </div>

                                <!-- Email -->
                                <div class="col-md-6">
                                    <label class="form-label text-secondary">Email</label>
                                    <input type="email" name="email" 
                                           class="form-control bg-transparent text-white border-secondary" required>
                                </div>
                                
                                <!-- Password -->
<div class="col-md-6">
    <label class="form-label text-secondary">
        <i class="bi bi-lock me-2"></i>Password
    </label>
    <input type="text" name="password"
           class="form-control bg-transparent text-white border-secondary"
           required>
</div>

                                <!-- Qualification -->
                                <div class="col-md-6">
                                    <label class="form-label text-secondary">
                                        <i class="bi bi-award me-2"></i>Qualification
                                    </label>
                                    <select name="qualification" class="form-select bg-transparent text-white border-secondary" required>
                                        <option value="" disabled selected class="text-dark">Select qualification</option>
                                        <option value="High School" class="text-dark">High School</option>
                                        <option value="Diploma" class="text-dark">Diploma</option>
                                        <option value="Bachelor's Degree" class="text-dark">Bachelor's Degree</option>
                                        <option value="Master's Degree" class="text-dark">Master's Degree</option>
                                        <option value="PhD" class="text-dark">PhD</option>
                                        <option value="Other" class="text-dark">Other</option>
                                    </select>
                                </div>

                                <!-- City -->
                                <div class="col-md-6">
                                    <label class="form-label text-secondary">
                                        <i class="bi bi-building me-2"></i>City
                                    </label>
                                    <input type="text" name="city" 
                                           class="form-control bg-transparent text-white border-secondary" 
                                           autocomplete="address-level2" required>
                                </div>

                                <!-- State -->
                                <div class="col-md-6">
                                    <label class="form-label text-secondary">
                                        <i class="bi bi-geo-alt me-2"></i>State
                                    </label>
                                    <input type="text" name="state" 
                                           class="form-control bg-transparent text-white border-secondary" 
                                           autocomplete="address-level1" required>
                                </div>

                                <!-- Country -->
                                <div class="col-md-6">
                                    <label class="form-label text-secondary">
                                        <i class="bi bi-globe me-2"></i>Country
                                    </label>
                                    <select name="country" class="form-select bg-transparent text-white border-secondary" required>
                                        <option value="" disabled selected class="text-dark">Select country</option>
                                        <option value="United States" class="text-dark">United States</option>
                                        <option value="Canada" class="text-dark">Canada</option>
                                        <option value="United Kingdom" class="text-dark">United Kingdom</option>
                                        <option value="India" class="text-dark">India</option>
                                        <option value="Australia" class="text-dark">Australia</option>
                                        <option value="Germany" class="text-dark">Germany</option>
                                        <option value="France" class="text-dark">France</option>
                                        <option value="Japan" class="text-dark">Japan</option>
                                        <option value="China" class="text-dark">China</option>
                                        <option value="Other" class="text-dark">Other</option>
                                    </select>
                                </div>

                                <!-- Profile Picture -->
                                <div class="col-md-6">
                                    <label class="form-label text-secondary">Profile Picture</label>
                                    <input type="file" name="profilePic" 
                                           class="form-control bg-transparent text-white border-secondary">
                                </div>

                                <!-- Status -->
                                <div class="col-md-6">
                                    <label class="form-label text-secondary">Status</label>
                                    <select name="is_active" class="form-select bg-transparent text-white border-secondary">
                                        <option value="true" selected class="text-dark">Active</option>
                                        <option value="false" class="text-dark">Inactive</option>
                                    </select>
                                </div>

                            </div>
                        </div>

                        <div class="modal-footer border-secondary">
                            <button type="submit" class="btn btn-success">
                                <i class="bi bi-check-circle me-2"></i>Save User
                            </button>
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                                <i class="bi bi-x-circle me-2"></i>Cancel
                            </button>
                        </div>
                    </form>

                </div>
            </div>
        </div>

    </main>

<%-- Include footer (closes .main-content, contains Bootstrap JS and common scripts) --%>
<jsp:include page="adminfooter.jsp" />

<%-- Page‑specific search filter script --%>
<script>
function filterTable() {
    const input = document.getElementById("searchInput").value.toLowerCase();
    const rows = document.querySelectorAll("#userTable tbody tr");
    rows.forEach(row => {
        row.style.display = row.innerText.toLowerCase().includes(input) ? "" : "none";
    });
}
</script>

<%-- No duplicate CSS/JS – everything is provided by the global includes --%>