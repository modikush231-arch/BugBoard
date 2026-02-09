<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard | BugBoard</title>

    <link rel="icon" href="data:image/svg+xml,<svg xmlns=%22http://www.w3.org/2000/svg%22 viewBox=%220 0 100 100%22><text y=%22.9em%22 font-size=%2290%22>🐞</text></svg>">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <style>
        :root {
            --primary-color: #6366f1;
            --primary-dark: #4f46e5;
            --secondary-color: #10b981;
            --warning-color: #f59e0b;
            --danger-color: #ef4444;
            --info-color: #3b82f6;
            --dark-bg: #0f172a;
            --card-bg: #1e293b;
            --sidebar-bg: #111827;
            --text-primary: #f8fafc;
            --text-secondary: #94a3b8;
            --border-color: #334155;
            --shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
        }

        body {
            background-color: var(--dark-bg);
            color: var(--text-primary);
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
            min-height: 100vh;
            overflow-x: hidden;
        }

        .glass-card {
            background: rgba(30, 41, 59, 0.7);
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 16px;
            box-shadow: var(--shadow);
            transition: all 0.3s ease;
        }

        .glass-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
            border-color: rgba(255, 255, 255, 0.2);
        }

        .navbar {
            background: rgba(15, 23, 42, 0.9);
            backdrop-filter: blur(10px);
            border-bottom: 1px solid var(--border-color);
            padding: 1rem 0;
            z-index: 1000;
        }

        .sidebar {
            background: var(--sidebar-bg);
            border-right: 1px solid var(--border-color);
            min-height: 100vh;
            position: fixed;
            left: 0;
            top: 0;
            width: 260px;
            z-index: 100;
            padding-top: 80px;
            transition: transform 0.3s ease;
        }

        .main-content {
            margin-left: 260px;
            padding: 30px;
            padding-top: 100px;
            min-height: 100vh;
            transition: margin-left 0.3s ease;
        }

        .nav-link {
            color: var(--text-secondary);
            padding: 12px 20px;
            margin: 4px 16px;
            border-radius: 10px;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            font-weight: 500;
            text-decoration: none;
        }

        .nav-link:hover {
            background: rgba(99, 102, 241, 0.1);
            color: var(--primary-color);
            transform: translateX(5px);
        }

        .nav-link.active {
            background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
            color: white;
            transform: translateX(5px);
        }

        .nav-link i {
            margin-right: 12px;
            font-size: 1.1rem;
            width: 24px;
            text-align: center;
        }

        .stat-card {
            padding: 24px;
            border-radius: 16px;
            position: relative;
            overflow: hidden;
        }

        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            border-radius: 16px 16px 0 0;
        }

        .card-projects::before { background: var(--primary-color); }
        .card-users::before { background: var(--secondary-color); }
        .card-bugs::before { background: var(--warning-color); }
        .card-pending::before { background: var(--danger-color); }

        .stat-icon {
            width: 60px;
            height: 60px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 20px;
            font-size: 1.8rem;
        }

        .icon-projects { background: rgba(99, 102, 241, 0.2); color: var(--primary-color); }
        .icon-users { background: rgba(16, 185, 129, 0.2); color: var(--secondary-color); }
        .icon-bugs { background: rgba(245, 158, 11, 0.2); color: var(--warning-color); }
        .icon-pending { background: rgba(239, 68, 68, 0.2); color: var(--danger-color); }

        .stat-number { font-size: 2.5rem; font-weight: 800; margin-bottom: 8px; line-height: 1; }

        .chart-container { padding: 20px; height: 300px; position: relative; }

        .activity-item {
            padding: 16px;
            border-bottom: 1px solid var(--border-color);
            transition: background-color 0.3s ease;
        }

        .activity-item:hover { background: rgba(255, 255, 255, 0.05); }
        .activity-item:last-child { border-bottom: none; }

        .activity-icon {
            width: 40px;
            height: 40px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 15px;
        }

        .quick-action-card { padding: 20px; text-align: center; cursor: pointer; transition: all 0.3s ease; }
        .quick-action-card:hover { transform: translateY(-8px); }

        .action-icon {
            width: 70px;
            height: 70px;
            border-radius: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            font-size: 2rem;
            background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
            color: white;
        }

        .table { --bs-table-bg: transparent; --bs-table-color: var(--text-primary); }
        .table td { vertical-align: middle; padding: 1rem 0.5rem; border-bottom: 1px solid var(--border-color); }
        .table th { color: var(--text-secondary); font-weight: 500; border-bottom: 1px solid var(--border-color); padding-bottom: 1rem; }
        
        .status-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
        }

        .badge-success { background: rgba(16, 185, 129, 0.2); color: var(--secondary-color); }
        .badge-warning { background: rgba(245, 158, 11, 0.2); color: var(--warning-color); }
        .badge-danger { background: rgba(239, 68, 68, 0.2); color: var(--danger-color); }
        .badge-info { background: rgba(59, 130, 246, 0.2); color: var(--info-color); }

        .notification-badge {
            position: absolute;
            top: -5px;
            right: -5px;
            background: var(--danger-color);
            color: white;
            border-radius: 50%;
            width: 18px;
            height: 18px;
            font-size: 0.7rem;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        @media (max-width: 992px) {
            .sidebar { transform: translateX(-100%); }
            .sidebar.open { transform: translateX(0); }
            .main-content { margin-left: 0; }
        }

        @keyframes fadeIn { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
        .fade-in { animation: fadeIn 0.5s ease forwards; }
        .delay-1 { animation-delay: 0.1s; }
        .delay-2 { animation-delay: 0.2s; }
        .delay-3 { animation-delay: 0.3s; }
    </style>
</head>

<body>

    <nav class="navbar navbar-expand-lg fixed-top">
        <div class="container-fluid">
            <button class="navbar-toggler border-0 text-white d-lg-none me-2" type="button" onclick="toggleSidebar()">
                <i class="bi bi-list fs-2"></i>
            </button>
            
            <a class="navbar-brand mx-auto mx-lg-0" href="#">
                <i class="bi bi-bug-fill me-2" style="color: var(--primary-color);"></i>
                <span class="fw-bold text-white">BugBoard Admin</span>
            </a>
            
            <div class="d-flex align-items-center ms-auto">
                <div class="dropdown me-3">
                    <button class="btn position-relative p-0 border-0 bg-transparent" type="button" data-bs-toggle="dropdown">
                        <i class="bi bi-bell fs-5 text-secondary"></i>
                        <span class="notification-badge">3</span>
                    </button>
                    <ul class="dropdown-menu dropdown-menu-end shadow" style="min-width: 300px;">
                        <li><h6 class="dropdown-header">Notifications</h6></li>
                        <li><a class="dropdown-item" href="#"><i class="bi bi-bug text-warning me-2"></i>New bug reported</a></li>
                        <li><a class="dropdown-item" href="#"><i class="bi bi-person-plus text-info me-2"></i>New user registered</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item text-center" href="#">View all notifications</a></li>
                    </ul>
                </div>
                
                <div class="dropdown">
                    <a href="#" class="d-flex align-items-center text-decoration-none dropdown-toggle" data-bs-toggle="dropdown">
                        <div class="me-2">
                            <div class="rounded-circle d-flex align-items-center justify-content-center" 
                                 style="width: 40px; height: 40px; background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));">
                                <i class="bi bi-person-fill text-white"></i>
                            </div>
                        </div>
                        <div class="d-none d-md-block">
                            <div class="fw-semibold text-white">
                                ${sessionScope.user != null ? sessionScope.user.first_name : 'Admin'} 
                                ${sessionScope.user != null ? sessionScope.user.last_name : ''}
                            </div>
                        </div>
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end shadow">
                        <li><a class="dropdown-item" href="profile"><i class="bi bi-person me-2"></i>Profile</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item text-danger" href="login"><i class="bi bi-box-arrow-right me-2"></i>Logout</a></li>
                    </ul>
                </div>
            </div>
        </div>
    </nav>

    <div class="sidebar" id="sidebar">
        <div class="sidebar-content">
            <div class="nav flex-column">
                <a class="nav-link active" href="adminDashboard"><i class="bi bi-speedometer2"></i> Dashboard</a>
                <a class="nav-link" href="projects"><i class="bi bi-kanban"></i> Projects</a>
                <a class="nav-link" href="projectStatus"><i class="bi bi-list-check"></i> Project Status</a>
                <a class="nav-link" href="users">
                    <i class="bi bi-people"></i> Users
                </a>
                <a class="nav-link" href="bugs">
                    <i class="bi bi-bug"></i> Bugs
                </a>
                <a class="nav-link" href="reports"><i class="bi bi-bar-chart-line"></i> Reports</a>
            </div>
        </div>
    </div>

    <main class="main-content" id="mainContent">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h1 class="h2 mb-2 text-white">
                    <i class="bi bi-speedometer2 me-2" style="color: var(--primary-color);"></i>Dashboard
                </h1>
                <p class="text-secondary mb-0">Welcome back! Here's what's happening today.</p>
            </div>
            <div class="d-flex gap-2">
                <button class="btn btn-outline-secondary text-white">
                    <i class="bi bi-calendar me-2"></i>${currentDate}
                </button>
                <button class="btn btn-primary" onclick="location.reload()">
                    <i class="bi bi-arrow-clockwise"></i>
                </button>
            </div>
        </div>

        <div class="row mb-4 g-4">
            <div class="col-xl-3 col-md-6">
                <div class="glass-card stat-card card-projects fade-in">
                    <div class="stat-icon icon-projects"><i class="bi bi-folder"></i></div>
                    <div class="stat-number text-white">${totalProjects != null ? totalProjects : 42}</div>
                    <div class="text-secondary">Total Projects</div>
                    <div class="mt-3">
                        <span class="badge-success status-badge me-2"><i class="bi bi-arrow-up me-1"></i>12%</span>
                    </div>
                </div>
            </div>
            <div class="col-xl-3 col-md-6">
                <div class="glass-card stat-card card-users fade-in delay-1">
                    <div class="stat-icon icon-users"><i class="bi bi-people"></i></div>
                    <div class="stat-number text-white">${totalUsers != null ? totalUsers : 156}</div>
                    <div class="text-secondary">Total Users</div>
                    <div class="mt-3">
                        <span class="badge-success status-badge me-2"><i class="bi bi-arrow-up me-1"></i>5%</span>
                    </div>
                </div>
            </div>
            <div class="col-xl-3 col-md-6">
                <div class="glass-card stat-card card-bugs fade-in delay-2">
                    <div class="stat-icon icon-bugs"><i class="bi bi-bug"></i></div>
                    <div class="stat-number text-white">${totalBugs != null ? totalBugs : 89}</div>
                    <div class="text-secondary">Active Bugs</div>
                    <div class="mt-3">
                        <span class="badge-danger status-badge me-2"><i class="bi bi-arrow-down me-1"></i>8%</span>
                    </div>
                </div>
            </div>
            <div class="col-xl-3 col-md-6">
                <div class="glass-card stat-card card-pending fade-in delay-3">
                    <div class="stat-icon icon-pending"><i class="bi bi-clock-history"></i></div>
                    <div class="stat-number text-white">${pendingTasks != null ? pendingTasks : 23}</div>
                    <div class="text-secondary">Pending Tasks</div>
                    <div class="mt-3">
                        <span class="badge-warning status-badge me-2"><i class="bi bi-dash me-1"></i>0%</span>
                    </div>
                </div>
            </div>
        </div>

        <div class="row g-4">
            <div class="col-xl-8">
                <div class="glass-card h-100">
                    <div class="d-flex justify-content-between align-items-center p-4 border-bottom border-secondary">
                        <h5 class="mb-0 text-white"><i class="bi bi-pie-chart me-2"></i>Project Status Distribution</h5>
                    </div>
                    <div class="chart-container">
                        <canvas id="projectStatusChart"></canvas>
                    </div>
                </div>
            </div>

            <div class="col-xl-4">
                <div class="glass-card h-100">
                    <div class="d-flex justify-content-between align-items-center p-4 border-bottom border-secondary">
                        <h5 class="mb-0 text-white"><i class="bi bi-clock-history me-2"></i>Recent Activity</h5>
                        <a href="#" class="text-primary small text-decoration-none">View All</a>
                    </div>
                    <div class="p-3" style="max-height: 400px; overflow-y: auto;">
                        <div class="activity-item">
                            <div class="d-flex align-items-center">
                                <div class="activity-icon" style="background: rgba(99, 102, 241, 0.2);">
                                    <i class="bi bi-plus-circle text-primary"></i>
                                </div>
                                <div>
                                    <div class="fw-medium text-white">New project created</div>
                                    <div class="text-secondary small">"E-commerce Platform"</div>
                                    <div class="text-secondary smaller mt-1" style="font-size: 0.8rem;">2 hours ago</div>
                                </div>
                            </div>
                        </div>
                        <div class="activity-item">
                            <div class="d-flex align-items-center">
                                <div class="activity-icon" style="background: rgba(239, 68, 68, 0.2);">
                                    <i class="bi bi-bug text-danger"></i>
                                </div>
                                <div>
                                    <div class="fw-medium text-white">Critical bug reported</div>
                                    <div class="text-secondary small">"Payment Gateway Issue"</div>
                                    <div class="text-secondary smaller mt-1" style="font-size: 0.8rem;">4 hours ago</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="row g-4 mt-4">
            <div class="col-lg-4">
                <div class="glass-card h-100">
                    <div class="p-4 border-bottom border-secondary">
                        <h5 class="mb-0 text-white"><i class="bi bi-lightning me-2"></i>Quick Actions</h5>
                    </div>
                    <div class="p-4">
                        <div class="row g-3">
                            <div class="col-6">
                                <div class="quick-action-card glass-card" onclick="location.href='addProject'">
                                    <div class="action-icon"><i class="bi bi-plus-lg"></i></div>
                                    <div class="fw-medium text-white">New Project</div>
                                </div>
                            </div>
                            <div class="col-6">
                                <div class="quick-action-card glass-card" onclick="location.href='addUser'">
                                    <div class="action-icon"><i class="bi bi-person-plus"></i></div>
                                    <div class="fw-medium text-white">Add User</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-lg-8">
                <div class="glass-card h-100">
                    <div class="d-flex justify-content-between align-items-center p-4 border-bottom border-secondary">
                        <h5 class="mb-0 text-white"><i class="bi bi-kanban me-2"></i>Recent Projects</h5>
                        <a href="projects" class="text-primary small text-decoration-none">View All Projects</a>
                    </div>
                    <div class="table-responsive">
                        <table class="table table-borderless table-hover mb-0">
                            <thead>
                                <tr>
                                    <th>Project Name</th>
                                    <th>Status</th>
                                    <th>Progress</th>
                                    <th>Due Date</th>
                                    <th>Team</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>
                                        <div class="fw-medium text-white">E-commerce Platform</div>
                                        <div class="text-secondary small">Client: TechCorp Inc.</div>
                                    </td>
                                    <td><span class="badge-info status-badge">In Progress</span></td>
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <div class="progress flex-grow-1 me-2" style="height: 6px;">
                                                <div class="progress-bar bg-info" style="width: 75%"></div>
                                            </div>
                                            <span class="small text-secondary">75%</span>
                                        </div>
                                    </td>
                                    <td class="text-secondary">2024-06-15</td>
                                    <td>
                                        <div class="avatar-group d-flex">
                                            <div class="rounded-circle bg-primary" style="width:25px; height:25px;"></div>
                                            <div class="rounded-circle bg-secondary ms-n2" style="width:25px; height:25px; margin-left: -10px;"></div>
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function toggleSidebar() {
            document.getElementById('sidebar').classList.toggle('open');
        }

        document.addEventListener('DOMContentLoaded', function() {
            const ctx = document.getElementById('projectStatusChart').getContext('2d');
            new Chart(ctx, {
                type: 'doughnut',
                data: {
                    labels: ['Completed', 'In Progress', 'On Hold', 'Pending'],
                    datasets: [{
                        data: [12, 19, 3, 5],
                        backgroundColor: [
                            'rgba(16, 185, 129, 0.7)',
                            'rgba(59, 130, 246, 0.7)',
                            'rgba(245, 158, 11, 0.7)',
                            'rgba(239, 68, 68, 0.7)'
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
</body>
</html>