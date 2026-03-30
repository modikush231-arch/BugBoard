<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="Developer Dashboard" scope="request" />
<c:set var="activeNav" value="dashboard" scope="request" />

<jsp:include page="DeveloperHeader.jsp" />
<jsp:include page="DeveloperSidebar.jsp" />

<main class="main-content" id="mainContent">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h1 class="h2 mb-2 text-white">
                <i class="bi bi-code-slash me-2" style="color: var(--primary-color);"></i>
                Developer Dashboard
            </h1>
            <p class="text-secondary mb-0">Welcome back, ${sessionScope.dbuser.first_name}! Track your development progress.</p>
        </div>
        <div class="d-flex gap-2">
            <button class="btn btn-outline-secondary text-white">
                <i class="bi bi-calendar me-2"></i><%= new java.text.SimpleDateFormat("MMMM dd, yyyy").format(new java.util.Date()) %>
            </button>
            <button class="btn btn-primary" onclick="location.reload()">
                <i class="bi bi-arrow-clockwise"></i>
            </button>
        </div>
    </div>

    <!-- Statistics Cards Row -->
    <div class="row mb-4 g-4">
        <div class="col-xl-2 col-md-4 col-6">
            <div class="glass-card stat-card card-projects fade-in">
                <div class="stat-icon icon-projects"><i class="bi bi-folder"></i></div>
                <div class="stat-number text-white">${totalProjects}</div>
                <div class="text-secondary">Total Projects</div>
            </div>
        </div>
        <div class="col-xl-2 col-md-4 col-6">
            <div class="glass-card stat-card card-users fade-in delay-1">
                <div class="stat-icon icon-users"><i class="bi bi-play-circle"></i></div>
                <div class="stat-number text-white">${ongoingProjects}</div>
                <div class="text-secondary">Ongoing Projects</div>
            </div>
        </div>
        <div class="col-xl-2 col-md-4 col-6">
            <div class="glass-card stat-card card-tasks fade-in delay-2">
                <div class="stat-icon icon-tasks"><i class="bi bi-list-task"></i></div>
                <div class="stat-number text-white">${totalTasks}</div>
                <div class="text-secondary">Total Tasks</div>
            </div>
        </div>
        <div class="col-xl-2 col-md-4 col-6">
            <div class="glass-card stat-card card-inprogress fade-in delay-3">
                <div class="stat-icon icon-inprogress"><i class="bi bi-arrow-repeat"></i></div>
                <div class="stat-number text-white">${inProgressCount}</div>
                <div class="text-secondary">In Progress</div>
            </div>
        </div>
        <div class="col-xl-2 col-md-4 col-6">
            <div class="glass-card stat-card card-pending fade-in delay-4">
                <div class="stat-icon icon-pending"><i class="bi bi-clock-history"></i></div>
                <div class="stat-number text-white">${pendingTasks}</div>
                <div class="text-secondary">Pending Review</div>
            </div>
        </div>
        <div class="col-xl-2 col-md-4 col-6">
            <div class="glass-card stat-card card-defect fade-in delay-5">
                <div class="stat-icon icon-defect"><i class="bi bi-exclamation-triangle"></i></div>
                <div class="stat-number text-white">${defectCount}</div>
                <div class="text-secondary">Defects to Fix</div>
            </div>
        </div>
    </div>

    <!-- Charts Row -->
    <div class="row g-4 mb-4">
        <!-- Task Status Chart -->
        <div class="col-xl-5">
            <div class="glass-card h-100">
                <div class="d-flex justify-content-between align-items-center p-4 border-bottom border-secondary">
                    <h5 class="mb-0 text-white">
                        <i class="bi bi-pie-chart me-2"></i>Task Status Distribution
                    </h5>
                </div>
                <div class="chart-container p-3" style="height: 280px; position: relative;">
                    <canvas id="taskStatusChart" style="width: 100%; height: 100%; display: block;"></canvas>
                </div>
            </div>
        </div>

        <!-- Recent Activities -->
        <div class="col-xl-7">
            <div class="glass-card h-100">
                <div class="d-flex justify-content-between align-items-center p-4 border-bottom border-secondary">
                    <h5 class="mb-0 text-white">
                        <i class="bi bi-clock-history me-2"></i>Recent Activities
                    </h5>
                </div>
                <div class="p-3" style="max-height: 280px; overflow-y: auto;">
                    <c:forEach var="activity" items="${recentActivities}" varStatus="status">
                        <div class="activity-item mb-3">
                            <div class="d-flex align-items-start">
                                <div class="activity-icon me-3" style="background: rgba(99,102,241,0.2);">
                                    <c:choose>
                                        <c:when test="${activity.taskStatus == 'Completed'}">
                                            <i class="bi bi-check-circle text-success"></i>
                                        </c:when>
                                        <c:when test="${activity.taskStatus == 'InProgress'}">
                                            <i class="bi bi-arrow-repeat text-primary"></i>
                                        </c:when>
                                        <c:when test="${activity.taskStatus == 'PendingTesting'}">
                                            <i class="bi bi-send text-warning"></i>
                                        </c:when>
                                        <c:when test="${activity.taskStatus == 'Defect'}">
                                            <i class="bi bi-exclamation-triangle text-danger"></i>
                                        </c:when>
                                        <c:otherwise>
                                            <i class="bi bi-clock text-info"></i>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="flex-grow-1">
                                    <div class="fw-medium text-white">${activity.taskTitle}</div>
                                    <div class="text-secondary small mt-1">
                                        <i class="bi bi-info-circle me-1"></i>${activity.activityMessage}
                                    </div>
                                    <div class="text-secondary smaller mt-1">
                                        <i class="bi bi-clock me-1"></i>${activity.timeAgo}
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                    
                    <c:if test="${empty recentActivities}">
                        <div class="text-center text-secondary py-4">
                            <i class="bi bi-clock-history fs-1 d-block mb-3"></i>
                            <p>No recent activities in the last 7 days</p>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>

    <!-- Quick Actions and Tasks Row -->
    <div class="row g-4">
        <!-- Quick Actions -->
        <div class="col-lg-3">
            <div class="glass-card h-100">
                <div class="p-4 border-bottom border-secondary">
                    <h5 class="mb-0 text-white">
                        <i class="bi bi-lightning me-2"></i>Quick Actions
                    </h5>
                </div>
                <div class="p-4">
                    <div class="row g-3">
                        <div class="col-6">
                            <div class="quick-action-card glass-card" onclick="location.href='taskListDeveloper'">
                                <div class="action-icon"><i class="bi bi-list-task"></i></div>
                                <div class="fw-medium text-white">All Tasks</div>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="quick-action-card glass-card" onclick="location.href='taskListDeveloper'">
                                <div class="action-icon"><i class="bi bi-play-circle"></i></div>
                                <div class="fw-medium text-white">In Progress</div>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="quick-action-card glass-card" onclick="location.href='taskListDeveloper?status=PendingTesting'">
                                <div class="action-icon"><i class="bi bi-send"></i></div>
                                <div class="fw-medium text-white">Ready for QA</div>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="quick-action-card glass-card" onclick="location.href='taskListDeveloper?status=Defect'">
                                <div class="action-icon"><i class="bi bi-bug"></i></div>
                                <div class="fw-medium text-white">Defects</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- My Recent Tasks -->
        <div class="col-lg-5">
            <div class="glass-card h-100">
                <div class="d-flex justify-content-between align-items-center p-4 border-bottom border-secondary">
                    <h5 class="mb-0 text-white">
                        <i class="bi bi-list-task me-2"></i>My Recent Tasks
                        <c:if test="${pendingTasks > 0}">
                            <span class="badge bg-warning ms-2">${pendingTasks}</span>
                        </c:if>
                    </h5>
                    <a href="taskListDeveloper" class="text-primary small text-decoration-none">View All</a>
                </div>
                <div class="table-responsive p-3" style="max-height: 350px; overflow-y: auto;">
                    <table class="table table-borderless table-hover mb-0">
                        <thead class="text-secondary">
                            <tr>
                                <th>Task Name</th>
                                <th>Project</th>
                                <th>Status</th>
                                <th>Action</th>
                              </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${recentTasks}" var="task" varStatus="status">
                                 <c:if test="${status.index < 5}">
                                      <tr>
                                          <td><div class="fw-medium text-white">${task.taskTitle}</div></td>
                                          <td class="text-secondary">${task.projectName}</td>
                                          <td>
                                              <c:choose>
                                                  <c:when test="${task.taskStatus == 'Assigned'}">
                                                      <span class="badge bg-info">${task.taskStatus}</span>
                                                  </c:when>
                                                  <c:when test="${task.taskStatus == 'InProgress'}">
                                                      <span class="badge bg-primary">${task.taskStatus}</span>
                                                  </c:when>
                                                  <c:when test="${task.taskStatus == 'PendingTesting'}">
                                                      <span class="badge bg-warning text-dark">Ready for QA</span>
                                                  </c:when>
                                                  <c:when test="${task.taskStatus == 'Completed'}">
                                                      <span class="badge bg-success">${task.taskStatus}</span>
                                                  </c:when>
                                                  <c:when test="${task.taskStatus == 'Defect'}">
                                                      <span class="badge bg-danger">${task.taskStatus}</span>
                                                  </c:when>
                                              </c:choose>
                                          </td>
                                          <td><a href="viewTaskDeveloper/${task.taskId}" class="btn btn-sm btn-primary"><i class="bi bi-eye"></i> View</a></td>
                                      </tr>
                                 </c:if>
                            </c:forEach>
                            <c:if test="${empty recentTasks}">
                                <tr>
                                    <td colspan="4" class="text-center text-secondary py-4">
                                        <i class="bi bi-inbox fs-1 d-block mb-2"></i>
                                        <p>No tasks assigned yet</p>
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Defect Summary -->
        <div class="col-lg-4">
            <div class="glass-card h-100">
                <div class="p-4 border-bottom border-secondary">
                    <h5 class="mb-0 text-white">
                        <i class="bi bi-exclamation-triangle me-2"></i>Defects to Fix
                        <c:if test="${defectCount > 0}">
                            <span class="badge bg-danger ms-2">${defectCount}</span>
                        </c:if>
                    </h5>
                </div>
                <div class="p-3">
                    <c:if test="${defectCount > 0}">
                        <div class="list-group list-group-flush bg-transparent">
                            <c:forEach items="${recentDefects}" var="defect" varStatus="status">
                                <c:if test="${status.index < 3}">
                                    <div class="list-group-item bg-transparent border-secondary px-0">
                                        <div class="d-flex justify-content-between align-items-center">
                                            <div>
                                                <div class="text-white fw-medium">${defect.taskTitle}</div>
                                                <div class="text-secondary small">${defect.comment}</div>
                                            </div>
                                            <a href="viewTaskDeveloper/${defect.taskId}" class="btn btn-sm btn-outline-danger">
                                                <i class="bi bi-eye"></i>
                                            </a>
                                        </div>
                                    </div>
                                </c:if>
                            </c:forEach>
                            <c:if test="${defectCount > 3}">
                                <div class="text-center mt-2">
                                    <a href="taskListDeveloper?status=Defect" class="text-primary small">View all ${defectCount} defects →</a>
                                </div>
                            </c:if>
                        </div>
                    </c:if>
                    <c:if test="${defectCount == 0}">
                        <div class="text-center text-secondary py-4">
                            <i class="bi bi-check-circle-fill fs-1 text-success mb-3 d-block"></i>
                            <p>No defects found!</p>
                            <small>Great job! All tasks are working correctly.</small>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="DeveloperFooter.jsp" />

<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function() {
    const canvas = document.getElementById('taskStatusChart');
    if (!canvas) return;
    
    const ctx = canvas.getContext('2d');
    
    const assigned = Number(${assignedCount != null ? assignedCount : 0});
    const inProgress = Number(${inProgressCount != null ? inProgressCount : 0});
    const pendingTesting = Number(${pendingTestingCount != null ? pendingTestingCount : 0});
    const completed = Number(${completedCount != null ? completedCount : 0});
    const defect = Number(${defectCount != null ? defectCount : 0});
    
    const total = assigned + inProgress + pendingTesting + completed + defect;
    
    if (total === 0) {
        canvas.style.display = 'none';
        canvas.parentElement.innerHTML = '<div class="text-center text-secondary py-5"><i class="bi bi-pie-chart fs-1 d-block mb-3"></i><p>No task data available</p></div>';
        return;
    }
    
    const labels = [];
    const data = [];
    const colors = [];
    
    if (assigned > 0) {
        labels.push('Assigned');
        data.push(assigned);
        colors.push('rgba(13, 202, 240, 0.8)');
    }
    if (inProgress > 0) {
        labels.push('In Progress');
        data.push(inProgress);
        colors.push('rgba(13, 110, 253, 0.8)');
    }
    if (pendingTesting > 0) {
        labels.push('Pending Testing');
        data.push(pendingTesting);
        colors.push('rgba(255, 193, 7, 0.8)');
    }
    if (completed > 0) {
        labels.push('Completed');
        data.push(completed);
        colors.push('rgba(25, 135, 84, 0.8)');
    }
    if (defect > 0) {
        labels.push('Defect');
        data.push(defect);
        colors.push('rgba(220, 53, 69, 0.8)');
    }
    
    new Chart(ctx, {
        type: 'doughnut',
        data: {
            labels: labels,
            datasets: [{
                data: data,
                backgroundColor: colors,
                borderColor: 'rgba(30, 41, 59, 1)',
                borderWidth: 2
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: { position: 'right', labels: { color: '#94a3b8' } },
                tooltip: {
                    callbacks: {
                        label: function(context) {
                            const value = context.raw;
                            const total = context.dataset.data.reduce((a, b) => a + b, 0);
                            const percent = Math.round((value / total) * 100);
                            return context.label + ': ' + value + ' (' + percent + '%)';
                        }
                    }
                }
            }
        }
    });
});
</script>

<style>
.stat-card {
    padding: 1rem;
    text-align: center;
}
.stat-icon {
    width: 48px;
    height: 48px;
    border-radius: 12px;
    display: flex;
    align-items: center;
    justify-content: center;
    margin: 0 auto 0.75rem;
    font-size: 1.5rem;
}
.icon-tasks { background: rgba(59, 130, 246, 0.2); color: #3b82f6; }
.icon-inprogress { background: rgba(16, 185, 129, 0.2); color: #10b981; }
.icon-defect { background: rgba(239, 68, 68, 0.2); color: #ef4444; }
.card-tasks::before { background: #3b82f6; }
.card-inprogress::before { background: #10b981; }
.card-defect::before { background: #ef4444; }
</style>