<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- Set page title and active sidebar item --%>
<c:set var="pageTitle" value="Project Management" scope="request" />
<c:set var="activeNav" value="projects" scope="request" />

<%-- Include global header (opens <html>, <head>, navbar) --%>
<jsp:include page="adminheader.jsp" />

<%-- Include sidebar --%>
<jsp:include page="adminsidebar.jsp" />

    <%-- MAIN CONTENT (starts with .main-content) --%>
    <main class="main-content" id="mainContent">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1 class="h2 text-white mb-0">
                <i class="bi bi-kanban me-2" style="color: var(--primary-color);"></i>Project Management
            </h1>
            <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#projectModal">
                <i class="bi bi-plus-circle me-2"></i>Add New Project
            </button>
        </div>

        <!-- Search Box -->
        <div class="mb-4 d-flex justify-content-end">
            <div class="col-md-4">
                <div class="input-group">
                    <span class="input-group-text bg-transparent border-secondary text-secondary">
                        <i class="bi bi-search"></i>
                    </span>
                    <input type="text" id="searchInput" class="form-control bg-transparent text-white border-secondary"
                           placeholder="Search projects..." onkeyup="filterTable()">
                </div>
            </div>
        </div>

        <!-- Project Table Card -->
        <div class="glass-card p-4">
            <div class="table-responsive">
                <table class="table table-hover mb-0" id="projectTable" style="--bs-table-bg: transparent;">
                    <thead>
                        <tr>
                            <th class="text-secondary">SrNo</th>
                            <th class="text-secondary">Title</th>
                            <th class="text-secondary">Description</th>
                            <th class="text-secondary">Doc URL</th>
                            <th class="text-secondary">Status</th>
                            
                            <th class="text-secondary">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="project" items="${projectList}" varStatus="status">
                            <tr>
                                <td class="text-white">${status.index + 1}</td>
                                <td class="text-white fw-medium">${project.title}</td>
                                <td class="text-white-50">${project.description}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty project.docURL}">
                                            <a href="${project.docURL}" target="_blank"
                                               class="btn btn-sm btn-info text-white">
                                                <i class="bi bi-file-earmark-text me-1"></i>View Doc
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-secondary">N/A</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
								<td class="text-white fw-medium">
								    <c:forEach var="status" items="${statusList}">
								        <c:if test="${status.projectStatusId == project.projectStatusId}">
								            ${status.status}
								        </c:if>
								    </c:forEach>
								</td>
                                
                                <td>
                                    <div class="d-flex gap-2 justify-content">
                                        <a href="viewProject/${project.projectId}"
                                           class="btn btn-sm btn-primary btn-custom">
                                            <i class="bi bi-eye"></i> View
                                        </a>
                                        <a href="editProject/${project.projectId}"
                                           class="btn btn-sm btn-warning btn-custom">
                                            <i class="bi bi-pencil"></i> Update
                                        </a>
                                        <a href="deleteProject/${project.projectId}"
                                           class="btn btn-sm btn-danger btn-custom"
                                           onclick="return confirm('Are you sure you want to delete this project?')">
                                            <i class="bi bi-trash"></i> Delete
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Add / Update Modal (adapted to dark theme) -->
        <div class="modal fade" id="projectModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content bg-dark text-white border-secondary">
                    <div class="modal-header border-secondary">
                        <h5 class="modal-title text-white">
                            <i class="bi bi-plus-circle-fill me-2" style="color: var(--primary-color);"></i>Add New Project
                        </h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <form action="saveProject" method="post">
                        <div class="modal-body">
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label class="form-label text-secondary">Title</label>
                                    <input type="text" name="title" class="form-control bg-transparent text-white border-secondary" required>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label text-secondary">Document URL</label>
                                    <input type="url" name="docURL" class="form-control bg-transparent text-white border-secondary">
                                </div>
                                <div class="col-md-12">
                                    <label class="form-label text-secondary">Description</label>
                                    <textarea name="description" class="form-control bg-transparent text-white border-secondary" rows="3" required></textarea>
                                </div>
                                
								

                                
                                <div class="col-md-4">
                                    <label class="form-label text-secondary">Estimated Hours</label>
                                    <input type="number" name="estimatedHours" class="form-control bg-transparent text-white border-secondary" required>
                                </div>
                           
                                <div class="col-md-4">
                                    <label class="form-label text-secondary">Start Date</label>
                                    <input type="date" name="projectStartDate" class="form-control bg-transparent text-white border-secondary" required>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label text-secondary">Completion Date</label>
                                    <input type="date" name="projectCompletionDate" class="form-control bg-transparent text-white border-secondary">
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer border-secondary">
                            <button type="submit" class="btn btn-success">
                                <i class="bi bi-check-circle me-2"></i>Save Project
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

<%-- Include footer (closes .main-content, contains Bootstrap JS and common scripts) --%>
<jsp:include page="adminfooter.jsp" />

<%-- Table filter script (remains page‑specific) --%>
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
</script>

<%-- No duplicate scripts: adminfooter already includes Bootstrap JS and toggleSidebar() --%>