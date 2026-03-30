<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle != null ? pageTitle : 'Admin Dashboard'} | BugBoard</title>

    <link rel="icon" href="data:image/svg+xml,<svg xmlns=%22http://www.w3.org/2000/svg%22 viewBox=%220 0 100 100%22><text y=%22.9em%22 font-size=%2290%22>🐞</text></svg>">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    
    <%-- Include admin CSS --%>
    <jsp:include page="admincss.jsp" />
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

                
               <div class="dropdown">
    <a href="#" class="d-flex align-items-center text-decoration-none dropdown-toggle" data-bs-toggle="dropdown">
        
        <div class="me-2">
            <c:choose>
                <c:when test="${not empty sessionScope.dbuser.profilePicURL}">
                    <img src="${sessionScope.dbuser.profilePicURL}" 
                         alt="profile"
                         style="width:40px; height:40px; border-radius:50%; object-fit:cover;">
                </c:when>
                <c:otherwise>
                    <div class="rounded-circle d-flex align-items-center justify-content-center" 
                         style="width:40px; height:40px; background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));">
                        <i class="bi bi-person-fill text-white"></i>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="fw-semibold text-white">
            ${sessionScope.dbuser.first_name} ${sessionScope.dbuser.last_name}
        </div>

    </a>

    <ul class="dropdown-menu dropdown-menu-end shadow">
    
        <li><a class="dropdown-item" href="../profile">
            <i class="bi bi-person me-2"></i>Profile
        </a></li>
        <li><hr class="dropdown-divider"></li>
        <li><a class="dropdown-item text-danger" href="../login">
            <i class="bi bi-box-arrow-right me-2"></i>Logout
        </a></li>
    </ul>
</div>
            </div>
        </div>
    </nav>