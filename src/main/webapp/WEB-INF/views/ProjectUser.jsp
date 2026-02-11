<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Project Manager Assignment</title>

<!-- Bootstrap 5 -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

<style>
    body {
        background-color: #f4f6f9;
    }
    .card {
        border-radius: 12px;
    }
    .badge-assign {
        background-color: #198754;
    }
    .badge-revoke {
        background-color: #dc3545;
    }
</style>

</head>
<body>

<div class="container mt-5">

    <!-- Page Header -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="fw-bold text-primary">Project → Manager Assignment</h3>
        <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#assignModal">
            + Assign Manager
        </button>
    </div>

    <!-- Assignment Table -->
    <div class="card shadow-sm">
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-bordered table-hover text-center align-middle">
                    <thead class="table-dark">
                        <tr>
                            <th>Project</th>
                            <th>Manager</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="pu" items="${projectList}">
                            <tr>
                                <td>${pu.project.projectName}</td>
                                <td>${pu.user.username}</td>

                                <td>
                                    <c:choose>
                                        <c:when test="${pu.assignStatus == 1}">
                                            <span class="badge badge-assign">Assigned</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge badge-revoke">Revoked</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>

                                <td>
                                    <a href="viewProjectUser/${pu.projectUserId}"
                                       class="btn btn-sm btn-primary">View</a>

                                    <a href="editProjectUser/${pu.projectUserId}"
                                       class="btn btn-sm btn-warning">Update</a>

                                    <a href="deleteProjectUser/${pu.projectUserId}"
                                       class="btn btn-sm btn-danger"
                                       onclick="return confirm('Are you sure?')">
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


<!-- Assign Modal -->
<div class="modal fade" id="assignModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">

            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title">Assign Manager to Project</h5>
                <button type="button" class="btn-close btn-close-white"
                        data-bs-dismiss="modal"></button>
            </div>

            <form action="saveProjectUser" method="post">
                <div class="modal-body">

                    <!-- Project -->
                    <div class="mb-3">
                        <label class="form-label">Project</label>
                        <select name="projectId" class="form-select" required>
                            <option value="-1">-- Select Project --</option>
                            <c:forEach var="project" items="${projectList}">
                                <option value="${project.projectId}">
                                    ${project.projectName}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <!-- User -->
                    <div class="mb-3">
                        <label class="form-label">Manager</label>
                        <select name="userId" class="form-select" required>
                            <option value="-1">-- Select Manager --</option>
                            <c:forEach var="user" items="${userList}">
                                <option value="${user.userId}">
                                    ${user.username}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <!-- Assign Status -->
                    <div class="mb-3">
                        <label class="form-label">Assignment Status</label>
                        <select name="assignStatus" class="form-select" required>
                            <option value="Assign">Assign</option>
                            <option value="Revoke">Revoke</option>
                        </select>
                    </div>

                </div>

                <div class="modal-footer">
                    <button type="submit" class="btn btn-success">
                        Save Assignment
                    </button>
                    <button type="button" class="btn btn-secondary"
                            data-bs-dismiss="modal">Cancel</button>
                </div>
            </form>

        </div>
    </div>
</div>


<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
