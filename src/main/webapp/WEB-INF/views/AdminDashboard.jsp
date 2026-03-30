<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- Set variables for header and sidebar --%>
<c:set var="pageTitle" value="Admin Dashboard" scope="request" />
<c:set var="activeNav" value="dashboard" scope="request" />

<%-- Include header --%>
<jsp:include page="adminheader.jsp" />

<%-- Include sidebar --%>
<jsp:include page="adminsidebar.jsp" />

	<main class="main-content" id="mainContent">
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
	
	    <!-- Charts Row with Fixed Canvas -->
	    <div class="row g-4 mb-4">
	        <!-- Project Status Chart - FIXED -->
	        <div class="col-xl-7">
	            <div class="glass-card h-100">
	                <div class="d-flex justify-content-between align-items-center p-4 border-bottom border-secondary">
	                    <h5 class="mb-0 text-white">
	                        <i class="bi bi-pie-chart me-2"></i>Project Status Distribution
	                    </h5>
	                    <!-- Debug Info - Remove in production -->
	                    <span class="badge bg-info" id="debugInfo" style="display: none;">Loading...</span>
	                </div>
	                <div class="chart-container p-3" style="height: 300px; position: relative;">
	                    <canvas id="projectStatusChart" style="width: 100%; height: 100%; display: block;"></canvas>
	                    <!-- Fallback message if chart fails -->
	                    <div id="chartFallback" style="display: none; text-align: center; padding: 50px;">
	                        <i class="bi bi-bar-chart text-secondary" style="font-size: 3rem;"></i>
	                        <p class="text-secondary mt-2">Chart data unavailable</p>
	                    </div>
	                </div>
	            </div>
	        </div>
	
	        <!-- Recent Activity -->
	        <div class="col-xl-5">
	            <div class="glass-card h-100">
	                <div class="d-flex justify-content-between align-items-center p-4 border-bottom border-secondary">
	                    <h5 class="mb-0 text-white">
	                        <i class="bi bi-clock-history me-2"></i>Recent Activity
	                    </h5>
	                </div>
	                <div class="p-3" style="max-height:300px; overflow-y:auto;">
	                    <!-- Sample activities - replace with dynamic data -->
	                    <div class="activity-item mb-3">
	                        <div class="d-flex align-items-center">
	                            <div class="activity-icon me-3" style="background: rgba(99,102,241,0.2);">
	                                <i class="bi bi-plus-circle text-primary"></i>
	                            </div>
	                            <div>
	                                <div class="fw-medium text-white">New Task Assigned</div>
	                                <div class="text-secondary small">Module Development</div>
	                                <div class="text-secondary smaller mt-1">1 hour ago</div>
	                            </div>
	                        </div>
	                    </div>
	                    <div class="activity-item">
	                        <div class="d-flex align-items-center">
	                            <div class="activity-icon me-3" style="background: rgba(16,185,129,0.2);">
	                                <i class="bi bi-check-circle text-success"></i>
	                            </div>
	                            <div>
	                                <div class="fw-medium text-white">Task Completed</div>
	                                <div class="text-secondary small">Login Module</div>
	                                <div class="text-secondary smaller mt-1">3 hours ago</div>
	                            </div>
	                        </div>
	                    </div>
	                </div>
	            </div>
	        </div>
	    </div>
	
	    <!-- Quick Actions and Recent Projects -->
	    <div class="row g-4">
	        <!-- Quick Actions -->
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
	                    </div>
	                </div>
	            </div>
	        </div>
	
	        <!-- Recent Projects -->
	        <div class="col-lg-8">
	            <div class="glass-card h-100">
	                <div class="d-flex justify-content-between align-items-center p-4 border-bottom border-secondary">
	                    <h5 class="mb-0 text-white">
	                        <i class="bi bi-kanban me-2"></i>Recent Projects
	                    </h5>
	                    <a href="projectListPM" class="text-primary small text-decoration-none">View All</a>
	                </div>
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
	                                        <div class="fw-medium text-white">${p.projectName}</div>
	                                        <div class="text-secondary small">Project #${status.index + 1}</div>
	                                    </td>
	                                    <td>
	                                        <span class="badge-info status-badge">${p.status != null ? p.status : 'In Progress'}</span>
	                                    </td>
	                                    <td style="min-width: 120px;">
	                                        <div class="d-flex align-items-center">
	                                            <div class="progress flex-grow-1 me-2" style="height:6px;">
	                                                <div class="progress-bar bg-info" style="width: ${p.progress != null ? p.progress : 50}%"></div>
	                                            </div>
	                                            <span class="small text-secondary">${p.progress != null ? p.progress : 50}%</span>
	                                        </div>
	                                    </td>
	                                    <td class="text-secondary">${p.endDate != null ? p.endDate : '2024-12-31'}</td>
	                                </tr>
	                            </c:forEach>
	                            <!-- Sample data if no projects -->
	                            <c:if test="${empty recentProjects}">
	                                <tr>
	                                    <td>
	                                        <div class="fw-medium text-white">E-Commerce Platform</div>
	                                        <div class="text-secondary small">Client: TechCorp</div>
	                                    </td>
	                                    <td><span class="badge-info status-badge">In Progress</span></td>
	                                    <td>
	                                        <div class="d-flex align-items-center">
	                                            <div class="progress flex-grow-1 me-2" style="height:6px;">
	                                                <div class="progress-bar bg-info" style="width: 75%"></div>
	                                            </div>
	                                            <span class="small text-secondary">75%</span>
	                                        </div>
	                                    </td>
	                                    <td class="text-secondary">2024-06-15</td>
	                                </tr>
	                                <tr>
	                                    <td>
	                                        <div class="fw-medium text-white">Mobile App Development</div>
	                                        <div class="text-secondary small">Client: StartupX</div>
	                                    </td>
	                                    <td><span class="badge-warning status-badge">On Hold</span></td>
	                                    <td>
	                                        <div class="d-flex align-items-center">
	                                            <div class="progress flex-grow-1 me-2" style="height:6px;">
	                                                <div class="progress-bar bg-warning" style="width: 30%"></div>
	                                            </div>
	                                            <span class="small text-secondary">30%</span>
	                                        </div>
	                                    </td>
	                                    <td class="text-secondary">2024-07-01</td>
	                                </tr>
	                            </c:if>
	                        </tbody>
	                    </table>
	                </div>
	            </div>
	        </div>
	    </div>
	</main>
	
	<jsp:include page="adminfooter.jsp" />
	
	<!-- Load Chart.js with fallback CDN -->
	<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
	<!-- Fallback CDN if first fails -->
	<script>
	window.onerror = function() {
	    var script = document.createElement('script');
	    script.src = 'https://cdnjs.cloudflare.com/ajax/libs/Chart.js/4.4.0/chart.umd.min.js';
	    document.head.appendChild(script);
	};
	</script>
	

<script>
document.addEventListener('DOMContentLoaded', function() {

const ctx = document.getElementById('projectStatusChart').getContext('2d');

new Chart(ctx, {
    type: 'doughnut',
    data: {
        labels: ['Lead','Not Started','In Progress','Hold','Completed'],
        datasets: [{
            data: [
                ${leadProjects},
                ${notStartedProjects},
                ${progressProjects},
                ${holdProjects},
                ${completedProjects}
            ],
            backgroundColor: [
                'rgba(168, 85, 247, 0.7)',   // Lead
                'rgba(156, 163, 175, 0.7)',  // Not Started
                'rgba(59, 130, 246, 0.7)',   // In Progress
                'rgba(245, 158, 11, 0.7)',   // Hold
                'rgba(16, 185, 129, 0.7)'    // Completed
            ],
            borderColor: 'rgba(30, 41, 59, 1)',
            borderWidth: 2
        }]
    },
    options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
            legend: {
                position: 'right',
                labels: { color: '#94a3b8' }
            }
        }
    }
});
});
</script>