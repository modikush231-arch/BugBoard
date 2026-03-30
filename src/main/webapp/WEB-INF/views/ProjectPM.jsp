<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="pageTitle" value="Project Management" scope="request" />
<c:set var="activeNav" value="projects" scope="request" />

<jsp:include page="ProjectManagerHeader.jsp" />
<jsp:include page="ProjectManagerSidebar.jsp" />

<main class="main-content" id="mainContent">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h1 class="h2 text-white mb-0">
                <i class="bi bi-kanban me-2" style="color: var(--primary-color);"></i>Project Management
            </h1>
            <p class="text-secondary mt-1">Manage and track your projects</p>
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
                        <div class="text-secondary small">All Projects</div>
                        <div class="text-white fs-3 fw-bold">${totalCount}</div>
                    </div>
                    <i class="bi bi-list-ul fs-1 text-secondary"></i>
                </div>
            </div>
        </div>
        <div class="col-md-2">
            <div class="glass-card p-3 ${statusFilter == '1' ? 'border-purple' : ''}" 
                 style="cursor: pointer;" onclick="location.href='?status=1&page=1&size=${pageSize}'">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <div class="text-secondary small">Lead</div>
                        <div class="text-white fs-3 fw-bold">${leadCount}</div>
                    </div>
                    <i class="bi bi-star fs-1 text-purple"></i>
                </div>
            </div>
        </div>
        <div class="col-md-2">
            <div class="glass-card p-3 ${statusFilter == '2' ? 'border-secondary' : ''}" 
                 style="cursor: pointer;" onclick="location.href='?status=2&page=1&size=${pageSize}'">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <div class="text-secondary small">Not Started</div>
                        <div class="text-white fs-3 fw-bold">${notStartedCount}</div>
                    </div>
                    <i class="bi bi-hourglass-split fs-1 text-secondary"></i>
                </div>
            </div>
        </div>
        <div class="col-md-2">
            <div class="glass-card p-3 ${statusFilter == '4' ? 'border-primary' : ''}" 
                 style="cursor: pointer;" onclick="location.href='?status=4&page=1&size=${pageSize}'">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <div class="text-secondary small">In Progress</div>
                        <div class="text-white fs-3 fw-bold">${progressCount}</div>
                    </div>
                    <i class="bi bi-play-circle fs-1 text-primary"></i>
                </div>
            </div>
        </div>
        <div class="col-md-2">
            <div class="glass-card p-3 ${statusFilter == '3' ? 'border-warning' : ''}" 
                 style="cursor: pointer;" onclick="location.href='?status=3&page=1&size=${pageSize}'">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <div class="text-secondary small">Hold</div>
                        <div class="text-white fs-3 fw-bold">${holdCount}</div>
                    </div>
                    <i class="bi bi-pause-circle fs-1 text-warning"></i>
                </div>
            </div>
        </div>
        <div class="col-md-2">
            <div class="glass-card p-3 ${statusFilter == '5' ? 'border-success' : ''}" 
                 style="cursor: pointer;" onclick="location.href='?status=5&page=1&size=${pageSize}'">
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
            of <span class="text-white fw-bold">${totalItems}</span> projects
        </div>
        <div class="d-flex gap-3">
            <div class="input-group" style="width: 250px;">
                <span class="input-group-text bg-transparent border-secondary text-secondary">
                    <i class="bi bi-search"></i>
                </span>
                <input type="text" id="searchInput" 
                       class="form-control bg-transparent text-white border-secondary"
                       placeholder="Search projects..." onkeyup="filterTable()">
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

    <!-- Projects Table -->
    <div class="glass-card p-4">
        <div class="table-responsive">
            <table class="table table-hover mb-0" id="projectTable">
                <thead>
                    <tr class="text-secondary">
                        <th>#</th>
                        <th>Project Name</th>
                        <th>Description</th>
                        <th>Status</th>
                        <th>Modules</th>
                        <th>Tasks</th>
                        <th>Progress</th>
                        <th>Actions</th>
                     </tr>
                </thead>
                <tbody>
                    <c:forEach var="project" items="${projectList}" varStatus="status">
                        <!-- Count Modules for this Project -->
                        <c:set var="moduleCountForProject" value="0" />
                        <c:forEach var="module" items="${moduleList}">
                            <c:if test="${module.projectId == project.projectId}">
                                <c:set var="moduleCountForProject" value="${moduleCountForProject + 1}" />
                            </c:if>
                        </c:forEach>
                        
                        <!-- Count Tasks for this Project -->
                        <c:set var="taskCountForProject" value="0" />
                        <c:forEach var="task" items="${taskList}">
                            <c:if test="${task.projectId == project.projectId}">
                                <c:set var="taskCountForProject" value="${taskCountForProject + 1}" />
                            </c:if>
                        </c:forEach>
                        
                        <!-- Progress Calculation based on Project Status ID -->
                        <c:set var="progressValue" value="0" />
                        <c:choose>
                            <c:when test="${project.projectStatusId == 1}"><c:set var="progressValue" value="5" /></c:when>
                            <c:when test="${project.projectStatusId == 2}"><c:set var="progressValue" value="10" /></c:when>
                            <c:when test="${project.projectStatusId == 3}"><c:set var="progressValue" value="30" /></c:when>
                            <c:when test="${project.projectStatusId == 4}"><c:set var="progressValue" value="60" /></c:when>
                            <c:when test="${project.projectStatusId == 5}"><c:set var="progressValue" value="100" /></c:when>
                        </c:choose>
                        
                        <tr>
                            <td class="text-white">${status.index + 1 + (currentPage-1)*pageSize}</td>
                            <td class="text-white fw-medium">${project.title}</td>
                            <td class="text-white-50">
                                ${fn:substring(project.description, 0, 50)}${fn:length(project.description) > 50 ? '...' : ''}
                            </td>
                            <td>
                                <c:forEach var="s" items="${statusList}">
                                    <c:if test="${s.projectStatusId == project.projectStatusId}">
                                        <span class="badge 
                                            <c:choose>
                                                <c:when test="${s.status == 'Lead'}">bg-purple</c:when>
                                                <c:when test="${s.status == 'NotStarted'}">bg-secondary</c:when>
                                                <c:when test="${s.status == 'InProgress'}">bg-primary</c:when>
                                                <c:when test="${s.status == 'Hold'}">bg-warning text-dark</c:when>
                                                <c:when test="${s.status == 'Completed'}">bg-success</c:when>
                                            </c:choose>
                                        ">${s.status}</span>
                                    </c:if>
                                </c:forEach>
                            </td>
                            <td class="text-white">
                                <a href="projectModules/${project.projectId}" class="btn btn-sm btn-info">
                                    <i class="bi bi-collection"></i> ${moduleCountForProject} Modules
                                </a>
                            </td>
                            <td class="text-white">${taskCountForProject}</td>
                            <td style="min-width: 100px;">
                                <div class="d-flex align-items-center">
                                    <div class="progress flex-grow-1 me-2" style="height:6px;">
                                        <div class="progress-bar 
                                            <c:choose>
                                            
                                                <c:when test="${progressValue == 100}">bg-success</c:when>
                                                <c:when test="${progressValue >= 60}">bg-primary</c:when>
                                                <c:when test="${progressValue >= 30}">bg-warning</c:when>
                                                <c:when test="${progressValue >= 10}">bg-secondary</c:when>
                                                <c:when test="${progressValue >= 5}">bg-purple</c:when>  
                                            </c:choose>
                                        " style="width: ${progressValue}%"></div>
                                    </div>
                                    <span class="small text-secondary">${progressValue}%</span>
                                </div>
                            </td>
                            <td>
                                <div class="d-flex gap-2">
                                    <a href="viewProjectPM/${project.projectId}" class="btn btn-sm btn-primary" title="View Project">
                                        <i class="bi bi-eye"></i>
                                    </a>
                                    <a href="editProjectPM/${project.projectId}" class="btn btn-sm btn-warning" title="Edit Project">
                                        <i class="bi bi-pencil"></i>
                                    </a>
                                    <a href="projectModules/${project.projectId}" class="btn btn-sm btn-info" title="View Modules">
                                        <i class="bi bi-collection"></i>
                                    </a>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty projectList}">
                        <tr>
                            <td colspan="8" class="text-center text-secondary py-5">
                                <i class="bi bi-inbox fs-1 d-block mb-3"></i>
                                <h5>No projects found</h5>
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

<jsp:include page="ProjectManagerFooter.jsp" />

<script>
function filterTable() {
    const input = document.getElementById("searchInput").value.toLowerCase();
    const table = document.getElementById("projectTable");
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
.bg-purple { background-color: #a855f7 !important; color: white; }
</style>