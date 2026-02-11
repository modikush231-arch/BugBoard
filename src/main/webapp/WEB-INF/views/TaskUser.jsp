<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Developer → Task Assignment</title>

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

    <!-- Header -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="fw-bold text-primary">Developer → Task Assignment</h3>
        <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#taskUserModal">
            + Assign Developer
        </button>
    </div>

    <!-- Table -->
    <div class="card shadow-sm">
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-bordered table-hover text-center align-middle">
                    <thead class="table-dark">
                        <tr>
                            <th>Task</th>
                            <th>Developer</th>
                            <th>Assign Status</th>
                            <th>Task Status</th>
                            <th>Utilized Hours</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="tu" items="${taskUserList}">
                            <tr>
                                <td>${tu.task.title}</td>
                                <td>${tu.user.username}</td>

                                <!-- Assign Status -->
                                <td>
                                    <c:choose>
                                        <c:when test="${tu.assignStatus == 1}">
                                            <span class="badge badge-assign">Assigned</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge badge-revoke">Revoked</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>

                                <!-- Task Status -->
                                <td>${tu.status.statusName}</td>

                                <td>${tu.utilizedHours}</td>

                                <td>
                                    <a href="viewTaskUser/${tu.taskUserId}"
                                       class="btn btn-sm btn-primary">View</a>

                                    <a href="editTaskUser/${tu.taskUserId}"
                                       class="btn btn-sm btn-warning">Update</a>

                                    <a href="deleteTaskUser/${tu.taskUserId}"
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

<!-- Modal -->
<div class="modal fade" id="taskUserModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">

            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title">Assign Developer to Task</h5>
                <button type="button" class="btn-close btn-close-white"
                        data-bs-dismiss="modal"></button>
            </div>

            <form action="saveTaskUser" method="post">
                <div class="modal-body">

                    <!-- Task -->
                    <div class="mb-3">
                        <label class="form-label">Task</label>
                        <select name="taskId" class="form-select" required>
                            <option value="-1">-- Select Task --</option>
                            <c:forEach var="task" items="${taskList}">
                                <option value="${task.taskId}">
                                    ${task.title}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <!-- Developer -->
                    <div class="mb-3">
                        <label class="form-label">Developer</label>
                        <select name="userId" class="form-select" required>
                            <option value="-1">-- Select Developer --</option>
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

                    <!-- Task Status FK -->
                    <div class="mb-3">
                        <label class="form-label">Task Status</label>
                        <select name="statusId" class="form-select" required>
                            <option value="-1">-- Select Status --</option>
                            <c:forEach var="status" items="${statusList}">
                                <option value="${status.statusId}">
                                    ${status.statusName}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <!-- Utilized Hours -->
                    <div class="mb-3">
                        <label class="form-label">Utilized Hours</label>
                        <input type="number" name="utilizedHours"
                               class="form-control" min="0">
                    </div>

                </div>

                <div class="modal-footer">
                    <button type="submit" class="btn btn-success">
                        Save
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
