<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> <!-- CHANGED: added for hour formatting -->

<c:set var="pageTitle" value="Test Tasks" scope="request" />
<c:set var="activeNav" value="testTasks" scope="request" />

<jsp:include page="TesterHeader.jsp" />
<jsp:include page="TesterSidebar.jsp" />

<main class="main-content" id="mainContent">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h1 class="h2 text-white mb-0">
                <i class="bi bi-list-check me-2" style="color: var(--primary-color);"></i>Test Tasks
            </h1>
            <p class="text-secondary mt-1">Review and verify tasks ready for testing</p>
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
                        <div class="text-secondary small">All Tasks</div>
                        <div class="text-white fs-3 fw-bold">${totalCount}</div>
                    </div>
                    <i class="bi bi-list-ul fs-1 text-secondary"></i>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="glass-card p-3 ${statusFilter == 'PendingTesting' ? 'border-warning' : ''}" 
                 style="cursor: pointer;" onclick="location.href='?status=PendingTesting&page=1&size=${pageSize}'">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <div class="text-secondary small">Pending Testing</div>
                        <div class="text-white fs-3 fw-bold">${pendingCount}</div>
                    </div>
                    <i class="bi bi-clock-history fs-1 text-warning"></i>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="glass-card p-3 ${statusFilter == 'Verified' ? 'border-success' : ''}" 
                 style="cursor: pointer;" onclick="location.href='?status=Verified&page=1&size=${pageSize}'">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <div class="text-secondary small">Verified</div>
                        <div class="text-white fs-3 fw-bold">${verifiedCount}</div>
                    </div>
                    <i class="bi bi-check-circle fs-1 text-success"></i>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="glass-card p-3 ${statusFilter == 'Defect' ? 'border-danger' : ''}" 
                 style="cursor: pointer;" onclick="location.href='?status=Defect&page=1&size=${pageSize}'">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <div class="text-secondary small">Defects Found</div>
                        <div class="text-white fs-3 fw-bold">${defectCount}</div>
                    </div>
                    <i class="bi bi-exclamation-triangle fs-1 text-danger"></i>
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
                        <th>Developer</th>
                        <th>Status</th>
                        <th>Hours Worked</th> <!-- CHANGED: was "Test Comment" -->
                        <th>Last Updated</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="tu" items="${taskUserList}" varStatus="status">
                        <c:set var="currentTask" value="" />
                        <c:forEach var="task" items="${taskList}">
                            <c:if test="${task.taskId == tu.taskId}">
                                <c:set var="currentTask" value="${task}" />
                            </c:if>
                        </c:forEach>
                        
                        <c:set var="currentProject" value="" />
                        <c:forEach var="project" items="${projectList}">
                            <c:if test="${project.projectId == currentTask.projectId}">
                                <c:set var="currentProject" value="${project}" />
                            </c:if>
                        </c:forEach>
                        
                        <%-- Get developer name from developerAssignmentMap --%>
                        <c:set var="developerName" value="Not assigned" />
                        <c:set var="devAssignment" value="${developerAssignmentMap[currentTask.taskId]}" />
                        <c:if test="${not empty devAssignment}">
                            <c:forEach var="user" items="${allUsers}">
                                <c:if test="${user.userId == devAssignment.userId}">
                                    <c:set var="developerName" value="${user.first_name} ${user.last_name}" />
                                </c:if>
                            </c:forEach>
                        </c:if>
                        
                        <tr>
                            <td class="text-white">${status.index + 1 + (currentPage-1)*pageSize}</td>
                            <td class="text-white fw-medium">${currentTask.title}</td>
                            <td class="text-white">${currentProject.title}</td>
                            <td class="text-white">
                                <i class="bi bi-person-badge me-1 text-secondary"></i>
                                ${developerName}
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${tu.taskStatus == 'PendingTesting'}">
                                        <span class="badge bg-warning text-dark px-3 py-2">
                                            <i class="bi bi-clock-history me-1"></i>Ready for Testing
                                        </span>
                                    </c:when>
                                    <c:when test="${tu.taskStatus == 'Verified'}">
                                        <span class="badge bg-success px-3 py-2">
                                            <i class="bi bi-check-circle me-1"></i>Verified
                                        </span>
                                    </c:when>
                                    <c:when test="${tu.taskStatus == 'Defect'}">
                                        <span class="badge bg-danger px-3 py-2">
                                            <i class="bi bi-exclamation-triangle me-1"></i>Defect Found
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-secondary px-3 py-2">${tu.taskStatus}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <!-- CHANGED: Show hours worked (utilizedHours stored in minutes) -->
                            <td class="text-white">
                                <c:set var="testMinutes" value="${tu.utilizedHours != null ? tu.utilizedHours : 0}" />
                                <c:choose>
                                    <c:when test="${testMinutes < 60}">
                                        ${testMinutes} min
                                    </c:when>
                                    <c:otherwise>
                                        <fmt:formatNumber value="${testMinutes / 60}" maxFractionDigits="1" /> hrs
                                    </c:otherwise>
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
                                    <a href="viewTaskTester/${tu.taskUserId}" class="btn btn-sm btn-primary">
                                        <i class="bi bi-eye"></i> Test
                                    </a>
                                    <c:if test="${tu.taskStatus == 'PendingTesting'}">
                                        <a href="viewTaskTester/${tu.taskUserId}" class="btn btn-sm btn-warning">
                                            <i class="bi bi-pencil"></i> Update
                                        </a>
                                    </c:if>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    
                    <c:if test="${empty taskUserList}">
                        <tr>
                            <td colspan="8" class="text-center text-secondary py-5">
                                <i class="bi bi-inbox fs-1 d-block mb-3"></i>
                                <h5>No test tasks available</h5>
                                <p class="small">Tasks will appear here once developers mark them as ready for testing</p>
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
                               href="?status=${statusFilter}&page=1&size=${pageSize}"
                               title="First Page">
                                <i class="bi bi-chevron-double-left"></i>
                            </a>
                        </li>
                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                            <a class="page-link bg-dark text-white border-secondary" 
                               href="?status=${statusFilter}&page=${currentPage-1}&size=${pageSize}"
                               title="Previous Page">
                                <i class="bi bi-chevron-left"></i>
                            </a>
                        </li>
                        <c:choose>
                            <c:when test="${totalPages <= 7}">
                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <li class="page-item ${currentPage == i ? 'active' : ''}">
                                        <a class="page-link ${currentPage == i ? 'bg-primary border-primary text-white' : 'bg-dark text-white border-secondary'}" 
                                           href="?status=${statusFilter}&page=${i}&size=${pageSize}">
                                            ${i}
                                        </a>
                                    </li>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <li class="page-item ${currentPage == 1 ? 'active' : ''}">
                                    <a class="page-link ${currentPage == 1 ? 'bg-primary border-primary text-white' : 'bg-dark text-white border-secondary'}" 
                                       href="?status=${statusFilter}&page=1&size=${pageSize}">1</a>
                                </li>
                                <c:if test="${currentPage > 3}">
                                    <li class="page-item disabled"><span class="page-link bg-dark text-white border-secondary">...</span></li>
                                </c:if>
                                <c:forEach begin="${currentPage-1}" end="${currentPage+1}" var="i">
                                    <c:if test="${i > 1 && i < totalPages}">
                                        <li class="page-item ${currentPage == i ? 'active' : ''}">
                                            <a class="page-link ${currentPage == i ? 'bg-primary border-primary text-white' : 'bg-dark text-white border-secondary'}" 
                                               href="?status=${statusFilter}&page=${i}&size=${pageSize}">${i}</a>
                                        </li>
                                    </c:if>
                                </c:forEach>
                                <c:if test="${currentPage < totalPages-2}">
                                    <li class="page-item disabled"><span class="page-link bg-dark text-white border-secondary">...</span></li>
                                </c:if>
                                <li class="page-item ${currentPage == totalPages ? 'active' : ''}">
                                    <a class="page-link ${currentPage == totalPages ? 'bg-primary border-primary text-white' : 'bg-dark text-white border-secondary'}" 
                                       href="?status=${statusFilter}&page=${totalPages}&size=${pageSize}">${totalPages}</a>
                                </li>
                            </c:otherwise>
                        </c:choose>
                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                            <a class="page-link bg-dark text-white border-secondary" 
                               href="?status=${statusFilter}&page=${currentPage+1}&size=${pageSize}"
                               title="Next Page">
                                <i class="bi bi-chevron-right"></i>
                            </a>
                        </li>
                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                            <a class="page-link bg-dark text-white border-secondary" 
                               href="?status=${statusFilter}&page=${totalPages}&size=${pageSize}"
                               title="Last Page">
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
.page-item.disabled .page-link {
    opacity: 0.5;
    cursor: not-allowed;
}

</style>

<jsp:include page="TesterFooter.jsp" />