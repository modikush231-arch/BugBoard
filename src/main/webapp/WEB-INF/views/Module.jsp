<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Module Management</title>

<!-- Bootstrap 5 -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

<style>
    body {
        background-color: #f4f6f9;
    }
    .card {
        border-radius: 12px;
    }
    .btn-custom {
        min-width: 80px;
    }
</style>
</head>

<body>

<div class="container mt-5">

    <!-- Page Title -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="fw-bold text-primary">Module Management</h3>
        <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#moduleModal">
            + Add New Module
        </button>
    </div>

    <!-- Search Box -->
    <div class="mb-3 d-flex justify-content-end">
        <input type="text" id="searchInput" class="form-control w-50" placeholder="Search Modules..." onkeyup="filterTable()">
    </div>

    <!-- Module Table -->
    <div class="card shadow-sm">
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-bordered table-hover align-middle text-center" id="moduleTable">
                    <thead class="table-dark">
                        <tr>
                            <th>SrNo</th>
                            <th>Module Name</th>
                            
                            <th>Description</th>
                            <th>Doc URL</th>
                          
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="module" items="${moduleList}" varStatus="status">
                            <tr>
                                <td>${status.index + 1}</td>
                                <td>${module.moduleName}</td>
                               
                         
                                <td>${module.description}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty module.docURL}">
                                            <a href="${module.docURL}" target="_blank" class="btn btn-sm btn-info text-white">View Doc</a>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted">N/A</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                              
                                <td>
                                    <a href="viewModule/${module.moduleId}" class="btn btn-sm btn-primary btn-custom">View</a>
                                    <a href="editModule/${module.moduleId}" class="btn btn-sm btn-warning btn-custom">Update</a>
                                    <a href="deleteModule/${module.moduleId}" class="btn btn-sm btn-danger btn-custom" onclick="return confirm('Are you sure you want to delete this module?')">Delete</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

</div>

<!-- Add / Update Modal -->
<div class="modal fade" id="moduleModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title">Add / Update Module</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>

            <form action="saveModule" method="post">
                <div class="modal-body">
                    <div class="row g-3">

                        <div class="col-md-6">
                            <label class="form-label">Module Name</label>
                            <input type="text" name="moduleName" class="form-control" required>
                        </div>
    					<div class="col-md-12">
                            <label class="form-label">Description</label>
                            <textarea name="description" class="form-control" rows="3"></textarea>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label">Document URL</label>
                            <input type="url" name="docURL" class="form-control">
                        </div>


                    </div>
                </div>

                <div class="modal-footer">
                    <button type="submit" class="btn btn-success">Save Module</button>
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                </div>
            </form>

        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<!-- Search Filter Script -->
<script>
function filterTable() {
    const input = document.getElementById("searchInput").value.toLowerCase();
    const table = document.getElementById("moduleTable");
    const rows = table.getElementsByTagName("tr");

    for (let i = 1; i < rows.length; i++) { // skip header row
        const rowText = rows[i].innerText.toLowerCase();
        if (rowText.indexOf(input) > -1) {
            rows[i].style.display = "";
        } else {
            rows[i].style.display = "none";
        }
    }
}
</script>

</body>
</html>
