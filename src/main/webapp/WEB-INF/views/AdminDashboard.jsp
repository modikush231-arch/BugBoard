<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="Admin Dashboard" scope="request" />
<c:set var="activeNav" value="dashboard" scope="request" />

<jsp:include page="adminheader.jsp" />
<jsp:include page="adminsidebar.jsp" />

<main class="main-content" id="mainContent">
<style>
.progress {
    background-color: #2d3748 !important;
    border-radius: 10px;
    overflow: hidden;
}
.progress-bar {
    transition: width 0.3s ease;
}
.progress-bar.bg-success { background-color: #10b981 !important; }
.progress-bar.bg-primary { background-color: #3b82f6 !important; }
.progress-bar.bg-warning { background-color: #f59e0b !important; }
.progress-bar.bg-purple { background-color: #a855f7 !important; }
.progress-bar.bg-secondary { background-color: #64748b !important; }

/* Quick Actions styling */
.quick-action-card {
    padding: 1rem;
    text-align: center;
    cursor: pointer;
    transition: all 0.3s ease;
    background: rgba(255, 255, 255, 0.05);
    backdrop-filter: blur(10px);
    border-radius: 12px;
    border: 1px solid rgba(255, 255, 255, 0.1);
}
.quick-action-card:hover {
    transform: translateY(-5px);
    background: rgba(255, 255, 255, 0.1);
}
.action-icon {
    width: 50px;
    height: 50px;
    border-radius: 12px;
    display: flex;
    align-items: center;
    justify-content: center;
    margin: 0 auto 10px;
    font-size: 1.5rem;
    background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
    color: white;
}

/* Scrollable Recent Projects */
.recent-projects-table-container {
    max-height: 350px;
    overflow-y: auto;
}
</style>

    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h1 class="h2 mb-2 text-white">
                <i class="bi bi-speedometer2 me-2" style="color: var(--primary-color);"></i>
                Admin Dashboard
            </h1>
            <p class="text-secondary mb-0">Welcome back! Here's your project overview.</p>
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

    <!-- Statistics Cards -->
    <div class="row mb-4 g-4">
        <div class="col-xl-3 col-md-6">
            <div class="glass-card stat-card card-projects fade-in">
                <div class="stat-icon icon-projects"><i class="bi bi-folder"></i></div>
                <div class="stat-number text-white">${totalProjects}</div>
                <div class="text-secondary">Total Projects</div>
            </div>
        </div>
        <div class="col-xl-3 col-md-6">
            <div class="glass-card stat-card card-users fade-in delay-1">
                <div class="stat-icon icon-users"><i class="bi bi-play-circle"></i></div>
                <div class="stat-number text-white">${ongoingProjects}</div>
                <div class="text-secondary">Ongoing Projects</div>
            </div>
        </div>
        <div class="col-xl-3 col-md-6">
            <div class="glass-card stat-card card-bugs fade-in delay-2">
                <div class="stat-icon icon-bugs"><i class="bi bi-kanban"></i></div>
                <div class="stat-number text-white">${totalTasks}</div>
                <div class="text-secondary">Total Tasks</div>
            </div>
        </div>
        <div class="col-xl-3 col-md-6">
            <div class="glass-card stat-card card-pending fade-in delay-3">
                <div class="stat-icon icon-pending"><i class="bi bi-clock-history"></i></div>
                <div class="stat-number text-white">${pendingTasks}</div>
                <div class="text-secondary">Pending Tasks</div>
            </div>
        </div>
    </div>

    <!-- Charts Row -->
    <div class="row g-4 mb-4">
        <div class="col-xl-7">
            <div class="glass-card h-100">
                <div class="d-flex justify-content-between align-items-center p-4 border-bottom border-secondary">
                    <h5 class="mb-0 text-white"><i class="bi bi-pie-chart me-2"></i>Project Status Distribution</h5>
                </div>
                <div class="chart-container p-3" style="height: 300px; position: relative;">
                    <canvas id="projectStatusChart" style="width: 100%; height: 100%; display: block;"></canvas>
                </div>
            </div>
        </div>

        <div class="col-xl-5">
            <div class="glass-card h-100">
                <div class="d-flex justify-content-between align-items-center p-4 border-bottom border-secondary">
                    <h5 class="mb-0 text-white"><i class="bi bi-clock-history me-2"></i>Recent Activity</h5>
                </div>
                <div class="p-3" style="max-height:300px; overflow-y:auto;">
                    <c:forEach var="activity" items="${recentActivities}">
                        <div class="activity-item mb-3">
                            <div class="d-flex align-items-start">
                                <div class="activity-icon me-3" style="background: rgba(99,102,241,0.2);">
                                    <i class="bi bi-arrow-repeat text-warning"></i>
                                </div>
                                <div>
                                    <div class="fw-medium text-white">${activity.message}</div>
                                    <div class="text-secondary smaller mt-1">${activity.timeAgo}</div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                    <c:if test="${empty recentActivities}">
                        <div class="text-center text-secondary py-4">
                            <i class="bi bi-clock-history fs-1 d-block mb-3"></i>
                            <p>No recent activities</p>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>

    <!-- Quick Actions & Recent Projects -->
    <div class="row g-4">
        <!-- Quick Actions Card (4 buttons in 2x2 grid) -->
        <div class="col-lg-4">
            <div class="glass-card h-100">
                <div class="p-4 border-bottom border-secondary">
                    <h5 class="mb-0 text-white"><i class="bi bi-lightning me-2"></i>Quick Actions</h5>
                </div>
                <div class="p-4">
                    <div class="row g-3">
                        <div class="col-6">
                            <div class="quick-action-card" onclick="location.href='projectList'">
                                <div class="action-icon"><i class="bi bi-folder2-open"></i></div>
                                <div class="fw-medium text-white">View Projects</div>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="quick-action-card" onclick="location.href='taskList'">
                                <div class="action-icon"><i class="bi bi-plus-lg"></i></div>
                                <div class="fw-medium text-white">Add Task</div>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="quick-action-card" onclick="location.href='UserList'">
                                <div class="action-icon"><i class="bi bi-people"></i></div>
                                <div class="fw-medium text-white">View Users</div>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="quick-action-card" onclick="location.href='moduleList'">
                                <div class="action-icon"><i class="bi bi-collection"></i></div>
                                <div class="fw-medium text-white">View Modules</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Recent Projects with Scrollbar -->
        <div class="col-lg-8">
            <div class="glass-card h-100">
                <div class="d-flex justify-content-between align-items-center p-4 border-bottom border-secondary">
                    <h5 class="mb-0 text-white"><i class="bi bi-kanban me-2"></i>Recent Projects</h5>
                    <a href="projectList" class="text-primary small text-decoration-none">View All</a>
                </div>
                <div class="recent-projects-table-container">
                    <div class="table-responsive">
                        <table class="table table-borderless table-hover mb-0">
                            <thead class="text-secondary">
                                <tr>
                                    <th>Project Name</th>
                                    <th>Status</th>
                                    <th>Progress</th>
                                    <th>Due Date</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${recentProjects}" var="p" varStatus="status">
                                    <tr>
                                        <td>
                                            <div class="fw-medium text-white">${p.title}</div>
                                            <div class="text-secondary small">Project #${p.projectId}</div>
                                        </td>
                                        <!-- Status Badge -->
                                        <td>
                                            <span class="badge 
                                                <c:choose>
                                                    <c:when test="${p.projectStatusId == 5}">bg-success</c:when>
                                                    <c:when test="${p.projectStatusId == 4}">bg-primary</c:when>
                                                    <c:when test="${p.projectStatusId == 3}">bg-warning text-dark</c:when>
                                                    <c:when test="${p.projectStatusId == 1}">bg-purple</c:when>
                                                    <c:otherwise>bg-secondary</c:otherwise>
                                                </c:choose>
                                            ">
                                                <c:choose>
                                                    <c:when test="${p.projectStatusId == 1}">Lead</c:when>
                                                    <c:when test="${p.projectStatusId == 2}">Not Started</c:when>
                                                    <c:when test="${p.projectStatusId == 3}">Hold</c:when>
                                                    <c:when test="${p.projectStatusId == 4}">In Progress</c:when>
                                                    <c:when test="${p.projectStatusId == 5}">Completed</c:when>
                                                    <c:otherwise>Unknown</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </td>
                                        <!-- Progress Bar -->
                                        <td style="min-width: 120px;">
                                            <div class="d-flex align-items-center">
                                                <div class="progress flex-grow-1 me-2" style="height: 10px; background-color: #2d3748;">
                                                    <div class="progress-bar 
                                                        <c:choose>
                                                            <c:when test="${p.projectStatusId == 5}">bg-success</c:when>
                                                            <c:when test="${p.projectStatusId == 4}">bg-primary</c:when>
                                                            <c:when test="${p.projectStatusId == 3}">bg-warning</c:when>
                                                            <c:when test="${p.projectStatusId == 1}">bg-purple</c:when>
                                                            <c:otherwise>bg-secondary</c:otherwise>
                                                        </c:choose>
                                                    " style="width: 
                                                        <c:choose>
                                                            <c:when test="${p.projectStatusId == 5}">100%</c:when>
                                                            <c:when test="${p.projectStatusId == 4}">60%</c:when>
                                                            <c:when test="${p.projectStatusId == 3}">30%</c:when>
                                                            <c:when test="${p.projectStatusId == 2}">10%</c:when>
                                                            <c:when test="${p.projectStatusId == 1}">5%</c:when>
                                                            <c:otherwise>0%</c:otherwise>
                                                        </c:choose>
                                                    "></div>
                                                </div>
                                                <span class="small text-secondary">
                                                    <c:choose>
                                                        <c:when test="${p.projectStatusId == 5}">100</c:when>
                                                        <c:when test="${p.projectStatusId == 4}">60</c:when>
                                                        <c:when test="${p.projectStatusId == 3}">30</c:when>
                                                        <c:when test="${p.projectStatusId == 2}">10</c:when>
                                                        <c:when test="${p.projectStatusId == 1}">5</c:when>
                                                        <c:otherwise>0</c:otherwise>
                                                    </c:choose>%
                                                </span>
                                            </div>
                                        </td>
                                        <td class="text-secondary">${p.projectCompletionDate != null ? p.projectCompletionDate : 'Not set'}</td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty recentProjects}">
                                    <tr>
                                        <td colspan="4" class="text-center text-secondary py-4">No projects found</td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="adminfooter.jsp" />

<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function() {
    const ctx = document.getElementById('projectStatusChart').getContext('2d');
    new Chart(ctx, {
        type: 'doughnut',
        data: {
            labels: ['Lead', 'Not Started', 'In Progress', 'Hold', 'Completed'],
            datasets: [{
                data: [${leadProjects}, ${notStartedProjects}, ${progressProjects}, ${holdProjects}, ${completedProjects}],
                backgroundColor: ['rgba(168,85,247,0.7)', 'rgba(156,163,175,0.7)', 'rgba(59,130,246,0.7)', 'rgba(245,158,11,0.7)', 'rgba(16,185,129,0.7)'],
                borderColor: 'rgba(30,41,59,1)',
                borderWidth: 2
            }]
        },
        options: { responsive: true, maintainAspectRatio: false, plugins: { legend: { position: 'right', labels: { color: '#94a3b8' } } } }
    });
});
</script>