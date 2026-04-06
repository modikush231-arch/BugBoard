<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- Bootstrap JS Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<style>
    .bugboard-footer {
        background: rgba(15, 23, 42, 0.8);
        backdrop-filter: blur(10px);
        border-top: 1px solid rgba(99, 102, 241, 0.2);
        margin-top: 3rem;
        padding: 1.5rem 0;
    }
    
    .bugboard-footer .footer-content {
        max-width: 1400px;
        margin: 0 auto;
        padding: 0 1.5rem;
        display: flex;
        justify-content: space-between;
        align-items: center;
        flex-wrap: wrap;
        gap: 1rem;
    }
    
    .bugboard-footer .footer-logo {
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }
    
    .bugboard-footer .footer-logo i {
        font-size: 1.5rem;
        color: var(--primary-color);
    }
    
    .bugboard-footer .footer-logo span {
        font-weight: 600;
        background: linear-gradient(135deg, #fff, var(--primary-color));
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        background-clip: text;
    }
    
    .bugboard-footer .footer-links {
        display: flex;
        gap: 2rem;
        flex-wrap: wrap;
    }
    
    .bugboard-footer .footer-links a {
        color: var(--text-secondary);
        text-decoration: none;
        font-size: 0.875rem;
        transition: all 0.2s;
        display: inline-flex;
        align-items: center;
        gap: 0.5rem;
    }
    
    .bugboard-footer .footer-links a:hover {
        color: var(--primary-color);
        transform: translateY(-2px);
    }
    
    .bugboard-footer .footer-copyright {
        color: var(--text-secondary);
        font-size: 0.75rem;
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }
    
    .bugboard-footer .status-badge {
        display: inline-flex;
        align-items: center;
        gap: 0.5rem;
        background: rgba(16, 185, 129, 0.15);
        padding: 0.25rem 0.75rem;
        border-radius: 20px;
        font-size: 0.75rem;
        color: var(--secondary-color);
    }
@media (min-width: 992px) {
    .bugboard-footer {
        margin-left: 260px;
        width: calc(100% - 260px);
    }
}
</style>

<script>
function toggleSidebar() {
    const sidebar = document.querySelector('.sidebar');
    const mainContent = document.querySelector('.main-content');
    
    if (sidebar && mainContent) {
        sidebar.classList.toggle('open');
        
        if (window.innerWidth <= 992) {
            if (sidebar.classList.contains('open')) {
                sidebar.style.transform = 'translateX(0)';
                mainContent.style.marginLeft = '0';
            } else {
                sidebar.style.transform = 'translateX(-100%)';
                mainContent.style.marginLeft = '0';
            }
        }
    }
}

document.addEventListener('click', function(event) {
    const sidebar = document.querySelector('.sidebar');
    const toggler = document.querySelector('.navbar-toggler');
    
    if (window.innerWidth <= 992 && sidebar && toggler && 
        !sidebar.contains(event.target) && !toggler.contains(event.target)) {
        sidebar.classList.remove('open');
        sidebar.style.transform = 'translateX(-100%)';
    }
});

document.addEventListener('DOMContentLoaded', function() {
    setTimeout(function() {
        const alerts = document.querySelectorAll('.alert:not(.alert-permanent)');
        alerts.forEach(function(alert) {
            alert.style.transition = 'opacity 0.5s';
            alert.style.opacity = '0';
            setTimeout(function() {
                if (alert.parentNode) {
                    alert.remove();
                }
            }, 500);
        });
    }, 3000);
    
    const yearSpan = document.getElementById('currentYear');
    if (yearSpan) {
        yearSpan.textContent = new Date().getFullYear();
    }
});

document.addEventListener('submit', function(e) {
    const form = e.target;
    const submitBtn = form.querySelector('button[type="submit"]');
    if (submitBtn && submitBtn.getAttribute('data-submitted') === 'true') {
        e.preventDefault();
    } else if (submitBtn) {
        submitBtn.setAttribute('data-submitted', 'true');
        setTimeout(() => {
            submitBtn.removeAttribute('data-submitted');
        }, 3000);
    }
});
</script>

<footer class="bugboard-footer">
    <div class="footer-content">
        <div class="footer-logo">
            <i class="bi bi-kanban-fill"></i>
            <span>BugBoard</span>
            <div class="status-badge">
                <i class="bi bi-circle-fill" style="font-size: 0.5rem; color: var(--secondary-color);"></i>
                Active
            </div>
        </div>
        
        <div class="footer-links">
            <a href="../login">
                <i class="bi bi-box-arrow-in-right"></i> Login
            </a>
            <a href="#" data-bs-toggle="modal" data-bs-target="#supportModal">
                <i class="bi bi-question-circle"></i> Support
            </a>
        </div>
        
        <div class="footer-copyright">
            <i class="bi bi-c-circle"></i>
            <span id="currentYear">2026</span>
            <span>BugBoard Inc.</span>
            <span class="mx-1">•</span>
            <span>v1.0</span>
        </div>
    </div>
</footer>

<div class="modal fade" id="supportModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content bg-dark text-white border-secondary">
            <div class="modal-header border-secondary">
                <h5 class="modal-title">
                    <i class="bi bi-headset text-primary me-2"></i>Need Help?
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="text-center mb-3">
                    <i class="bi bi-chat-dots fs-1 text-secondary"></i>
                </div>
                <p class="text-center text-secondary mb-4">
                    Need assistance? Contact the support team.
                </p>
                <div class="d-flex flex-column gap-2">
                    <a href="mailto:support@bugboard.com" class="btn btn-outline-primary">
                        <i class="bi bi-envelope me-2"></i>Email Support
                    </a>
                    <a href="#" class="btn btn-outline-secondary">
                        <i class="bi bi-slack me-2"></i>Slack Channel
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>