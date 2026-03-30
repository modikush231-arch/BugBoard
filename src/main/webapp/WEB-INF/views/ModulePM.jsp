<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="pageTitle" value="Module Management" scope="request" />
<c:set var="activeNav" value="modules" scope="request" />

<jsp:include page="ProjectManagerHeader.jsp" />
<jsp:include page="ProjectManagerSidebar.jsp" />

<main class="main-content" id="mainContent">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h1 class="h2 text-white mb-0">
                <i class="bi bi-collection me-2" style="color: var(--primary-color);"></i>Module Management
            </h1>
            <p class="text-secondary mt-1">Manage modules within your projects</p>
        </div>
        <div class="d-flex gap-2">
            <button class="btn btn-outline-secondary text-white" onclick="location.reload()">
                <i class="bi bi-arrow-clockwise"></i>
            </button>
        </div>
    </div>

    <!-- Status Filter Cards -->
    <div class="row mb-4 g-3">
        <div class="col-md-3">
            <div class="glass-card p-3 ${statusFilter == 'all' ? 'border-primary' : ''}" 
                 style="cursor: pointer;" onclick="location.href='?status=all&page=1&size=${pageSize}'">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <div class="text-secondary small">All Modules</div>
                        <div class="text-white fs-3 fw-bold">${totalCount}</div>
                    </div>
                    <i class="bi bi-list-ul fs-1 text-secondary"></i>
                </div>
            </div>
        </div>
        <div class="col-md-3">
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
        <div class="col-md-3">
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
        <div class="col-md-3">
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
    </div>

    <!-- Search and Items Info -->
    <div class="mb-4 d-flex justify-content-between align-items-center flex-wrap gap-3">
        <div class="text-secondary">
            <i class="bi bi-info-circle me-1"></i>
            Showing 
            <span class="text-white fw-bold">${pageSize * (currentPage - 1) + 1}</span> - 
            <span class="text-white fw-bold">${pageSize * currentPage > totalItems ? totalItems : pageSize * currentPage}</span> 
            of <span class="text-white fw-bold">${totalItems}</span> modules
        </div>
        <div class="d-flex gap-3">
            <div class="input-group" style="width: 250px;">
                <span class="input-group-text bg-transparent border-secondary text-secondary">
                    <i class="bi bi-search"></i>
                </span>
                <input type="text" id="searchInput" 
                       class="form-control bg-transparent text-white border-secondary"
                       placeholder="Search modules..." onkeyup="filterTable()">
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

    <div class="mb-4 text-end">
        <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#moduleModal">
            <i class="bi bi-plus-circle me-2"></i>Add New Module
        </button>
    </div>

    <!-- Modules Table -->
    <div class="glass-card p-4">
        <div class="table-responsive">
            <table class="table table-hover mb-0" id="moduleTable">
                <thead>
                    <tr class="text-secondary">
                        <th>#</th>
                        <th>Module Name</th>
                        <th>Project</th>
                        <th>Description</th>
                        <th>Status</th>
                        <th>Tasks</th>
                        <th>Est. Hours</th>
                        <th>Actions</th>
                     </tr>
                </thead>
                <tbody>
                    <c:forEach var="module" items="${moduleList}" varStatus="status">
                         <tr>
                            <td class="text-white">${status.index + 1 + (currentPage-1)*pageSize}</td>
                            <td class="text-white fw-medium">${module.moduleName}</td>
                            <td class="text-white">
                                <c:forEach var="p" items="${projectList}">
                                    <c:if test="${p.projectId == module.projectId}">${p.title}</c:if>
                                </c:forEach>
                            </td>
                            <td class="text-white-50">
                                ${fn:substring(module.description, 0, 40)}${fn:length(module.description) > 40 ? '...' : ''}
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${module.status == 'InProgress'}">
                                        <span class="badge bg-primary">In Progress</span>
                                    </c:when>
                                    <c:when test="${module.status == 'Completed'}">
                                        <span class="badge bg-success">Completed</span>
                                    </c:when>
                                    <c:when test="${module.status == 'PendingTesting'}">
                                        <span class="badge bg-warning text-dark">Pending Review</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-secondary">${module.status}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="text-white">
                                <a href="moduleTasks/${module.moduleId}" class="btn btn-sm btn-info">
                                    <i class="bi bi-list-task"></i> ${module.taskCount != null ? module.taskCount : 0} Tasks
                                </a>
                            </td>
                            <td class="text-white">${module.estimatedHours} hrs</td>
                            <td>
                                <div class="d-flex gap-2">
                                    <a href="viewModulePM/${module.moduleId}" class="btn btn-sm btn-primary">
                                        <i class="bi bi-eye"></i>
                                    </a>
                                    <a href="editModulePM/${module.moduleId}" class="btn btn-sm btn-warning">
                                        <i class="bi bi-pencil"></i>
                                    </a>
                                    <a href="moduleTasks/${module.moduleId}" class="btn btn-sm btn-info">
                                        <i class="bi bi-list-task"></i>
                                    </a>
                                </div>
                            </td>
                         </tr>
                    </c:forEach>
                    <c:if test="${empty moduleList}">
                         <tr>
                            <td colspan="8" class="text-center text-secondary py-5">
                                <i class="bi bi-inbox fs-1 d-block mb-3"></i>
                                <h5>No modules found</h5>
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
                               href="?status=${statusFilter}&page=1&size=${pageSize}">
                                <i class="bi bi-chevron-double-left"></i>
                            </a>
                        </li>
                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                            <a class="page-link bg-dark text-white border-secondary" 
                               href="?status=${statusFilter}&page=${currentPage-1}&size=${pageSize}">
                                <i class="bi bi-chevron-left"></i>
                            </a>
                        </li>
                        <c:forEach begin="${currentPage-2 > 0 ? currentPage-2 : 1}" 
                                   end="${currentPage+2 <= totalPages ? currentPage+2 : totalPages}" var="i">
                            <li class="page-item ${currentPage == i ? 'active' : ''}">
                                <a class="page-link ${currentPage == i ? 'bg-primary border-primary text-white' : 'bg-dark text-white border-secondary'}" 
                                   href="?status=${statusFilter}&page=${i}&size=${pageSize}">
                                    ${i}
                                </a>
                            </li>
                        </c:forEach>
                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                            <a class="page-link bg-dark text-white border-secondary" 
                               href="?status=${statusFilter}&page=${currentPage+1}&size=${pageSize}">
                                <i class="bi bi-chevron-right"></i>
                            </a>
                        </li>
                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                            <a class="page-link bg-dark text-white border-secondary" 
                               href="?status=${statusFilter}&page=${totalPages}&size=${pageSize}">
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

<!-- Add Module Modal -->
<div class="modal fade" id="moduleModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content bg-dark text-white border-secondary">
            <div class="modal-header border-secondary">
                <h5 class="modal-title">
                    <i class="bi bi-collection-fill me-2 text-success"></i>Add New Module
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <form action="saveModulePM" method="post">
                <div class="modal-body">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label text-secondary">Module Name *</label>
                            <input type="text" name="moduleName" 
                                   class="form-control bg-transparent text-white border-secondary" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label text-secondary">Project *</label>
                            <select name="projectId" class="form-select bg-dark text-white border-secondary" required>
                                <option value="">Select Project</option>
                                <c:forEach var="p" items="${projectList}">
                                    <option value="${p.projectId}">${p.title}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-12">
                            <label class="form-label text-secondary">Description</label>
                            <textarea name="description" 
                                      class="form-control bg-transparent text-white border-secondary" rows="3"></textarea>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label text-secondary">Document URL</label>
                            <input type="url" name="docURL" 
                                   class="form-control bg-transparent text-white border-secondary">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label text-secondary">Status *</label>
                            <select name="status" class="form-select bg-dark text-white border-secondary" required>
                                <option value="">Select Status</option>
                                <option value="Assigned">Assigned</option>
                                <option value="InProgress">In Progress</option>
                                <option value="PendingTesting">Pending Testing</option>
                                <option value="Completed">Completed</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label text-secondary">Estimated Hours</label>
                            <input type="number" name="estimatedHours" 
                                   class="form-control bg-transparent text-white border-secondary" required>
                        </div>
                    </div>
                </div>
                <div class="modal-footer border-secondary">
                    <button type="submit" class="btn btn-success">
                        <i class="bi bi-check-circle me-2"></i>Save Module
                    </button>
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                        <i class="bi bi-x-circle me-2"></i>Cancel
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="ProjectManagerFooter.jsp" />

<script>
function filterTable() {
    const input = document.getElementById("searchInput").value.toLowerCase();
    const table = document.getElementById("moduleTable");
    const rows = table.getElementsByTagName("tr");
    for (let i = 1; i < rows.length; i++) {
        rows[i].style.display = rows[i].innerText.toLowerCase().indexOf(input) > -1 ? "" : "none";
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
</style>