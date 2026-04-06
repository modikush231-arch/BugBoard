<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="pageTitle" value="Task Assignment Management" scope="request" />
<c:set var="activeNav" value="taskUser" scope="request" />

<jsp:include page="ProjectManagerHeader.jsp" />
<jsp:include page="ProjectManagerSidebar.jsp" />

<main class="main-content" id="mainContent">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h1 class="h2 text-white mb-0">
                <i class="bi bi-person-check me-2" style="color: var(--primary-color);"></i>Task Assignment Management
            </h1>
            <p class="text-secondary mt-1">Assign developers and testers to tasks in your projects</p>
        </div>
        <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#taskUserModal">
            <i class="bi bi-plus-circle me-2"></i>Assign Developer & Tester
        </button>
    </div>

    <!-- Search and Items Info -->
    <div class="mb-4 d-flex justify-content-between align-items-center flex-wrap gap-3">
        <div class="text-secondary">
            <i class="bi bi-info-circle me-1"></i>
            Showing 
            <span class="text-white fw-bold">${pageSize * (currentPage - 1) + 1}</span> - 
            <span class="text-white fw-bold">${pageSize * currentPage > totalItems ? totalItems : pageSize * currentPage}</span> 
            of <span class="text-white fw-bold">${totalItems}</span> assignments
            <c:if test="${not empty searchTerm}">
                <span class="ms-2">
                    <span class="badge bg-info">Search: "${searchTerm}"</span>
                    <a href="?page=1&size=${pageSize}" class="text-decoration-none ms-1">
                        <i class="bi bi-x-circle"></i> Clear
                    </a>
                </span>
            </c:if>
        </div>
        <div class="d-flex gap-3">
            <form method="get" action="" id="searchForm" class="d-flex gap-2">
                <input type="hidden" name="page" value="1">
                <input type="hidden" name="size" value="${pageSize}">
                <div class="input-group" style="width: 280px;">
                    <span class="input-group-text bg-transparent border-secondary text-secondary">
                        <i class="bi bi-search"></i>
                    </span>
                    <input type="text" name="search" id="searchInput" 
                           class="form-control bg-transparent text-white border-secondary"
                           placeholder="Search by task, user, status..." 
                           value="${searchTerm}"
                           onkeypress="handleSearchKeyPress(event)">
                    <c:if test="${not empty searchTerm}">
                        <button type="button" class="btn btn-outline-secondary" onclick="clearSearch()">
                            <i class="bi bi-x"></i>
                        </button>
                    </c:if>
                </div>
                <button type="submit" class="btn btn-primary">
                    <i class="bi bi-search"></i> Search
                </button>
            </form>
            
            <select id="pageSizeSelect" class="form-select bg-dark text-white border-secondary" 
                    style="width: auto;" onchange="changePageSize()">
                <option value="5" ${pageSize == 5 ? 'selected' : ''}>5 per page</option>
                <option value="10" ${pageSize == 10 ? 'selected' : ''}>10 per page</option>
                <option value="20" ${pageSize == 20 ? 'selected' : ''}>20 per page</option>
                <option value="50" ${pageSize == 50 ? 'selected' : ''}>50 per page</option>
            </select>
        </div>
    </div>

    <!-- Assignment Table Card -->
    <div class="glass-card p-4">
        <div class="table-responsive">
            <table class="table table-hover mb-0">
                <thead>
                    <tr class="text-secondary">
                        <th>#</th>
                        <th>Task</th>
                        <th>Assigned To</th>
                        <th>Role</th>
                        <th>Task Status</th>
                        <th>Comment</th>
                        <th>Assign Status</th>
                        <th>Actions</th>
                     </tr>
                </thead>
                <tbody>
                    <c:forEach var="tu" items="${taskUserList}" varStatus="loop">
                        <tr style="border-bottom: 1px solid rgba(255,255,255,0.1);">
                            <td class="text-white">${loop.index + 1 + (currentPage-1)*pageSize}</td>
                            <td class="text-white fw-medium">
                                <c:forEach var="task" items="${taskList}">
                                    <c:if test="${task.taskId == tu.taskId}">
                                        ${task.title}
                                    </c:if>
                                </c:forEach>
                            </td>
                            <td class="text-white">
                                <c:forEach var="user" items="${allUsers}">
                                    <c:if test="${user.userId == tu.userId}">
                                        ${user.first_name} ${user.last_name}
                                    </c:if>
                                </c:forEach>
                            </td>
                            <td>
                                <c:forEach var="user" items="${allUsers}">
                                    <c:if test="${user.userId == tu.userId}">
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
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${tu.taskStatus == 'Assigned'}">
                                        <span class="badge bg-info">Assigned</span>
                                    </c:when>
                                    <c:when test="${tu.taskStatus == 'InProgress'}">
                                        <span class="badge bg-primary">In Progress</span>
                                    </c:when>
                                    <c:when test="${tu.taskStatus == 'Completed'}">
                                        <span class="badge bg-success">Completed</span>
                                    </c:when>
                                    <c:when test="${tu.taskStatus == 'NotStarted'}">
                                        <span class="badge bg-secondary">Not Started</span>
                                    </c:when>
                                    <c:when test="${tu.taskStatus == 'Verified'}">
                                        <span class="badge bg-success">Completed</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-dark">${tu.taskStatus}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="text-white-50">${fn:substring(tu.comments, 0, 30)}${fn:length(tu.comments) > 30 ? '...' : ''}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${tu.assignStatus == 1}">
                                        <span class="badge bg-success">Active</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-danger">Revoked</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <div class="btn-group btn-group-sm" role="group">
                                    <a href="viewTaskUserPM/${tu.taskUserId}" class="btn btn-primary">
                                        <i class="bi bi-eye"></i>
                                    </a>
                                    <a href="editTaskUserPM/${tu.taskUserId}" class="btn btn-warning">
                                        <i class="bi bi-pencil"></i>
                                    </a>
                                    <a href="deleteTaskUserPM/${tu.taskId}" class="btn btn-danger"
                                       onclick="return confirm('Delete all assignments for this task?')">
                                        <i class="bi bi-trash"></i>
                                    </a>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty taskUserList}">
                        <tr>
                            <td colspan="8" class="text-center text-secondary py-5">
                                <i class="bi bi-inbox fs-1 d-block mb-3"></i>
                                <h5>No assignments found</h5>
                                <c:if test="${not empty searchTerm}">
                                    <p class="mt-2">No assignments matching "<strong class="text-info">${searchTerm}</strong>"</p>
                                    <a href="?page=1&size=${pageSize}" class="btn btn-sm btn-outline-primary mt-2">
                                        <i class="bi bi-x-circle"></i> Clear Search
                                    </a>
                                </c:if>
                                <c:if test="${empty searchTerm}">
                                    <p class="mt-2">No tasks have been assigned yet in your projects</p>
                                    <button class="btn btn-sm btn-success mt-2" data-bs-toggle="modal" data-bs-target="#taskUserModal">
                                        <i class="bi bi-plus-circle"></i> Assign Now
                                    </button>
                                </c:if>
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
        
        <!-- Pagination -->
        <c:if test="${totalItems > 0}">
            <div class="d-flex justify-content-center mt-4">
                <nav>
                    <ul class="pagination mb-0">
                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                            <a class="page-link bg-dark text-white border-secondary" 
                               href="?page=1&size=${pageSize}&search=${searchTerm}">
                                <i class="bi bi-chevron-double-left"></i>
                            </a>
                        </li>
                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                            <a class="page-link bg-dark text-white border-secondary" 
                               href="?page=${currentPage-1}&size=${pageSize}&search=${searchTerm}">
                                <i class="bi bi-chevron-left"></i>
                            </a>
                        </li>
                        <c:forEach begin="${currentPage-2 > 0 ? currentPage-2 : 1}" 
                                   end="${currentPage+2 <= totalPages ? currentPage+2 : totalPages}" var="i">
                            <li class="page-item ${currentPage == i ? 'active' : ''}">
                                <a class="page-link ${currentPage == i ? 'bg-primary border-primary text-white' : 'bg-dark text-white border-secondary'}" 
                                   href="?page=${i}&size=${pageSize}&search=${searchTerm}">
                                    ${i}
                                </a>
                            </li>
                        </c:forEach>
                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                            <a class="page-link bg-dark text-white border-secondary" 
                               href="?page=${currentPage+1}&size=${pageSize}&search=${searchTerm}">
                                <i class="bi bi-chevron-right"></i>
                            </a>
                        </li>
                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                            <a class="page-link bg-dark text-white border-secondary" 
                               href="?page=${totalPages}&size=${pageSize}&search=${searchTerm}">
                                <i class="bi bi-chevron-double-right"></i>
                            </a>
                        </li>
                    </ul>
                </nav>
            </div>
            <div class="text-center text-secondary mt-3">
                <small>Page <strong class="text-white">${currentPage}</strong> of <strong class="text-white">${totalPages}</strong></small>
            </div>
        </c:if>
    </div>

    <!-- Assign Modal (Same as before but with task filter) -->
    <div class="modal fade" id="taskUserModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content bg-dark text-white border-secondary">
                <div class="modal-header border-secondary">
                    <h5 class="modal-title text-white">
                        <i class="bi bi-person-plus-fill me-2" style="color: var(--primary-color);"></i>
                        Assign Developer & Tester to Task
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>

                <form action="saveTaskUserPM" method="post">
                    <div class="modal-body">
                        <!-- Task - Only show tasks from PM's projects -->
                      <div class="mb-3">
    <label class="form-label text-secondary">Task <span class="text-danger">*</span></label>
  <select name="taskId" class="form-select bg-dark text-white border-secondary" required>
    <option value="" disabled selected>-- Select Task --</option>
    <c:forEach var="task" items="${unassignedTasks}">
        <option value="${task.taskId}">${task.title}</option>
    </c:forEach>
</select>
<small class="text-secondary">
    Only tasks that have not been assigned yet are shown.
    <c:if test="${empty unassignedTasks}">
        <span class="text-warning">No unassigned tasks available.</span>
    </c:if>
</small>
</div>

                        <!-- Developer -->
                        <div class="mb-3">
                            <label class="form-label text-secondary">Developer <span class="text-danger">*</span></label>
                            <select name="developerId" class="form-select bg-dark text-white border-secondary" required>
                                <option value="" disabled selected>-- Select Developer --</option>
                                <c:forEach var="user" items="${userList}">
                                    <option value="${user.userId}">
                                        ${user.first_name} ${user.last_name} (${user.email})
                                    </option>
                                </c:forEach>
                            </select>
                            <small class="text-secondary">Developer will start with "Assigned" status</small>
                        </div>
                        
                        <!-- Tester -->
                        <div class="mb-3">
                            <label class="form-label text-secondary">Tester <span class="text-danger">*</span></label>
                            <select name="testerId" class="form-select bg-dark text-white border-secondary" required>
                                <option value="" disabled selected>-- Select Tester --</option>
                                <c:forEach var="user" items="${userListTester}">
                                    <option value="${user.userId}">
                                        ${user.first_name} ${user.last_name} (${user.email})
                                    </option>
                                </c:forEach>
                            </select>
                            <small class="text-secondary">Tester will start with "NotStarted" status</small>
                        </div>

                        <!-- Assignment Status -->
                        <div class="mb-3">
                            <label class="form-label text-secondary">Assignment Status</label>
                            <select name="assignStatus" class="form-select bg-dark text-white border-secondary" required>
                                <option value="1">Active</option>
                                <option value="2">Revoked</option>
                            </select>
                        </div>

                        <!-- Initial Hours -->
                        <div class="mb-3">
                            <label class="form-label text-secondary">Initial Hours (Utilized)</label>
                            <input type="number" name="utilizedHours" 
                                   class="form-control bg-transparent text-white border-secondary" 
                                   min="0" value="0" step="0.5">
                            <small class="text-secondary">Hours already spent on this task (usually 0 for new tasks)</small>
                        </div>
                        
                        <!-- Developer Comment -->
                        <div class="mb-3">
                            <label class="form-label text-secondary">Developer Comment (Optional)</label>
                            <textarea name="devComment" class="form-control bg-transparent text-white border-secondary" rows="2"></textarea>
                        </div>

                        <!-- Tester Comment -->
                        <div class="mb-3">
                            <label class="form-label text-secondary">Tester Comment (Optional)</label>
                            <textarea name="testerComment" class="form-control bg-transparent text-white border-secondary" rows="2"></textarea>
                        </div>
                    </div>

                    <div class="modal-footer border-secondary">
                        <button type="submit" class="btn btn-success">
                            <i class="bi bi-check-circle me-2"></i>Save Assignment
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

<jsp:include page="adminfooter.jsp" />

<script>
function handleSearchKeyPress(event) {
    if (event.key === 'Enter') {
        event.preventDefault();
        document.getElementById('searchForm').submit();
    }
}

function clearSearch() {
    window.location.href = "?page=1&size=${pageSize}";
}

function changePageSize() {
    const size = document.getElementById("pageSizeSelect").value;
    window.location.href = "?page=1&size=" + size + "&search=${searchTerm}";
}
</script>

<style>
.page-item.active .page-link {
    background-color: var(--primary-color) !important;
    border-color: var(--primary-color) !important;
    color: white !important;
}

.glass-card {
    background: rgba(255, 255, 255, 0.05);
    backdrop-filter: blur(10px);
    border-radius: 12px;
    border: 1px solid rgba(255, 255, 255, 0.1);
}

.btn-group-sm > .btn {
    padding: 0.25rem 0.5rem;
    font-size: 0.75rem;
}
</style>