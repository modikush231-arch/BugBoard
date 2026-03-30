<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="Project Manager Dashboard" scope="request" />
<c:set var="activeNav" value="dashboard" scope="request" />

<jsp:include page="ProjectManagerHeader.jsp" />
<jsp:include page="ProjectManagerSidebar.jsp" />

<main class="main-content" id="mainContent">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h1 class="h2 mb-2 text-white">
                <i class="bi bi-kanban me-2" style="color: var(--primary-color);"></i>
                Project Manager Dashboard
            </h1>
            <p class="text-secondary mb-0">Welcome back, ${sessionScope.dbuser.first_name}! Track your project progress.</p>
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

    <!-- 6 Statistics Cards Row -->
    <div class="row mb-4 g-4">
        <div class="col-xl-2 col-md-4 col-6">
            <div class="glass-card stat-card card-projects fade-in">
                <div class="stat-icon icon-projects"><i class="bi bi-folder"></i></div>
                <div class="stat-number text-white">${totalProjects}</div>
                <div class="text-secondary">Total Projects</div>
            </div>
        </div>
        <div class="col-xl-2 col-md-4 col-6">
            <div class="glass-card stat-card card-ongoing fade-in delay-1">
                <div class="stat-icon icon-ongoing"><i class="bi bi-play-circle"></i></div>
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
            <div class="glass-card stat-card card-pending fade-in delay-3">
                <div class="stat-icon icon-pending"><i class="bi bi-clock-history"></i></div>
                <div class="stat-number text-white">${pendingTasks}</div>
                <div class="text-secondary">Pending Tasks</div>
            </div>
        </div>
        <div class="col-xl-2 col-md-4 col-6">
            <div class="glass-card stat-card card-lead fade-in delay-4">
                <div class="stat-icon icon-lead"><i class="bi bi-star"></i></div>
                <div class="stat-number text-white">${leadProjects}</div>
                <div class="text-secondary">Lead Projects</div>
            </div>
        </div>
        <div class="col-xl-2 col-md-4 col-6">
            <div class="glass-card stat-card card-hold fade-in delay-5">
                <div class="stat-icon icon-hold"><i class="bi bi-pause-circle"></i></div>
                <div class="stat-number text-white">${holdProjects}</div>
                <div class="text-secondary">On Hold</div>
            </div>
        </div>
    </div>

    <!-- Charts Row -->
    <div class="row g-4 mb-4">
        <div class="col-xl-7">
            <div class="glass-card h-100">
                <div class="d-flex justify-content-between align-items-center p-4 border-bottom border-secondary">
                    <h5 class="mb-0 text-white">
                        <i class="bi bi-pie-chart me-2"></i>Project Status Distribution
                    </h5>
                </div>
                <div class="chart-container p-3" style="height: 280px; position: relative;">
                    <canvas id="projectStatusChart" style="width: 100%; height: 100%; display: block;"></canvas>
                </div>
            </div>
        </div>
        <div class="col-xl-5">
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
                                        <c:when test="${activity.type == 'task_created'}">
                                            <i class="bi bi-plus-circle text-primary"></i>
                                        </c:when>
                                        <c:when test="${activity.type == 'task_completed'}">
                                            <i class="bi bi-check-circle text-success"></i>
                                        </c:when>
                                        <c:when test="${activity.type == 'task_assigned'}">
                                            <i class="bi bi-person-plus text-info"></i>
                                        </c:when>
                                        <c:otherwise>
                                            <i class="bi bi-arrow-repeat text-warning"></i>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="flex-grow-1">
                                    <div class="fw-medium text-white">${activity.message}</div>
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
                            <p>No recent activities</p>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>

    <!-- Quick Actions and Recent Projects Row -->
    <div class="row g-4">
        <div class="col-lg-4">
            <div class="glass-card h-100">
                <div class="p-4 border-bottom border-secondary">
                    <h5 class="mb-0 text-white">
                        <i class="bi bi-lightning me-2"></i>Quick Actions
                    </h5>
                </div>
                <div class="p-4">
                    <div class="row g-3">
                        <div class="col-6">
                            <div class="quick-action-card glass-card" onclick="location.href='projectListPM'">
                                <div class="action-icon"><i class="bi bi-folder2-open"></i></div>
                                <div class="fw-medium text-white">View Projects</div>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="quick-action-card glass-card" onclick="location.href='taskListPM'">
                                <div class="action-icon"><i class="bi bi-plus-lg"></i></div>
                                <div class="fw-medium text-white">Add Task</div>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="quick-action-card glass-card" onclick="location.href='moduleListPM'">
                                <div class="action-icon"><i class="bi bi-collection"></i></div>
                                <div class="fw-medium text-white">Modules</div>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="quick-action-card glass-card" onclick="location.href='taskUserListPM'">
                                <div class="action-icon"><i class="bi bi-person-check"></i></div>
                                <div class="fw-medium text-white">Assign Tasks</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-lg-8">
            <div class="glass-card h-100">
                <div class="d-flex justify-content-between align-items-center p-4 border-bottom border-secondary">
                    <h5 class="mb-0 text-white">
                        <i class="bi bi-kanban me-2"></i>Recent Projects
                    </h5>
                    <a href="projectListPM" class="text-primary small text-decoration-none">View All</a>
                </div>
                <div class="table-responsive p-3" style="max-height: 350px; overflow-y: auto;">
                    <table class="table table-borderless table-hover mb-0">
                        <thead class="text-secondary">
                            <tr>
                                <th>Project Name</th>
                                <th>Status</th>
                                <th>Progress</th>
                                <th>Tasks</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${recentProjects}" var="project" varStatus="status">
                                <c:if test="${status.index < 5}">
                                    <tr>
                                        <td>
                                            <div class="fw-medium text-white">${project.title}</div>
                                            <div class="text-secondary small">Project #${project.projectId}</div>
                                        </td>
                                        <td>
                                            <c:forEach var="s" items="${statusList}">
                                                <c:if test="${s.projectStatusId == project.projectStatusId}">
                                                    <span class="badge 
                                                        <c:choose>
                                                            <c:when test="${s.status == 'Lead'}">bg-purple</c:when>
                                                            <c:when test="${s.status == 'Not Started'}">bg-secondary</c:when>
                                                            <c:when test="${s.status == 'In Progress'}">bg-primary</c:when>
                                                            <c:when test="${s.status == 'Hold'}">bg-warning text-dark</c:when>
                                                            <c:when test="${s.status == 'Completed'}">bg-success</c:when>
                                                        </c:choose>
                                                    ">${s.status}</span>
                                                </c:if>
                                            </c:forEach>
                                        </td>
                                        <td style="min-width: 120px;">
                                            <div class="d-flex align-items-center">
                                                <div class="progress flex-grow-1 me-2" style="height:6px;">
                                                    <div class="progress-bar bg-info" style="width: ${project.progress != null ? project.progress : 0}%"></div>
                                                </div>
                                                <span class="small text-secondary">${project.progress != null ? project.progress : 0}%</span>
                                            </div>
                                        </td>
                                        <td class="text-secondary">${project.taskCount != null ? project.taskCount : 0} tasks</td>
                                        <td>
                                            <a href="viewProjectPM/${project.projectId}" class="btn btn-sm btn-primary">
                                                <i class="bi bi-eye"></i> View
                                            </a>
                                        </td>
                                    </tr>
                                </c:if>
                            </c:forEach>
                            <c:if test="${empty recentProjects}">
                                <tr>
                                    <td colspan="5" class="text-center text-secondary py-4">No projects found</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="ProjectManagerFooter.jsp" />

<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function() {
    const canvas = document.getElementById('projectStatusChart');
    if (!canvas) return;
    const ctx = canvas.getContext('2d');
    const lead = Number(${leadProjects != null ? leadProjects : 0});
    const notStarted = Number(${notStartedProjects != null ? notStartedProjects : 0});
    const progress = Number(${progressProjects != null ? progressProjects : 0});
    const hold = Number(${holdProjects != null ? holdProjects : 0});
    const completed = Number(${completedProjects != null ? completedProjects : 0});
    const total = lead + notStarted + progress + hold + completed;
    if (total === 0) {
        canvas.style.display = 'none';
        canvas.parentElement.innerHTML = '<div class="text-center text-secondary py-5"><i class="bi bi-pie-chart fs-1 d-block mb-3"></i><p>No project data available</p></div>';
        return;
    }
    const labels = [];
    const data = [];
    const colors = [];
    if (lead > 0) { labels.push('Lead'); data.push(lead); colors.push('rgba(168, 85, 247, 0.8)'); }
    if (notStarted > 0) { labels.push('Not Started'); data.push(notStarted); colors.push('rgba(156, 163, 175, 0.8)'); }
    if (progress > 0) { labels.push('In Progress'); data.push(progress); colors.push('rgba(59, 130, 246, 0.8)'); }
    if (hold > 0) { labels.push('Hold'); data.push(hold); colors.push('rgba(245, 158, 11, 0.8)'); }
    if (completed > 0) { labels.push('Completed'); data.push(completed); colors.push('rgba(16, 185, 129, 0.8)'); }
    new Chart(ctx, {
        type: 'doughnut',
        data: { labels: labels, datasets: [{ data: data, backgroundColor: colors, borderColor: 'rgba(30, 41, 59, 1)', borderWidth: 2 }] },
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
.stat-card { padding: 1rem; text-align: center; }
.stat-icon { width: 48px; height: 48px; border-radius: 12px; display: flex; align-items: center; justify-content: center; margin: 0 auto 0.75rem; font-size: 1.5rem; }
.icon-projects { background: rgba(99, 102, 241, 0.2); color: #6366f1; }
.icon-ongoing { background: rgba(16, 185, 129, 0.2); color: #10b981; }
.icon-tasks { background: rgba(59, 130, 246, 0.2); color: #3b82f6; }
.icon-pending { background: rgba(245, 158, 11, 0.2); color: #f59e0b; }
.icon-lead { background: rgba(168, 85, 247, 0.2); color: #a855f7; }
.icon-hold { background: rgba(239, 68, 68, 0.2); color: #ef4444; }
.card-ongoing::before { background: #10b981; }
.card-tasks::before { background: #3b82f6; }
.card-lead::before { background: #a855f7; }
.card-hold::before { background: #ef4444; }
</style>