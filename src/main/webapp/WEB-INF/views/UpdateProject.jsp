<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="pageTitle" value="Update Project Status" scope="request" />
<c:set var="activeNav" value="projects" scope="request" />

<jsp:include page="adminheader.jsp" />
<jsp:include page="adminsidebar.jsp" />

<main class="main-content" id="mainContent">
    <div class="mb-4">
        <a href="../projectList" class="text-decoration-none text-secondary">
            <i class="bi bi-arrow-left-circle me-1"></i> Back to Projects
        </a>
    </div>
    
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="glass-card p-4">
                <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom border-secondary">
                    <h4 class="text-white">
                        <i class="bi bi-pencil-square me-2"></i>Update Project Status
                    </h4>
                    <span class="badge bg-primary">ID: #${project.projectId}</span>
                </div>
                
                <form action="../updateProject" method="post">
                    <input type="hidden" name="projectId" value="${project.projectId}">
                    
                    <div class="row g-4">
                        <div class="col-md-6">
                            <label class="form-label text-secondary">Project Title</label>
                            <input type="text" class="form-control bg-dark text-white border-secondary" 
                                   value="${project.title}" readonly>
                        </div>
                        
                        <div class="col-md-6">
                            <label class="form-label text-secondary">Document URL</label>
                            <input type="text" class="form-control bg-dark text-white border-secondary" 
                                   value="${project.docURL}" readonly>
                        </div>
                        
                        <div class="col-12">
                            <label class="form-label text-secondary">Description</label>
                            <textarea class="form-control bg-dark text-white border-secondary" 
                                      rows="3" readonly>${project.description}</textarea>
                        </div>
                        
                        <div class="col-md-4">
                            <label class="form-label text-secondary">Estimated Hours</label>
                            <input type="number" class="form-control bg-dark text-white border-secondary" 
                                   value="${project.estimatedHours}" readonly>
                        </div>
                        
                        <div class="col-md-4">
                            <label class="form-label text-secondary">Start Date</label>
                            <input type="text" class="form-control bg-dark text-white border-secondary" 
                                   value="${project.projectStartDate}" readonly>
                        </div>
                        
                        <div class="col-md-4">
                            <label class="form-label text-secondary">Completion Date</label>
                            <input type="text" class="form-control bg-dark text-white border-secondary" 
                                   value="${project.projectCompletionDate}" readonly>
                        </div>
                        
                        <div class="col-md-6">
                            <label class="form-label text-secondary">Project Status *</label>
                            <select name="projectStatusId" class="form-select bg-dark text-white border-secondary" required>
                                <c:forEach var="s" items="${statusList}">
                                    <option value="${s.projectStatusId}" 
                                            ${s.projectStatusId == project.projectStatusId ? 'selected' : ''}>
                                        ${s.status}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>
                    
                    <hr class="my-4 border-secondary">
                    <div class="d-flex gap-2">
                        <button type="submit" class="btn btn-success">
                            <i class="bi bi-check-circle me-2"></i>Update Status
                        </button>
                        <a href="../projectList" class="btn btn-secondary">
                            <i class="bi bi-arrow-left me-2"></i>Back
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</main>

<jsp:include page="adminfooter.jsp" />