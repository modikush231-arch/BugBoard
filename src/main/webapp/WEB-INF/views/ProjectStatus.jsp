<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Project Status | BugBoard Admin</title>

    <link rel="icon" href="data:image/svg+xml,<svg xmlns=%22http://www.w3.org/2000/svg%22 viewBox=%220 0 100 100%22><text y=%22.9em%22 font-size=%2290%22>🐞</text></svg>">
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">

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
            font-family: 'Inter', sans-serif;
            min-height: 100vh;
            overflow-x: hidden;
        }

        .glass-card {
            background: rgba(30, 41, 59, 0.7);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 16px;
            box-shadow: var(--shadow);
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
        }

        .nav-link {
            color: var(--text-secondary);
            padding: 12px 20px;
            margin: 4px 16px;
            border-radius: 10px;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            text-decoration: none;
            font-weight: 500;
        }

        .nav-link:hover { background: rgba(99, 102, 241, 0.1); color: var(--primary-color); transform: translateX(5px); }
        .nav-link.active { background: linear-gradient(135deg, var(--primary-color), var(--primary-dark)); color: white; }
        .nav-link i { margin-right: 12px; font-size: 1.1rem; width: 24px; text-align: center; }

        .table { --bs-table-bg: transparent; --bs-table-color: var(--text-primary); }
        .table td { vertical-align: middle; padding: 1rem 0.5rem; border-bottom: 1px solid var(--border-color); }
        .table th { color: var(--text-secondary); border-bottom: 1px solid var(--border-color); }
        
        .status-badge {
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            background: rgba(99, 102, 241, 0.1);
            color: var(--primary-color);
            border: 1px solid rgba(99, 102, 241, 0.3);
        }

        .modal-content { background: var(--card-bg); border: 1px solid var(--border-color); color: white; }
        .form-control, .form-select { background: var(--dark-bg); border-color: var(--border-color); color: white; }
        .form-control:focus, .form-select:focus { background: var(--dark-bg); color: white; border-color: var(--primary-color); box-shadow: none; }
        .btn-close { filter: invert(1); }

        .notification-badge {
            position: absolute; top: -5px; right: -5px; background: var(--danger-color);
            color: white; border-radius: 50%; width: 18px; height: 18px; font-size: 0.7rem;
            display: flex; align-items: center; justify-content: center;
        }

        @media (max-width: 992px) {
            .sidebar { transform: translateX(-100%); }
            .sidebar.open { transform: translateX(0); }
            .main-content { margin-left: 0; }
        }
    </style>
</head>
<body>

    <nav class="navbar navbar-expand-lg fixed-top">
        <div class="container-fluid">
            <button class="navbar-toggler border-0 text-white d-lg-none me-2" type="button" onclick="toggleSidebar()">
                <i class="bi bi-list fs-2"></i>
            </button>
            <a class="navbar-brand mx-auto mx-lg-0" href="adminDashboard">
                <i class="bi bi-bug-fill me-2" style="color: var(--primary-color);"></i>
                <span class="fw-bold text-white">BugBoard Admin</span>
            </a>
            <div class="ms-auto d-flex align-items-center">
                <div class="dropdown me-3">
                    <button class="btn position-relative p-0 border-0 bg-transparent" type="button" data-bs-toggle="dropdown">
                        <i class="bi bi-bell fs-5 text-secondary"></i>
                        <span class="notification-badge">3</span>
                    </button>
                    <ul class="dropdown-menu dropdown-menu-end shadow" style="min-width: 250px;">
                        <li><h6 class="dropdown-header">Notifications</h6></li>
                        <li><a class="dropdown-item" href="#">New bug reported</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item text-center small" href="#">View all</a></li>
                    </ul>
                </div>
                <div class="dropdown">
                    <a href="#" class="d-flex align-items-center text-decoration-none dropdown-toggle" data-bs-toggle="dropdown">
                        <div class="me-2 rounded-circle d-flex align-items-center justify-content-center" 
                             style="width: 40px; height: 40px; background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));">
                            <i class="bi bi-person-fill text-white"></i>
                        </div>
                        <div class="d-none d-md-block">
                            <div class="fw-semibold text-white">
                                ${sessionScope.user != null ? sessionScope.user.first_name : 'Admin'} 
                                ${sessionScope.user != null ? sessionScope.user.last_name : ''}
                            </div>
                        </div>
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end shadow">
                        <li><a class="dropdown-item" href="profile">Profile</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item text-danger" href="login">Logout</a></li>
                    </ul>
                </div>
            </div>
        </div>
    </nav>

    <div class="sidebar" id="sidebar">
        <div class="nav flex-column">
            <a class="nav-link" href="adminDashboard"><i class="bi bi-speedometer2"></i> Dashboard</a>
            <a class="nav-link" href="projects"><i class="bi bi-kanban"></i> Projects</a>
            <a class="nav-link active" href="projectStatus"><i class="bi bi-list-check"></i> Project Status</a>
            <a class="nav-link" href="users"><i class="bi bi-people"></i> Users</a>
            <a class="nav-link" href="bugs"><i class="bi bi-bug"></i> Bugs</a>
            <a class="nav-link" href="reports"><i class="bi bi-bar-chart-line"></i> Reports</a>
        </div>
    </div>

    <main class="main-content">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h1 class="h2 mb-2 text-white">
                    <i class="bi bi-list-check me-2" style="color: var(--primary-color);"></i>Project Status
                </h1>
                <p class="text-secondary mb-0">Define and manage lifecycle stages for your projects.</p>
            </div>
            <button class="btn btn-primary px-4" data-bs-toggle="modal" data-bs-target="#addStatusModal">
                <i class="bi bi-plus-lg me-2"></i>New Status
            </button>
        </div>

        <div class="glass-card p-4">
            <div class="table-responsive">
                <table id="statusTable" class="table table-hover">
                    <thead>
                        <tr>
                            <th width="30%">Status Type</th>
                            <th width="50%">Description</th>
                            <th width="20%" class="text-end">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="status" items="${statusList}">
                            <tr>
                                <td><span class="status-badge text-uppercase">${status.status}</span></td>
                                <td class="text-secondary">${status.description}</td>
                                <td class="text-end">
                                    <button class="btn btn-sm btn-outline-info border-0 me-2" 
                                            onclick="editStatus(${status.projectStatusID}, '${status.status}', '${status.description}')"
                                            data-bs-toggle="modal" data-bs-target="#editStatusModal">
                                        <i class="bi bi-pencil"></i>
                                    </button>
                                    <button class="btn btn-sm btn-outline-danger border-0" onclick="deleteStatus(${status.projectStatusID})">
                                        <i class="bi bi-trash"></i>
                                    </button>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </main>

    <div class="modal fade" id="addStatusModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header border-secondary">
                    <h5 class="modal-title">Add Workflow Status</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form id="addStatusForm" action="saveStatus" method="post">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label text-secondary">Status Option</label>
                            <select name="status" class="form-select" required>
                                <option value="lead">Lead</option>
                                <option value="notStarted">Not Started</option>
                                <option value="hold">Hold</option>
                                <option value="inProgress">In Progress</option>
                                <option value="completed">Completed</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label text-secondary">Description</label>
                            <textarea name="description" class="form-control" rows="3" required placeholder="Describe what this stage implies..."></textarea>
                        </div>
                    </div>
                    <div class="modal-footer border-secondary">
                        <button type="submit" class="btn btn-primary w-100">Add Status</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <div class="modal fade" id="editStatusModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header border-secondary">
                    <h5 class="modal-title">Edit Status</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form id="editStatusForm" action="saveStatus" method="post">

                    <input type="hidden" name="id" id="editStatusId">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label text-secondary">Status Option</label>
                            <select name="status" id="editStatusSelect" class="form-select" required>
                                <option value="lead">Lead</option>
                                <option value="notStarted">Not Started</option>
                                <option value="hold">Hold</option>
                                <option value="inProgress">In Progress</option>
                                <option value="completed">Completed</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label text-secondary">Description</label>
                            <textarea name="description" id="editStatusDesc" class="form-control" rows="3" required></textarea>
                        </div>
                    </div>
                    <div class="modal-footer border-secondary">
                        <button type="submit" class="btn btn-primary w-100">Update Status</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>

    <script>
        function toggleSidebar() {
            document.getElementById('sidebar').classList.toggle('open');
        }

        $(document).ready(function() {
            $('#statusTable').DataTable({
                "language": { "search": "", "searchPlaceholder": "Search statuses..." },
                "dom": '<"d-flex justify-content-between align-items-center mb-3"f>rt<"d-flex justify-content-between align-items-center mt-3"ip>'
            });
        }); 


        function editStatus(id, name, desc) {
            $('#editStatusId').val(id);
            $('#editStatusSelect').val(name);
            $('#editStatusDesc').val(desc);
        }

        function deleteStatus(id) {
            if(confirm('Are you sure you want to remove this status stage?')) {
                $.post('deleteProjectStatus', { id: id }, function() {
                    location.reload();
                });
            }
        }
    </script>
</body>
</html>