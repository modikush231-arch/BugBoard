<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>View Task</title>

<!-- Bootstrap 5 -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

<style>
    body {
        background-color: #f4f6f9;
    }
    .card {
        border-radius: 12px;
        box-shadow: 0 0.75rem 1.5rem rgba(0,0,0,0.08);
        padding: 1.5rem;
    }
    .card-header {
        font-weight: 700;
        font-size: 1.4rem;
        color: #0066FF;
    }
    .label-bold {
        font-weight: 600;
        font-size: 0.85rem;
        color: #6c757d;
        text-transform: uppercase;
        margin-bottom: 0.25rem;
    }
    .info-value {
        font-size: 1.1rem;
        font-weight: 500;
    }
    .badge-id {
        background-color: #e0f0ff;
        color: #0066FF;
        font-weight: 600;
        border-radius: 50px;
        padding: 0.4em 0.8em;
        font-size: 0.85rem;
    }
    .btn-back {
        text-decoration: none;
        font-weight: 500;
    }
</style>
</head>

<body>
<div class="container py-5">

    <!-- Back Button -->
    <div class="mb-4">
        <a href="../taskList" class="btn-back text-decoration-none text-secondary">
            <i class="fas fa-arrow-left"></i> Back to Task List
        </a>
    </div>

    <!-- Task Card -->
    <div class="card">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <span class="card-header">Task Specifications</span>
            <span class="badge badge-id">ID: #${task.taskId}</span>
        </div>

        <!-- Title + Description -->
        <div class="row mb-3">
            <div class="col-md-6">
                <div class="label-bold">Task Title</div>
                <div class="info-value">${task.title}</div>
            </div>
            <div class="col-md-6">
              <div class="label-bold">Description</div>
                <div class="info-value">${task.description}</div>
            </div>
        </div>

    

        <!-- Estimated & Utilized Hours -->
        <div class="row mb-3">
            <div class="col-md-6">
                <div class="label-bold">Estimated Hours</div>
                <div class="info-value">${task.estimatedHours} hrs</div>
            </div>
            <div class="col-md-6">
                <div class="label-bold">Utilized Hours</div>
                <div class="info-value text-danger">
                    ${task.totalUtilizedHours} hrs
                </div>
            </div>
        </div>

        <!-- Documentation -->
        <div class="row mb-4">
            <div class="col-md-12">
                <div class="label-bold">Documentation</div>
                <c:choose>
                    <c:when test="${not empty task.docURL}">
                        <a href="${task.docURL}" target="_blank" class="btn btn-outline-info">
                            <i class="fas fa-file-alt"></i> Open Document Link
                        </a>
                    </c:when>
                    <c:otherwise>
                        <span class="text-muted">N/A</span>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Footer -->
        <div class="card-footer bg-light p-3 d-flex justify-content-end gap-2">
            <a href="../editTask/${task.taskId}" class="btn btn-warning px-4">
                <i class="fas fa-pen me-1"></i> Edit
            </a>
            <button class="btn btn-outline-danger" onclick="confirmDelete()">
                <i class="fas fa-trash me-1"></i> Delete
            </button>
        </div>
    </div>
</div>

<!-- Delete Confirmation -->
<script>
    function confirmDelete() {
        if (confirm("Are you sure you want to remove this task permanently?")) {
            window.location.href = "../deleteTask/${task.taskId}";
        }
    }
</script>

</body>
</html>
