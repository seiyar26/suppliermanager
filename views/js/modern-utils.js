/**
 * Modern Utilities for Supplier Manager
 * Compatible JavaScript without template literals for Smarty templates
 */

// Modern Notification System
window.ModernNotificationSystem = {
    container: null,
    
    init: function() {
        if (!this.container) {
            this.container = document.createElement('div');
            this.container.className = 'notification-container';
            this.container.style.cssText = 'position: fixed; top: 20px; right: 20px; z-index: 10000; display: flex; flex-direction: column; gap: 12px; max-width: 400px;';
            document.body.appendChild(this.container);
        }
    },
    
    show: function(message, type, duration) {
        if (!type) type = 'info';
        if (!duration) duration = 5000;
        
        this.init();
        
        var notification = document.createElement('div');
        notification.className = 'notification notification-' + type;
        
        var iconClass = 'icon-info';
        if (type === 'success') iconClass = 'icon-check';
        else if (type === 'error') iconClass = 'icon-times';
        else if (type === 'warning') iconClass = 'icon-exclamation-triangle';
        
        notification.innerHTML = 
            '<div class="notification-content">' +
                '<i class="' + iconClass + '"></i>' +
                '<span>' + message + '</span>' +
            '</div>' +
            '<button class="notification-close" type="button">' +
                '<i class="icon-times"></i>' +
            '</button>';
        
        this.container.appendChild(notification);
        
        // Show animation
        setTimeout(function() {
            notification.classList.add('show');
        }, 100);
        
        // Auto-hide
        var hideTimer = setTimeout(function() {
            ModernNotificationSystem.hide(notification);
        }, duration);
        
        // Manual close
        var closeBtn = notification.querySelector('.notification-close');
        if (closeBtn) {
            closeBtn.addEventListener('click', function() {
                clearTimeout(hideTimer);
                ModernNotificationSystem.hide(notification);
            });
        }
        
        return notification;
    },
    
    hide: function(notification) {
        notification.classList.remove('show');
        setTimeout(function() {
            if (notification.parentNode) {
                notification.parentNode.removeChild(notification);
            }
        }, 300);
    }
};

// Modern Loading State Manager
window.ModernLoadingManager = {
    show: function(element) {
        if (element) {
            element.classList.add('loading');
            element.disabled = true;
        }
    },
    
    hide: function(element) {
        if (element) {
            element.classList.remove('loading');
            element.disabled = false;
        }
    },
    
    showOnButton: function(button, text) {
        if (!text) text = 'Chargement...';
        
        if (button) {
            button.classList.add('loading');
            button.disabled = true;
            button.setAttribute('data-original-text', button.innerHTML);
            button.innerHTML = '<i class="icon-spinner icon-spin"></i> ' + text;
        }
    },
    
    hideOnButton: function(button) {
        if (button) {
            button.classList.remove('loading');
            button.disabled = false;
            var originalText = button.getAttribute('data-original-text');
            if (originalText) {
                button.innerHTML = originalText;
                button.removeAttribute('data-original-text');
            }
        }
    }
};

// Modern Animation Manager
window.ModernAnimationManager = {
    fadeIn: function(elements, delay) {
        if (!delay) delay = 0;
        
        var elementArray = Array.isArray(elements) ? elements : [elements];
        
        elementArray.forEach(function(element, index) {
            if (element) {
                element.style.opacity = '0';
                element.style.transform = 'translateY(20px)';
                
                setTimeout(function() {
                    element.style.transition = 'all 0.6s cubic-bezier(0.4, 0, 0.2, 1)';
                    element.style.opacity = '1';
                    element.style.transform = 'translateY(0)';
                }, delay + (index * 100));
            }
        });
    },
    
    fadeOut: function(element) {
        return new Promise(function(resolve) {
            if (element) {
                element.style.transition = 'all 0.3s ease-out';
                element.style.opacity = '0';
                element.style.transform = 'translateY(-20px)';
                
                setTimeout(resolve, 300);
            } else {
                resolve();
            }
        });
    },
    
    pulse: function(element) {
        if (element) {
            element.style.animation = 'modernPulse 0.6s ease-out';
            setTimeout(function() {
                element.style.animation = '';
            }, 600);
        }
    },
    
    slideIn: function(element, direction) {
        if (!direction) direction = 'right';
        
        if (element) {
            element.style.opacity = '0';
            element.style.transform = 'translateX(' + (direction === 'right' ? '20px' : '-20px') + ')';
            
            setTimeout(function() {
                element.style.transition = 'all 0.4s cubic-bezier(0.4, 0, 0.2, 1)';
                element.style.opacity = '1';
                element.style.transform = 'translateX(0)';
            }, 50);
        }
    }
};

// Modern Form Utilities
window.ModernFormUtils = {
    validateField: function(field) {
        var value = field.value.trim();
        var rules = field.getAttribute('data-validate');
        if (!rules) return true;
        
        var ruleArray = rules.split('|');
        var errors = [];
        
        ruleArray.forEach(function(rule) {
            var parts = rule.split(':');
            var ruleName = parts[0];
            var ruleValue = parts[1];
            
            switch (ruleName) {
                case 'required':
                    if (!value) errors.push('Ce champ est requis');
                    break;
                case 'email':
                    if (value && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value)) {
                        errors.push('Format d\'email invalide');
                    }
                    break;
                case 'min':
                    if (value && value.length < parseInt(ruleValue)) {
                        errors.push('Minimum ' + ruleValue + ' caractères');
                    }
                    break;
                case 'max':
                    if (value && value.length > parseInt(ruleValue)) {
                        errors.push('Maximum ' + ruleValue + ' caractères');
                    }
                    break;
                case 'numeric':
                    if (value && !/^\d+$/.test(value)) {
                        errors.push('Seuls les chiffres sont autorisés');
                    }
                    break;
            }
        });
        
        this.showFieldErrors(field, errors);
        return errors.length === 0;
    },
    
    showFieldErrors: function(field, errors) {
        this.clearFieldError(field);
        
        if (errors.length > 0) {
            field.classList.add('error');
            
            var errorDiv = document.createElement('div');
            errorDiv.className = 'field-error';
            errorDiv.textContent = errors[0];
            
            field.parentNode.appendChild(errorDiv);
        }
    },
    
    clearFieldError: function(field) {
        field.classList.remove('error');
        var existingError = field.parentNode.querySelector('.field-error');
        if (existingError) {
            existingError.remove();
        }
    },
    
    validateForm: function(form) {
        var fields = form.querySelectorAll('[data-validate]');
        var isValid = true;
        
        fields.forEach(function(field) {
            if (!ModernFormUtils.validateField(field)) {
                isValid = false;
            }
        });
        
        return isValid;
    }
};

// Modern Utility Functions
window.ModernUtils = {
    debounce: function(func, wait) {
        var timeout;
        return function executedFunction() {
            var context = this;
            var args = arguments;
            var later = function() {
                clearTimeout(timeout);
                func.apply(context, args);
            };
            clearTimeout(timeout);
            timeout = setTimeout(later, wait);
        };
    },
    
    delay: function(ms) {
        return new Promise(function(resolve) {
            setTimeout(resolve, ms);
        });
    },
    
    formatCurrency: function(amount) {
        return new Intl.NumberFormat('fr-FR', {
            style: 'currency',
            currency: 'EUR'
        }).format(amount);
    },
    
    copyToClipboard: function(text) {
        if (navigator.clipboard) {
            navigator.clipboard.writeText(text).then(function() {
                ModernNotificationSystem.show('Copié dans le presse-papiers', 'success');
            }).catch(function() {
                ModernNotificationSystem.show('Erreur lors de la copie', 'error');
            });
        } else {
            // Fallback for older browsers
            var textArea = document.createElement('textarea');
            textArea.value = text;
            document.body.appendChild(textArea);
            textArea.select();
            try {
                document.execCommand('copy');
                ModernNotificationSystem.show('Copié dans le presse-papiers', 'success');
            } catch (err) {
                ModernNotificationSystem.show('Erreur lors de la copie', 'error');
            }
            document.body.removeChild(textArea);
        }
    },
    
    generateRandomToken: function() {
        return Math.random().toString(36).substring(2, 15) + Math.random().toString(36).substring(2, 15);
    },
    
    formatDate: function(date) {
        return new Date(date).toLocaleDateString('fr-FR');
    },
    
    formatDateTime: function(date) {
        return new Date(date).toLocaleString('fr-FR');
    }
};

// Global notification function for backward compatibility
function showNotification(message, type) {
    ModernNotificationSystem.show(message, type);
}

// Initialize when DOM is ready
document.addEventListener('DOMContentLoaded', function() {
    // Initialize notification system
    ModernNotificationSystem.init();
    
    // Add modern interactions to all forms
    var forms = document.querySelectorAll('form');
    forms.forEach(function(form) {
        var inputs = form.querySelectorAll('input, select, textarea');
        
        inputs.forEach(function(input) {
            input.addEventListener('blur', function() {
                ModernFormUtils.validateField(this);
            });
            
            input.addEventListener('input', function() {
                ModernFormUtils.clearFieldError(this);
            });
        });
    });
    
    // Add loading states to buttons
    var buttons = document.querySelectorAll('.btn');
    buttons.forEach(function(button) {
        if (button.type === 'submit' || button.classList.contains('btn-test')) {
            button.addEventListener('click', function() {
                var self = this;
                ModernLoadingManager.showOnButton(self);
                
                setTimeout(function() {
                    ModernLoadingManager.hideOnButton(self);
                }, 2000);
            });
        }
    });
    
    // Animate elements on scroll
    var observer = new IntersectionObserver(function(entries) {
        entries.forEach(function(entry) {
            if (entry.isIntersecting) {
                entry.target.classList.add('fade-in-up');
            }
        });
    });
    
    var animatedElements = document.querySelectorAll('.panel, .card, .settings-section');
    animatedElements.forEach(function(element) {
        observer.observe(element);
    });
    
    // Add hover effects to cards
    var cards = document.querySelectorAll('.card, .panel, .card-box');
    cards.forEach(function(card) {
        card.addEventListener('mouseenter', function() {
            this.style.transform = 'translateY(-4px) scale(1.01)';
        });
        
        card.addEventListener('mouseleave', function() {
            this.style.transform = '';
        });
    });
});

// Common functions for all templates
function togglePassword(inputId) {
    var input = document.getElementById(inputId);
    var button = input.nextElementSibling;
    var icon = button.querySelector('i');
    
    if (input.type === 'password') {
        input.type = 'text';
        icon.className = 'icon-eye-slash';
    } else {
        input.type = 'password';
        icon.className = 'icon-eye';
    }
}

function copyToClipboard(inputId) {
    var input = document.getElementById(inputId);
    ModernUtils.copyToClipboard(input.value);
    
    var button = input.nextElementSibling;
    var originalIcon = button.querySelector('i').className;
    button.querySelector('i').className = 'icon-check';
    button.style.background = 'var(--secondary-100)';
    button.style.color = 'var(--secondary-700)';
    
    setTimeout(function() {
        button.querySelector('i').className = originalIcon;
        button.style.background = '';
        button.style.color = '';
    }, 2000);
}

function regenerateToken() {
    if (confirm('Êtes-vous sûr de vouloir régénérer le jeton ? L\'ancien jeton ne fonctionnera plus.')) {
        var tokenInput = document.querySelector('input[name="cron_token"]');
        if (tokenInput) {
            var newToken = ModernUtils.generateRandomToken();
            tokenInput.value = newToken;
            ModernNotificationSystem.show('Nouveau jeton généré', 'success');
        }
    }
}

function resetForm() {
    if (confirm('Êtes-vous sûr de vouloir réinitialiser tous les paramètres ?')) {
        var form = document.querySelector('.settings-form') || document.querySelector('form');
        if (form) {
            form.reset();
            ModernNotificationSystem.show('Formulaire réinitialisé', 'info');
        }
    }
}

// Export for use in other scripts
window.ModernSupplierManager = {
    NotificationSystem: ModernNotificationSystem,
    LoadingManager: ModernLoadingManager,
    AnimationManager: ModernAnimationManager,
    FormUtils: ModernFormUtils,
    Utils: ModernUtils
};