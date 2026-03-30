<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="pageTitle" value="Test Task - ${task.title}" scope="request" />
<c:set var="activeNav" value="testTasks" scope="request" />

<jsp:include page="TesterHeader.jsp" />
<jsp:include page="TesterSidebar.jsp" />

<main class="main-content" id="mainContent">
    <!-- Back button -->
    <div class="mb-4">
        <a href="../taskTester" class="text-decoration-none text-secondary hover-text-primary">
            <i class="bi bi-arrow-left-circle me-1"></i> Back to Test Tasks
        </a>
    </div>

    <div class="row">
        <!-- Task Details Section -->
        <div class="col-lg-7 mb-4">
            <div class="glass-card p-4">
                <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom border-secondary">
                    <h4 class="mb-0 text-white">
                        <i class="bi bi-bug-fill me-2" style="color: var(--primary-color);"></i>Task Details
                    </h4>
                    <span class="badge bg-primary-subtle text-primary border border-primary-subtle">
                        <i class="bi bi-hash me-1"></i>Task #${task.taskId}
                    </span>
                </div>

                <div class="row g-4">
                    <div class="col-md-6">
                        <label class="text-secondary small mb-1">Task Name</label>
                        <div class="text-white fw-bold fs-5">${task.title}</div>
                    </div>
                    <div class="col-md-6">
                        <label class="text-secondary small mb-1">Project</label>
                        <div class="text-white">
                            <i class="bi bi-kanban me-2 text-secondary"></i>${project.title}
                        </div>
                    </div>
                    <div class="col-md-6">
                        <label class="text-secondary small mb-1">Developer</label>
                        <div class="text-white">
                            <i class="bi bi-person-badge me-2 text-secondary"></i>
                            <c:set var="developerName" value="Not assigned" />
                            <c:forEach var="assignment" items="${taskUserList}">
                                <c:if test="${assignment.taskId == task.taskId}">
                                    <c:forEach var="user" items="${allUsers}">
                                        <c:if test="${user.userId == assignment.userId && user.role == 'developer'}">
                                            <c:set var="developerName" value="${user.first_name} ${user.last_name}" />
                                        </c:if>
                                    </c:forEach>
                                </c:if>
                            </c:forEach>
                            ${developerName}
                        </div>
                    </div>
                    <div class="col-md-6">
                        <label class="text-secondary small mb-1">Current Status</label>
                        <div>
                            <c:choose>
                                <c:when test="${taskUser.taskStatus == 'PendingTesting'}">
                                    <span class="badge bg-warning text-dark fs-6 p-2">
                                        <i class="bi bi-clock-history me-1"></i>Ready for Testing
                                    </span>
                                </c:when>
                                <c:when test="${taskUser.taskStatus == 'Verified'}">
                                    <span class="badge bg-success fs-6 p-2">
                                        <i class="bi bi-check-circle me-1"></i>Verified
                                    </span>
                                </c:when>
                                <c:when test="${taskUser.taskStatus == 'Defect'}">
                                    <span class="badge bg-danger fs-6 p-2">
                                        <i class="bi bi-exclamation-triangle me-1"></i>Defect Found
                                    </span>
                                </c:when>
                            </c:choose>
                        </div>
                    </div>
                    <div class="col-12">
                        <label class="text-secondary small mb-1">Description</label>
                        <div class="bg-dark p-3 rounded border border-secondary">
                            <p class="text-white-50 mb-0">${task.description}</p>
                        </div>
                    </div>
                    
                    <div class="col-12">
                        <hr class="border-secondary">
                        <h6 class="text-white mb-3">
                            <i class="bi bi-chat-dots me-2" style="color: var(--primary-color);"></i>
                            Developer's Comments
                        </h6>
                        <div class="bg-dark p-3 rounded border border-secondary" style="max-height: 200px; overflow-y: auto;">
                            <c:choose>
                                <c:when test="${not empty taskUser.comments}">
                                    <p class="text-white-50 small mb-0" style="white-space: pre-line;">
                                        ${taskUser.comments}
                                    </p>
                                </c:when>
                                <c:otherwise>
                                    <p class="text-secondary small mb-0">No comments from developer</p>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    
                    <div class="col-12">
                        <label class="text-secondary small mb-1">Documentation</label>
                        <div class="mt-2">
                            <c:choose>
                                <c:when test="${not empty task.docURL}">
                                    <a href="${task.docURL}" target="_blank" class="btn btn-outline-info btn-sm">
                                        <i class="bi bi-file-earmark-text me-1"></i> Open Documentation
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <p class="text-secondary mb-0">No documentation provided</p>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Test Result Form Section -->
        <div class="col-lg-5 mb-4">
            <div class="glass-card p-4">
                <h5 class="text-white mb-3">
                    <i class="bi bi-pencil-square me-2" style="color: var(--primary-color);"></i>
                    Test Result
                </h5>
                
                <c:choose>
                    <c:when test="${taskUser.taskStatus == 'PendingTesting'}">
                        <!-- Timer Status Card -->
                        <div class="mb-3 bg-dark p-3 rounded border border-secondary">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <i class="bi bi-stopwatch text-primary me-1"></i>
                                    <span class="text-secondary small">Testing Status:</span>
                                </div>
                                <div>
                                    <c:choose>
                                        <c:when test="${not empty taskUser.testingStartTime}">
                                            <span class="badge bg-success">
                                                <i class="bi bi-play-circle-fill me-1"></i>Testing in Progress
                                            </span>
                                            <span class="text-white fw-bold ms-2" id="liveTimer">0 mins</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-secondary">
                                                <i class="bi bi-stop-circle-fill me-1"></i>Not Started
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            
                            <c:if test="${not empty taskUser.testingStartTime}">
                                <div class="mt-2">
                                    <small class="text-secondary">
                                        <i class="bi bi-clock me-1"></i>Started at: ${formattedTestingStartTime}
                                    </small>
                                </div>
                            </c:if>
                        </div>
                        
                        <!-- Start Testing Button (only if timer not started) -->
                        <c:if test="${empty taskUser.testingStartTime}">
                            <form action="../startTesting/${taskUser.taskUserId}" method="post" class="mb-3">
                                <button type="submit" class="btn btn-primary w-100">
                                    <i class="bi bi-play-circle-fill me-2"></i>Start Testing
                                </button>
                                <small class="text-secondary d-block text-center mt-2">
                                    Click to start timer - your testing time will be tracked automatically
                                </small>
                            </form>
                        </c:if>
                        
                        <!-- Submit Result Form (only show if timer is running) -->
                        <c:if test="${not empty taskUser.testingStartTime}">
                            <form action="../updateTestTaskStatus/${taskUser.taskUserId}" method="post">
                                <input type="hidden" name="taskUserId" value="${taskUser.taskUserId}" />
                                
                                <!-- Test Result Selection -->
                                <div class="mb-4">
                                    <label class="form-label text-secondary">Test Result <span class="text-danger">*</span></label>
                                    <div class="row g-3">
                                        <div class="col-6">
                                            <div class="test-result-option glass-card p-3 text-center" 
                                                 data-value="Verified" onclick="selectResult(this, 'Verified')">
                                                <i class="bi bi-check-circle-fill fs-1 text-success"></i>
                                                <div class="fw-bold text-white mt-2">Verified</div>
                                                <div class="text-secondary small">Works correctly</div>
                                            </div>
                                        </div>
                                        <div class="col-6">
                                            <div class="test-result-option glass-card p-3 text-center" 
                                                 data-value="Defect" onclick="selectResult(this, 'Defect')">
                                                <i class="bi bi-exclamation-triangle-fill fs-1 text-danger"></i>
                                                <div class="fw-bold text-white mt-2">Defect Found</div>
                                                <div class="text-secondary small">Issue identified</div>
                                            </div>
                                        </div>
                                    </div>
                                    <input type="hidden" name="taskStatus" id="selectedResult" required>
                                </div>
                                
                                <!-- Test Comment -->
                                <div class="mb-3">
                                    <label class="form-label text-secondary">Test Comment <span class="text-danger">*</span></label>
                                    <textarea name="comments" rows="4" 
                                              class="form-control bg-dark text-white border-secondary"
                                              required placeholder="Describe your testing results..."></textarea>
                                    <small class="text-secondary">For defects, describe what went wrong and steps to reproduce</small>
                                </div>
                                
                                <!-- Submit Button -->
                                <button type="submit" class="btn btn-success w-100" id="submitBtn" disabled>
                                    <i class="bi bi-check-circle me-2"></i>Submit Test Result
                                </button>
                            </form>
                        </c:if>
                    </c:when>
                    
                    <c:when test="${taskUser.taskStatus == 'Verified'}">
                        <div class="text-center py-4">
                            <i class="bi bi-check-circle-fill fs-1 text-success"></i>
                            <h5 class="text-white mt-3">Task Verified</h5>
                            <p class="text-secondary">This task has been verified and marked as completed.</p>
                            <div class="bg-dark p-3 rounded mt-3 text-start">
                                <div class="d-flex justify-content-between mb-2">
                                    <label class="text-secondary small">Testing Time</label>
                                    <span class="text-white fw-bold">
                                        <c:if test="${not empty taskUser.utilizedHours}">
                                            <c:set var="totalMinutes" value="${taskUser.utilizedHours}" />
                                            <c:choose>
                                                <c:when test="${totalMinutes < 60}">
                                                    ${totalMinutes} minute${totalMinutes != 1 ? 's' : ''}
                                                </c:when>
                                                <c:otherwise>
                                                    <c:set var="hours" value="${totalMinutes / 60}" />
                                                    <c:set var="minutes" value="${totalMinutes % 60}" />
                                                    <fmt:formatNumber value="${hours}" maxFractionDigits="0" /> hr${hours != 1 ? 's' : ''}
                                                    <c:if test="${minutes > 0}">
                                                        ${minutes} minute${minutes != 1 ? 's' : ''}
                                                    </c:if>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:if>
                                        <c:if test="${empty taskUser.utilizedHours}">
                                            0 minutes
                                        </c:if>
                                    </span>
                                </div>
                                <div class="d-flex justify-content-between">
                                    <label class="text-secondary small">Test Comment</label>
                                    <p class="text-white-50 mb-0" style="white-space: pre-line;">${taskUser.comments}</p>
                                </div>
                            </div>
                        </div>
                    </c:when>
                    
                    <c:when test="${taskUser.taskStatus == 'Defect'}">
                        <div class="text-center py-4">
                            <i class="bi bi-exclamation-triangle-fill fs-1 text-danger"></i>
                            <h5 class="text-white mt-3">Defect Reported</h5>
                            <p class="text-secondary">A defect was found during testing. Developer will fix it.</p>
                            <div class="bg-dark p-3 rounded mt-3 text-start">
                                <div class="d-flex justify-content-between mb-2">
                                    <label class="text-secondary small">Testing Time</label>
                                    <span class="text-white fw-bold">
                                        <c:if test="${not empty taskUser.utilizedHours}">
                                            <c:set var="totalMinutes" value="${taskUser.utilizedHours}" />
                                            <c:choose>
                                                <c:when test="${totalMinutes < 60}">
                                                    ${totalMinutes} minute${totalMinutes != 1 ? 's' : ''}
                                                </c:when>
                                                <c:otherwise>
                                                    <c:set var="hours" value="${totalMinutes / 60}" />
                                                    <c:set var="minutes" value="${totalMinutes % 60}" />
                                                    <fmt:formatNumber value="${hours}" maxFractionDigits="0" /> hr${hours != 1 ? 's' : ''}
                                                    <c:if test="${minutes > 0}">
                                                        ${minutes} minute${minutes != 1 ? 's' : ''}
                                                    </c:if>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:if>
                                        <c:if test="${empty taskUser.utilizedHours}">
                                            0 minutes
                                        </c:if>
                                    </span>
                                </div>
                                <div class="d-flex justify-content-between">
                                    <label class="text-secondary small">Defect Description</label>
                                    <p class="text-white-50 mb-0" style="white-space: pre-line;">${taskUser.comments}</p>
                                </div>
                            </div>
                        </div>
                    </c:when>
                </c:choose>
            </div>
            
            <!-- Testing Tips Card -->
            <div class="glass-card p-4 mt-4">
                <h6 class="text-white mb-3">
                    <i class="bi bi-lightbulb me-2 text-warning"></i>Testing Tips
                </h6>
                <ul class="text-secondary small mb-0">
                    <li>Test all features as described in the task</li>
                    <li>Check for edge cases and invalid inputs</li>
                    <li>Verify the feature works across different scenarios</li>
                    <li>Document defects clearly with steps to reproduce</li>
                    <li>Include screenshots if possible</li>
                </ul>
                
                <hr class="border-secondary my-3">
                <div class="text-center">
                    <small class="text-info">
                        <i class="bi bi-stopwatch me-1"></i>
                        Click "Start Testing" to begin tracking your testing time.
                        Time is only counted when you are actively testing.
                    </small>
                </div>
            </div>
        </div>
    </div>
</main>

<script>
function selectResult(element, result) {
    document.getElementById('selectedResult').value = result;
    document.getElementById('submitBtn').disabled = false;
    
    const options = document.querySelectorAll('.test-result-option');
    options.forEach(opt => {
        opt.classList.remove('border-primary');
        opt.style.background = '';
    });
    
    element.classList.add('border-primary');
    element.style.background = 'rgba(99, 102, 241, 0.1)';
}

// ✅ Live timer for testing duration
document.addEventListener('DOMContentLoaded', function() {
    const startTime = '${taskUser.testingStartTime}';
    const liveTimer = document.getElementById('liveTimer');
    
    if (startTime && liveTimer) {
        const start = new Date(startTime);
        
        function updateTimer() {
            const now = new Date();
            const diffMs = now - start;
            const diffMinutes = Math.floor(diffMs / (1000 * 60));
            const diffHours = Math.floor(diffMinutes / 60);
            const remainingMinutes = diffMinutes % 60;
            
            if (diffHours > 0) {
                liveTimer.textContent = diffHours + 'h ' + remainingMinutes + 'm';
            } else {
                liveTimer.textContent = diffMinutes + ' minute' + (diffMinutes != 1 ? 's' : '');
            }
        }
        
        updateTimer();
        setInterval(updateTimer, 60000); // Update every minute
    }
});
</script>

<style>
.test-result-option {
    transition: all 0.2s;
    border: 2px solid transparent;
    cursor: pointer;
}
.test-result-option:hover {
    transform: translateY(-2px);
    border-color: var(--primary-color);
}
.test-result-option.border-primary {
    border-color: var(--primary-color);
    background: rgba(99, 102, 241, 0.1);
}
</style>

<jsp:include page="TesterFooter.jsp" />