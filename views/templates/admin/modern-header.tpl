{* Modern Header for Supplier Manager Templates *}

{* CSS de force d'affichage (priorité absolue) *}
<link rel="stylesheet" href="{$module_dir}views/css/force-display.css" type="text/css" media="all">

{* Include modern CSS files *}
<link rel="stylesheet" href="{$module_dir}views/css/admin.css" type="text/css" media="all">
<link rel="stylesheet" href="{$module_dir}views/css/components.css" type="text/css" media="all">
<link rel="stylesheet" href="{$module_dir}views/css/modern-enhancements.css" type="text/css" media="all">
<link rel="stylesheet" href="{$module_dir}views/css/modern-fixes.css" type="text/css" media="all">
<link rel="stylesheet" href="{$module_dir}views/css/order-view.css" type="text/css" media="all">

{* Script de reconstruction HTML - priorité maximale *}
<script src="{$module_dir}views/js/html-rebuild.js"></script>

{* Script de correction d'urgence - chargé en premier *}
<script src="{$module_dir}views/js/direct-fix.js"></script>

{* Include modern JavaScript files *}
<script src="{$module_dir}views/js/modern-utils.js"></script>
<script src="{$module_dir}views/js/admin.js"></script>
<script src="{$module_dir}views/js/browser-compatibility.js"></script>

{* Modern CSS Variables and Enhancements *}
<style>
/* Additional modern enhancements specific to this template */
:root {
    /* Enhanced color palette */
    --primary-gradient: linear-gradient(135deg, var(--primary-500), var(--primary-600));
    --secondary-gradient: linear-gradient(135deg, var(--secondary-500), var(--secondary-600));
    --success-gradient: linear-gradient(135deg, var(--secondary-500), var(--secondary-600));
    --warning-gradient: linear-gradient(135deg, var(--warning-500), var(--warning-600));
    --danger-gradient: linear-gradient(135deg, var(--danger-500), var(--danger-600));
    
    /* Enhanced shadows */
    --shadow-glow: 0 0 20px rgba(59, 130, 246, 0.3);
    --shadow-success: 0 0 20px rgba(34, 197, 94, 0.3);
    --shadow-warning: 0 0 20px rgba(245, 158, 11, 0.3);
    --shadow-danger: 0 0 20px rgba(239, 68, 68, 0.3);
    
    /* Enhanced transitions */
    --transition-bounce: cubic-bezier(0.68, -0.55, 0.265, 1.55);
    --transition-smooth: cubic-bezier(0.4, 0, 0.2, 1);
}

/* Modern glassmorphism effects */
.glass-effect {
    background: rgba(255, 255, 255, 0.1);
    backdrop-filter: blur(10px);
    border: 1px solid rgba(255, 255, 255, 0.2);
}

/* Modern gradient text */
.gradient-text {
    background: var(--primary-gradient);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
}

/* Modern button hover effects */
.btn-modern {
    position: relative;
    overflow: hidden;
    transform-style: preserve-3d;
}

.btn-modern::before {
    content: '';
    position: absolute;
    top: 0;
    left: -100%;
    width: 100%;
    height: 100%;
    background: linear-gradient(90deg, transparent, rgba(255,255,255,0.4), transparent);
    transition: left 0.5s ease;
}

.btn-modern:hover::before {
    left: 100%;
}

/* Modern card stack effect */
.card-stack {
    position: relative;
}

.card-stack::before,
.card-stack::after {
    content: '';
    position: absolute;
    top: 4px;
    left: 4px;
    right: -4px;
    bottom: -4px;
    background: rgba(255, 255, 255, 0.5);
    border-radius: inherit;
    z-index: -1;
    transform: rotate(1deg);
}

.card-stack::after {
    top: 8px;
    left: 8px;
    right: -8px;
    bottom: -8px;
    background: rgba(255, 255, 255, 0.3);
    transform: rotate(-1deg);
}

/* Modern progress indicators */
.progress-modern {
    height: 8px;
    background: var(--gray-200);
    border-radius: 10px;
    overflow: hidden;
    position: relative;
}

.progress-modern::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    height: 100%;
    background: var(--primary-gradient);
    border-radius: inherit;
    transition: width 0.6s var(--transition-smooth);
}

/* Modern floating labels */
.floating-label {
    position: relative;
}

.floating-label input {
    padding-top: 1.5rem;
}

.floating-label label {
    position: absolute;
    top: 1rem;
    left: 1rem;
    transition: all 0.3s var(--transition-smooth);
    pointer-events: none;
    color: var(--gray-500);
}

.floating-label input:focus + label,
.floating-label input:not(:placeholder-shown) + label {
    top: 0.25rem;
    font-size: 0.75rem;
    color: var(--primary-600);
}

/* Modern skeleton loading */
.skeleton {
    background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
    background-size: 200% 100%;
    animation: loading 1.5s infinite;
}

@keyframes loading {
    0% {
        background-position: 200% 0;
    }
    100% {
        background-position: -200% 0;
    }
}

/* Modern tooltip */
.tooltip-modern {
    position: relative;
}

.tooltip-modern::before {
    content: attr(data-tooltip);
    position: absolute;
    bottom: 100%;
    left: 50%;
    transform: translateX(-50%);
    background: var(--gray-900);
    color: white;
    padding: 0.5rem 1rem;
    border-radius: 0.5rem;
    font-size: 0.875rem;
    white-space: nowrap;
    opacity: 0;
    visibility: hidden;
    transition: all 0.3s var(--transition-smooth);
    z-index: 1000;
}

.tooltip-modern::after {
    content: '';
    position: absolute;
    bottom: 100%;
    left: 50%;
    transform: translateX(-50%);
    border: 5px solid transparent;
    border-top-color: var(--gray-900);
    opacity: 0;
    visibility: hidden;
    transition: all 0.3s var(--transition-smooth);
}

.tooltip-modern:hover::before,
.tooltip-modern:hover::after {
    opacity: 1;
    visibility: visible;
    transform: translateX(-50%) translateY(-5px);
}

/* Modern focus indicators */
.focus-modern:focus {
    outline: none;
    box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.3);
    border-color: var(--primary-500);
}

/* Modern scroll indicators */
.scroll-indicator {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 4px;
    background: var(--gray-200);
    z-index: 9999;
}

.scroll-indicator::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    height: 100%;
    background: var(--primary-gradient);
    transition: width 0.1s ease;
}

/* Modern status indicators */
.status-dot-modern {
    width: 12px;
    height: 12px;
    border-radius: 50%;
    display: inline-block;
    position: relative;
    margin-right: 0.5rem;
}

.status-dot-modern::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    border-radius: 50%;
    animation: pulse-ring 2s infinite;
}

.status-dot-modern.online {
    background: var(--secondary-500);
}

.status-dot-modern.online::before {
    background: var(--secondary-500);
}

.status-dot-modern.offline {
    background: var(--gray-400);
}

.status-dot-modern.offline::before {
    background: var(--gray-400);
}

@keyframes pulse-ring {
    0% {
        transform: scale(1);
        opacity: 1;
    }
    100% {
        transform: scale(2);
        opacity: 0;
    }
}

/* Modern responsive utilities */
@media (max-width: 640px) {
    .hide-mobile {
        display: none !important;
    }
}

@media (min-width: 641px) {
    .show-mobile {
        display: none !important;
    }
}

@media (max-width: 768px) {
    .hide-tablet {
        display: none !important;
    }
}

@media (min-width: 769px) {
    .show-tablet {
        display: none !important;
    }
}

/* Modern print utilities */
@media print {
    .no-print {
        display: none !important;
    }
    
    .print-only {
        display: block !important;
    }
}
</style>

{* Inclusion de l'outil de réparation des onglets *}
{include file="./tab-fixer.tpl"}

{* Modern JavaScript enhancements *}
<script>
// Modern scroll indicator
document.addEventListener('DOMContentLoaded', function() {
    // Create scroll indicator
    var scrollIndicator = document.createElement('div');
    scrollIndicator.className = 'scroll-indicator';
    document.body.appendChild(scrollIndicator);
    
    // Update scroll indicator
    function updateScrollIndicator() {
        var scrollTop = window.pageYOffset || document.documentElement.scrollTop;
        var scrollHeight = document.documentElement.scrollHeight - window.innerHeight;
        var scrollPercent = (scrollTop / scrollHeight) * 100;
        
        scrollIndicator.style.background = 'linear-gradient(to right, var(--primary-500) ' + scrollPercent + '%, var(--gray-200) ' + scrollPercent + '%)';
    }
    
    window.addEventListener('scroll', updateScrollIndicator);
    updateScrollIndicator();
    
    // Modern smooth scrolling for anchor links
    document.querySelectorAll('a[href^="#"]').forEach(function(anchor) {
        anchor.addEventListener('click', function(e) {
            e.preventDefault();
            var target = document.querySelector(this.getAttribute('href'));
            if (target) {
                target.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        });
    });
    
    // Modern keyboard navigation
    document.addEventListener('keydown', function(e) {
        // Escape key to close modals/notifications
        if (e.key === 'Escape') {
            var notifications = document.querySelectorAll('.notification.show');
            notifications.forEach(function(notification) {
                notification.classList.remove('show');
            });
        }
        
        // Ctrl/Cmd + K for search
        if ((e.ctrlKey || e.metaKey) && e.key === 'k') {
            e.preventDefault();
            var searchInput = document.querySelector('.search-input');
            if (searchInput) {
                searchInput.focus();
            }
        }
    });
    
    // Modern intersection observer for animations
    var observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    var observer = new IntersectionObserver(function(entries) {
        entries.forEach(function(entry) {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-in');
            }
        });
    }, observerOptions);
    
    // Observe elements for animation
    document.querySelectorAll('.panel, .card, .settings-section, .kpi-card').forEach(function(element) {
        observer.observe(element);
    });
});

// Modern performance monitoring
if ('performance' in window) {
    window.addEventListener('load', function() {
        setTimeout(function() {
            var perfData = performance.getEntriesByType('navigation')[0];
            if (perfData && perfData.loadEventEnd - perfData.loadEventStart > 3000) {
                console.warn('Page load time is slow:', perfData.loadEventEnd - perfData.loadEventStart + 'ms');
            }
        }, 0);
    });
}
</script>