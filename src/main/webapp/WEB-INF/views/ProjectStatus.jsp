<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- Set page title and active sidebar item --%>
<c:set var="pageTitle" value="Project Status Management" scope="request" />
<c:set var="activeNav" value="projectStatus" scope="request" />

<%-- Include global header (opens <html>, <head>, navbar) --%>
<jsp:include page="adminheader.jsp" />

<%-- Include sidebar --%>
<jsp:include page="adminsidebar.jsp" />

    <%-- MAIN CONTENT (starts with .main-content) --%>
    <main class="main-content" id="mainContent">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1 class="h2 text-white mb-0">
                <i class="bi bi-list-check me-2" style="color: var(--primary-color);"></i>Project Status Management
            </h1>
            <button class="btn btn-success" 
                    onclick="clearForm()"
                    data-bs-toggle="modal" 
                    data-bs-target="#statusModal">
                <i class="bi bi-plus-circle me-2"></i>Add New Status
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
                           placeholder="Search status..." 
                           onkeyup="filterTable()">
                </div>
            </div>
        </div>

        <!-- Status Table Card -->
        <div class="glass-card p-4">
            <div class="table-responsive">
                <table class="table table-hover mb-0" id="statusTable" style="--bs-table-bg: transparent;">
                    <thead>
                        <tr>
                            <th class="text-secondary">SrNo</th>
                            <th class="text-secondary">Status Name</th>
                            <th class="text-secondary">Description</th>
                            <th class="text-secondary">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="status" items="${projectStatusList}" varStatus="s">
                            <tr>
                                <td class="text-white">${s.index + 1}</td>
                                <td class="text-white fw-medium text-capitalize">${status.status}</td>
                                <td class="text-white-50">${status.description}</td>
                                <td>
                                    <div class="d-flex gap-2 justify-content">
                                        <!-- UPDATE -->
                                        <button class="btn btn-sm btn-warning btn-custom"
                                                onclick="editStatus(
                                                    '${status.projectStatusId}',
                                                    '${status.status}',
                                                    '${status.description}'
                                                )"
                                                data-bs-toggle="modal"
                                                data-bs-target="#statusModal">
                                            <i class="bi bi-pencil"></i> Update
                                        </button>
                                        <!-- DELETE -->
                                        <a href="deleteProjectStatus/${status.projectStatusId}"
                                           class="btn btn-sm btn-danger btn-custom"
                                           onclick="return confirm('Are you sure you want to delete this status?')">
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
        <div class="modal fade" id="statusModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content bg-dark text-white border-secondary">
                    <div class="modal-header border-secondary">
                        <h5 class="modal-title text-white">
                            <i class="bi bi-tag-fill me-2" style="color: var(--primary-color);"></i>Add Status
                        </h5>
                        <button type="button" class="btn-close btn-close-white" 
                                data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <form action="saveStatus" method="post">
                        <div class="modal-body">
                            <!-- Hidden ID for Update -->
                            <input type="hidden" name="projectStatusId" id="statusId">

                            <div class="mb-3">
                                <label class="form-label text-secondary">Status</label>
                                  <select name="status" class="form-select bg-transparent text-white border-secondary" required>
                                        <option value="" disabled selected class="text-dark">Select Status</option>
                                        <option value="Lead" class="text-dark">Lead</option>
                                        <option value="NotStarted" class="text-dark">NotStarted</option>
                                        <option value="Hold" class="text-dark">Hold</option>
                                        <option value="InProgress" class="text-dark">InProgress</option>
                                         <option value="Completed" class="text-dark">Completed</option>
                                    </select>
                            </div>
                            <div class="mb-3">
                                <label class="form-label text-secondary">Description</label>
                                <textarea name="description" 
                                          id="statusDesc"
                                          class="form-control bg-transparent text-white border-secondary" 
                                          rows="3" 
                                          required></textarea>
                            </div>
                        </div>
                        <div class="modal-footer border-secondary">
                            <button type="submit" class="btn btn-success">
                                <i class="bi bi-check-circle me-2"></i>Save Status
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

<%-- Page‑specific JavaScript functions --%>
<script>
function filterTable() {
    const input = document.getElementById("searchInput").value.toLowerCase();
    const rows = document.querySelectorAll("#statusTable tbody tr");
    rows.forEach(row => {
        row.style.display = row.innerText.toLowerCase().includes(input) ? "" : "none";
    });
}

function editStatus(id, statusName, desc) {
    document.getElementById("statusId").value = id;
    // For the select dropdown, set the selected option
    const select = document.querySelector("select[name='status']");
    for (let i = 0; i < select.options.length; i++) {
        if (select.options[i].value === statusName) {
            select.options[i].selected = true;
            break;
        }
    }
    document.getElementById("statusDesc").value = desc;
}

function clearForm() {
    document.getElementById("statusId").value = "";
    document.querySelector("select[name='status']").selectedIndex = 0;
    document.getElementById("statusDesc").value = "";
}
</script>

<%-- No duplicate CSS/JS – everything is provided by the global includes --%>