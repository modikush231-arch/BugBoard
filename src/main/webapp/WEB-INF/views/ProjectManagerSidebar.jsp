<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="sidebar" id="sidebar">
    <div class="sidebar-content">
        <div class="nav flex-column">
            <a class="nav-link ${activeNav == 'dashboard' ? 'active' : ''}" href="../ProjectManagerDashboard">
                <i class="bi bi-speedometer2"></i> Dashboard
            </a>
            <a class="nav-link ${activeNav == 'projects' ? 'active' : ''}" href="../projectListPM">
                <i class="bi bi-kanban"></i> Projects
            </a>
            <a class="nav-link ${activeNav == 'modules' ? 'active' : ''}" href="../moduleListPM">
                <i class="bi bi-collection"></i> Modules
            </a>
            <a class="nav-link ${activeNav == 'tasks' ? 'active' : ''}" href="../taskListPM">
                <i class="bi bi-list-task"></i> Tasks
            </a>
            <a class="nav-link ${activeNav == 'taskUser' ? 'active' : ''}" href="../taskUserListPM">
                <i class="bi bi-person-check"></i> Task User
            </a>
        </div>
    </div>
</div>