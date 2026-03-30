<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="pageTitle" value="My Tasks" scope="request" />
<c:set var="activeNav" value="tasks" scope="request" />

<jsp:include page="DeveloperHeader.jsp" />
<jsp:include page="DeveloperSidebar.jsp" />

<main class="main-content" id="mainContent">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h1 class="h2 text-white mb-0">
                <i class="bi bi-list-task me-2" style="color: var(--primary-color);"></i>My Tasks
            </h1>
            <p class="text-secondary mt-1">Manage and track your development tasks</p>
        </div>
        <div class="d-flex gap-2">
            <button class="btn btn-outline-secondary text-white" onclick="location.reload()">
                <i class="bi bi-arrow-clockwise"></i>
            </button>
        </div>
    </div>

    <!-- Status Filter Cards -->
    <div class="row mb-4 g-3">
        <div class="col-md-2">
            <div class="glass-card p-3 ${statusFilter == 'all' ? 'border-primary' : ''}" 
                 style="cursor: pointer;" onclick="location.href='?status=all&page=1&size=${pageSize}'">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <div class="text-secondary small">All Tasks</div>
                        <div class="text-white fs-3 fw-bold">${totalCount}</div>
                    </div>
                    <i class="bi bi-list-ul fs-1 text-secondary"></i>
                </div>
            </div>
        </div>
        <div class="col-md-2">
            <div class="glass-card p-3 ${statusFilter == 'Assigned' ? 'border-info' : ''}" 
                 style="cursor: pointer;" onclick="location.href='?status=Assigned&page=1&size=${pageSize}'">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <div class="text-secondary small">Assigned</div>
                        <div class="text-white fs-3 fw-bold">${assignedCount}</div>
                    </div>
                    <i class="bi bi-envelope fs-1 text-info"></i>
                </div>
            </div>
        </div>
        <div class="col-md-2">
            <div class="glass-card p-3 ${statusFilter == 'InProgress' ? 'border-primary' : ''}" 
                 style="cursor: pointer;" onclick="location.href='?status=InProgress&page=1&size=${pageSize}'">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <div class="text-secondary small">In Progress</div>
                        <div class="text-white fs-3 fw-bold">${inProgressCount}</div>
                    </div>
                    <i class="bi bi-play-circle fs-1 text-primary"></i>
                </div>
            </div>
        </div>
        <div class="col-md-2">
            <div class="glass-card p-3 ${statusFilter == 'PendingTesting' ? 'border-warning' : ''}" 
                 style="cursor: pointer;" onclick="location.href='?status=PendingTesting&page=1&size=${pageSize}'">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <div class="text-secondary small">Pending Review</div>
                        <div class="text-white fs-3 fw-bold">${pendingTestingCount}</div>
                    </div>
                    <i class="bi bi-clock-history fs-1 text-warning"></i>
                </div>
            </div>
        </div>
        <div class="col-md-2">
            <div class="glass-card p-3 ${statusFilter == 'Defect' ? 'border-danger' : ''}" 
                 style="cursor: pointer;" onclick="location.href='?status=Defect&page=1&size=${pageSize}'">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <div class="text-secondary small">Defects</div>
                        <div class="text-white fs-3 fw-bold">${defectCount}</div>
                    </div>
                    <i class="bi bi-exclamation-triangle fs-1 text-danger"></i>
                </div>
            </div>
        </div>
        <div class="col-md-2">
            <div class="glass-card p-3 ${statusFilter == 'Completed' ? 'border-success' : ''}" 
                 style="cursor: pointer;" onclick="location.href='?status=Completed&page=1&size=${pageSize}'">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <div class="text-secondary small">Completed</div>
                        <div class="text-white fs-3 fw-bold">${completedCount}</div>
                    </div>
                    <i class="bi bi-check-circle fs-1 text-success"></i>
                </div>
            </div>
        </div>
    </div>

    <!-- Search and Items Info -->
    <div class="mb-4 d-flex justify-content-between align-items-center flex-wrap gap-3">
        <div class="text-secondary">
            <i class="bi bi-info-circle me-1"></i>
            Showing 
            <span class="text-white fw-bold">${pageSize * (currentPage - 1) + 1}</span> - 
            <span class="text-white fw-bold">${pageSize * currentPage > totalItems ? totalItems : pageSize * currentPage}</span> 
            of <span class="text-white fw-bold">${totalItems}</span> tasks
        </div>
        <div class="d-flex gap-3">
            <div class="input-group" style="width: 250px;">
                <span class="input-group-text bg-transparent border-secondary text-secondary">
                    <i class="bi bi-search"></i>
                </span>
                <input type="text" id="searchInput" 
                       class="form-control bg-transparent text-white border-secondary"
                       placeholder="Search tasks..." 
                       onkeyup="filterTable()">
            </div>
            <select id="pageSizeSelect" class="form-select bg-dark text-white border-secondary" 
                    style="width: auto;" onchange="changePageSize()">
                <option value="5" ${pageSize == 5 ? 'selected' : ''}>5 per page</option>
                <option value="10" ${pageSize == 10 ? 'selected' : ''}>10 per page</option>
                <option value="20" ${pageSize == 20 ? 'selected' : ''}>20 per page</option>
                <option value="50" ${pageSize == 50 ? 'selected' : ''}>50 per page</option>
            </select>
        </div>
    </div>

    <!-- Tasks Table -->
    <div class="glass-card p-4">
        <div class="table-responsive">
            <table class="table table-hover mb-0" id="taskTable">
                <thead>
                    <tr class="text-secondary">
                        <th>#</th>
                        <th>Task Name</th>
                        <th>Project</th>
                        <th>Module</th>
                        <th>Status</th>
                        <th>Hours Worked</th>
                        <th>Last Updated</th>
                        <th>Actions</th>
                       </tr>
                </thead>
                <tbody>
                    <c:forEach var="task" items="${taskList}" varStatus="status">
                        <c:set var="tu" value="${taskUserMap[task.taskId]}" />
                        <c:set var="projectName" value="" />
                        <c:forEach var="project" items="${projectList}">
                            <c:if test="${project.projectId == task.projectId}">
                                <c:set var="projectName" value="${project.title}" />
                            </c:if>
                        </c:forEach>
                        <c:set var="moduleName" value="" />
                        <c:forEach var="module" items="${moduleList}">
                            <c:if test="${module.moduleId == task.moduleId}">
                                <c:set var="moduleName" value="${module.moduleName}" />
                            </c:if>
                        </c:forEach>
                        
                         <tr>
                            <td class="text-white">${status.index + 1 + (currentPage-1)*pageSize}</td>
                            <td class="text-white fw-medium">${task.title}</td>
                            <td class="text-white">${projectName}</td>
                            <td class="text-white">${moduleName}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${tu.taskStatus == 'Assigned'}">
                                        <span class="badge bg-info">Assigned</span>
                                    </c:when>
                                    <c:when test="${tu.taskStatus == 'InProgress'}">
                                        <span class="badge bg-primary">In Progress</span>
                                    </c:when>
                                    <c:when test="${tu.taskStatus == 'PendingTesting'}">
                                        <span class="badge bg-warning text-dark">Pending Review</span>
                                    </c:when>
                                    <c:when test="${tu.taskStatus == 'Completed'}">
                                        <span class="badge bg-success">Completed</span>
                                    </c:when>
                                    <c:when test="${tu.taskStatus == 'Defect'}">
                                        <span class="badge bg-danger">Defect</span>
                                    </c:when>
                                </c:choose>
                            </td>
                            <td class="text-white">
                                <c:choose>
                                    <c:when test="${not empty tu.utilizedHours}">
                                        <c:set var="totalMinutes" value="${tu.utilizedHours}" />
                                        <c:choose>
                                            <c:when test="${totalMinutes < 60}">
                                                ${totalMinutes} min
                                            </c:when>
                                            <c:otherwise>
                                                <fmt:formatNumber value="${totalMinutes / 60}" maxFractionDigits="1" /> hrs
                                            </c:otherwise>
                                        </c:choose>
                                    </c:when>
                                    <c:otherwise>0 hrs</c:otherwise>
                                </c:choose>
                            </td>
                            <td class="text-secondary">
                                <c:choose>
                                    <c:when test="${not empty formattedDates[tu.taskUserId]}">
                                        ${formattedDates[tu.taskUserId]}
                                    </c:when>
                                    <c:otherwise>-</c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <div class="d-flex gap-2">
                                    <a href="viewTaskDeveloper/${task.taskId}" class="btn btn-sm btn-primary">
                                        <i class="bi bi-eye"></i> View
                                    </a>
                                    <!-- ✅ UPDATE BUTTON VISIBLE FOR ALL TASKS EXCEPT COMPLETED -->
                                    <c:if test="${tu.taskStatus != 'Completed' && tu.taskStatus != 'Verified'}">
                                        <a href="updateTaskStatusDeveloper/${tu.taskUserId}" class="btn btn-sm btn-warning">
                                            <i class="bi bi-pencil"></i> Update
                                        </a>
                                    </c:if>
                                    <!-- Show message for completed tasks -->
                                    <c:if test="${tu.taskStatus == 'Completed'}">
                                        <span class="badge bg-success px-3 py-2">
                                            <i class="bi bi-check-circle"></i> Done
                                        </span>
                                    </c:if>
                                </div>
                            </td>
                         </tr>
                    </c:forEach>
                    
                    <c:if test="${empty taskList}">
                         <tr>
                            <td colspan="8" class="text-center text-secondary py-5">
                                <i class="bi bi-inbox fs-1 d-block mb-3"></i>
                                <h5>No tasks available</h5>
                                <p class="small">Tasks will appear here once assigned by PM</p>
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
                            <a class="page-link bg-dark text-white border-secondary" href="?status=${statusFilter}&page=1&size=${pageSize}">
                                <i class="bi bi-chevron-double-left"></i>
                            </a>
                        </li>
                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                            <a class="page-link bg-dark text-white border-secondary" href="?status=${statusFilter}&page=${currentPage-1}&size=${pageSize}">
                                <i class="bi bi-chevron-left"></i>
                            </a>
                        </li>
                        
                        <c:forEach begin="${currentPage-2 > 0 ? currentPage-2 : 1}" end="${currentPage+2 <= totalPages ? currentPage+2 : totalPages}" var="i">
                            <li class="page-item ${currentPage == i ? 'active' : ''}">
                                <a class="page-link ${currentPage == i ? 'bg-primary border-primary text-white' : 'bg-dark text-white border-secondary'}" 
                                   href="?status=${statusFilter}&page=${i}&size=${pageSize}">
                                    ${i}
                                </a>
                            </li>
                        </c:forEach>
                        
                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                            <a class="page-link bg-dark text-white border-secondary" href="?status=${statusFilter}&page=${currentPage+1}&size=${pageSize}">
                                <i class="bi bi-chevron-right"></i>
                            </a>
                        </li>
                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                            <a class="page-link bg-dark text-white border-secondary" href="?status=${statusFilter}&page=${totalPages}&size=${pageSize}">
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
</main>

<script>
function filterTable() {
    const input = document.getElementById("searchInput").value.toLowerCase();
    const table = document.getElementById("taskTable");
    const rows = table.getElementsByTagName("tr");

    for (let i = 1; i < rows.length; i++) {
        const rowText = rows[i].innerText.toLowerCase();
        rows[i].style.display = rowText.indexOf(input) > -1 ? "" : "none";
    }
}

function changePageSize() {
    const size = document.getElementById("pageSizeSelect").value;
    window.location.href = "?status=${statusFilter}&page=1&size=" + size;
}
</script>

<style>
.page-item.active .page-link {
    background-color: var(--primary-color) !important;
    border-color: var(--primary-color) !important;
    color: white !important;
}
.page-link:hover:not(.disabled) {
    background-color: rgba(99, 102, 241, 0.2) !important;
    border-color: var(--primary-color) !important;
    color: white !important;
}
</style>

<jsp:include page="DeveloperFooter.jsp" />