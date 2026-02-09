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

    <title>Reset Password | BugBoard</title>

    <!-- Favicon -->
    <link rel="icon" href="data:image/svg+xml,<svg xmlns=%22http://www.w3.org/2000/svg%22 viewBox=%220 0 100 100%22><text y=%22.9em%22 font-size=%2290%22>🐞</text></svg>">

    <style>
        body {
            background: linear-gradient(135deg, #1d2671, #c33764);
            min-height: 100vh;
            margin: 0;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .reset-card {
            width: 100%;
            max-width: 420px;
            padding: 25px;
            border-radius: 12px;
            background: #fff;
            box-shadow: 0 0 12px rgba(0, 0, 0, 0.15);
        }

        .input-group-text {
            cursor: pointer;
        }
        .header-icon {
            font-size: 2.5rem;
            margin-bottom: 10px;
            color: #1d2671;
        }
        .form-floating {
            position: relative;
        }
        .form-floating label {
            padding-left: 40px;
        }
        .form-floating i {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            z-index: 10;
        }
    </style>
</head>

<body>

<!-- ✅ NO container -->
<div class="reset-card">
    <!-- Updated header -->
    <div class="text-center mb-4">
        <div class="header-icon">
            <i class="bi bi-shield-lock-fill"></i>
        </div>
        <h3 class="mb-2">Reset Password</h3>
        <p class="text-muted">Create a new password for your account</p>
    </div>

    <c:if test="${not empty success}">
        <div class="alert alert-success">
            <i class="bi bi-check-circle-fill me-2"></i> ${success}
        </div>
    </c:if>

    <c:if test="${not empty error}">
        <div class="alert alert-danger">
            <i class="bi bi-exclamation-triangle-fill me-2"></i> ${error}
        </div>
    </c:if>

    <form action="rlogin" method="post" onsubmit="return validateForm();">

        <input type="hidden" name="token" value="${param.token}" />

        <!-- New Password -->
        <div class="input-group mb-2">
            <div class="form-floating flex-grow-1">
                <i class="bi bi-lock text-muted"></i>
                <input type="password"
                       class="form-control ps-5"
                       id="newPassword"
                       name="newPassword"
                       placeholder="Enter New Password"
                       onkeyup="checkStrength()"
                       required>
                <label>New Password</label>
            </div>
            <span class="input-group-text"
                  onclick="togglePassword('newPassword', this)">
                <i class="bi bi-eye-slash"></i>
            </span>
        </div>

        <!-- Strength Bar -->
        <div class="progress mb-3" style="height: 5px;">
            <div id="strengthBar" class="progress-bar"></div>
        </div>

        <!-- Confirm Password -->
        <div class="input-group mb-3">
            <div class="form-floating flex-grow-1">
                <i class="bi bi-lock-fill text-muted"></i>
                <input type="password"
                       class="form-control ps-5"
                       id="confirmNewPassword"
                       name="confirmNewPassword"
                       placeholder="Confirm New Password"
                       required>
                <label>Confirm New Password</label>
            </div>
            <span class="input-group-text"
                  onclick="togglePassword('confirmNewPassword', this)">
                <i class="bi bi-eye-slash"></i>
            </span>
        </div>

        <button type="submit" class="btn btn-primary w-100">
            <i class="bi bi-key me-2"></i> Reset Password
        </button>

        <p class="text-center mt-3 mb-0">
            <a href="login" class="text-decoration-none"><i class="bi bi-arrow-left me-1"></i> Back to Login</a>
        </p>

    </form>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<script>
function togglePassword(id, el) {
    const field = document.getElementById(id);
    const icon = el.querySelector("i");

    if (field.type === "password") {
        field.type = "text";
        icon.classList.replace("bi-eye-slash", "bi-eye");
    } else {
        field.type = "password";
        icon.classList.replace("bi-eye", "bi-eye-slash");
    }
}

function checkStrength() {
    const pwd = document.getElementById("newPassword").value;
    const bar = document.getElementById("strengthBar");

    let strength = 0;
    if (pwd.length >= 8) strength++;
    if (/[A-Z]/.test(pwd)) strength++;
    if (/[0-9]/.test(pwd)) strength++;
    if (/[^A-Za-z0-9]/.test(pwd)) strength++;

    bar.className = "progress-bar";

    const levels = ["0%", "25%", "50%", "75%", "100%"];
    const colors = ["", "bg-danger", "bg-warning", "bg-info", "bg-success"];

    bar.style.width = levels[strength];
    if (colors[strength]) bar.classList.add(colors[strength]);
}

function validateForm() {
    const pwd = document.getElementById("newPassword").value;
    const cpwd = document.getElementById("confirmNewPassword").value;

    if (pwd !== cpwd) {
        alert("Passwords do not match!");
        return false;
    }
    return true;
}
</script>

</body>
</html>