<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="pageTitle" value="Module Tasks - ${module.moduleName}" scope="request" />
<c:set var="activeNav" value="modules" scope="request" />

<jsp:include page="ProjectManagerHeader.jsp" />
<jsp:include page="ProjectManagerSidebar.jsp" />

<main class="main-content" id="mainContent">
    <!-- Header Section with Back Button and Title -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <a href="../projectModules/${module.projectId}" class="text-decoration-none text-secondary">
                <i class="bi bi-arrow-left-circle me-1"></i> Back to Modules
            </a>
            <h1 class="h2 text-white mt-2 mb-0">
                <i class="bi bi-list-task me-2" style="color: var(--primary-color);"></i>
                Tasks
            </h1>
            <p class="text-secondary mt-1">Manage tasks in <strong class="text-primary">${module.moduleName}</strong></p>
        </div>
        <div>
            <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#addTaskModal">
                <i class="bi bi-plus-circle me-2"></i>Create Task
            </button>
        </div>
    </div>

    <!-- Stats Cards -->
    <div class="row g-3 mb-4">
        <div class="col-md-3">
            <div class="glass-card p-3 text-center">
                <div class="text-secondary small">Total Tasks</div>
                <div class="text-white fs-2 fw-bold">${taskCount}</div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="glass-card p-3 text-center">
                <div class="text-secondary small">In Progress</div>
                <div class="text-primary fs-2 fw-bold">${inProgressTaskCount}</div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="glass-card p-3 text-center">
                <div class="text-secondary small">Completed</div>
                <div class="text-success fs-2 fw-bold">${completedTaskCount}</div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="glass-card p-3 text-center">
                <div class="text-secondary small">Defects</div>
                <div class="text-danger fs-2 fw-bold">${defectTaskCount}</div>
            </div>
        </div>
    </div>

    <div class="glass-card p-4">
        <!-- Search and Filter Section -->
        <div class="d-flex justify-content-between align-items-center flex-wrap gap-3 mb-4">
            <div class="d-flex gap-2">
                <div class="input-group" style="width: 280px;">
                    <span class="input-group-text bg-transparent border-secondary text-secondary">
                        <i class="bi bi-search"></i>
                    </span>
                    <input type="text" id="searchInput" 
                           class="form-control bg-transparent text-white border-secondary"
                           placeholder="Search tasks..." onkeyup="filterTable()">
                </div>
                <select id="statusFilter" class="form-select bg-dark text-white border-secondary" style="width: 140px;">
                    <option value="all">All Status</option>
                    <option value="Assigned">Assigned</option>
                    <option value="InProgress">In Progress</option>
                    <option value="PendingTesting">Pending Review</option>
                    <option value="Completed">Completed</option>
                    <option value="Defect">Defect</option>
                </select>
            </div>
            <div class="d-flex gap-2 align-items-center">
                <span class="text-secondary small">
                    <i class="bi bi-info-circle me-1"></i>
                    ${pageSize * (currentPage - 1) + 1} - ${pageSize * currentPage > totalItems ? totalItems : pageSize * currentPage} of ${totalItems}
                </span>
                <select id="pageSizeSelect" class="form-select bg-dark text-white border-secondary" 
                        style="width: auto;" onchange="changePageSize()">
                    <option value="5" ${pageSize == 5 ? 'selected' : ''}>5</option>
                    <option value="10" ${pageSize == 10 ? 'selected' : ''}>10</option>
                    <option value="20" ${pageSize == 20 ? 'selected' : ''}>20</option>
                    <option value="50" ${pageSize == 50 ? 'selected' : ''}>50</option>
                </select>
                <span class="text-secondary small">per page</span>
            </div>
        </div>

        <!-- Tasks Table -->
        <div class="table-responsive">
            <table class="table table-hover mb-0" id="taskTable">
                <thead>
                    <tr class="text-secondary">
                        <th style="width: 60px;">#</th>
                        <th>Task Name</th>
                        <th>Description</th>
                        <th style="width: 120px;">Status</th>
                        <th style="width: 100px;">Est. Hours</th>
                        <th style="width: 120px;">Actions</th>
                     </tr>
                </thead>
                <tbody>
                    <c:forEach var="task" items="${taskList}" varStatus="status">
                        <tr>
                            <td class="text-white">${status.index + 1 + (currentPage-1)*pageSize}</td>
                            <td class="text-white fw-medium">${task.title}</td>
                            <td class="text-white-50">
                                ${fn:substring(task.description, 0, 50)}${fn:length(task.description) > 50 ? '...' : ''}
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${task.status == 'Assigned'}">
                                        <span class="badge bg-info">Assigned</span>
                                    </c:when>
                                    <c:when test="${task.status == 'InProgress'}">
                                        <span class="badge bg-primary">In Progress</span>
                                    </c:when>
                                    <c:when test="${task.status == 'PendingTesting'}">
                                        <span class="badge bg-warning text-dark">Pending Review</span>
                                    </c:when>
                                    <c:when test="${task.status == 'Completed'}">
                                        <span class="badge bg-success">Completed</span>
                                    </c:when>
                                    <c:when test="${task.status == 'Defect'}">
                                        <span class="badge bg-danger">Defect</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-secondary">${task.status}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="text-white">${task.estimatedHours} hrs</td>
                            <td>
                                <div class="btn-group btn-group-sm">
                                    <a href="../viewTaskPM/${task.taskId}" class="btn btn-primary" title="View">
                                        <i class="bi bi-eye"></i>
                                    </a>
                                    <a href="../editTaskPM/${task.taskId}" class="btn btn-warning" title="Edit">
                                        <i class="bi bi-pencil"></i>
                                    </a>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty taskList}">
                        <tr>
                            <td colspan="6" class="text-center text-secondary py-5">
                                <i class="bi bi-inbox fs-1 d-block mb-3"></i>
                                <h5>No tasks found</h5>
                                <button class="btn btn-primary mt-3" data-bs-toggle="modal" data-bs-target="#addTaskModal">
                                    <i class="bi bi-plus-circle me-2"></i>Create your first task
                                </button>
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
        
        <!-- Pagination -->
        <c:if test="${totalItems > 0}">
            <div class="d-flex justify-content-between align-items-center mt-4">
                <div class="text-secondary small">
                    Showing ${pageSize * (currentPage - 1) + 1} to ${pageSize * currentPage > totalItems ? totalItems : pageSize * currentPage} of ${totalItems} entries
                </div>
                <nav>
                    <ul class="pagination pagination-sm mb-0">
                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                            <a class="page-link bg-dark text-white border-secondary" href="?page=1&size=${pageSize}">
                                <i class="bi bi-chevron-double-left"></i>
                            </a>
                        </li>
                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                            <a class="page-link bg-dark text-white border-secondary" href="?page=${currentPage-1}&size=${pageSize}">
                                <i class="bi bi-chevron-left"></i>
                            </a>
                        </li>
                        <c:forEach begin="${currentPage-2 > 0 ? currentPage-2 : 1}" 
                                   end="${currentPage+2 <= totalPages ? currentPage+2 : totalPages}" var="i">
                            <li class="page-item ${currentPage == i ? 'active' : ''}">
                                <a class="page-link ${currentPage == i ? 'bg-primary border-primary text-white' : 'bg-dark text-white border-secondary'}" 
                                   href="?page=${i}&size=${pageSize}">
                                    ${i}
                                </a>
                            </li>
                        </c:forEach>
                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                            <a class="page-link bg-dark text-white border-secondary" href="?page=${currentPage+1}&size=${pageSize}">
                                <i class="bi bi-chevron-right"></i>
                            </a>
                        </li>
                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                            <a class="page-link bg-dark text-white border-secondary" href="?page=${totalPages}&size=${pageSize}">
                                <i class="bi bi-chevron-double-right"></i>
                            </a>
                        </li>
                    </ul>
                </nav>
            </div>
        </c:if>
    </div>
</main>

<!-- Add Task Modal -->
<div class="modal fade" id="addTaskModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content bg-dark text-white border-secondary">
            <div class="modal-header border-secondary">
                <h5 class="modal-title">
                    <i class="bi bi-plus-square-fill me-2 text-success"></i>Create New Task
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <form action="../saveTaskPM" method="post">
                <div class="modal-body">
                    <input type="hidden" name="moduleId" value="${module.moduleId}">
                    <input type="hidden" name="projectId" value="${module.projectId}">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label text-secondary">Task Name <span class="text-danger">*</span></label>
                            <input type="text" name="title" class="form-control bg-transparent text-white border-secondary" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label text-secondary">Status <span class="text-danger">*</span></label>
                            <select name="status" class="form-select bg-dark text-white border-secondary" required>
                                <option value="Assigned">Assigned</option>
                                <option value="InProgress">In Progress</option>
                                <option value="PendingTesting">Pending Testing</option>
                                <option value="Completed">Completed</option>
                                <option value="Defect">Defect</option>
                            </select>
                        </div>
                        <div class="col-12">
                            <label class="form-label text-secondary">Description</label>
                            <textarea name="description" class="form-control bg-transparent text-white border-secondary" rows="3"></textarea>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label text-secondary">Document URL</label>
                            <input type="url" name="docURL" class="form-control bg-transparent text-white border-secondary">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label text-secondary">Estimated Hours <span class="text-danger">*</span></label>
                            <input type="number" name="estimatedHours" class="form-control bg-transparent text-white border-secondary" required>
                        </div>
                    </div>
                </div>
                <div class="modal-footer border-secondary">
                    <button type="submit" class="btn btn-success">Create Task</button>
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
function filterTable() {
    const input = document.getElementById("searchInput").value.toLowerCase();
    const statusFilter = document.getElementById("statusFilter").value;
    const table = document.getElementById("taskTable");
    const rows = table.getElementsByTagName("tr");
    
    for (let i = 1; i < rows.length; i++) {
        const row = rows[i];
        const text = row.innerText.toLowerCase();
        const statusCell = row.cells[3]?.innerText || "";
        let show = text.indexOf(input) > -1;
        
        if (statusFilter !== "all") {
            show = show && statusCell.includes(statusFilter);
        }
        
        row.style.display = show ? "" : "none";
    }
}

function changePageSize() {
    const size = document.getElementById("pageSizeSelect").value;
    window.location.href = "?page=1&size=" + size;
}

document.getElementById("statusFilter")?.addEventListener("change", filterTable);
</script>

<style>
.page-item.active .page-link {
    background-color: var(--primary-color) !important;
    border-color: var(--primary-color) !important;
    color: white !important;
}
.btn-group-sm .btn {
    padding: 0.25rem 0.5rem;
    font-size: 0.75rem;
}
</style>

<jsp:include page="ProjectManagerFooter.jsp" />