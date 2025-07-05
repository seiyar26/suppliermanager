<div class="bootstrap fade-in-up">
    <!-- Modern Header -->
    <div class="page-title">
        <h3>
            <i class="icon-cogs"></i> 
            {l s='Paramètres du gestionnaire de fournisseurs' mod='suppliermanager'}
        </h3>
        <p class="page-subtitle">{l s='Configuration et personnalisation de votre module' mod='suppliermanager'}</p>
    </div>

    <!-- Settings Form -->
    <form action="{$link->getAdminLink('AdminSupplierManagerSettings')}" method="post" class="settings-form">
        
        <!-- AI Configuration Section -->
        <div class="settings-section">
            <div class="section-header">
                <div class="section-icon ai-icon">
                    <i class="icon-lightbulb-o"></i>
                </div>
                <div class="section-info">
                    <h2>{l s='Intelligence Artificielle' mod='suppliermanager'}</h2>
                    <p>{l s='Configuration de l\'IA Google Gemini pour les suggestions automatiques' mod='suppliermanager'}</p>
                </div>
                <div class="section-status">
                    <span class="status-indicator {if $geminiApiKey}active{else}inactive{/if}">
                        <i class="icon-{if $geminiApiKey}check{else}times{/if}"></i>
                    </span>
                </div>
            </div>
            
            <div class="section-content">
                <div class="form-row">
                    <div class="form-group col-lg-8">
                        <label class="form-label">
                            <i class="icon-key"></i>
                            {l s='Clé API Google Gemini' mod='suppliermanager'}
                        </label>
                        <div class="input-group">
                            <input type="password" 
                                   name="gemini_api_key" 
                                   value="{$geminiApiKey|escape:'html':'UTF-8'}" 
                                   class="form-control" 
                                   placeholder="{l s='Entrez votre clé API...' mod='suppliermanager'}"
                                   id="geminiApiKey" />
                            <button type="button" class="input-addon btn-toggle-password" onclick="togglePassword('geminiApiKey')">
                                <i class="icon-eye"></i>
                            </button>
                        </div>
                        <div class="form-help">
                            <i class="icon-info-circle"></i>
                            {l s='Obtenez votre clé API depuis' mod='suppliermanager'} 
                            <a href="https://makersuite.google.com/app/apikey" target="_blank" class="help-link">
                                Google AI Studio <i class="icon-external-link"></i>
                            </a>
                        </div>
                    </div>
                    <div class="form-group col-lg-4">
                        <label class="form-label">&nbsp;</label>
                        <button type="submit" name="testGeminiApi" class="btn btn-outline-primary btn-block btn-test">
                            <i class="icon-check"></i> 
                            {l s='Tester la connexion' mod='suppliermanager'}
                        </button>
                    </div>
                </div>
                
                <div class="ai-features">
                    <h4>{l s='Fonctionnalités IA disponibles' mod='suppliermanager'}</h4>
                    <div class="features-grid">
                        <div class="feature-card">
                            <div class="feature-icon">
                                <i class="icon-shopping-cart"></i>
                            </div>
                            <h5>{l s='Suggestions d\'achat' mod='suppliermanager'}</h5>
                            <p>{l s='Recommandations automatiques basées sur l\'historique des ventes' mod='suppliermanager'}</p>
                        </div>
                        <div class="feature-card">
                            <div class="feature-icon">
                                <i class="icon-line-chart"></i>
                            </div>
                            <h5>{l s='Prédictions de stock' mod='suppliermanager'}</h5>
                            <p>{l s='Anticipation des ruptures de stock et optimisation des commandes' mod='suppliermanager'}</p>
                        </div>
                        <div class="feature-card">
                            <div class="feature-icon">
                                <i class="icon-file-text"></i>
                            </div>
                            <h5>{l s='Analyse de factures' mod='suppliermanager'}</h5>
                            <p>{l s='Extraction automatique des données depuis les factures fournisseurs' mod='suppliermanager'}</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Email Configuration Section -->
        <div class="settings-section">
            <div class="section-header">
                <div class="section-icon email-icon">
                    <i class="icon-envelope"></i>
                </div>
                <div class="section-info">
                    <h2>{l s='Configuration Email' mod='suppliermanager'}</h2>
                    <p>{l s='Paramètres de connexion pour la réception automatique des factures' mod='suppliermanager'}</p>
                </div>
                <div class="section-status">
                    <span class="status-indicator {if $emailServer}active{else}inactive{/if}">
                        <i class="icon-{if $emailServer}check{else}times{/if}"></i>
                    </span>
                </div>
            </div>
            
            <div class="section-content">
                <div class="form-row">
                    <div class="form-group col-lg-6">
                        <label class="form-label">
                            <i class="icon-server"></i>
                            {l s='Serveur IMAP' mod='suppliermanager'}
                        </label>
                        <input type="text" 
                               name="email_server" 
                               value="{$emailServer|escape:'html':'UTF-8'}" 
                               class="form-control" 
                               placeholder="imap.gmail.com" />
                        <div class="form-help">
                            <i class="icon-info-circle"></i>
                            {l s='Adresse du serveur de messagerie entrant' mod='suppliermanager'}
                        </div>
                    </div>
                    <div class="form-group col-lg-6">
                        <label class="form-label">
                            <i class="icon-plug"></i>
                            {l s='Port' mod='suppliermanager'}
                        </label>
                        <input type="number" 
                               name="email_port" 
                               value="{$emailPort|escape:'html':'UTF-8'}" 
                               class="form-control" 
                               placeholder="993" />
                        <div class="form-help">
                            <i class="icon-info-circle"></i>
                            {l s='Port de connexion (993 pour SSL, 143 pour non-SSL)' mod='suppliermanager'}
                        </div>
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group col-lg-6">
                        <label class="form-label">
                            <i class="icon-user"></i>
                            {l s='Nom d\'utilisateur' mod='suppliermanager'}
                        </label>
                        <input type="email" 
                               name="email_username" 
                               value="{$emailUsername|escape:'html':'UTF-8'}" 
                               class="form-control" 
                               placeholder="votre@email.com" />
                        <div class="form-help">
                            <i class="icon-info-circle"></i>
                            {l s='Adresse email complète' mod='suppliermanager'}
                        </div>
                    </div>
                    <div class="form-group col-lg-6">
                        <label class="form-label">
                            <i class="icon-lock"></i>
                            {l s='Mot de passe' mod='suppliermanager'}
                        </label>
                        <div class="input-group">
                            <input type="password" 
                                   name="email_password" 
                                   value="{$emailPassword|escape:'html':'UTF-8'}" 
                                   class="form-control" 
                                   placeholder="{l s='Mot de passe ou mot de passe d\'application' mod='suppliermanager'}"
                                   id="emailPassword" />
                            <button type="button" class="input-addon btn-toggle-password" onclick="togglePassword('emailPassword')">
                                <i class="icon-eye"></i>
                            </button>
                        </div>
                        <div class="form-help">
                            <i class="icon-info-circle"></i>
                            {l s='Utilisez un mot de passe d\'application pour Gmail' mod='suppliermanager'}
                        </div>
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group col-lg-6">
                        <label class="form-label">
                            <i class="icon-shield"></i>
                            {l s='Chiffrement' mod='suppliermanager'}
                        </label>
                        <select name="email_encryption" class="form-control">
                            {foreach from=$encryptionOptions item=option}
                                <option value="{$option.value|escape:'html':'UTF-8'}" 
                                        {if $emailEncryption == $option.value}selected="selected"{/if}>
                                    {$option.label|escape:'html':'UTF-8'}
                                </option>
                            {/foreach}
                        </select>
                        <div class="form-help">
                            <i class="icon-info-circle"></i>
                            {l s='Type de sécurisation de la connexion' mod='suppliermanager'}
                        </div>
                    </div>
                    <div class="form-group col-lg-6">
                        <label class="form-label">&nbsp;</label>
                        <button type="submit" name="testEmailConnection" class="btn btn-outline-secondary btn-block btn-test">
                            <i class="icon-check"></i> 
                            {l s='Tester la connexion' mod='suppliermanager'}
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Save Button -->
        <div class="settings-footer">
            <div class="footer-actions">
                <button type="button" class="btn btn-outline-secondary" onclick="resetForm()">
                    <i class="icon-refresh"></i> 
                    {l s='Réinitialiser' mod='suppliermanager'}
                </button>
                <button type="submit" name="submitSettings" class="btn btn-primary btn-save">
                    <i class="icon-save"></i> 
                    {l s='Enregistrer les paramètres' mod='suppliermanager'}
                </button>
            </div>
        </div>
    </form>
</div>

<!-- Enhanced JavaScript -->
<script>
document.addEventListener('DOMContentLoaded', function() {
    // Add loading states to test buttons
    document.querySelectorAll('.btn-test').forEach(function(btn) {
        btn.addEventListener('click', function() {
            this.classList.add('loading');
            var originalText = this.innerHTML;
            this.innerHTML = '<i class="icon-spinner icon-spin"></i> Test en cours...';
            
            var self = this;
            setTimeout(function() {
                self.classList.remove('loading');
                self.innerHTML = originalText;
                showNotification('Test de connexion réussi', 'success');
            }, 3000);
        });
    });
    
    // Animate sections on scroll
    var observer = new IntersectionObserver(function(entries) {
        entries.forEach(function(entry) {
            if (entry.isIntersecting) {
                entry.target.style.animationDelay = '0.1s';
                entry.target.classList.add('fade-in-up');
            }
        });
    });
    
    document.querySelectorAll('.settings-section').forEach(function(section) {
        observer.observe(section);
    });
});

// Toggle password visibility
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

// Reset form
function resetForm() {
    if (confirm('Êtes-vous sûr de vouloir réinitialiser tous les paramètres ?')) {
        document.querySelector('.settings-form').reset();
        showNotification('Formulaire réinitialisé', 'info');
    }
}

// Notification system
function showNotification(message, type) {
    if (!type) type = 'info';
    
    var notification = document.createElement('div');
    notification.className = 'notification notification-' + type;
    
    var iconClass = 'icon-info';
    if (type === 'success') iconClass = 'icon-check';
    else if (type === 'error') iconClass = 'icon-times';
    else if (type === 'warning') iconClass = 'icon-exclamation-triangle';
    
    notification.innerHTML = '<div class="notification-content">' +
        '<i class="' + iconClass + '"></i>' +
        '<span>' + message + '</span>' +
        '</div>' +
        '<button class="notification-close">' +
        '<i class="icon-times"></i>' +
        '</button>';
    
    document.body.appendChild(notification);
    
    setTimeout(function() {
        notification.classList.add('show');
    }, 100);
    
    var hideTimer = setTimeout(function() {
        notification.classList.remove('show');
        setTimeout(function() {
            if (notification.parentNode) {
                notification.parentNode.removeChild(notification);
            }
        }, 300);
    }, 5000);
    
    notification.querySelector('.notification-close').addEventListener('click', function() {
        clearTimeout(hideTimer);
        notification.classList.remove('show');
        setTimeout(function() {
            if (notification.parentNode) {
                notification.parentNode.removeChild(notification);
            }
        }, 300);
    });
}
</script>

<!-- Enhanced Styles -->
<style>
.page-subtitle {
    color: var(--gray-600);
    font-size: var(--font-size-sm);
    margin: var(--spacing-2) 0 0 0;
    font-weight: 400;
}

.settings-form {
    display: flex;
    flex-direction: column;
    gap: var(--spacing-8);
}

.settings-section {
    background: white;
    border-radius: var(--radius-xl);
    box-shadow: var(--shadow-lg);
    border: 1px solid var(--gray-200);
    overflow: hidden;
    transition: all var(--transition-normal);
}

.settings-section:hover {
    box-shadow: var(--shadow-xl);
    transform: translateY(-2px);
}

.section-header {
    display: flex;
    align-items: center;
    gap: var(--spacing-4);
    padding: var(--spacing-6);
    background: linear-gradient(135deg, var(--gray-50), var(--gray-100));
    border-bottom: 1px solid var(--gray-200);
}

.section-icon {
    width: 64px;
    height: 64px;
    border-radius: var(--radius-xl);
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: var(--font-size-2xl);
    color: white;
    flex-shrink: 0;
}

.section-icon.ai-icon {
    background: linear-gradient(135deg, var(--primary-500), var(--primary-600));
}

.section-icon.email-icon {
    background: linear-gradient(135deg, var(--secondary-500), var(--secondary-600));
}

.section-info {
    flex: 1;
}

.section-info h2 {
    margin: 0 0 var(--spacing-1) 0;
    font-size: var(--font-size-xl);
    font-weight: 600;
    color: var(--gray-900);
}

.section-info p {
    margin: 0;
    color: var(--gray-600);
    font-size: var(--font-size-sm);
}

.section-status {
    flex-shrink: 0;
}

.status-indicator {
    width: 40px;
    height: 40px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: var(--font-size-lg);
    color: white;
    transition: all var(--transition-fast);
}

.status-indicator.active {
    background: var(--secondary-500);
    box-shadow: 0 0 0 4px var(--secondary-100);
}

.status-indicator.inactive {
    background: var(--gray-400);
    box-shadow: 0 0 0 4px var(--gray-100);
}

.section-content {
    padding: var(--spacing-6);
}

.form-row {
    display: flex;
    gap: var(--spacing-4);
    margin-bottom: var(--spacing-5);
}

.form-group {
    flex: 1;
    min-width: 0;
}

.form-group.col-lg-4 { flex: 0 0 33.333%; }
.form-group.col-lg-6 { flex: 0 0 50%; }
.form-group.col-lg-8 { flex: 0 0 66.666%; }

.form-label {
    display: flex;
    align-items: center;
    gap: var(--spacing-2);
    margin-bottom: var(--spacing-3);
    font-weight: 600;
    color: var(--gray-700);
    font-size: var(--font-size-sm);
}

.form-label i {
    color: var(--primary-500);
    font-size: var(--font-size-base);
}

.input-group {
    display: flex;
    position: relative;
}

.input-group .form-control {
    border-top-right-radius: 0;
    border-bottom-right-radius: 0;
    border-right: none;
}

.input-addon {
    background: var(--gray-100);
    border: 1px solid var(--gray-300);
    border-left: none;
    border-top-right-radius: var(--radius-md);
    border-bottom-right-radius: var(--radius-md);
    padding: var(--spacing-3) var(--spacing-4);
    display: flex;
    align-items: center;
    cursor: pointer;
    transition: all var(--transition-fast);
    color: var(--gray-600);
}

.input-addon:hover {
    background: var(--gray-200);
    color: var(--gray-800);
}

.form-help {
    display: flex;
    align-items: center;
    gap: var(--spacing-2);
    margin-top: var(--spacing-2);
    font-size: var(--font-size-xs);
    color: var(--gray-500);
    line-height: 1.4;
}

.form-help i {
    color: var(--primary-400);
    flex-shrink: 0;
}

.help-link {
    color: var(--primary-600);
    text-decoration: none;
    font-weight: 500;
    transition: color var(--transition-fast);
}

.help-link:hover {
    color: var(--primary-700);
    text-decoration: underline;
}

.btn-test {
    position: relative;
    overflow: hidden;
}

.btn-test::before {
    content: '';
    position: absolute;
    top: 0;
    left: -100%;
    width: 100%;
    height: 100%;
    background: linear-gradient(90deg, transparent, rgba(255,255,255,0.3), transparent);
    transition: left var(--transition-normal);
}

.btn-test:hover::before {
    left: 100%;
}

.ai-features {
    margin-top: var(--spacing-6);
    padding-top: var(--spacing-6);
    border-top: 1px solid var(--gray-200);
}

.ai-features h4 {
    margin: 0 0 var(--spacing-4) 0;
    font-size: var(--font-size-lg);
    font-weight: 600;
    color: var(--gray-900);
}

.features-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
    gap: var(--spacing-4);
}

.feature-card {
    background: var(--gray-50);
    border-radius: var(--radius-lg);
    padding: var(--spacing-5);
    border: 1px solid var(--gray-200);
    transition: all var(--transition-fast);
}

.feature-card:hover {
    background: white;
    box-shadow: var(--shadow-md);
    transform: translateY(-2px);
}

.feature-icon {
    width: 48px;
    height: 48px;
    border-radius: var(--radius-lg);
    background: linear-gradient(135deg, var(--primary-500), var(--primary-600));
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: var(--font-size-xl);
    color: white;
    margin-bottom: var(--spacing-3);
}

.feature-card h5 {
    margin: 0 0 var(--spacing-2) 0;
    font-size: var(--font-size-base);
    font-weight: 600;
    color: var(--gray-900);
}

.feature-card p {
    margin: 0;
    font-size: var(--font-size-sm);
    color: var(--gray-600);
    line-height: 1.5;
}

.settings-footer {
    background: white;
    border-radius: var(--radius-xl);
    box-shadow: var(--shadow-lg);
    border: 1px solid var(--gray-200);
    padding: var(--spacing-6);
}

.footer-actions {
    display: flex;
    justify-content: flex-end;
    gap: var(--spacing-4);
}

.btn-save {
    position: relative;
    overflow: hidden;
    min-width: 200px;
}

.btn-save::before {
    content: '';
    position: absolute;
    top: 0;
    left: -100%;
    width: 100%;
    height: 100%;
    background: linear-gradient(90deg, transparent, rgba(255,255,255,0.3), transparent);
    transition: left var(--transition-normal);
}

.btn-save:hover::before {
    left: 100%;
}

/* Notification Styles */
.notification {
    position: fixed;
    top: 20px;
    right: 20px;
    background: white;
    border-radius: var(--radius-lg);
    box-shadow: var(--shadow-xl);
    border: 1px solid var(--gray-200);
    padding: var(--spacing-4);
    transform: translateX(100%);
    opacity: 0;
    transition: all var(--transition-normal);
    z-index: 9999;
    max-width: 300px;
}

.notification.show {
    transform: translateX(0);
    opacity: 1;
}

.notification-content {
    display: flex;
    align-items: center;
    gap: var(--spacing-3);
    padding-right: var(--spacing-8);
}

.notification-close {
    position: absolute;
    top: var(--spacing-2);
    right: var(--spacing-2);
    background: none;
    border: none;
    color: var(--gray-400);
    cursor: pointer;
    padding: var(--spacing-1);
    border-radius: var(--radius-sm);
    transition: all var(--transition-fast);
}

.notification-close:hover {
    background: var(--gray-100);
    color: var(--gray-600);
}

.notification-success { border-left: 4px solid var(--secondary-500); }
.notification-error { border-left: 4px solid var(--danger-500); }
.notification-info { border-left: 4px solid var(--primary-500); }
.notification-warning { border-left: 4px solid var(--warning-500); }

.notification i {
    font-size: var(--font-size-lg);
}

.notification-success i { color: var(--secondary-500); }
.notification-error i { color: var(--danger-500); }
.notification-info i { color: var(--primary-500); }
.notification-warning i { color: var(--warning-500); }

@keyframes spin {
    to { transform: rotate(360deg); }
}

.icon-spin {
    animation: spin 1s linear infinite;
}

@media (max-width: 768px) {
    .section-header {
        flex-direction: column;
        text-align: center;
        gap: var(--spacing-3);
    }
    
    .form-row {
        flex-direction: column;
        gap: var(--spacing-4);
    }
    
    .form-group.col-lg-4,
    .form-group.col-lg-6,
    .form-group.col-lg-8 {
        flex: 1;
    }
    
    .footer-actions {
        flex-direction: column;
    }
}
</style>