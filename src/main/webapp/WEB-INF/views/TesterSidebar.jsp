<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="sidebar" id="sidebar">
    <div class="sidebar-content">
        <div class="nav flex-column">
            <a class="nav-link ${activeNav == 'dashboard' ? 'active' : ''}"
               href="../TesterDashboard">
                <i class="bi bi-speedometer2"></i> Dashboard
            </a>
            <a class="nav-link ${activeNav == 'testTasks' ? 'active' : ''}"
               href="../taskTester">
                <i class="bi bi-list-check"></i> Test Tasks
            </a>
        </div>
    </div>
</div>