<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="Update Task Status" scope="request" />
<c:set var="activeNav" value="tasks" scope="request" />

<jsp:include page="DeveloperHeader.jsp" />
<jsp:include page="DeveloperSidebar.jsp" />

<main class="main-content" id="mainContent">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="h2 text-white mb-0">
            <i class="bi bi-pencil-square me-2" style="color: var(--primary-color);"></i>Update Task Status
        </h1>
        <a href="javascript:history.back()" class="btn btn-secondary">
            <i class="bi bi-arrow-left me-2"></i>Back to Tasks
        </a>
    </div>

    <div class="row">
        <!-- Task Information Card -->
        <div class="col-md-4 mb-4">
            <div class="glass-card p-4">
                <h5 class="text-white mb-3">
                    <i class="bi bi-info-circle me-2" style="color: var(--primary-color);"></i>Task Information
                </h5>
                
                <div class="mb-3">
                    <label class="text-secondary small mb-1">Task Name</label>
                    <div class="text-white fw-medium">${task.title}</div>
                </div>
                
                <div class="mb-3">
                    <label class="text-secondary small mb-1">Project</label>
                    <div class="text-white">${project.title}</div>
                </div>
                
                <div class="mb-3">
                    <label class="text-secondary small mb-1">Current Status</label>
                    <div>
                        <c:choose>
                            <c:when test="${taskUser.taskStatus == 'Assigned'}">
                                <span class="badge bg-info fs-6 p-2">Assigned</span>
                            </c:when>
                            <c:when test="${taskUser.taskStatus == 'InProgress'}">
                                <span class="badge bg-primary fs-6 p-2">In Progress</span>
                            </c:when>
                            <c:when test="${taskUser.taskStatus == 'PendingTesting'}">
                                <span class="badge bg-warning text-dark fs-6 p-2">Pending Testing</span>
                            </c:when>
                            <c:when test="${taskUser.taskStatus == 'Defect'}">
                                <span class="badge bg-danger fs-6 p-2">Defect Found</span>
                            </c:when>
                            <c:when test="${taskUser.taskStatus == 'Completed'}">
                                <span class="badge bg-success fs-6 p-2">Completed (Verified)</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-secondary fs-6 p-2">${taskUser.taskStatus}</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
                
                <!-- Show hours worked so far -->
                <div class="mb-3">
                    <label class="text-secondary small mb-1">Total Hours Worked</label>
                    <div class="text-white fw-medium">
                        <c:choose>
                            <c:when test="${not empty taskUser.utilizedHours}">
                                ${taskUser.utilizedHours} hrs
                            </c:when>
                            <c:otherwise>
                                0 hrs
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
                
                <c:if test="${not empty task.description}">
                    <div class="mb-3">
                        <label class="text-secondary small mb-1">Description</label>
                        <div class="text-white-50">${task.description}</div>
                    </div>
                </c:if>
                
                <c:if test="${not empty task.docURL}">
                    <div class="mb-3">
                        <label class="text-secondary small mb-1">Documentation</label>
                        <div>
                            <a href="${task.docURL}" target="_blank" class="btn btn-sm btn-info text-white">
                                <i class="bi bi-file-earmark-text me-1"></i>View Doc
                            </a>
                        </div>
                    </div>
                </c:if>
            </div>
        </div>
        
        <!-- Update Form Card -->
        <div class="col-md-8 mb-4">
            <div class="glass-card p-4">
                <h5 class="text-white mb-3">
                    <i class="bi bi-arrow-up-circle me-2" style="color: var(--primary-color);"></i>Update Status
                </h5>
                
                <form action="${pageContext.request.contextPath}/updateTaskStatusDeveloper/${taskUser.taskUserId}" method="post">
                    <input type="hidden" name="taskUserId" value="${taskUser.taskUserId}" />
                    
                    <div class="row g-4">
                        <!-- New Status - Dynamic based on current status -->
                        <div class="col-md-12">
                            <label class="form-label text-secondary">New Status <span class="text-danger">*</span></label>
                            <select name="taskStatus" class="form-select bg-dark text-white border-secondary" required>
                                <option value="" disabled selected>Select New Status</option>
                                
                                <!-- ✅ PROFESSIONAL STATUS OPTIONS -->
                                <c:choose>
                                    <%-- From Assigned --%>
                                    <c:when test="${taskUser.taskStatus == 'Assigned'}">
                                        <option value="InProgress">🚀 Start Working (Timer Starts)</option>
                                    </c:when>
                                    
                                    <%-- From InProgress --%>
                                    <c:when test="${taskUser.taskStatus == 'InProgress'}">
                                        <option value="PendingTesting">✅ Ready for Testing (Stop Timer)</option>
                                    </c:when>
                                    
                                    <%-- From PendingTesting - REMOVED "Completed" option --%>
                                    <c:when test="${taskUser.taskStatus == 'PendingTesting'}">
                                        <option value="" disabled>⏳ Task is with Tester - No updates</option>
                                        <option value="Defect">🐛 Report Defect (if you found issue during testing)</option>
                                    </c:when>
                                    
                                    <%-- From Defect --%>
                                    <c:when test="${taskUser.taskStatus == 'Defect'}">
                                        <option value="InProgress">🔧 Fix Defect (Timer Restarts)</option>
                                    </c:when>
                                    
                                    <%-- From Completed (if developer ever sees this) --%>
                                    <c:when test="${taskUser.taskStatus == 'Completed'}">
                                        <option value="" disabled>✅ Task Completed & Verified by Tester</option>
                                    </c:when>
                                </c:choose>
                            </select>
                            
                            <!-- Status guidance message -->
                            <div class="mt-2 p-2 bg-dark rounded border border-secondary">
                                <c:choose>
                                    <c:when test="${taskUser.taskStatus == 'Assigned'}">
                                        <small class="text-info">
                                            <i class="bi bi-info-circle me-1"></i>
                                            Click "Start Working" to begin timing your work
                                        </small>
                                    </c:when>
                                    <c:when test="${taskUser.taskStatus == 'InProgress'}">
                                        <small class="text-warning">
                                            <i class="bi bi-stopwatch me-1"></i>
                                            Timer is running! Click "Ready for Testing" to stop and calculate hours
                                        </small>
                                    </c:when>
                                    <c:when test="${taskUser.taskStatus == 'PendingTesting'}">
                                        <small class="text-info">
                                            <i class="bi bi-clock-history me-1"></i>
                                            Task is with Tester for verification. You can only report a defect if you find one.
                                        </small>
                                    </c:when>
                                    <c:when test="${taskUser.taskStatus == 'Defect'}">
                                        <small class="text-danger">
                                            <i class="bi bi-bug me-1"></i>
                                            Fix the defect - timer will restart automatically
                                        </small>
                                    </c:when>
                                </c:choose>
                            </div>
                        </div>
                        
                        <!-- Comment -->
                        <div class="col-12">
                            <label class="form-label text-secondary">Comment <span class="text-danger">*</span></label>
                            <textarea name="comments" rows="4" 
                                      class="form-control bg-transparent text-white border-secondary"
                                      required placeholder="Add a comment about your progress..."></textarea>
                            <small class="text-secondary">
                                <i class="bi bi-chat-dots me-1"></i>
                                Describe what you did or any challenges faced
                            </small>
                        </div>
                        
                        <!-- Submit Buttons -->
                        <div class="col-12 mt-3">
                            <c:choose>
                                <c:when test="${taskUser.taskStatus == 'Completed' or taskUser.taskStatus == 'PendingTesting'}">
                                    <button type="submit" class="btn btn-secondary me-2" disabled>
                                        <i class="bi bi-check-circle me-2"></i>Cannot Update (With Tester)
                                    </button>
                                </c:when>
                                <c:otherwise>
                                    <button type="submit" class="btn btn-success me-2">
                                        <i class="bi bi-check-circle me-2"></i>Update Status
                                    </button>
                                </c:otherwise>
                            </c:choose>
                            <a href="../taskListDeveloper" class="btn btn-secondary">
                                <i class="bi bi-x-circle me-2"></i>Cancel
                            </a>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <!-- Professional Status Flow Guide -->
    <div class="row">
        <div class="col-12">
            <div class="glass-card p-4">
                <h5 class="text-white mb-3">
                    <i class="bi bi-diagram-3 me-2" style="color: var(--primary-color);"></i>Task Status Flow
                </h5>
                <div class="row g-3">
                    <div class="col-md-2 text-center">
                        <div class="p-3 bg-dark rounded">
                            <span class="badge bg-info mb-2">Assigned</span>
                            <i class="bi bi-arrow-down mx-2 text-secondary d-block my-2"></i>
                            <span class="badge bg-primary">InProgress</span>
                            <p class="text-secondary small mt-2">👨‍💻 Developer Works</p>
                        </div>
                    </div>
                    <div class="col-md-2 text-center">
                        <div class="p-3 bg-dark rounded">
                            <span class="badge bg-primary mb-2">InProgress</span>
                            <i class="bi bi-arrow-down mx-2 text-secondary d-block my-2"></i>
                            <span class="badge bg-warning text-dark">PendingTesting</span>
                            <p class="text-secondary small mt-2">📤 Ready for QA</p>
                        </div>
                    </div>
                    <div class="col-md-2 text-center">
                        <div class="p-3 bg-dark rounded">
                            <span class="badge bg-warning text-dark mb-2">PendingTesting</span>
                            <i class="bi bi-arrow-right mx-2 text-secondary d-block my-2"></i>
                            <i class="bi bi-arrow-down mx-2 text-secondary d-block my-2"></i>
                            <span class="badge bg-success">Verified</span>
                            <p class="text-secondary small mt-2">✅ Tester Verifies</p>
                        </div>
                    </div>
                    <div class="col-md-2 text-center">
                        <div class="p-3 bg-dark rounded">
                            <span class="badge bg-warning text-dark mb-2">PendingTesting</span>
                            <i class="bi bi-arrow-right mx-2 text-secondary d-block my-2"></i>
                            <i class="bi bi-arrow-down mx-2 text-secondary d-block my-2"></i>
                            <span class="badge bg-danger">Defect</span>
                            <p class="text-secondary small mt-2">🐛 Tester Finds Issue</p>
                        </div>
                    </div>
                    <div class="col-md-2 text-center">
                        <div class="p-3 bg-dark rounded">
                            <span class="badge bg-danger mb-2">Defect</span>
                            <i class="bi bi-arrow-down mx-2 text-secondary d-block my-2"></i>
                            <span class="badge bg-primary">InProgress</span>
                            <p class="text-secondary small mt-2">🔧 Developer Fixes</p>
                        </div>
                    </div>
                    <div class="col-md-2 text-center">
                        <div class="p-3 bg-dark rounded">
                            <span class="badge bg-success mb-2">Verified</span>
                            <p class="text-secondary small mt-2">✅ Task Complete</p>
                        </div>
                    </div>
                </div>
                <hr class="border-secondary my-3">
                <div class="text-center">
                    <small class="text-secondary">
                        <i class="bi bi-info-circle me-1"></i>
                        Developers mark tasks as "Ready for Testing". Testers then verify and mark as "Verified" or "Defect".
                        Hours are tracked automatically!
                    </small>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="DeveloperFooter.jsp" />