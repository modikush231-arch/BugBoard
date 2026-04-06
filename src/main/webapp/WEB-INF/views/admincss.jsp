<%@ page contentType="text/css; charset=UTF-8" %>
<style>
    :root {
        --primary-color: #6366f1;
        --primary-dark: #4f46e5;
        --secondary-color: #10b981;
        --warning-color: #f59e0b;
        --danger-color: #ef4444;
        --info-color: #3b82f6;
        --purple-color: #8b5cf6;
        --cyan-color: #06b6d4;
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
        padding: 20px;
        border-radius: 16px;
        position: relative;
        overflow: hidden;
        text-align: center;
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
    .card-testing::before { background: var(--purple-color); }
    .card-efficiency::before { background: var(--cyan-color); }

    .stat-icon {
        width: 48px;
        height: 48px;
        border-radius: 12px;
        display: flex;
        align-items: center;
        justify-content: center;
        margin: 0 auto 12px;
        font-size: 1.5rem;
    }

    .icon-projects { background: rgba(99, 102, 241, 0.2); color: var(--primary-color); }
    .icon-users { background: rgba(16, 185, 129, 0.2); color: var(--secondary-color); }
    .icon-bugs { background: rgba(245, 158, 11, 0.2); color: var(--warning-color); }
    .icon-pending { background: rgba(239, 68, 68, 0.2); color: var(--danger-color); }
    .icon-testing { background: rgba(139, 92, 246, 0.2); color: var(--purple-color); }
    .icon-efficiency { background: rgba(6, 182, 212, 0.2); color: var(--cyan-color); }

    .stat-number { 
        font-size: 2rem; 
        font-weight: 700; 
        margin-bottom: 4px; 
        line-height: 1;
    }

    .chart-container { padding: 20px; height: 280px; position: relative; }

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

    .quick-action-card { 
        padding: 16px; 
        text-align: center; 
        cursor: pointer; 
        transition: all 0.3s ease; 
    }
    .quick-action-card:hover { transform: translateY(-8px); }

    .action-icon {
        width: 60px;
        height: 60px;
        border-radius: 16px;
        display: flex;
        align-items: center;
        justify-content: center;
        margin: 0 auto 12px;
        font-size: 1.5rem;
        background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
        color: white;
    }

    .table { --bs-table-bg: transparent; --bs-table-color: var(--text-primary); }
    .table td { vertical-align: middle; padding: 0.75rem 0.5rem; border-bottom: 1px solid var(--border-color); }
    .table th { color: var(--text-secondary); font-weight: 500; border-bottom: 1px solid var(--border-color); padding-bottom: 0.75rem; }
    
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
    .badge-purple { background: rgba(139, 92, 246, 0.2); color: var(--purple-color); }
    .badge-cyan { background: rgba(6, 182, 212, 0.2); color: var(--cyan-color); }

    .list-group-item {
        background-color: transparent;
        border-color: var(--border-color);
    }

	.bg-purple { background-color: #a855f7 !important; }

#searchInput {
    color: white !important;
    caret-color: white; /* cursor color */
}

#searchInput::placeholder {
    color: #aaa !important; /* light gray placeholder */
}

#searchInput:focus {
    color: white !important;
    background-color: transparent;
}
.input-group-text {
    color: #ccc !important;
}
.form-control {
    color: #212529;
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
    .delay-4 { animation-delay: 0.4s; }
    .delay-5 { animation-delay: 0.5s; }
    
    .bg-purple { background-color: #a855f7 !important; }
</style>