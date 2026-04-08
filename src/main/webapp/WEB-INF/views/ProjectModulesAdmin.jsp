<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="pageTitle" value="Project Modules - ${project.title}" scope="request" />
<c:set var="activeNav" value="projects" scope="request" />

<jsp:include page="adminheader.jsp" />
<jsp:include page="adminsidebar.jsp" />

<main class="main-content" id="mainContent">
    <!-- Header Section with Back Button and Title -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <a href="../viewProject/${project.projectId}" class="text-decoration-none text-secondary">
                <i class="bi bi-arrow-left-circle me-1"></i> Back to Project
            </a>
            <h1 class="h2 text-white mt-2 mb-0">
                <i class="bi bi-collection me-2" style="color: var(--primary-color);"></i>
                Modules
            </h1>
            <p class="text-secondary mt-1">Manage modules in <strong class="text-primary">${project.title}</strong></p>
        </div>
        <div>
            <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#addModuleModal">
                <i class="bi bi-plus-circle me-2"></i>Create Module
            </button>
        </div>
    </div>

    <!-- Stats Cards (unchanged) -->
    <div class="row g-3 mb-4">
        <div class="col-md-3">
            <div class="glass-card p-3 text-center">
                <div class="text-secondary small">Total Modules</div>
                <div class="text-white fs-2 fw-bold">${moduleCount}</div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="glass-card p-3 text-center">
                <div class="text-secondary small">In Progress</div>
                <div class="text-primary fs-2 fw-bold">${inProgressCount}</div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="glass-card p-3 text-center">
                <div class="text-secondary small">Completed</div>
                <div class="text-success fs-2 fw-bold">${completedCount}</div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="glass-card p-3 text-center">
                <div class="text-secondary small">Pending Review</div>
                <div class="text-warning fs-2 fw-bold">${pendingCount}</div>
            </div>
        </div>
    </div>

    <div class="glass-card p-4">
        <!-- Search and Filter Section (unchanged) -->
        <div class="d-flex justify-content-between align-items-center flex-wrap gap-3 mb-4">
            <div class="text-secondary">
                <i class="bi bi-info-circle me-1"></i>
                Showing 
                <span class="text-white fw-bold">${pageSize * (currentPage - 1) + 1}</span> - 
                <span class="text-white fw-bold">${pageSize * currentPage > totalItems ? totalItems : pageSize * currentPage}</span> 
                of <span class="text-white fw-bold">${totalItems}</span> modules
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
                               placeholder="Search by module name or description..." 
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

        <!-- Modules Table -->
        <div class="table-responsive">
            <table class="table table-hover mb-0" id="moduleTable">
                <thead>
                    <tr class="text-secondary">
                        <th style="width: 60px;">#</th>
                        <th>Module Name</th>
                        <th>Description</th>
                        <th style="width: 120px;">Status</th>
                        <th style="width: 80px;">Tasks</th>
                        <th style="width: 100px;">Est. Hours</th>
                        <th style="width: 180px;">Actions</th>
                     </tr>
                </thead>
                <tbody>
                    <c:forEach var="module" items="${moduleList}" varStatus="status">
                        <c:set var="taskCountForModule" value="0" />
                        <c:forEach var="task" items="${taskList}">
                            <c:if test="${task.moduleId == module.moduleId}">
                                <c:set var="taskCountForModule" value="${taskCountForModule + 1}" />
                            </c:if>
                        </c:forEach>
                        <tr>
                            <td class="text-white">${status.index + 1 + (currentPage-1)*pageSize}</td>
                            <td class="text-white fw-medium">${module.moduleName}</td>
                            <td class="text-white-50">
                                ${fn:substring(module.description, 0, 50)}${fn:length(module.description) > 50 ? '...' : ''}
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${module.status == 'InProgress'}"><span class="badge bg-primary">In Progress</span></c:when>
                                    <c:when test="${module.status == 'Completed'}"><span class="badge bg-success">Completed</span></c:when>
                                    <c:when test="${module.status == 'PendingTesting'}"><span class="badge bg-warning text-dark">Pending Review</span></c:when>
                                    <c:when test="${module.status == 'Assigned'}"><span class="badge bg-info">Assigned</span></c:when>
                                    <c:otherwise><span class="badge bg-secondary">${module.status}</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <a href="../moduleTasksAdmin/${module.moduleId}" class="btn btn-sm btn-outline-info">
                                    <i class="bi bi-list-task me-1"></i> ${taskCountForModule}
                                </a>
                            </td>
                            <td class="text-white">${module.estimatedHours} hrs</td>
                            <td class="text-center">
                                <div class="btn-group btn-group-sm" role="group">
                                    <a href="../viewModule/${module.moduleId}" class="btn btn-primary" title="View">
                                        <i class="bi bi-eye"></i>
                                    </a>
                                    <a href="../editModule/${module.moduleId}" class="btn btn-warning" title="Edit">
                                        <i class="bi bi-pencil"></i>
                                    </a>
                                    
                                    <a href="../deleteModule/${module.moduleId}?projectId=${project.projectId}" 
                                       class="btn btn-danger" title="Delete"
                                       onclick="return confirm('Delete this module and all its tasks? This action cannot be undone!')">
                                        <i class="bi bi-trash"></i>
                                    </a>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty moduleList}">
                        <tr>
                            <td colspan="7" class="text-center text-secondary py-5">
                                <i class="bi bi-inbox fs-1 d-block mb-3"></i>
                                <h5>No modules found</h5>
                                <c:if test="${not empty searchTerm}">
                                    <p class="mt-2">No modules matching "<strong class="text-info">${searchTerm}</strong>"</p>
                                    <a href="?page=1&size=${pageSize}" class="btn btn-sm btn-outline-primary mt-2">
                                        <i class="bi bi-x-circle"></i> Clear Search
                                    </a>
                                </c:if>
                                <c:if test="${empty searchTerm}">
                                    <button class="btn btn-primary mt-3" data-bs-toggle="modal" data-bs-target="#addModuleModal">
                                        <i class="bi bi-plus-circle me-2"></i>Create your first module
                                    </button>
                                </c:if>
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
        
        <!-- Pagination (preserve search term) -->
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
</main>

<!-- Add Module Modal (unchanged) -->
<div class="modal fade" id="addModuleModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content bg-dark text-white border-secondary">
            <div class="modal-header border-secondary">
                <h5 class="modal-title"><i class="bi bi-collection-fill me-2 text-success"></i>Create New Module</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <form action="saveModule" method="post">
                <div class="modal-body">
                    <input type="hidden" name="projectId" value="${project.projectId}">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label text-secondary">Module Name <span class="text-danger">*</span></label>
                            <input type="text" name="moduleName" class="form-control bg-transparent text-white border-secondary" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label text-secondary">Status <span class="text-danger">*</span></label>
                            <select name="status" class="form-select bg-dark text-white border-secondary" required>
                                <option value="Assigned">Assigned</option>
                                <option value="InProgress">In Progress</option>
                                <option value="PendingTesting">Pending Testing</option>
                                <option value="Completed">Completed</option>
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
                            <label class="form-label text-secondary">Estimated Hours</label>
                            <input type="number" name="estimatedHours" class="form-control bg-transparent text-white border-secondary" required>
                        </div>
                    </div>
                </div>
                <div class="modal-footer border-secondary">
                    <button type="submit" class="btn btn-success">Create Module</button>
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                </div>
            </form>
        </div>
    </div>
</div>

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
.btn-group-sm .btn {
    padding: 0.25rem 0.5rem;
    font-size: 0.75rem;
}
</style>