<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Sign Up | BugBoard</title>

<!-- Favicon -->
<link rel="icon" href="data:image/svg+xml,<svg xmlns=%22http://www.w3.org/2000/svg%22 viewBox=%220 0 100 100%22><text y=%22.9em%22 font-size=%2290%22>🐞</text></svg>">

<!-- Bootstrap CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Bootstrap Icons -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

<style>
    body {
        background: linear-gradient(135deg, #1d2671, #c33764);
        min-height: 100vh;
        margin: 0;
        display: flex;
        align-items: center;
        justify-content: center;
    }
    .signup-card {
        width: 100%;
        max-width: 450px;
        padding: 25px;
        border-radius: 10px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        background: #fff;
    }
    .password-toggle {
        cursor: pointer;
    }
    .password-rules {
        font-size: 13px;
    }
    /* Make checkbox more visible with color */
    .form-check-input {
        accent-color: #007bff;
        border: 1.5px solid #007bff;
    }
    .header-icon {
        font-size: 2.5rem;
        margin-bottom: 10px;
        color: #1d2671;
    }
    .form-select {
        cursor: pointer;
    }
    .form-select:focus {
        border-color: #1d2671;
        box-shadow: 0 0 0 0.25rem rgba(29, 38, 113, 0.25);
    }
    
    /* Multi-step form styles */
    .step-indicator {
        display: flex;
        justify-content: space-between;
        margin-bottom: 20px;
        position: relative;
    }
    
    .step-indicator::before {
        content: '';
        position: absolute;
        top: 15px;
        left: 0;
        right: 0;
        height: 2px;
        background-color: #e9ecef;
        z-index: 1;
    }
    
    .step {
        width: 30px;
        height: 30px;
        border-radius: 50%;
        background-color: white;
        border: 2px solid #e9ecef;
        display: flex;
        align-items: center;
        justify-content: center;
        font-weight: bold;
        color: #6c757d;
        position: relative;
        z-index: 2;
        transition: all 0.3s ease;
    }
    
    .step.active {
        background-color: #1d2671;
        border-color: #1d2671;
        color: white;
    }
    
    .step.completed {
        background-color: #28a745;
        border-color: #28a745;
        color: white;
    }
    
    .form-step {
        display: none;
    }
    
    .form-step.active {
        display: block;
        animation: fadeIn 0.3s ease;
    }
    
    .form-navigation {
        display: flex;
        justify-content: space-between;
        margin-top: 20px;
    }
    
    @keyframes fadeIn {
        from { opacity: 0; transform: translateY(10px); }
        to { opacity: 1; transform: translateY(0); }
    }
    
    /* Modal styles for Terms */
    .modal-backdrop {
        background-color: rgba(0, 0, 0, 0.7);
    }
    
    .modal-content {
        border-radius: 10px;
        border: none;
    }
    
    .modal-header {
        background-color: #1d2671;
        color: white;
        border-radius: 10px 10px 0 0;
    }
    
    .modal-body {
        max-height: 400px;
        overflow-y: auto;
    }

</style>
</head>

<body>

<!-- Terms and Conditions Modal -->
<div class="modal fade" id="termsModal" tabindex="-1" aria-labelledby="termsModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="termsModalLabel">
                    <i class="bi bi-journal-text me-2"></i>Terms & Conditions
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="terms-content">
                    <h4>BugBoard Terms of Service</h4>
                    <p><strong>Last Updated:</strong> <span id="currentDate"></span></p>
                    
                    <h5>1. Acceptance of Terms</h5>
                    <p>By accessing or using BugBoard, you agree to be bound by these Terms of Service. If you disagree with any part of the terms, you may not access the service.</p>
                    
                    <h5>2. User Accounts</h5>
                    <p>You must provide accurate and complete information when creating an account. You are responsible for maintaining the confidentiality of your account and password.</p>
                    
                    <h5>3. Privacy Policy</h5>
                    <p>Your privacy is important to us. Please read our Privacy Policy to understand how we collect, use, and disclose information about you.</p>
                    
                    <h5>4. User Conduct</h5>
                    <p>You agree not to use the service to:</p>
                    <ul>
                        <li>Upload or transmit any content that is unlawful, harmful, or infringing</li>
                        <li>Impersonate any person or entity</li>
                        <li>Interfere with or disrupt the service</li>
                        <li>Attempt to gain unauthorized access to any part of the service</li>
                    </ul>
                    
                    <h5>5. Content Ownership</h5>
                    <p>You retain ownership of any content you submit, but grant BugBoard a license to use, modify, and display such content to provide the service.</p>
                    
                    <h5>6. Termination</h5>
                    <p>We may terminate or suspend your account immediately, without prior notice, for conduct that we believe violates these Terms or is harmful to other users.</p>
                    
                    <h5>7. Disclaimer</h5>
                    <p>The service is provided "as is" without warranties of any kind. We do not guarantee that the service will be uninterrupted or error-free.</p>
                    
                    <h5>8. Limitation of Liability</h5>
                    <p>BugBoard shall not be liable for any indirect, incidental, special, consequential, or punitive damages resulting from your use of the service.</p>
                    
                    <h5>9. Changes to Terms</h5>
                    <p>We reserve the right to modify these terms at any time. We will notify users of any material changes via email or through the service.</p>
                    
                    <h5>10. Contact Information</h5>
                    <p>If you have any questions about these Terms, please contact us at: support@bugboard.com</p>
                    
                    <div class="text-center mt-4">
                        <button type="button" class="btn btn-primary" data-bs-dismiss="modal">
                            <i class="bi bi-check-circle me-2"></i> I Understand
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="signup-card">
    <!-- Step Indicator -->
    <div class="step-indicator">
        <div class="step active" id="step1Indicator">1</div>
        <div class="step" id="step2Indicator">2</div>
        <div class="step" id="step3Indicator">3</div>
    </div>
    
    <!-- Added logo and description -->
    <div class="text-center mb-4">
        <div class="header-icon">
            <i class="bi bi-person-plus-fill"></i>
        </div>
        <h2 class="mb-2">Create Your Account</h2>
        <p class="text-muted">Join our bug tracking community</p>
    </div>

    <form action="register" method="post" id="signupForm" onsubmit="return validateForm(event)">
        
        <!-- Step 1: Personal Information -->
        <div class="form-step active" id="step1Form">
            <h5 class="mb-3"><i class="bi bi-person-badge me-2"></i>Personal Information</h5>

            <!-- First Name -->
            <div class="mb-3">
                <label class="form-label"><i class="bi bi-person me-2"></i>First Name</label>
                <input type="text" id="first_name" name="first_name" class="form-control" 
                       autocomplete="given-name" required>
                <div class="invalid-feedback">Please enter your first name (2-50 characters)</div>
            </div>

            <!-- Last Name -->
            <div class="mb-3">
                <label class="form-label"><i class="bi bi-person me-2"></i>Last Name</label>
                <input type="text" id="last_name" name="last_name" class="form-control" 
                       autocomplete="family-name" required>
                <div class="invalid-feedback">Please enter your last name (2-50 characters)</div>
            </div>

            <!-- Gender Field (added with icon) -->
            <div class="mb-3">
                <label class="form-label"><i class="bi bi-gender-ambiguous me-2"></i>Gender</label>
                <select id="gender" name="gender" class="form-select" required>
                    <option value="" disabled selected>Select your gender</option>
                    <option value="Male">Male</option>
                    <option value="Female">Female</option>
                    <option value="Other">Other</option>
                </select>
                <div class="invalid-feedback">Please select your gender.</div>
            </div>

            <!-- Navigation -->
            <div class="form-navigation">
                <button type="button" class="btn btn-outline-secondary" disabled>Previous</button>
                <button type="button" class="btn btn-primary" onclick="validateAndGoToStep(2)">Next <i class="bi bi-arrow-right ms-1"></i></button>
            </div>
        </div>
        
        <!-- Step 2: Contact Information -->
        <div class="form-step" id="step2Form">
            <h5 class="mb-3"><i class="bi bi-telephone me-2"></i>Contact Information</h5>

            <!-- Mobile -->
            <div class="mb-3">
                <label class="form-label"><i class="bi bi-phone me-2"></i>Mobile Number</label>
                <input type="tel" id="mobile" name="mobile" class="form-control"
                       pattern="[0-9]{10}" autocomplete="tel" required>
                <div class="invalid-feedback">Please enter a valid 10-digit mobile number</div>
            </div>

            <!-- Email -->
            <div class="mb-3">
                <label class="form-label"><i class="bi bi-envelope me-2"></i>Email</label>
                <input type="email" id="email" name="email" class="form-control" 
                       autocomplete="email" required>
                <div class="invalid-feedback">Please enter a valid email address</div>
            </div>

            <!-- Navigation -->
            <div class="form-navigation">
                <button type="button" class="btn btn-outline-secondary" onclick="goToStep(1)">
                    <i class="bi bi-arrow-left me-1"></i> Previous
                </button>
                <button type="button" class="btn btn-primary" onclick="validateAndGoToStep(3)">
                    Next <i class="bi bi-arrow-right ms-1"></i>
                </button>
            </div>
        </div>
        
        <!-- Step 3: Security -->
        <div class="form-step" id="step3Form">
            <h5 class="mb-3"><i class="bi bi-shield-lock me-2"></i>Security Settings</h5>

            <!-- Password -->
            <div class="mb-3">
                <label class="form-label"><i class="bi bi-lock me-2"></i>Password</label>
                <div class="input-group">
                    <input type="password" id="password" name="password_hash"
                           class="form-control" onkeyup="checkPasswordStrength()" 
                           autocomplete="new-password" required>
                    <span class="input-group-text password-toggle"
                          onclick="togglePassword('password','eye1')">
                        <i class="bi bi-eye-slash" id="eye1"></i>
                    </span>
                </div>

                <!-- Password Rules -->
                <div id="passwordHelp" class="password-rules mt-2 text-danger">
                    <i class="bi bi-info-circle me-1"></i> Must contain at least 8 characters, uppercase, lowercase,
                    number & special character.
                </div>
            </div>

            <!-- Confirm Password -->
            <div class="mb-3">
                <label class="form-label"><i class="bi bi-lock-fill me-2"></i>Confirm Password</label>
                <div class="input-group">
                    <input type="password" id="confirmPassword"
                           class="form-control" autocomplete="new-password" required 
                           onkeyup="checkPasswordMatch()">
                    <span class="input-group-text password-toggle"
                          onclick="togglePassword('confirmPassword','eye2')">
                        <i class="bi bi-eye-slash" id="eye2"></i>
                    </span>
                </div>
                <div id="matchError" class="text-danger small"></div>
            </div>
            
            <!-- Terms --> 
            <div class="form-check mb-3"> 
                <input class="form-check-input" type="checkbox" id="terms" required> 
                <label class="form-check-label"> 
                    <i class="bi bi-check2-circle me-1"></i> I agree to the 
                    <a href="#" onclick="showTermsModal(); return false;" class="text-decoration-none">Terms & Conditions</a>
                </label> 
                <div class="invalid-feedback">You must agree to the terms and conditions.</div>
            </div>

            <!-- Navigation -->
            <div class="form-navigation">
                <button type="button" class="btn btn-outline-secondary" onclick="goToStep(2)">
                    <i class="bi bi-arrow-left me-1"></i> Previous
                </button>
                <button type="submit" class="btn btn-success">
                    <i class="bi bi-person-plus me-2"></i> Sign Up
                </button>
            </div>
        </div>

        <!-- Login -->
        <div class="text-center mt-3">
            <i class="bi bi-person me-1"></i> Already have an account?
            <a href="login" class="ms-1">Login</a>
        </div>

    </form>
</div>

<!-- Bootstrap JS Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // Initialize the form when page loads
    document.addEventListener('DOMContentLoaded', function() {
        showStep(1);
        
        // Set current date in terms modal
        const currentDate = new Date().toLocaleDateString('en-US', {
            year: 'numeric',
            month: 'long',
            day: 'numeric'
        });
        document.getElementById('currentDate').textContent = currentDate;
        
        // Add input event listeners for validation
        const firstNameInput = document.getElementById('first_name');
        const lastNameInput = document.getElementById('last_name');
        const genderSelect = document.getElementById('gender');
        const mobileInput = document.getElementById('mobile');
        const emailInput = document.getElementById('email');
        
        // Fix for autocomplete issue - prevent browser autofill from mixing data
        firstNameInput.addEventListener('input', function() {
            this.setAttribute('value', this.value);
            validateFirstName();
        });
        
        lastNameInput.addEventListener('input', function() {
            this.setAttribute('value', this.value);
            validateLastName();
        });
        
        genderSelect.addEventListener('change', validateGender);
        
        mobileInput.addEventListener('input', function() {
            // Allow only numbers and limit to 10 digits
            this.value = this.value.replace(/\D/g, '').slice(0, 10);
            validateMobile();
        });
        
        emailInput.addEventListener('input', function() {
            validateEmail();
        });
        
        // Initialize terms checkbox validation
        document.getElementById('terms').addEventListener('change', validateTerms);
    });
    
    // Multi-step form functionality
    let currentStep = 1;
    
    function showStep(step) {
        // Hide all steps
        document.getElementById('step1Form').classList.remove('active');
        document.getElementById('step2Form').classList.remove('active');
        document.getElementById('step3Form').classList.remove('active');
        
        // Remove active class from all step indicators
        document.getElementById('step1Indicator').classList.remove('active', 'completed');
        document.getElementById('step2Indicator').classList.remove('active', 'completed');
        document.getElementById('step3Indicator').classList.remove('active', 'completed');
        
        // Show current step
        document.getElementById('step' + step + 'Form').classList.add('active');
        
        // Update step indicators
        for (let i = 1; i <= 3; i++) {
            const stepIndicator = document.getElementById('step' + i + 'Indicator');
            if (i < step) {
                stepIndicator.classList.add('completed');
            } else if (i === step) {
                stepIndicator.classList.add('active');
            }
        }
        
        currentStep = step;
    }
    
    function goToStep(step) {
        showStep(step);
    }
    
    function validateAndGoToStep(nextStep) {
        if (validateCurrentStep()) {
            showStep(nextStep);
        }
    }
    
    function validateCurrentStep() {
        switch(currentStep) {
            case 1:
                return validateStep1();
            case 2:
                return validateStep2();
            case 3:
                return validateStep3();
            default:
                return false;
        }
    }
    
    function validateStep1() {
        let isValid = true;
        
        // Validate first name
        if (!validateFirstName()) isValid = false;
        
        // Validate last name
        if (!validateLastName()) isValid = false;
        
        // Validate gender
        if (!validateGender()) isValid = false;
        
        if (!isValid) {
            alert('Please fill in all required fields in Step 1 correctly.');
        }
        
        return isValid;
    }
    
    function validateStep2() {
        let isValid = true;
        
        // Validate mobile
        if (!validateMobile()) isValid = false;
        
        // Validate email
        if (!validateEmail()) isValid = false;
        
        // Check if email is being used in other fields (common autofill issue)
        const firstName = document.getElementById('first_name').value;
        const lastName = document.getElementById('last_name').value;
        const email = document.getElementById('email').value;
        
        if (firstName === email || lastName === email) {
            alert('Your email address should not appear in the name fields. Please check your input.');
            isValid = false;
        }
        
        if (!isValid) {
            alert('Please fill in all required fields in Step 2 correctly.');
        }
        
        return isValid;
    }
    
    function validateStep3() {
        let isValid = true;
        
        // Validate password strength
        if (!checkPasswordStrength()) {
            alert('Please create a strong password (8+ characters with uppercase, lowercase, number, and special character).');
            isValid = false;
        }
        
        // Validate password match
        if (!checkPasswordMatch()) {
            alert('Passwords do not match. Please make sure both password fields are identical.');
            isValid = false;
        }
        
        // Validate terms
        if (!validateTerms()) {
            alert('You must agree to the terms and conditions.');
            isValid = false;
        }
        
        return isValid;
    }
    
    // Individual validation functions
    function validateFirstName() {
        const firstName = document.getElementById('first_name');
        const nameValue = firstName.value.trim();
        
        // Check if it's empty or contains email pattern
        if (nameValue === '' || nameValue.length < 2 || nameValue.length > 50) {
            firstName.classList.add('is-invalid');
            firstName.classList.remove('is-valid');
            return false;
        }
        
        // Check if it contains @ (email address)
        if (nameValue.includes('@')) {
            firstName.classList.add('is-invalid');
            firstName.classList.remove('is-valid');
            return false;
        }
        
        firstName.classList.remove('is-invalid');
        firstName.classList.add('is-valid');
        return true;
    }
    
    function validateLastName() {
        const lastName = document.getElementById('last_name');
        const nameValue = lastName.value.trim();
        
        // Check if it's empty or contains email pattern
        if (nameValue === '' || nameValue.length < 2 || nameValue.length > 50) {
            lastName.classList.add('is-invalid');
            lastName.classList.remove('is-valid');
            return false;
        }
        
        // Check if it contains @ (email address) or is the same as email
        const emailValue = document.getElementById('email').value.trim();
        if (nameValue.includes('@') || nameValue === emailValue) {
            lastName.classList.add('is-invalid');
            lastName.classList.remove('is-valid');
            return false;
        }
        
        lastName.classList.remove('is-invalid');
        lastName.classList.add('is-valid');
        return true;
    }
    
    function validateGender() {
        const gender = document.getElementById('gender');
        if (gender.value === '') {
            gender.classList.add('is-invalid');
            gender.classList.remove('is-valid');
            return false;
        } else {
            gender.classList.remove('is-invalid');
            gender.classList.add('is-valid');
            return true;
        }
    }
    
    function validateMobile() {
        const mobile = document.getElementById('mobile');
        const mobileRegex = /^[0-9]{10}$/;
        if (!mobileRegex.test(mobile.value)) {
            mobile.classList.add('is-invalid');
            mobile.classList.remove('is-valid');
            return false;
        } else {
            mobile.classList.remove('is-invalid');
            mobile.classList.add('is-valid');
            return true;
        }
    }
    
    function validateEmail() {
        const email = document.getElementById('email');
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!emailRegex.test(email.value)) {
            email.classList.add('is-invalid');
            email.classList.remove('is-valid');
            return false;
        } else {
            email.classList.remove('is-invalid');
            email.classList.add('is-valid');
            return true;
        }
    }
    
    function validateTerms() {
        const terms = document.getElementById('terms');
        if (!terms.checked) {
            terms.classList.add('is-invalid');
            return false;
        } else {
            terms.classList.remove('is-invalid');
            return true;
        }
    }
    
    // Terms modal function
    function showTermsModal() {
        const termsModal = new bootstrap.Modal(document.getElementById('termsModal'));
        termsModal.show();
    }

    function togglePassword(inputId, eyeId) {
        const input = document.getElementById(inputId);
        const eye = document.getElementById(eyeId);

        if (input.type === "password") {
            input.type = "text";
            eye.classList.replace("bi-eye-slash", "bi-eye");
        } else {
            input.type = "password";
            eye.classList.replace("bi-eye", "bi-eye-slash");
        }
    }

    function checkPasswordStrength() {
        const password = document.getElementById("password").value;
        const help = document.getElementById("passwordHelp");

        const strongRegex =
            /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/;

        if (strongRegex.test(password)) {
            help.classList.remove("text-danger");
            help.classList.add("text-success");
            help.innerHTML = '<i class="bi bi-check-circle me-1"></i> Strong password ✔';
            return true;
        } else {
            help.classList.remove("text-success");
            help.classList.add("text-danger");
            help.innerHTML = '<i class="bi bi-info-circle me-1"></i> Must contain 8+ chars, uppercase, lowercase, number & special character';
            return false;
        }
    }
    
    function checkPasswordMatch() {
        const password = document.getElementById("password").value;
        const confirm = document.getElementById("confirmPassword").value;
        const matchError = document.getElementById("matchError");
        
        if (confirm === '') {
            matchError.innerHTML = '';
            return false;
        }
        
        if (password !== confirm) {
            matchError.innerHTML = '<i class="bi bi-exclamation-triangle me-1"></i> Passwords do not match!';
            matchError.className = 'text-danger small';
            return false;
        } else {
            matchError.innerHTML = '<i class="bi bi-check-circle me-1"></i> Passwords match!';
            matchError.className = 'text-success small';
            return true;
        }
    }

    function validateForm(event) {
        // Prevent the default form submission
        event.preventDefault();
        
        // Validate all steps before submission
        if (!validateStep1() || !validateStep2() || !validateStep3()) {
            // Show the first step with errors
            if (!validateStep1()) {
                showStep(1);
            } else if (!validateStep2()) {
                showStep(2);
            } else if (!validateStep3()) {
                showStep(3);
            }
            alert('Please fix all errors before submitting.');
            return false;
        }
        
        // Final check for email in last name field
        const lastName = document.getElementById('last_name').value;
        const email = document.getElementById('email').value;
        if (lastName === email || lastName.includes('@')) {
            alert('Please check your last name field. It appears to contain an email address.');
            showStep(1);
            return false;
        }
        
        // If all validations pass, submit the form
        document.getElementById('signupForm').submit();
        return true;
    }
</script>

</body>
</html>