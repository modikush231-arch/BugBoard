<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Login | BugBoard</title>

<!-- Favicon -->
<link rel="icon" href="data:image/svg+xml,<svg xmlns=%22http://www.w3.org/2000/svg%22 viewBox=%220 0 100 100%22><text y=%22.9em%22 font-size=%2290%22>🐞</text></svg>">

<!-- Bootstrap CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<!-- Bootstrap Icons -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

<style>
    :root {
        --primary-gradient: linear-gradient(135deg, #1d2671, #c33764);
        --success-color: #198754;
        --warning-color: #ffc107;
        --danger-color: #dc3545;
    }
    
    body {
        background: var(--primary-gradient);
        min-height: 100vh;
        display: flex;
        align-items: center;
        justify-content: center;
        padding: 20px;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    }
    
    .login-card {
        background: #fff;
        padding: 2.5rem;
        border-radius: 15px;
        width: 100%;
        max-width: 420px;
        box-shadow: 0 15px 30px rgba(0,0,0,.25);
        animation: fadeIn 0.5s ease-out;
    }
    
    @keyframes fadeIn {
        from { opacity: 0; transform: translateY(20px); }
        to { opacity: 1; transform: translateY(0); }
    }
    
    .logo-container {
        text-align: center;
        margin-bottom: 1.5rem;
    }
    
    .header-icon {
        font-size: 2.5rem;
        margin-bottom: 10px;
        color: #1d2671;
    }
    
    .tagline {
        color: #6c757d;
        margin-bottom: 2rem;
    }
    
    .password-toggle {
        cursor: pointer;
        transition: color 0.2s;
        border-left: none !important;
    }
    
    .password-toggle:hover {
        color: #1d2671 !important;
        background-color: #f8f9fa !important;
    }
    
    .form-control:focus {
        border-color: #1d2671;
        box-shadow: 0 0 0 0.25rem rgba(29, 38, 113, 0.25);
    }
    
    .btn-primary {
        background: var(--primary-gradient);
        border: none;
        padding: 12px;
        font-weight: 600;
        transition: transform 0.2s, box-shadow 0.2s;
    }
    
    .btn-primary:hover {
        transform: translateY(-2px);
        box-shadow: 0 5px 15px rgba(29, 38, 113, 0.3);
    }
    
    /* Make checkbox more visible with color */
    .form-check-input {
        accent-color: #007bff;
        border: 1.5px solid #007bff;
    }
    
    .input-group {
        position: relative;
    }
    
    @media (max-width: 576px) {
        .login-card {
            padding: 1.5rem;
        }
    }
</style>
</head>

<body>

<div class="login-card">
    <!-- Logo/Brand - Updated -->
    <div class="logo-container">
        <div class="header-icon">
            <i class="bi bi-person-circle"></i>
        </div>
        <h3 class="text-center mb-2 fw-bold">Welcome Back</h3>
        <p class="text-center tagline">Track bugs efficiently with our dashboard</p>
    </div>

    <form action="LoginServlet" method="post">

        <!-- Email -->
        <div class="mb-3">
            <label class="form-label fw-semibold"><i class="bi bi-envelope me-2"></i>Email Address</label>
            <input type="email" class="form-control" name="email" placeholder="Enter your email" required>
        </div>

        <!-- Password -->
        <div class="mb-3">
            <label class="form-label fw-semibold"><i class="bi bi-lock me-2"></i>Password</label>
            <div class="input-group">
                <input type="password" class="form-control" id="password" name="password_hash" 
                       placeholder="Enter your password" required>
                <span class="input-group-text password-toggle" id="togglePassword">
                    <i class="bi bi-eye-slash" id="eyeIcon"></i>
                </span>
            </div>
        </div>

        <!-- Remember Me & Forgot Password -->
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div class="form-check">
                <input class="form-check-input" type="checkbox" id="rememberMe" name="rememberMe">
                <label class="form-check-label"><i class="bi bi-check2-square me-1"></i>Remember Me</label>
            </div>
            <div>
                <a href="forgetPass" class="text-decoration-none"><i class="bi bi-key me-1"></i>Forgot Password?</a>
            </div>
        </div>

        <!-- Submit -->
        <div class="d-grid mb-4">
            <button type="submit" class="btn btn-primary btn-lg">
                <i class="bi bi-box-arrow-in-right me-2"></i> Sign In
            </button>
        </div>

        <!-- Sign Up Link -->
        <div class="text-center pt-3 border-top">
            <p class="mb-2"><i class="bi bi-person-plus me-1"></i> Don't have an account?</p>
            <a href="signup" class="fw-semibold text-decoration-none">Create Account</a>
        </div>
    </form>
</div>

<!-- Bootstrap JS Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // Initialize when DOM is ready
    document.addEventListener('DOMContentLoaded', function() {
        // Password toggle functionality
        document.getElementById('togglePassword').addEventListener('click', function() {
            togglePassword();
        });
        
        // Form submission enhancement
        const form = document.querySelector('form');
        const submitBtn = form.querySelector('button[type="submit"]');
        
        form.addEventListener('submit', function(e) {
            // You can add form validation here if needed
            submitBtn.disabled = true;
            submitBtn.innerHTML = '<span class="spinner-border spinner-border-sm me-2" role="status"></span> Signing In...';
        });
    });
    
    function togglePassword() {
        const passwordInput = document.getElementById('password');
        const eyeIcon = document.getElementById('eyeIcon');
        
        if (passwordInput.type === "password") {
            passwordInput.type = "text";
            eyeIcon.classList.remove("bi-eye-slash");
            eyeIcon.classList.add("bi-eye");
        } else {
            passwordInput.type = "password";
            eyeIcon.classList.remove("bi-eye");
            eyeIcon.classList.add("bi-eye-slash");
        }
    }
</script>

</body>
</html>