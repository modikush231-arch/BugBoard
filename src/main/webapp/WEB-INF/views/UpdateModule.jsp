<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="pageTitle" value="Update Module" scope="request" />
<c:set var="activeNav" value="modules" scope="request" />

<jsp:include page="adminheader.jsp" />
<jsp:include page="adminsidebar.jsp" />

<main class="main-content" id="mainContent">
    <div class="mb-4">
        <a href="javascript:history.back()" class="text-decoration-none text-secondary">
            <i class="bi bi-arrow-left-circle me-1"></i> Back to Modules
        </a>
    </div>

    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="glass-card p-4">
                <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom border-secondary">
                    <h4 class="text-white">
                        <i class="bi bi-pencil-square me-2"></i>Update Module
                    </h4>
                    <span class="badge bg-primary">Module #${module.moduleId}</span>
                </div>

                <form action="../updateModule" method="post">
                    <input type="hidden" name="moduleId" value="${module.moduleId}">

                    <div class="row g-4">
                        <div class="col-md-6">
                            <label class="form-label text-secondary">Module Name *</label>
                            <input type="text" name="moduleName" class="form-control bg-dark text-white border-secondary"
                                   value="${module.moduleName}" required>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label text-secondary">Project</label>
                            <select name="projectId" class="form-select bg-dark text-white border-secondary" required>
                                <c:forEach var="p" items="${projectList}">
                                    <option value="${p.projectId}" ${p.projectId == module.projectId ? 'selected' : ''}>
                                        ${p.title}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="col-12">
                            <label class="form-label text-secondary">Description</label>
                            <textarea name="description" class="form-control bg-dark text-white border-secondary"
                                      rows="3">${module.description}</textarea>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label text-secondary">Document URL</label>
                            <input type="url" name="docURL" class="form-control bg-dark text-white border-secondary"
                                   value="${module.docURL}">
                        </div>

                        <div class="col-md-6">
                            <label class="form-label text-secondary">Status *</label>
                            <select name="status" class="form-select bg-dark text-white border-secondary" required>
                                <option value="Assigned" ${module.status == 'Assigned' ? 'selected' : ''}>Assigned</option>
                                <option value="InProgress" ${module.status == 'InProgress' ? 'selected' : ''}>In Progress</option>
                                <option value="PendingTesting" ${module.status == 'PendingTesting' ? 'selected' : ''}>Pending Testing</option>
                                <option value="Completed" ${module.status == 'Completed' ? 'selected' : ''}>Completed</option>
                            </select>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label text-secondary">Estimated Hours</label>
                            <input type="number" name="estimatedHours" step="0.5"
                                   class="form-control bg-dark text-white border-secondary"
                                   value="${module.estimatedHours}" required>
                        </div>
                    </div>

                    <hr class="my-4 border-secondary">
                    <div class="d-flex justify-content-end gap-3">
                        <button type="submit" class="btn btn-success">
                            <i class="bi bi-check-circle me-2"></i>Update Module
                        </button>
                        <a href="../moduleList" class="btn btn-secondary">
                            <i class="bi bi-x-circle me-2"></i>Cancel
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</main>

<jsp:include page="adminfooter.jsp" />