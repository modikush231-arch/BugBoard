<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="My Task Assignments" scope="request" />
<c:set var="activeNav" value="taskUser" scope="request" />

<jsp:include page="DeveloperHeader.jsp" />
<jsp:include page="DeveloperSidebar.jsp" />

<main class="main-content" id="mainContent">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="h2 text-white mb-0">
            <i class="bi bi-person-check me-2" style="color: var(--primary-color);"></i>My Task Assignments
        </h1>
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
                       placeholder="Search assignments..." onkeyup="filterTable()">
            </div>
        </div>
    </div>

    <!-- Task Assignments Table -->
    <div class="glass-card p-4">
        <form action="${pageContext.request.contextPath}/bulkUpdateTaskStatus" method="post" id="bulkUpdateForm">
            <div class="table-responsive">
                <table class="table table-hover mb-0" id="taskTable" style="--bs-table-bg: transparent;">
                    <thead>
                        <tr>
                            <th class="text-secondary">
                                <input type="checkbox" id="selectAll" onclick="toggleAllCheckboxes()">
                            </th>
                            <th class="text-secondary">SrNo</th>
                            <th class="text-secondary">Task</th>
                            <th class="text-secondary">Project</th>
                            <th class="text-secondary">Role</th>
                            <th class="text-secondary">Task Status</th>
                            <th class="text-secondary">Comment</th>
                            <th class="text-secondary">Assign Status</th>
                            <th class="text-secondary">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="tu" items="${taskUserList}" varStatus="loop">
                            <tr>
                                <td>
                                    <input type="checkbox" name="selectedTasks" value="${tu.taskUserId}" 
                                           class="taskCheckbox">
                                </td>
                                <td class="text-white">${loop.index + 1}</td>
                                
                                <!-- Task Name -->
                                <td class="text-white fw-medium">
                                    <c:forEach var="task" items="${taskList}">
                                        <c:if test="${task.taskId == tu.taskId}">
                                            ${task.title}
                                        </c:if>
                                    </c:forEach>
                                </td>
                                
                                <!-- Project Name -->
                                <td class="text-white">
                                    <c:forEach var="task" items="${taskList}">
                                        <c:if test="${task.taskId == tu.taskId}">
                                            <c:forEach var="project" items="${projectList}">
                                                <c:if test="${project.projectId == task.projectId}">
                                                    <span class="fw-medium">${project.title}</span>
                                                </c:if>
                                            </c:forEach>
                                        </c:if>
                                    </c:forEach>
                                </td>
                                
                                <!-- Role Badge -->
                                <td>
                                    <span class="badge bg-primary">
                                        <i class="bi bi-code-slash me-1"></i>Developer
                                    </span>
                                </td>
                                
                                <!-- Task Status with Color Coding (No quick update dropdown) -->
                                <td>
                                    <c:choose>
                                        <c:when test="${tu.taskStatus == 'Assigned'}">
                                            <span class="badge bg-info status-badge">${tu.taskStatus}</span>
                                        </c:when>
                                        <c:when test="${tu.taskStatus == 'InProgress'}">
                                            <span class="badge bg-primary status-badge">${tu.taskStatus}</span>
                                        </c:when>
                                        <c:when test="${tu.taskStatus == 'PendingTesting'}">
                                            <span class="badge bg-warning text-dark status-badge">${tu.taskStatus}</span>
                                        </c:when>
                                        <c:when test="${tu.taskStatus == 'Completed'}">
                                            <span class="badge bg-success status-badge">${tu.taskStatus}</span>
                                        </c:when>
                                        <c:when test="${tu.taskStatus == 'Defect'}">
                                            <span class="badge bg-danger status-badge">${tu.taskStatus}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-secondary status-badge">${tu.taskStatus}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                
                                <!-- Comment -->
                                <td class="text-white-50" style="max-width: 200px;">
                                    <c:choose>
                                        <c:when test="${not empty tu.comments}">
                                            <span title="${tu.comments}">
                                                ${tu.comments.length() > 30 ? tu.comments.substring(0,30).concat('...') : tu.comments}
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-secondary">-</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                
                                <!-- Assign Status -->
                                <td>
                                    <c:choose>
                                        <c:when test="${tu.assignStatus == 1}">
                                            <span class="badge bg-success">
                                                <i class="bi bi-check-circle me-1"></i>Assigned
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-danger">
                                                <i class="bi bi-x-circle me-1"></i>Revoked
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                
                                <!-- Actions - Only View and Update Status (No Quick Update button) -->
                                <td>
                                    <div class="d-flex gap-2">
                                        <a href="viewTaskUserDeveloper/${tu.taskUserId}" 
                                           class="btn btn-sm btn-primary btn-custom"
                                           title="View Details">
                                            <i class="bi bi-eye"></i>
                                        </a>
                                        <a href="${pageContext.request.contextPath}/updateTaskStatusDeveloper/${tu.taskUserId}" 
                                           class="btn btn-sm btn-warning btn-custom"
                                           title="Update Status">
                                            <i class="bi bi-pencil"></i>
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        
                        <!-- If no assignments -->
                        <c:if test="${empty taskUserList}">
                            <tr>
                                <td colspan="9" class="text-center text-secondary py-5">
                                    <i class="bi bi-inbox fs-1 d-block mb-3"></i>
                                    <h5 class="text-secondary">No tasks assigned yet</h5>
                                    <p class="text-secondary small">When PM assigns tasks, they will appear here</p>
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
            
            <!-- Bulk Update Section (appears when checkboxes are selected) -->
            <div id="bulkUpdateSection" class="mt-4 p-3 border border-secondary rounded" style="display: none;">
                <div class="row align-items-center">
                    <div class="col-md-3">
                        <h6 class="text-white mb-0">
                            <i class="bi bi-pencil-square me-2"></i>Bulk Update (<span id="selectedCount">0</span> selected)
                        </h6>
                    </div>
                    <div class="col-md-4">
                        <select name="bulkStatus" class="form-select bg-dark text-white border-secondary" id="bulkStatus">
                            <option value="">Select Status</option>
                            <option value="InProgress">In Progress</option>
                            <option value="PendingTesting">Pending Testing</option>
                            <option value="Completed">Completed</option>
                            <option value="Defect">Defect</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <input type="text" name="bulkComment" class="form-control bg-dark text-white border-secondary" 
                               placeholder="Bulk comment (optional)" id="bulkComment">
                    </div>
                    <div class="col-md-2">
                        <button type="submit" class="btn btn-success w-100" id="bulkUpdateBtn">
                            <i class="bi bi-check-all me-2"></i>Update All
                        </button>
                    </div>
                </div>
            </div>
        </form>
    </div>
    
    <!-- Summary Cards -->
    <div class="row mt-4 g-4">
        <div class="col-md-3">
            <div class="glass-card p-3">
                <div class="d-flex align-items-center">
                    <div class="stat-icon icon-projects me-3">
                        <i class="bi bi-list-task"></i>
                    </div>
                    <div>
                        <h6 class="text-secondary mb-1">Total Assigned</h6>
                        <h3 class="text-white mb-0">${totalAssigned}</h3>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="col-md-3">
            <div class="glass-card p-3">
                <div class="d-flex align-items-center">
                    <div class="stat-icon icon-users me-3" style="background: rgba(59,130,246,0.2);">
                        <i class="bi bi-play-circle text-primary"></i>
                    </div>
                    <div>
                        <h6 class="text-secondary mb-1">In Progress</h6>
                        <h3 class="text-white mb-0">${inProgressCount}</h3>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="col-md-3">
            <div class="glass-card p-3">
                <div class="d-flex align-items-center">
                    <div class="stat-icon icon-bugs me-3" style="background: rgba(245,158,11,0.2);">
                        <i class="bi bi-clock-history text-warning"></i>
                    </div>
                    <div>
                        <h6 class="text-secondary mb-1">Pending Testing</h6>
                        <h3 class="text-white mb-0">${pendingTestingCount}</h3>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="col-md-3">
            <div class="glass-card p-3">
                <div class="d-flex align-items-center">
                    <div class="stat-icon icon-pending me-3" style="background: rgba(16,185,129,0.2);">
                        <i class="bi bi-check-circle text-success"></i>
                    </div>
                    <div>
                        <h6 class="text-secondary mb-1">Completed</h6>
                        <h3 class="text-white mb-0">${completedCount}</h3>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<style>
    #taskTable tbody tr:hover td,
    #taskTable tbody tr:hover th {
        color: white !important;
    }
    .status-badge {
        font-size: 0.85rem;
        padding: 0.35rem 0.65rem;
    }
    .btn-custom {
        padding: 0.25rem 0.5rem;
        font-size: 0.875rem;
    }
</style>

<jsp:include page="ProjectManagerFooter.jsp" />

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
    
    function toggleAllCheckboxes() {
        const selectAll = document.getElementById("selectAll");
        const checkboxes = document.getElementsByClassName("taskCheckbox");
        
        for (let i = 0; i < checkboxes.length; i++) {
            checkboxes[i].checked = selectAll.checked;
        }
        
        updateBulkUpdateSection();
    }
    
    function updateBulkUpdateSection() {
        const checkboxes = document.getElementsByClassName("taskCheckbox");
        let selectedCount = 0;
        
        for (let i = 0; i < checkboxes.length; i++) {
            if (checkboxes[i].checked) {
                selectedCount++;
            }
        }
        
        document.getElementById("selectedCount").innerText = selectedCount;
        document.getElementById("bulkUpdateSection").style.display = 
            selectedCount > 0 ? "block" : "none";
    }
    
    // Add event listeners to checkboxes
    document.addEventListener('DOMContentLoaded', function() {
        const checkboxes = document.getElementsByClassName("taskCheckbox");
        for (let i = 0; i < checkboxes.length; i++) {
            checkboxes[i].addEventListener('change', updateBulkUpdateSection);
        }
    });
</script>