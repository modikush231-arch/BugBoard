<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>View Module</title>

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
    .btn-edit {
        background-color: #ffc107;
        border-color: #ffc107;
        color: #000;
        font-weight: 500;
    }
    .btn-delete {
        background-color: #fff;
        border: 1px solid #dc3545;
        color: #dc3545;
        font-weight: 500;
    }
</style>
</head>

<body>
<div class="container py-5">
    <!-- Back Button -->
    <div class="mb-4">
        <a href="../moduleList" class="btn-back text-decoration-none text-secondary">
            <i class="fas fa-arrow-left"></i> Back to Module List
        </a>
    </div>

    <!-- Module Card -->
    <div class="card">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <span class="card-header">Module Specifications</span>
            <span class="badge badge-id">ID: #${module.moduleId}</span>
        </div>

        <div class="row mb-3">
            <div class="col-md-6">
                <div class="label-bold">Module Name</div>
                <div class="info-value">${module.moduleName}</div>
            </div>
            <div class="col-md-6">
                <div class="label-bold">Description</div>
                <div class="info-value">${module.description}</div>
            </div>
        </div>

        <div class="row mb-3">
            <div class="col-md-6">
                <div class="label-bold">Estimated Hours</div>
                <div class="info-value">${module.estimatedHours} hrs</div>
            </div>
            <div class="col-md-6">
                <div class="label-bold">Utilized Hours</div>
                <div class="info-value text-danger">${module.totalUtilizedHours} hrs</div>
            </div>
        </div>

        <div class="row mb-3">
            <div class="col-md-12">
                <div class="label-bold">Documentation</div>
                <c:choose>
                    <c:when test="${not empty module.docURL}">
                        <a href="${module.docURL}" target="_blank" class="btn btn-outline-info">
                            <i class="fas fa-file-pdf"></i> Open Document Link
                        </a>
                    </c:when>
                    <c:otherwise>
                        <span class="text-muted">N/A</span>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

          <div class="card-footer bg-light p-3 d-flex justify-content-end gap-2">
                    <a href="../editProject/${module.moduleId}" class="btn btn-warning px-4">
                        <i class="bi bi-pencil-square me-1"></i> Edit
                    </a>
                    <button class="btn btn-outline-danger" onclick="confirmDelete()">
                        <i class="bi bi-trash me-1"></i> Delete
                    </button>
                </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script>
    function confirmDelete() {
        if(confirm("Are you sure you want to remove this module permanently?")) {
            window.location.href = "../deleteModule/${module.moduleId}";
        }
    }
</script>
</body>
</html>
