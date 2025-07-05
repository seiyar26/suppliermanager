/**
 * Modern Supplier Manager JavaScript
 * Enhanced with modern ES6+ features and improved UX
 */

class SupplierManager {
    constructor() {
        this.init();
        this.bindEvents();
        this.initializeComponents();
    }

    init() {
        // Initialize modern features
        this.notifications = new NotificationManager();
        this.loadingStates = new LoadingStateManager();
        this.animations = new AnimationManager();
        
        // Initialize data tables with modern styling
        this.initDataTables();
        
        // Initialize form validation
        this.initFormValidation();
        
        // Initialize search functionality
        this.initSearch();
        
        // Initialize tooltips and popovers
        this.initTooltips();
        
        // Initialize date pickers
        this.initDatePickers();
        
        // Initialize charts
        this.initCharts();
    }

    bindEvents() {
        // Modern event delegation
        document.addEventListener('click', this.handleClick.bind(this));
        document.addEventListener('change', this.handleChange.bind(this));
        document.addEventListener('input', this.handleInput.bind(this));
        document.addEventListener('submit', this.handleSubmit.bind(this));
        
        // Keyboard shortcuts
        document.addEventListener('keydown', this.handleKeyboard.bind(this));
        
        // Window events
        window.addEventListener('resize', this.handleResize.bind(this));
        window.addEventListener('scroll', this.handleScroll.bind(this));
    }

    handleClick(event) {
        const target = event.target.closest('[data-action]');
        if (!target) return;

        const action = target.dataset.action;
        const params = { ...target.dataset };
        delete params.action;

        this.executeAction(action, params, target);
    }

    handleChange(event) {
        const target = event.target;
        
        // Auto-save functionality
        if (target.hasAttribute('data-auto-save')) {
            this.debounce(() => this.autoSave(target), 1000)();
        }
        
        // Dynamic calculations
        if (target.classList.contains('product-quantity')) {
            this.updateOrderTotal();
        }
        
        // Filter updates
        if (target.classList.contains('filter-control')) {
            this.updateFilters();
        }
    }

    handleInput(event) {
        const target = event.target;
        
        // Real-time search
        if (target.classList.contains('search-input')) {
            this.debounce(() => this.performSearch(target.value), 300)();
        }
        
        // Input validation
        if (target.hasAttribute('data-validate')) {
            this.validateField(target);
        }
    }

    handleSubmit(event) {
        const form = event.target;
        
        if (form.classList.contains('ajax-form')) {
            event.preventDefault();
            this.submitAjaxForm(form);
        }
        
        // Form validation
        if (!this.validateForm(form)) {
            event.preventDefault();
        }
    }

    handleKeyboard(event) {
        // Ctrl/Cmd + S for save
        if ((event.ctrlKey || event.metaKey) && event.key === 's') {
            event.preventDefault();
            this.quickSave();
        }
        
        // Escape to close modals
        if (event.key === 'Escape') {
            this.closeModals();
        }
        
        // Enter to submit forms
        if (event.key === 'Enter' && event.target.classList.contains('quick-submit')) {
            event.preventDefault();
            event.target.closest('form')?.submit();
        }
    }

    executeAction(action, params, element) {
        this.loadingStates.show(element);
        
        const actions = {
            'create-contract': () => this.createContract(params),
            'edit-contract': () => this.editContract(params.id),
            'delete-contract': () => this.deleteContract(params.id),
            'renew-contract': () => this.renewContract(params.id),
            'export-data': () => this.exportData(params.type),
            'import-data': () => this.importData(params.type),
            'apply-suggestion': () => this.applySuggestion(params),
            'test-connection': () => this.testConnection(params.type),
            'refresh-data': () => this.refreshData(params.target),
            'toggle-view': () => this.toggleView(params.target),
            'copy-text': () => this.copyToClipboard(params.text),
            'preview-template': () => this.previewTemplate(params.template),
            'generate-report': () => this.generateReport(params.type)
        };

        const actionFunction = actions[action];
        if (actionFunction) {
            actionFunction().finally(() => {
                this.loadingStates.hide(element);
            });
        } else {
            console.warn(`Unknown action: ${action}`);
            this.loadingStates.hide(element);
        }
    }

    // Data Tables with modern features
    initDataTables() {
        const tables = document.querySelectorAll('.modern-datatable');
        
        tables.forEach(table => {
            if (typeof DataTable !== 'undefined') {
                new DataTable(table, {
                    responsive: true,
                    pageLength: 25,
                    lengthMenu: [[10, 25, 50, 100], [10, 25, 50, 100]],
                    language: {
                        search: '',
                        searchPlaceholder: 'Rechercher...',
                        lengthMenu: 'Afficher _MENU_ éléments',
                        info: 'Affichage de _START_ à _END_ sur _TOTAL_ éléments',
                        infoEmpty: 'Aucun élément à afficher',
                        infoFiltered: '(filtré de _MAX_ éléments au total)',
                        paginate: {
                            first: '⟨⟨',
                            previous: '⟨',
                            next: '⟩',
                            last: '⟩⟩'
                        }
                    },
                    dom: '<"table-controls"<"table-length"l><"table-search"f>>rtip',
                    drawCallback: () => {
                        this.animations.fadeIn(table.querySelectorAll('tbody tr'));
                    }
                });
            }
        });
    }

    // Form validation with modern UX
    initFormValidation() {
        const forms = document.querySelectorAll('.validated-form');
        
        forms.forEach(form => {
            const inputs = form.querySelectorAll('input, select, textarea');
            
            inputs.forEach(input => {
                input.addEventListener('blur', () => this.validateField(input));
                input.addEventListener('input', () => this.clearFieldError(input));
            });
        });
    }

    validateField(field) {
        const value = field.value.trim();
        const rules = field.dataset.validate?.split('|') || [];
        const errors = [];

        rules.forEach(rule => {
            const [ruleName, ruleValue] = rule.split(':');
            
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
                        errors.push(`Minimum ${ruleValue} caractères`);
                    }
                    break;
                case 'max':
                    if (value && value.length > parseInt(ruleValue)) {
                        errors.push(`Maximum ${ruleValue} caractères`);
                    }
                    break;
                case 'numeric':
                    if (value && !/^\d+$/.test(value)) {
                        errors.push('Seuls les chiffres sont autorisés');
                    }
                    break;
                case 'decimal':
                    if (value && !/^\d+(\.\d+)?$/.test(value)) {
                        errors.push('Format décimal invalide');
                    }
                    break;
            }
        });

        this.showFieldErrors(field, errors);
        return errors.length === 0;
    }

    showFieldErrors(field, errors) {
        this.clearFieldError(field);
        
        if (errors.length > 0) {
            field.classList.add('error');
            
            const errorDiv = document.createElement('div');
            errorDiv.className = 'field-error';
            errorDiv.textContent = errors[0];
            
            field.parentNode.appendChild(errorDiv);
        }
    }

    clearFieldError(field) {
        field.classList.remove('error');
        const existingError = field.parentNode.querySelector('.field-error');
        if (existingError) {
            existingError.remove();
        }
    }

    validateForm(form) {
        const fields = form.querySelectorAll('[data-validate]');
        let isValid = true;
        
        fields.forEach(field => {
            if (!this.validateField(field)) {
                isValid = false;
            }
        });
        
        return isValid;
    }

    // Modern search with debouncing
    initSearch() {
        const searchInputs = document.querySelectorAll('.search-input');
        
        searchInputs.forEach(input => {
            const searchResults = input.parentNode.querySelector('.search-results');
            if (searchResults) {
                input.addEventListener('focus', () => {
                    searchResults.style.display = 'block';
                });
                
                document.addEventListener('click', (e) => {
                    if (!input.parentNode.contains(e.target)) {
                        searchResults.style.display = 'none';
                    }
                });
            }
        });
    }

    performSearch(query) {
        if (query.length < 2) return;
        
        // Implementation depends on the specific search endpoint
        console.log('Searching for:', query);
    }

    // Order total calculation
    updateOrderTotal() {
        const quantityInputs = document.querySelectorAll('.product-quantity');
        let totalQuantity = 0;
        let totalAmount = 0;
        
        quantityInputs.forEach(input => {
            const quantity = parseInt(input.value) || 0;
            const price = parseFloat(input.dataset.price) || 0;
            const rowTotal = quantity * price;
            
            totalQuantity += quantity;
            totalAmount += rowTotal;
            
            // Update row total
            const rowTotalElement = input.closest('tr')?.querySelector('.row-total');
            if (rowTotalElement) {
                rowTotalElement.textContent = this.formatCurrency(rowTotal);
            }
        });
        
        // Update totals
        const totalQuantityElement = document.getElementById('total-quantity');
        const totalAmountElement = document.getElementById('total-amount');
        
        if (totalQuantityElement) totalQuantityElement.textContent = totalQuantity;
        if (totalAmountElement) totalAmountElement.textContent = this.formatCurrency(totalAmount);
        
        // Check minimum order requirements
        this.checkMinimumOrder(totalQuantity, totalAmount);
    }

    checkMinimumOrder(quantity, amount) {
        const minQuantity = parseInt(document.getElementById('min-order-quantity')?.value) || 0;
        const minAmount = parseFloat(document.getElementById('min-order-amount')?.value) || 0;
        
        const quantityWarning = document.getElementById('quantity-warning');
        const amountWarning = document.getElementById('amount-warning');
        
        if (quantityWarning) {
            quantityWarning.style.display = quantity < minQuantity ? 'block' : 'none';
        }
        
        if (amountWarning) {
            amountWarning.style.display = amount < minAmount ? 'block' : 'none';
        }
    }

    // Contract management
    async createContract(params) {
        try {
            this.notifications.show('Création du contrat en cours...', 'info');
            
            // Simulate API call
            await this.delay(2000);
            
            this.notifications.show('Contrat créé avec succès', 'success');
            this.refreshData('contracts');
        } catch (error) {
            this.notifications.show('Erreur lors de la création du contrat', 'error');
        }
    }

    async editContract(id) {
        try {
            this.notifications.show(`Modification du contrat #${id}...`, 'info');
            
            // Simulate API call
            await this.delay(1500);
            
            this.notifications.show('Contrat modifié avec succès', 'success');
        } catch (error) {
            this.notifications.show('Erreur lors de la modification', 'error');
        }
    }

    async deleteContract(id) {
        if (!confirm('Êtes-vous sûr de vouloir supprimer ce contrat ?')) {
            return;
        }
        
        try {
            this.notifications.show(`Suppression du contrat #${id}...`, 'warning');
            
            // Simulate API call
            await this.delay(1000);
            
            this.notifications.show('Contrat supprimé avec succès', 'success');
            
            // Remove from DOM with animation
            const contractElement = document.querySelector(`[data-contract-id="${id}"]`);
            if (contractElement) {
                this.animations.fadeOut(contractElement).then(() => {
                    contractElement.remove();
                });
            }
        } catch (error) {
            this.notifications.show('Erreur lors de la suppression', 'error');
        }
    }

    async renewContract(id) {
        if (!confirm('Renouveler ce contrat ?')) {
            return;
        }
        
        try {
            this.notifications.show(`Renouvellement du contrat #${id}...`, 'info');
            
            // Simulate API call
            await this.delay(2500);
            
            this.notifications.show('Contrat renouvelé avec succès', 'success');
        } catch (error) {
            this.notifications.show('Erreur lors du renouvellement', 'error');
        }
    }

    // Data export/import
    async exportData(type) {
        try {
            this.notifications.show(`Export ${type} en cours...`, 'info');
            
            // Simulate export
            await this.delay(3000);
            
            this.notifications.show('Export terminé avec succès', 'success');
            
            // Trigger download
            this.triggerDownload(`export_${type}_${Date.now()}.xlsx`);
        } catch (error) {
            this.notifications.show('Erreur lors de l\'export', 'error');
        }
    }

    async importData(type) {
        const input = document.createElement('input');
        input.type = 'file';
        input.accept = '.xlsx,.csv';
        
        input.onchange = async (e) => {
            const file = e.target.files[0];
            if (!file) return;
            
            try {
                this.notifications.show(`Import ${type} en cours...`, 'info');
                
                // Simulate import
                await this.delay(4000);
                
                this.notifications.show('Import terminé avec succès', 'success');
                this.refreshData(type);
            } catch (error) {
                this.notifications.show('Erreur lors de l\'import', 'error');
            }
        };
        
        input.click();
    }

    // AI suggestions
    applySuggestion(params) {
        const { productId, suggestedQty } = params;
        const quantityInput = document.getElementById(`product-${productId}-quantity`);
        
        if (quantityInput) {
            quantityInput.value = suggestedQty;
            this.updateOrderTotal();
            this.notifications.show('Suggestion appliquée', 'success');
            
            // Highlight the changed input
            quantityInput.classList.add('highlight');
            setTimeout(() => {
                quantityInput.classList.remove('highlight');
            }, 2000);
        }
    }

    // Connection testing
    async testConnection(type) {
        try {
            this.notifications.show(`Test de connexion ${type}...`, 'info');
            
            // Simulate connection test
            await this.delay(3000);
            
            const success = Math.random() > 0.3; // 70% success rate for demo
            
            if (success) {
                this.notifications.show('Connexion réussie', 'success');
            } else {
                this.notifications.show('Échec de la connexion', 'error');
            }
        } catch (error) {
            this.notifications.show('Erreur lors du test', 'error');
        }
    }

    // Utility functions
    debounce(func, wait) {
        let timeout;
        return function executedFunction(...args) {
            const later = () => {
                clearTimeout(timeout);
                func(...args);
            };
            clearTimeout(timeout);
            timeout = setTimeout(later, wait);
        };
    }

    delay(ms) {
        return new Promise(resolve => setTimeout(resolve, ms));
    }

    formatCurrency(amount) {
        return new Intl.NumberFormat('fr-FR', {
            style: 'currency',
            currency: 'EUR'
        }).format(amount);
    }

    copyToClipboard(text) {
        navigator.clipboard.writeText(text).then(() => {
            this.notifications.show('Copié dans le presse-papiers', 'success');
        }).catch(() => {
            this.notifications.show('Erreur lors de la copie', 'error');
        });
    }

    triggerDownload(filename) {
        const link = document.createElement('a');
        link.href = '#'; // Would be actual file URL
        link.download = filename;
        link.click();
    }

    async refreshData(target) {
        const elements = document.querySelectorAll(`[data-refresh-target="${target}"]`);
        
        elements.forEach(element => {
            this.loadingStates.show(element);
        });
        
        try {
            // Simulate data refresh
            await this.delay(1500);
            
            elements.forEach(element => {
                this.loadingStates.hide(element);
                this.animations.pulse(element);
            });
            
            this.notifications.show('Données actualisées', 'success');
        } catch (error) {
            elements.forEach(element => {
                this.loadingStates.hide(element);
            });
            this.notifications.show('Erreur lors de l\'actualisation', 'error');
        }
    }

    toggleView(target) {
        const container = document.querySelector(`[data-view-container="${target}"]`);
        if (container) {
            container.classList.toggle('grid-view');
            container.classList.toggle('list-view');
            
            const isGrid = container.classList.contains('grid-view');
            this.notifications.show(`Vue ${isGrid ? 'grille' : 'liste'} activée`, 'info');
        }
    }

    initTooltips() {
        // Modern tooltip implementation
        const tooltipElements = document.querySelectorAll('[data-tooltip]');
        
        tooltipElements.forEach(element => {
            element.addEventListener('mouseenter', (e) => {
                this.showTooltip(e.target, e.target.dataset.tooltip);
            });
            
            element.addEventListener('mouseleave', () => {
                this.hideTooltip();
            });
        });
    }

    showTooltip(element, text) {
        const tooltip = document.createElement('div');
        tooltip.className = 'modern-tooltip';
        tooltip.textContent = text;
        
        document.body.appendChild(tooltip);
        
        const rect = element.getBoundingClientRect();
        tooltip.style.left = rect.left + (rect.width / 2) - (tooltip.offsetWidth / 2) + 'px';
        tooltip.style.top = rect.top - tooltip.offsetHeight - 8 + 'px';
        
        setTimeout(() => tooltip.classList.add('show'), 10);
    }

    hideTooltip() {
        const tooltip = document.querySelector('.modern-tooltip');
        if (tooltip) {
            tooltip.classList.remove('show');
            setTimeout(() => tooltip.remove(), 200);
        }
    }

    initDatePickers() {
        const dateInputs = document.querySelectorAll('.date-picker');
        
        dateInputs.forEach(input => {
            // Modern date picker implementation
            input.type = 'date';
            input.addEventListener('change', () => {
                this.validateField(input);
            });
        });
    }

    initCharts() {
        // Initialize charts if Chart.js is available
        if (typeof Chart !== 'undefined') {
            const chartElements = document.querySelectorAll('.chart-canvas');
            
            chartElements.forEach(canvas => {
                const type = canvas.dataset.chartType || 'line';
                const data = JSON.parse(canvas.dataset.chartData || '{}');
                
                new Chart(canvas, {
                    type: type,
                    data: data,
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: {
                            legend: {
                                position: 'bottom'
                            }
                        },
                        scales: {
                            y: {
                                beginAtZero: true
                            }
                        }
                    }
                });
            });
        }
    }

    initializeComponents() {
        // Initialize any additional components
        this.initModals();
        this.initTabs();
        this.initAccordions();
    }

    initModals() {
        const modalTriggers = document.querySelectorAll('[data-modal]');
        
        modalTriggers.forEach(trigger => {
            trigger.addEventListener('click', (e) => {
                e.preventDefault();
                const modalId = trigger.dataset.modal;
                this.openModal(modalId);
            });
        });
        
        // Close modals on escape or backdrop click
        document.addEventListener('click', (e) => {
            if (e.target.classList.contains('modal-backdrop')) {
                this.closeModals();
            }
        });
    }

    openModal(modalId) {
        const modal = document.getElementById(modalId);
        if (modal) {
            modal.classList.add('show');
            document.body.classList.add('modal-open');
        }
    }

    closeModals() {
        const modals = document.querySelectorAll('.modal.show');
        modals.forEach(modal => {
            modal.classList.remove('show');
        });
        document.body.classList.remove('modal-open');
    }

    initTabs() {
        console.log('📋 InitTabs: Initializing tabs with forced display');
        const tabButtons = document.querySelectorAll('.tab-button');
        
        // 1. Ajouter les événements click sur tous les boutons d'onglet
        tabButtons.forEach(button => {
            button.addEventListener('click', (e) => {
                e.preventDefault();
                const tabId = button.dataset.tab;
                this.switchTab(tabId, button);
                
                // Force l'affichage après un léger délai (pour tous navigateurs)
                setTimeout(() => {
                    const selectedTab = document.getElementById(tabId);
                    if (selectedTab) {
                        selectedTab.style.display = 'block';
                        selectedTab.style.opacity = '1';
                        selectedTab.style.visibility = 'visible';
                    }
                }, 10);
            });
        });
        
        // 2. Activer automatiquement le premier onglet au chargement
        if (tabButtons.length > 0) {
            console.log('▶️ Activating first tab on page load');
            const firstButton = tabButtons[0];
            const firstTabId = firstButton.dataset.tab;
            
            // Activer l'onglet
            this.switchTab(firstTabId, firstButton);
            
            // Double-vérification que l'onglet est bien affiché
            const selectedTab = document.getElementById(firstTabId);
            if (selectedTab) {
                // Forcer l'affichage avec des styles inline pour être sûr
                selectedTab.setAttribute('style', 'display: block !important; visibility: visible !important; opacity: 1 !important;');
                console.log('✅ First tab forced visible:', firstTabId);
            }
        }
        
        // 3. Solution de secours - vérifier après un délai si un onglet est bien actif
        setTimeout(() => {
            const activeContent = document.querySelector('.tab-content.active');
            if (!activeContent && tabButtons.length > 0) {
                console.log('⚠️ No active tab found after timeout, forcing first tab display again');
                const firstButton = tabButtons[0];
                const firstTabId = firstButton.dataset.tab;
                this.switchTab(firstTabId, firstButton);
                
                // Force l'affichage encore plus fort
                const firstTab = document.getElementById(firstTabId);
                if (firstTab) {
                    firstTab.classList.add('active');
                    firstTab.style.display = 'block';
                    firstTab.style.visibility = 'visible';
                    firstTab.style.opacity = '1';
                    console.log('🔧 Emergency display fix applied to tab:', firstTabId);
                }
            }
        }, 500);
    }

    switchTab(tabId, button) {
        // Hide all tab contents
        const tabContents = document.querySelectorAll('.tab-content');
        tabContents.forEach(content => {
            content.classList.remove('active');
        });
        
        // Remove active class from all buttons
        const tabButtons = document.querySelectorAll('.tab-button');
        tabButtons.forEach(btn => {
            btn.classList.remove('active');
        });
        
        // Show selected tab and activate button
        const selectedTab = document.getElementById(tabId);
        if (selectedTab) {
            selectedTab.classList.add('active');
            button.classList.add('active');
        }
    }

    initAccordions() {
        const accordionHeaders = document.querySelectorAll('.accordion-header');
        
        accordionHeaders.forEach(header => {
            header.addEventListener('click', () => {
                const content = header.nextElementSibling;
                const isOpen = content.classList.contains('open');
                
                // Close all accordions in the same group
                const group = header.closest('.accordion-group');
                if (group) {
                    group.querySelectorAll('.accordion-content').forEach(c => {
                        c.classList.remove('open');
                    });
                    group.querySelectorAll('.accordion-header').forEach(h => {
                        h.classList.remove('active');
                    });
                }
                
                // Toggle current accordion
                if (!isOpen) {
                    content.classList.add('open');
                    header.classList.add('active');
                }
            });
        });
    }

    handleResize() {
        // Handle responsive behavior
        this.debounce(() => {
            // Recalculate layouts if needed
        }, 250)();
    }

    handleScroll() {
        // Handle scroll-based animations or sticky elements
        this.debounce(() => {
            // Implement scroll-based features
        }, 100)();
    }

    quickSave() {
        const activeForm = document.querySelector('form:focus-within');
        if (activeForm && activeForm.classList.contains('auto-save')) {
            this.submitAjaxForm(activeForm);
        }
    }

    async submitAjaxForm(form) {
        try {
            this.loadingStates.show(form);
            
            const formData = new FormData(form);
            
            // Simulate AJAX submission
            await this.delay(2000);
            
            this.notifications.show('Formulaire enregistré', 'success');
        } catch (error) {
            this.notifications.show('Erreur lors de l\'enregistrement', 'error');
        } finally {
            this.loadingStates.hide(form);
        }
    }

    autoSave(field) {
        // Auto-save individual field changes
        console.log('Auto-saving field:', field.name, field.value);
    }

    updateFilters() {
        // Update filtered content based on current filter values
        const filters = document.querySelectorAll('.filter-control');
        const filterValues = {};
        
        filters.forEach(filter => {
            filterValues[filter.name] = filter.value;
        });
        
        // Apply filters to content
        this.applyFilters(filterValues);
    }

    applyFilters(filters) {
        const items = document.querySelectorAll('.filterable-item');
        
        items.forEach(item => {
            let visible = true;
            
            Object.entries(filters).forEach(([key, value]) => {
                if (value && item.dataset[key] !== value) {
                    visible = false;
                }
            });
            
            item.style.display = visible ? 'block' : 'none';
        });
    }
}

// Supporting classes
class NotificationManager {
    constructor() {
        this.container = this.createContainer();
    }

    createContainer() {
        const container = document.createElement('div');
        container.className = 'notification-container';
        document.body.appendChild(container);
        return container;
    }

    show(message, type = 'info', duration = 5000) {
        const notification = document.createElement('div');
        notification.className = `notification notification-${type}`;
        
        const icon = this.getIcon(type);
        notification.innerHTML = `
            <div class="notification-content">
                <i class="${icon}"></i>
                <span>${message}</span>
            </div>
            <button class="notification-close">
                <i class="icon-times"></i>
            </button>
        `;
        
        this.container.appendChild(notification);
        
        // Show animation
        setTimeout(() => notification.classList.add('show'), 10);
        
        // Auto-hide
        const hideTimer = setTimeout(() => this.hide(notification), duration);
        
        // Manual close
        notification.querySelector('.notification-close').addEventListener('click', () => {
            clearTimeout(hideTimer);
            this.hide(notification);
        });
        
        return notification;
    }

    hide(notification) {
        notification.classList.remove('show');
        setTimeout(() => {
            if (notification.parentNode) {
                notification.parentNode.removeChild(notification);
            }
        }, 300);
    }

    getIcon(type) {
        const icons = {
            success: 'icon-check',
            error: 'icon-times',
            warning: 'icon-exclamation-triangle',
            info: 'icon-info'
        };
        return icons[type] || icons.info;
    }
}

class LoadingStateManager {
    show(element) {
        element.classList.add('loading');
        element.disabled = true;
    }

    hide(element) {
        element.classList.remove('loading');
        element.disabled = false;
    }
}

class AnimationManager {
    fadeIn(elements) {
        const elementArray = Array.isArray(elements) ? elements : [elements];
        
        elementArray.forEach((element, index) => {
            element.style.opacity = '0';
            element.style.transform = 'translateY(20px)';
            
            setTimeout(() => {
                element.style.transition = 'all 0.3s ease-out';
                element.style.opacity = '1';
                element.style.transform = 'translateY(0)';
            }, index * 50);
        });
    }

    fadeOut(element) {
        return new Promise(resolve => {
            element.style.transition = 'all 0.3s ease-out';
            element.style.opacity = '0';
            element.style.transform = 'translateY(-20px)';
            
            setTimeout(resolve, 300);
        });
    }

    pulse(element) {
        element.style.animation = 'pulse 0.6s ease-out';
        setTimeout(() => {
            element.style.animation = '';
        }, 600);
    }

    bounce(element) {
        element.style.animation = 'bounce 0.6s ease-out';
        setTimeout(() => {
            element.style.animation = '';
        }, 600);
    }
}

// Initialize when DOM is ready
document.addEventListener('DOMContentLoaded', () => {
    window.supplierManager = new SupplierManager();
});

// Legacy jQuery support for existing code
if (typeof $ !== 'undefined') {
    $(document).ready(function() {
        // Maintain backward compatibility with existing jQuery code
        console.log('Supplier Manager: Modern JavaScript initialized with jQuery compatibility');
    });
}