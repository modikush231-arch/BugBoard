<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="sidebar" id="sidebar">
    <div class="sidebar-content">
        <div class="nav flex-column">
            <a class="nav-link ${activeNav == 'dashboard' ? 'active' : ''}" href="../AdminDashboard">
                <i class="bi bi-speedometer2"></i> Dashboard
            </a>
            <a class="nav-link ${activeNav == 'projects' ? 'active' : ''}" href="../projectList">
                <i class="bi bi-kanban"></i> Projects
            </a>
            <a class="nav-link ${activeNav == 'projectStatus' ? 'active' : ''}" href="../projectStatusList">
                <i class="bi bi-list-check"></i> Project Status
            </a>
            <a class="nav-link ${activeNav == 'users' ? 'active' : ''}" href="../UserList">
                <i class="bi bi-people"></i> Users
            </a>
            <a class="nav-link ${activeNav == 'modules' ? 'active' : ''}" href="../moduleList">
                <i class="bi bi-collection"></i> Module
            </a>
            <a class="nav-link ${activeNav == 'tasks' ? 'active' : ''}" href="../taskList">
                <i class="bi bi-list-task"></i> Task
            </a>
            <a class="nav-link ${activeNav == 'projectUser' ? 'active' : ''}" href="../projectUserList">
                <i class="bi bi-person-badge"></i> Project User
            </a>
            <a class="nav-link ${activeNav == 'taskUser' ? 'active' : ''}" href="../taskUserList">
                <i class="bi bi-person-check"></i> Task User
            </a>
        </div>
    </div>
</div>