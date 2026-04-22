<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="pageTitle" value="Project Manager Assignment" scope="request" />
<c:set var="activeNav" value="projectUser" scope="request" />

<jsp:include page="adminheader.jsp" />
<jsp:include page="adminsidebar.jsp" />

<main class="main-content" id="mainContent">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h1 class="h2 text-white mb-0">
                <i class="bi bi-person-badge me-2" style="color: var(--primary-color);"></i>Project Manager Assignment
            </h1>
            <p class="text-secondary mt-1">Assign project managers to projects</p>
        </div>
        <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#assignModal">
            <i class="bi bi-plus-circle me-2"></i>Assign Manager
        </button>
    </div>

    <!-- Search and Items Info -->
    <div class="mb-4 d-flex justify-content-between align-items-center flex-wrap gap-3">
        <div class="text-secondary">
            <i class="bi bi-info-circle me-1"></i>
            Showing 
            <span class="text-white fw-bold">${(currentPage - 1) * pageSize + 1}</span> - 
            <span class="text-white fw-bold">${currentPage * pageSize > totalItems ? totalItems : currentPage * pageSize}</span> 
            of <span class="text-white fw-bold">${totalItems}</span> assignments
            <c:if test="${not empty searchTerm}">
                <span class="ms-2">
                    <span class="badge bg-info">Search: "${searchTerm}"</span>
                    <a href="?page=1&size=${pageSize}" class="text-decoration-none ms-1 text-warning">
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
                           placeholder="Search by project or manager..." 
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

    <!-- Assignments Table -->
    <div class="glass-card p-4">
        <div class="table-responsive">
            <table class="table table-hover mb-0">
                <thead>
                    <tr class="text-secondary">
                        <th style="width: 5%">#</th>
                        <th style="width: 25%">Project</th>
                        <th style="width: 25%">Project Manager</th>
                        <th style="width: 15%">Project Status</th>
                        <th style="width: 15%">Assign Status</th>
                        <th style="width: 15%">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="pu" items="${projectUserList}" varStatus="loop">
                        <c:set var="matchedProject" value="${null}" />
                        <c:forEach var="p" items="${projectList}">
                            <c:if test="${p.projectId == pu.projectId}">
                                <c:set var="matchedProject" value="${p}" />
                            </c:if>
                        </c:forEach>
                        <c:set var="managerName" value="" />
                        <c:forEach var="u" items="${userList}">
                            <c:if test="${u.userId == pu.userId}">
                                <c:set var="managerName" value="${u.first_name} ${u.last_name}" />
                            </c:if>
                        </c:forEach>
                        
                        <c:choose>
                            <c:when test="${empty matchedProject}">
                                <!-- Orphaned record: project no longer exists -->
                                <tr style="border-bottom: 1px solid rgba(255,255,255,0.1); background-color: rgba(255,100,0,0.1);">
                                    <td class="text-white">${loop.index + 1 + (currentPage-1)*pageSize}</td>
                                    <td colspan="5" class="text-warning">
                                        <i class="bi bi-exclamation-triangle me-2"></i>
                                        Project ID ${pu.projectId} no longer exists (orphaned assignment)
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <!-- Resolve status name from projectStatusList -->
                                <c:set var="statusName" value="-" />
                                <c:forEach var="ps" items="${projectStatusList}">
                                    <c:if test="${ps.projectStatusId == matchedProject.projectStatusId}">
                                        <c:set var="statusName" value="${ps.status}" />
                                    </c:if>
                                </c:forEach>
                                <tr style="border-bottom: 1px solid rgba(255,255,255,0.1);">
                                    <td class="text-white">${loop.index + 1 + (currentPage-1)*pageSize}</td>
                                    <td class="text-white fw-medium">${matchedProject.title}</td>
                                    <td class="text-white">${managerName}</td>
                                    <td>
                                        <span class="badge 
                                            <c:choose>
                                                <c:when test="${statusName == 'Lead'}">bg-purple</c:when>
                                                <c:when test="${statusName == 'NotStarted'}">bg-secondary</c:when>
                                                <c:when test="${statusName == 'InProgress'}">bg-primary</c:when>
                                                <c:when test="${statusName == 'Hold'}">bg-warning text-dark</c:when>
                                                <c:when test="${statusName == 'Completed'}">bg-success</c:when>
                                                <c:otherwise>bg-secondary</c:otherwise>
                                            </c:choose>
                                        ">${statusName}</span>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${pu.assignStatus == 1}">
                                                <span class="badge bg-success">Active</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-danger">Revoked</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div class="btn-group btn-group-sm" role="group">
                                            <a href="viewProjectUser/${pu.projectUserId}" class="btn btn-primary">
                                                <i class="bi bi-eye"></i>
                                            </a>
                                            <a href="editProjectUser/${pu.projectUserId}" class="btn btn-warning">
                                                <i class="bi bi-pencil"></i>
                                            </a>
                                            <a href="deleteProjectUser/${pu.projectUserId}" class="btn btn-danger" 
                                               onclick="return confirm('Delete this assignment? This will also remove the manager from all project tasks.')">
                                                <i class="bi bi-trash"></i>
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>
                    
                    <c:if test="${empty projectUserList}">
                        <tr>
                            <td colspan="6" class="text-center text-secondary py-5">
                                <i class="bi bi-inbox fs-1 d-block mb-3"></i>
                                <h5>No assignments found</h5>
                                <c:if test="${not empty searchTerm}">
                                    <p class="mt-2">No assignments matching "<strong class="text-info">${searchTerm}</strong>"</p>
                                    <a href="?page=1&size=${pageSize}" class="btn btn-sm btn-outline-primary mt-2">
                                        <i class="bi bi-x-circle"></i> Clear Search
                                    </a>
                                </c:if>
                                <c:if test="${empty searchTerm}">
                                    <button class="btn btn-sm btn-success mt-2" data-bs-toggle="modal" data-bs-target="#assignModal">
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

    <!-- Assign Modal (only unassigned projects shown) -->
    <div class="modal fade" id="assignModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content bg-dark text-white border-secondary">
                <div class="modal-header border-secondary">
                    <h5 class="modal-title">
                        <i class="bi bi-person-plus-fill me-2 text-primary"></i> Assign Manager to Project
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <form action="${pageContext.request.contextPath}/saveProjectUser" method="post">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label text-secondary">Project <span class="text-danger">*</span></label>
                            <select name="projectId" class="form-select bg-dark text-white border-secondary" required>
                                <option value="" disabled selected>-- Select Project --</option>
                                <c:forEach var="p" items="${unassignedProjects}">
                                    <option value="${p.projectId}">${p.title}</option>
                                </c:forEach>
                            </select>
                            <small class="text-secondary">
                                Only projects without a manager appear here.
                                <c:if test="${empty unassignedProjects}">
                                    <span class="text-warning"> All projects already have a manager.</span>
                                </c:if>
                            </small>
                        </div>
                        <div class="mb-3">
                            <label class="form-label text-secondary">Project Manager <span class="text-danger">*</span></label>
                            <select name="userId" class="form-select bg-dark text-white border-secondary" required>
                                <option value="" disabled selected>-- Select Manager --</option>
                                <c:forEach var="u" items="${userList}">
                                    <option value="${u.userId}">${u.first_name} ${u.last_name} (${u.email})</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label text-secondary">Assignment Status</label>
                            <select name="assignStatus" class="form-select bg-dark text-white border-secondary">
                                <option value="1">Active</option>
                                <option value="0">Revoked</option>
                            </select>
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
.glass-card {
    background: rgba(255, 255, 255, 0.05);
    backdrop-filter: blur(10px);
    border-radius: 12px;
    border: 1px solid rgba(255, 255, 255, 0.1);
    transition: all 0.3s ease;
}

.page-item.active .page-link {
    background-color: var(--primary-color) !important;
    border-color: var(--primary-color) !important;
    color: white !important;
}

.table-hover tbody tr:hover {
    background-color: rgba(255, 255, 255, 0.05);
}

.btn-group-sm > .btn {
    padding: 0.25rem 0.5rem;
    font-size: 0.75rem;
}

.bg-purple {
    background-color: #6f42c1 !important;
    color: white !important;
}
</style>