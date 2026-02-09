<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

    <title>Forgot Password | BugBoard</title>

    <!-- Favicon -->
    <link rel="icon" href="data:image/svg+xml,<svg xmlns=%22http://www.w3.org/2000/svg%22 viewBox=%220 0 100 100%22><text y=%22.9em%22 font-size=%2290%22>🐞</text></svg>">

    <style>
        body {
        background: linear-gradient(135deg, #1d2671, #c33764);
        min-height: 100vh;
        display: flex;
        align-items: center;
        justify-content: center;
        }

        .forgot-card {
            max-width: 420px;
            margin: 60px auto;
            padding: 25px;
            border-radius: 12px;
            background: #fff;
            box-shadow: 0 0 12px rgba(0, 0, 0, 0.1);
        }
        .header-icon {
            font-size: 2.5rem;
            margin-bottom: 10px;
            color: #1d2671;
        }
    </style>
</head>

<body>

    <div class="container">
        <div class="forgot-card">
            <!-- Updated header -->
            <div class="text-center mb-4">
                <div class="header-icon">
                    <i class="bi bi-key-fill"></i>
                </div>
                <h3 class="mb-2">Forgot Password</h3>
                <p class="text-muted">We'll send a otp to your email</p>
            </div>

            <!-- Success Message -->
            <c:if test="${not empty success}">
                <div class="alert alert-success">
                    <i class="bi bi-check-circle-fill me-2"></i> ${success}
                </div>
            </c:if>

            <!-- Error Message -->
            <c:if test="${not empty error}">
                <div class="alert alert-danger">
                    <i class="bi bi-exclamation-triangle-fill me-2"></i> ${error}
                </div>
            </c:if>

            <form action="sendResetLink" method="post">

                <!-- Email Field -->
                <div class="mb-3">
                    <label class="form-label" for="email"><i class="bi bi-envelope me-2"></i>Email Address</label>
                    <input type="email" name="email" id="email" class="form-control"
                           placeholder="Enter your registered email" required>
                </div>

                <!-- Submit Button -->
                <button type="submit" class="btn btn-primary w-100">
                    <i class="bi bi-send me-2"></i> Send OTP
                </button>

                <p class="text-center mt-3">
                    <a href="login" class="text-decoration-none"><i class="bi bi-arrow-left me-1"></i> Back to Login</a>
                </p>
            </form>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

</body>

</html>