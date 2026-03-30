<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="pageTitle" value="Developer → Task Assignment" scope="request" />
<c:set var="activeNav" value="taskUser" scope="request" />

<jsp:include page="ProjectManagerHeader.jsp" />
<jsp:include page="ProjectManagerSidebar.jsp" />

<main class="main-content" id="mainContent">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="h2 text-white mb-0">
            <i class="bi bi-person-check me-2" style="color: var(--primary-color);"></i>Task Assignment
        </h1>
        <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#taskUserModal">
            <i class="bi bi-plus-circle me-2"></i>Assign Developer & Tester
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
                       placeholder="Search..." onkeyup="filterTable()">
            </div>
        </div>
    </div>

    <!-- Assignment Table Card -->
    <div class="glass-card p-4">
        <div class="table-responsive">
            <table id="taskTable" class="table table-hover mb-0" style="--bs-table-bg: transparent;">
                <thead>
                    <tr class="text-secondary">
                        <th>SrNo</th>
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
                        <tr>
                            <td class="text-white">${loop.index + 1}</td>
                            <td class="text-white">
                                <c:forEach var="task" items="${taskList}">
                                    <c:if test="${task.taskId == tu.taskId}">${task.title}</c:if>
                                </c:forEach>
                            </td>
                            <td class="text-white">
                                <c:forEach var="user" items="${allUsers}">
                                    <c:if test="${user.userId == tu.userId}">${user.first_name} ${user.last_name}</c:if>
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
                            <td class="text-white">${tu.taskStatus}</td>
                            <td class="text-white-50">${tu.comments}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${tu.assignStatus == 1}">
                                        <span class="badge bg-success">Assigned</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-danger">Revoked</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <div class="d-flex gap-2">
                                    <a href="viewTaskUserPM/${tu.taskUserId}" class="btn btn-sm btn-primary">
                                        <i class="bi bi-eye"></i>
                                    </a>
                                    <a href="editTaskUserPM/${tu.taskUserId}" class="btn btn-sm btn-warning">
                                        <i class="bi bi-pencil"></i>
                                    </a>
                                    <a href="deleteTaskUserPM/${tu.taskId}" class="btn btn-sm btn-danger"
                                       onclick="return confirm('Delete all assignments for this task?')">
                                        <i class="bi bi-trash"></i>
                                    </a>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Assign Modal -->
    <div class="modal fade" id="taskUserModal" tabindex="-1">
        <div class="modal-dialog">
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
                        <!-- Task -->
                        <div class="mb-3">
                            <label class="form-label text-secondary">Task <span class="text-danger">*</span></label>
                            <select name="taskId" class="form-select bg-transparent text-white border-secondary" required>
                                <option value="" disabled selected>-- Select Task --</option>
                                <c:forEach var="task" items="${taskList}">
                                    <option value="${task.taskId}" class="text-dark">${task.title}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <!-- Developer -->
                        <div class="mb-3">
                            <label class="form-label text-secondary">Developer <span class="text-danger">*</span></label>
                            <select name="developerId" class="form-select bg-transparent text-white border-secondary" required>
                                <option value="" disabled selected>-- Select Developer --</option>
                                <c:forEach var="user" items="${userList}">
                                    <option value="${user.userId}" class="text-dark">
                                        ${user.first_name} ${user.last_name}
                                    </option>
                                </c:forEach>
                            </select>
                            <small class="text-secondary">Developer will start with "Assigned" status</small>
                        </div>
                        
                        <!-- Tester -->
                        <div class="mb-3">
                            <label class="form-label text-secondary">Tester <span class="text-danger">*</span></label>
                            <select name="testerId" class="form-select bg-transparent text-white border-secondary" required>
                                <option value="" disabled selected>-- Select Tester --</option>
                                <c:forEach var="user" items="${userListTester}">
                                    <option value="${user.userId}" class="text-dark">
                                        ${user.first_name} ${user.last_name}
                                    </option>
                                </c:forEach>
                            </select>
                            <small class="text-secondary">Tester will start with "NotStarted" status</small>
                        </div>

                        <!-- Assignment Status -->
                        <div class="mb-3">
                            <label class="form-label text-secondary">Assignment Status</label>
                            <select name="assignStatus" class="form-select bg-transparent text-white border-secondary" required>
                                <option value="1" class="text-dark">Assign</option>
                                <option value="2" class="text-dark">Revoke</option>
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
                            <i class="bi bi-check-circle me-2"></i>Save
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

<style>
    #taskTable tbody tr:hover td,
    #taskTable tbody tr:hover th {
        color: white !important;
    }
</style>

<jsp:include page="adminfooter.jsp" />

<script>
function filterTable() {
    const input = document.getElementById("searchInput").value.toLowerCase();
    const table = document.getElementById("taskTable");
    const rows = table.getElementsByTagName("tr");
    for (let i = 1; i < rows.length; i++) {
        const text = rows[i].innerText.toLowerCase();
        rows[i].style.display = text.includes(input) ? "" : "none";
    }
}
</script>