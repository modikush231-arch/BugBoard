<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add User Role</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    
    <style>
        body {
            background-color: #4a148c; 
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
        }
        
        .card {
            border: none;
            border-radius: 24px;
            width: 100%;
            max-width: 400px;
            padding: 10px;
            background: #fff;
        }

        .user-icon-header {
            font-size: 60px;
            color: #1a237e;
            text-align: center;
            margin-top: 10px;
        }

        .welcome-text {
            font-weight: 700;
            color: #111;
            font-size: 1.75rem;
            margin-top: 15px;
        }

        .sub-text {
            color: #6c757d;
            font-size: 0.9rem;
            margin-bottom: 35px;
        }

        .form-label {
            font-weight: 600;
            font-size: 0.9rem;
            color: #333;
            margin-bottom: 8px;
            display: block;
        }

        .form-select {
            border-radius: 10px;
            padding: 12px 15px;
            border: 1px solid #e0e0e0;
            font-size: 0.95rem;
            color: #495057;
            background-color: #fff;
            cursor: pointer;
        }

        /* Submit Button Styling */
        .btn-gradient {
            background: linear-gradient(to right, #202b7a, #b01a54);
            border: none;
            color: white;
            padding: 14px;
            border-radius: 12px;
            font-weight: 600;
            font-size: 1rem;
            margin-top: 25px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            transition: all 0.3s ease;
        }

        .btn-gradient:hover {
            opacity: 0.9;
            color: white;
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
        }

        .footer-text {
            margin-top: 25px;
            padding-top: 20px;
            border-top: 1px solid #f0f0f0;
            font-size: 0.85rem;
        }

        .back-link {
            color: #0d6efd;
            text-decoration: none;
            font-weight: 600;
        }
    </style>
</head>
<body>

<div class="card shadow-lg">
    <div class="card-body p-4 text-center">
        
        <div class="user-icon-header">
            <i class="fa-solid fa-circle-user"></i>
        </div>
        
        <h2 class="welcome-text">New Role</h2>
        <p class="sub-text">Assign a user type to the system</p>

        <form action="saveUserType" method="post" class="text-start">
            
            <div class="mb-3">
                <label class="form-label">
                    <i class="fa-solid fa-user-shield me-2"></i>Select Role Type
                </label>
                <select name="userType" class="form-select" required>
                    <option value="" disabled selected>Choose a role...</option>
                    <option value="Admin">Admin</option>
                    <option value="PM">PM (Project Manager)</option>
                    <option value="Developer">Developer</option>
                    <option value="Tester">Tester</option>
                </select>
            </div>

            <div class="d-grid">
                <button type="submit" class="btn btn-gradient">
                    <i class="fa-solid fa-paper-plane"></i> Submit
                </button>
            </div>

            <div class="footer-text">
                <p class="mb-1 text-muted">Changed your mind?</p>
                <a href="adminDashboard" class="back-link">Return to Dashboard</a>
            </div>

        </form>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>