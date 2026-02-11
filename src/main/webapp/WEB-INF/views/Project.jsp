<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Project Management</title>

<!-- Bootstrap 5 CSS -->
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
        <h3 class="fw-bold text-primary">Project Management</h3>
        <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#projectModal">
            + Add New Project
        </button>
    </div>

    <!-- Project Table -->
    <div class="card shadow-sm">
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-bordered table-hover align-middle text-center">
                    <thead class="table-dark">
                        <tr>
                        <th>SrNo</th>
                            <th>Title</th>
                            <th>Description</th>
                            <th>Doc URL</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
<tbody>
    <c:forEach var="project" items="${projectList}" varStatus="status">
        <tr>
            <!-- Sr No -->
            <td>${status.index + 1}</td>

            <!-- Title -->
            <td>${project.title}</td>

            <!-- Description -->
            <td>${project.description}</td>

            <!-- Doc URL -->
            <td>
                <c:choose>
                    <c:when test="${not empty project.docURL}">
                        <a href="${project.docURL}" target="_blank"
                           class="btn btn-sm btn-info text-white">
                            View Doc
                        </a>
                    </c:when>
                    <c:otherwise>
                        <span class="text-muted">N/A</span>
                    </c:otherwise>
                </c:choose>
            </td>

       
            <!-- Actions -->
            <td>
                <a href="viewProject/${project.projectId}"
                   class="btn btn-sm btn-primary btn-custom">View</a>

                <a href="editProject/${project.projectId}"
                   class="btn btn-sm btn-warning btn-custom">Update</a>

                <a href="deleteProject/${project.projectId}"
                   class="btn btn-sm btn-danger btn-custom"
                   onclick="return confirm('Are you sure you want to delete this project?')">
                    Delete
                </a>
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
<div class="modal fade" id="projectModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title">Add / Update Project</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>

            <form action="saveProject" method="post">
                <div class="modal-body">
                    <div class="row g-3">

                        <div class="col-md-6">
                            <label class="form-label">Title</label>
                            <input type="text" name="title" class="form-control" required>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label">Document URL</label>
                            <input type="url" name="docURL" class="form-control">
                        </div>

                        <div class="col-md-12">
                            <label class="form-label">Description</label>
                            <textarea name="description" class="form-control" rows="3" required></textarea>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label">Estimated Hours</label>
                            <input type="number" name="estimatedHours" class="form-control" required>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label">Total Utilized Hours</label>
                            <input type="number" name="totalUtilizedHours" class="form-control">
                        </div>

                        <div class="col-md-4">
                            <label class="form-label">Start Date</label>
                            <input type="date" name="projectStartDate" class="form-control" required>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label">Completion Date</label>
                            <input type="date" name="projectCompletionDate" class="form-control">
                        </div>

                    </div>
                </div>

                <div class="modal-footer">
                    <button type="submit" class="btn btn-success">Save Project</button>
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
