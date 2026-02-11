<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Project Details | ${project.title}</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">

<style>
    body { background-color: #f8f9fa; }
    .detail-label { font-weight: 600; color: #6c757d; font-size: 0.9rem; text-transform: uppercase; }
    .detail-value { font-size: 1.1rem; color: #212529; margin-bottom: 1.5rem; }
    .card { border: none; border-radius: 15px; }
    .status-badge { font-size: 0.85rem; padding: 0.5em 1em; border-radius: 50px; }
</style>
</head>
<body>

<div class="container py-5">
    <div class="mb-4">
        <a href="../projectList" class="text-decoration-none text-secondary">
            <i class="bi bi-arrow-left"></i> Back to Project List
        </a>
    </div>

    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="card shadow-sm">
                <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                    <h4 class="mb-0 fw-bold text-primary">Project Specifications</h4>
                    <span class="badge bg-primary-subtle text-primary border border-primary-subtle status-badge">
                        ID: #${project.projectId}
                    </span>
                </div>

                <div class="card-body p-4">
                    <div class="row">
                        <div class="col-12">
                            <label class="detail-label">Project Title</label>
                            <p class="detail-value fw-bold">${project.title}</p>
                        </div>

                        <div class="col-12">
                            <label class="detail-label">Description</label>
                            <p class="detail-value text-muted">${project.description}</p>
                        </div>

                        <hr class="my-3 opacity-25">

                        <div class="col-md-6">
                            <label class="detail-label"><i class="bi bi-calendar-event me-1"></i> Start Date</label>
                            <p class="detail-value">${project.projectStartDate}</p>
                        </div>
                        <div class="col-md-6">
                            <label class="detail-label"><i class="bi bi-calendar-check me-1"></i> Completion Date</label>
                            <p class="detail-value">${not empty project.projectCompletionDate ? project.projectCompletionDate : '---'}</p>
                        </div>

                        <div class="col-md-6">
                            <label class="detail-label"><i class="bi bi-clock me-1"></i> Estimated Hours</label>
                            <p class="detail-value">${project.estimatedHours} hrs</p>
                        </div>
                        <div class="col-md-6">
                            <label class="detail-label"><i class="bi bi-hourglass-split me-1"></i> Utilized Hours</label>
                            <p class="detail-value text-danger">${project.totalUtilizedHours} hrs</p>
                        </div>

                        <div class="col-12 mt-3">
                            <label class="detail-label">Documentation</label>
                            <div>
                                <c:choose>
                                    <c:when test="${not empty project.docURL}">
                                        <a href="${project.docURL}" target="_blank" class="btn btn-outline-info">
                                            <i class="bi bi-file-earmark-pdf me-1"></i> Open Document Link
                                        </a>
                                    </c:when>
                                    <c:otherwise>
                                        <p class="text-muted small">No documentation provided.</p>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card-footer bg-light p-3 d-flex justify-content-end gap-2">
                    <a href="../editProject/${project.projectId}" class="btn btn-warning px-4">
                        <i class="bi bi-pencil-square me-1"></i> Edit
                    </a>
                    <button class="btn btn-outline-danger" onclick="confirmDelete()">
                        <i class="bi bi-trash me-1"></i> Delete
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    function confirmDelete() {
        if(confirm("Are you sure you want to remove this project permanently?")) {
            window.location.href = "../deleteProject/${project.projectId}";
        }
    }
</script>

</body>
</html>