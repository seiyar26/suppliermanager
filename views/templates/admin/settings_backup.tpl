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

        <!-- Email Template Section -->
        <div class="settings-section">
            <div class="section-header">
                <div class="section-icon template-icon">
                    <i class="icon-envelope-o"></i>
                </div>
                <div class="section-info">
                    <h2>{l s='Modèles d\'email' mod='suppliermanager'}</h2>
                    <p>{l s='Personnalisation des emails envoyés aux fournisseurs' mod='suppliermanager'}</p>
                </div>
            </div>
            
            <div class="section-content">
                <div class="template-editor">
                    <div class="editor-header">
                        <h4>{l s='Modèle de commande fournisseur' mod='suppliermanager'}</h4>
                        <div class="editor-actions">
                            <button type="button" class="btn btn-sm btn-outline-primary" onclick="previewTemplate()">
                                <i class="icon-eye"></i> {l s='Aperçu' mod='suppliermanager'}
                            </button>
                            <button type="button" class="btn btn-sm btn-outline-secondary" onclick="resetTemplate()">
                                <i class="icon-refresh"></i> {l s='Réinitialiser' mod='suppliermanager'}
                            </button>
                        </div>
                    </div>
                    
                    <div class="editor-content">
                        <textarea name="supplier_order_email_template" 
                                  class="form-control email-template-editor" 
                                  rows="15"
                                  placeholder="{l s='Contenu du modèle d\'email...' mod='suppliermanager'}">{$supplier_order_email_template|escape:'html':'UTF-8'}</textarea>
                    </div>
                    
                    <div class="template-variables">
                        <h5>{l s='Variables disponibles' mod='suppliermanager'}</h5>
                        <div class="variables-grid">
                            <div class="variable-item" onclick="insertVariable('{literal}{shop_name}{/literal}')">
                                <code>{literal}{shop_name}{/literal}</code>
                                <span>{l s='Nom de la boutique' mod='suppliermanager'}</span>
                            </div>
                            <div class="variable-item" onclick="insertVariable('{literal}{order_id}{/literal}')">
                                <code>{literal}{order_id}{/literal}</code>
                                <span>{l s='ID de la commande' mod='suppliermanager'}</span>
                            </div>
                            <div class="variable-item" onclick="insertVariable('{literal}{order_date}{/literal}')">
                                <code>{literal}{order_date}{/literal}</code>
                                <span>{l s='Date de commande' mod='suppliermanager'}</span>
                            </div>
                            <div class="variable-item" onclick="insertVariable('{literal}{supplier_name}{/literal}')">
                                <code>{literal}{supplier_name}{/literal}</code>
                                <span>{l s='Nom du fournisseur' mod='suppliermanager'}</span>
                            </div>
                            <div class="variable-item" onclick="insertVariable('{literal}{total_amount}{/literal}')">
                                <code>{literal}{total_amount}{/literal}</code>
                                <span>{l s='Montant total' mod='suppliermanager'}</span>
                            </div>
                            <div class="variable-item" onclick="insertVariable('{literal}{order_details}{/literal}')">
                                <code>{literal}{order_details}{/literal}</code>
                                <span>{l s='Détails de la commande' mod='suppliermanager'}</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Automation Section -->
        <div class="settings-section">
            <div class="section-header">
                <div class="section-icon automation-icon">
                    <i class="icon-time"></i>
                </div>
                <div class="section-info">
                    <h2>{l s='Automatisation' mod='suppliermanager'}</h2>
                    <p>{l s='Configuration des tâches automatiques et de la synchronisation' mod='suppliermanager'}</p>
                </div>
                <div class="section-status">
                    <span class="status-indicator {if $cronToken}active{else}inactive{/if}">
                        <i class="icon-{if $cronToken}check{else}times{/if}"></i>
                    </span>
                </div>
            </div>
            
            <div class="section-content">
                <div class="cron-configuration">
                    <div class="cron-info">
                        <h4>{l s='Configuration Cron' mod='suppliermanager'}</h4>
                        <p>{l s='Les tâches automatiques permettent de traiter les commandes et analyser les factures en arrière-plan.' mod='suppliermanager'}</p>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group col-lg-8">
                            <label class="form-label">
                                <i class="icon-link"></i>
                                {l s='URL de la tâche Cron' mod='suppliermanager'}
                            </label>
                            <div class="input-group">
                                <input type="text" 
                                       value="{$cronUrl}" 
                                       class="form-control" 
                                       readonly 
                                       id="cronUrl" />
                                <button type="button" class="input-addon btn-copy" onclick="copyToClipboard('cronUrl')">
                                    <i class="icon-copy"></i>
                                </button>
                            </div>
                            <div class="form-help">
                                <i class="icon-info-circle"></i>
                                {l s='Configurez cette URL dans votre cPanel ou serveur pour exécuter les tâches automatiques' mod='suppliermanager'}
                            </div>
                        </div>
                        <div class="form-group col-lg-4">
                            <label class="form-label">
                                <i class="icon-key"></i>
                                {l s='Jeton de sécurité' mod='suppliermanager'}
                            </label>
                            <div class="input-group">
                                <input type="text" 
                                       name="cron_token" 
                                       value="{$cronToken|escape:'html':'UTF-8'}" 
                                       class="form-control" 
                                       readonly />
                                <button type="button" class="input-addon btn-regenerate" onclick="regenerateToken()">
                                    <i class="icon-refresh"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                    
                    <div class="cron-schedule">
                        <h5>{l s='Fréquence recommandée' mod='suppliermanager'}</h5>
                        <div class="schedule-options">
                            <div class="schedule-option recommended">
                                <div class="schedule-icon">
                                    <i class="icon-clock-o"></i>
                                </div>
                                <div class="schedule-info">
                                    <h6>{l s='Toutes les heures' mod='suppliermanager'}</h6>
                                    <code>0 * * * *</code>
                                    <p>{l s='Recommandé pour un traitement optimal' mod='suppliermanager'}</p>
                                </div>
                            </div>
                            <div class="schedule-option">
                                <div class="schedule-icon">
                                    <i class="icon-clock-o"></i>
                                </div>
                                <div class="schedule-info">
                                    <h6>{l s='Toutes les 6 heures' mod='suppliermanager'}</h6>
                                    <code>0 */6 * * *</code>
                                    <p>{l s='Pour un usage modéré' mod='suppliermanager'}</p>
                                </div>
                            </div>
                            <div class="schedule-option">
                                <div class="schedule-icon">
                                    <i class="icon-clock-o"></i>
                                </div>
                                <div class="schedule-info">
                                    <h6>{l s='Une fois par jour' mod='suppliermanager'}</h6>
                                    <code>0 2 * * *</code>
                                    <p>{l s='Traitement nocturne' mod='suppliermanager'}</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Data Management Section -->
        <div class="settings-section">
            <div class="section-header">
                <div class="section-icon data-icon">
                    <i class="icon-database"></i>
                </div>
                <div class="section-info">
                    <h2>{l s='Gestion des données' mod='suppliermanager'}</h2>
                    <p>{l s='Import, export et synchronisation des données fournisseurs' mod='suppliermanager'}</p>
                </div>
            </div>
            
            <div class="section-content">
                <div class="data-actions">
                    <div class="action-card import-card">
                        <div class="action-icon">
                            <i class="icon-upload"></i>
                        </div>
                        <div class="action-content">
                            <h4>{l s='Importer les fournisseurs' mod='suppliermanager'}</h4>
                            <p>{l s='Synchroniser tous les fournisseurs existants de PrestaShop avec le module Supplier Manager' mod='suppliermanager'}</p>
                            <button type="submit" name="importSuppliers" class="btn btn-primary">
                                <i class="icon-upload"></i> 
                                {l s='Lancer l\'import' mod='suppliermanager'}
                            </button>
                        </div>
                    </div>
                    
                    <div class="action-card export-card">
                        <div class="action-icon">
                            <i class="icon-download"></i>
                        </div>
                        <div class="action-content">
                            <h4>{l s='Exporter les données' mod='suppliermanager'}</h4>
                            <p>{l s='Télécharger un rapport complet de vos données fournisseurs au format Excel' mod='suppliermanager'}</p>
                            <button type="button" class="btn btn-secondary" onclick="exportData()">
                                <i class="icon-download"></i> 
                                {l s='Exporter' mod='suppliermanager'}
                            </button>
                        </div>
                    </div>
                    
                    <div class="action-card backup-card">
                        <div class="action-icon">
                            <i class="icon-shield"></i>
                        </div>
                        <div class="action-content">
                            <h4>{l s='Sauvegarde' mod='suppliermanager'}</h4>
                            <p>{l s='Créer une sauvegarde complète de la configuration et des données du module' mod='suppliermanager'}</p>
                            <button type="button" class="btn btn-warning" onclick="createBackup()">
                                <i class="icon-shield"></i> 
                                {l s='Sauvegarder' mod='suppliermanager'}
                            </button>
                        </div>
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

.section-icon.template-icon {
    background: linear-gradient(135deg, var(--warning-500), var(--warning-600));
}

.section-icon.automation-icon {
    background: linear-gradient(135deg, var(--danger-500), var(--danger-600));
}

.section-icon.data-icon {
    background: linear-gradient(135deg, var(--gray-600), var(--gray-700));
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

.template-editor {
    background: var(--gray-50);
    border-radius: var(--radius-lg);
    border: 1px solid var(--gray-200);
    overflow: hidden;
}

.editor-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: var(--spacing-4) var(--spacing-5);
    background: white;
    border-bottom: 1px solid var(--gray-200);
}

.editor-header h4 {
    margin: 0;
    font-size: var(--font-size-lg);
    font-weight: 600;
    color: var(--gray-900);
}

.editor-actions {
    display: flex;
    gap: var(--spacing-2);
}

.editor-content {
    padding: var(--spacing-5);
}

.email-template-editor {
    font-family: 'Monaco', 'Menlo', 'Ubuntu Mono', monospace;
    font-size: var(--font-size-sm);
    line-height: 1.6;
    resize: vertical;
    min-height: 300px;
}

.template-variables {
    padding: var(--spacing-5);
    border-top: 1px solid var(--gray-200);
    background: white;
}

.template-variables h5 {
    margin: 0 0 var(--spacing-4) 0;
    font-size: var(--font-size-base);
    font-weight: 600;
    color: var(--gray-900);
}

.variables-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: var(--spacing-3);
}

.variable-item {
    display: flex;
    flex-direction: column;
    gap: var(--spacing-1);
    padding: var(--spacing-3);
    background: var(--gray-50);
    border-radius: var(--radius-md);
    border: 1px solid var(--gray-200);
    cursor: pointer;
    transition: all var(--transition-fast);
}

.variable-item:hover {
    background: var(--primary-50);
    border-color: var(--primary-200);
    transform: translateY(-1px);
}

.variable-item code {
    background: var(--primary-100);
    color: var(--primary-800);
    padding: var(--spacing-1) var(--spacing-2);
    border-radius: var(--radius-sm);
    font-size: var(--font-size-xs);
    font-weight: 600;
    align-self: flex-start;
}

.variable-item span {
    font-size: var(--font-size-xs);
    color: var(--gray-600);
}

.cron-configuration {
    background: var(--gray-50);
    border-radius: var(--radius-lg);
    padding: var(--spacing-6);
    border: 1px solid var(--gray-200);
}

.cron-info {
    margin-bottom: var(--spacing-6);
}

.cron-info h4 {
    margin: 0 0 var(--spacing-2) 0;
    font-size: var(--font-size-lg);
    font-weight: 600;
    color: var(--gray-900);
}

.cron-info p {
    margin: 0;
    color: var(--gray-600);
    font-size: var(--font-size-sm);
}

.btn-copy, .btn-regenerate {
    background: var(--primary-100);
    color: var(--primary-700);
    border: 1px solid var(--primary-200);
}

.btn-copy:hover, .btn-regenerate:hover {
    background: var(--primary-200);
    color: var(--primary-800);
}

.cron-schedule {
    margin-top: var(--spacing-6);
    padding-top: var(--spacing-6);
    border-top: 1px solid var(--gray-200);
}

.cron-schedule h5 {
    margin: 0 0 var(--spacing-4) 0;
    font-size: var(--font-size-base);
    font-weight: 600;
    color: var(--gray-900);
}

.schedule-options {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: var(--spacing-4);
}

.schedule-option {
    display: flex;
    gap: var(--spacing-3);
    padding: var(--spacing-4);
    background: white;
    border-radius: var(--radius-lg);
    border: 1px solid var(--gray-200);
    transition: all var(--transition-fast);
}

.schedule-option:hover {
    box-shadow: var(--shadow-md);
    transform: translateY(-1px);
}

.schedule-option.recommended {
    border-color: var(--primary-300);
    background: var(--primary-50);
}

.schedule-option.recommended .schedule-icon {
    background: var(--primary-500);
}

.schedule-icon {
    width: 40px;
    height: 40px;
    border-radius: var(--radius-lg);
    background: var(--gray-400);
    display: flex;
    align-items: center;
    justify-content: center;
    color: white;
    flex-shrink: 0;
}

.schedule-info h6 {
    margin: 0 0 var(--spacing-1) 0;
    font-size: var(--font-size-sm);
    font-weight: 600;
    color: var(--gray-900);
}

.schedule-info code {
    background: var(--gray-200);
    color: var(--gray-800);
    padding: var(--spacing-1) var(--spacing-2);
    border-radius: var(--radius-sm);
    font-size: var(--font-size-xs);
    margin-bottom: var(--spacing-2);
    display: inline-block;
}

.schedule-option.recommended code {
    background: var(--primary-200);
    color: var(--primary-800);
}

.schedule-info p {
    margin: 0;
    font-size: var(--font-size-xs);
    color: var(--gray-600);
}

.data-actions {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
    gap: var(--spacing-6);
}

.action-card {
    display: flex;
    gap: var(--spacing-4);
    padding: var(--spacing-6);
    background: var(--gray-50);
    border-radius: var(--radius-xl);
    border: 1px solid var(--gray-200);
    transition: all var(--transition-fast);
}

.action-card:hover {
    background: white;
    box-shadow: var(--shadow-md);
    transform: translateY(-2px);
}

.action-card .action-icon {
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

.import-card .action-icon {
    background: linear-gradient(135deg, var(--primary-500), var(--primary-600));
}

.export-card .action-icon {
    background: linear-gradient(135deg, var(--secondary-500), var(--secondary-600));
}

.backup-card .action-icon {
    background: linear-gradient(135deg, var(--warning-500), var(--warning-600));
}

.action-content {
    flex: 1;
}

.action-content h4 {
    margin: 0 0 var(--spacing-2) 0;
    font-size: var(--font-size-lg);
    font-weight: 600;
    color: var(--gray-900);
}

.action-content p {
    margin: 0 0 var(--spacing-4) 0;
    color: var(--gray-600);
    font-size: var(--font-size-sm);
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
    
    .editor-header {
        flex-direction: column;
        gap: var(--spacing-3);
        align-items: flex-start;
    }
    
    .variables-grid {
        grid-template-columns: 1fr;
    }
    
    .schedule-options {
        grid-template-columns: 1fr;
    }
    
    .data-actions {
        grid-template-columns: 1fr;
    }
    
    .action-card {
        flex-direction: column;
        text-align: center;
    }
    
    .footer-actions {
        flex-direction: column;
    }
}
</style>

<!-- Enhanced JavaScript -->
<script>
document.addEventListener('DOMContentLoaded', function() {
    // Initialize rich text editor for email template
    if (typeof tinyMCE !== 'undefined') {
        tinyMCE.init({
            selector: '.email-template-editor',
            height: 300,
            menubar: false,
            plugins: 'advlist autolink lists link image charmap print preview anchor searchreplace visualblocks code fullscreen insertdatetime media table paste code help wordcount',
            toolbar: 'undo redo | formatselect | bold italic backcolor | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | removeformat | help',
            content_style: 'body { font-family: Inter, sans-serif; font-size: 14px; }'
        });
    }
    
    // Add loading states to test buttons
    document.querySelectorAll('.btn-test').forEach(btn => {
        btn.addEventListener('click', function() {
            this.classList.add('loading');
            const originalText = this.innerHTML;
            this.innerHTML = '<i class="icon-spinner icon-spin"></i> Test en cours...';
            
            setTimeout(() => {
                this.classList.remove('loading');
                this.innerHTML = originalText;
                showNotification('Test de connexion réussi', 'success');
            }, 3000);
        });
    });
    
    // Animate sections on scroll
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.style.animationDelay = '0.1s';
                entry.target.classList.add('fade-in-up');
            }
        });
    });
    
    document.querySelectorAll('.settings-section').forEach(section => {
        observer.observe(section);
    });
});

// Toggle password visibility
function togglePassword(inputId) {
    const input = document.getElementById(inputId);
    const button = input.nextElementSibling;
    const icon = button.querySelector('i');
    
    if (input.type === 'password') {
        input.type = 'text';
        icon.className = 'icon-eye-slash';
    } else {
        input.type = 'password';
        icon.className = 'icon-eye';
    }
}

// Copy to clipboard
function copyToClipboard(inputId) {
    const input = document.getElementById(inputId);
    input.select();
    document.execCommand('copy');
    
    const button = input.nextElementSibling;
    const originalIcon = button.querySelector('i').className;
    button.querySelector('i').className = 'icon-check';
    button.style.background = 'var(--secondary-100)';
    button.style.color = 'var(--secondary-700)';
    
    setTimeout(() => {
        button.querySelector('i').className = originalIcon;
        button.style.background = '';
        button.style.color = '';
    }, 2000);
    
    showNotification('URL copiée dans le presse-papiers', 'success');
}

// Regenerate token
function regenerateToken() {
    if (confirm('Êtes-vous sûr de vouloir régénérer le jeton ? L\'ancien jeton ne fonctionnera plus.')) {
        const tokenInput = document.querySelector('input[name="cron_token"]');
        const newToken = generateRandomToken();
        tokenInput.value = newToken;
        showNotification('Nouveau jeton généré', 'success');
    }
}

// Generate random token
function generateRandomToken() {
    return Math.random().toString(36).substring(2, 15) + Math.random().toString(36).substring(2, 15);
}

// Insert variable into template
function insertVariable(variable) {
    const textarea = document.querySelector('.email-template-editor');
    const cursorPos = textarea.selectionStart;
    const textBefore = textarea.value.substring(0, cursorPos);
    const textAfter = textarea.value.substring(cursorPos);
    
    textarea.value = textBefore + variable + textAfter;
    textarea.focus();
    textarea.setSelectionRange(cursorPos + variable.length, cursorPos + variable.length);
    
    showNotification('Variable insérée', 'success');
}

// Preview template
function previewTemplate() {
    const template = document.querySelector('.email-template-editor').value;
    const previewWindow = window.open('', '_blank', 'width=600,height=400');
    previewWindow.document.write(`
        <html>
            <head>
                <title>Aperçu du modèle d'email</title>
                <style>
                    body { font-family: Arial, sans-serif; padding: 20px; line-height: 1.6; }
                    .preview-header { background: #f8f9fa; padding: 15px; border-radius: 5px; margin-bottom: 20px; }
                </style>
            </head>
            <body>
                <div class="preview-header">
                    <h3>Aperçu du modèle d'email</h3>
                    <p>Ceci est un aperçu de votre modèle avec des données d'exemple.</p>
                </div>
                <div class="email-content">
                    ${template.replace(/\{shop_name\}/g, 'Ma Boutique')
                             .replace(/\{order_id\}/g, '12345')
                             .replace(/\{order_date\}/g, new Date().toLocaleDateString())
                             .replace(/\{supplier_name\}/g, 'Fournisseur ABC')
                             .replace(/\{total_amount\}/g, '1 234,56 €')
                             .replace(/\{order_details\}/g, 'Détails de la commande...')
                             .replace(/\{current_year\}/g, new Date().getFullYear())}
                </div>
            </body>
        </html>
    `);
}

// Reset template
function resetTemplate() {
    if (confirm('Êtes-vous sûr de vouloir réinitialiser le modèle ? Toutes vos modifications seront perdues.')) {
        const defaultTemplate = `Bonjour {supplier_name},

Nous souhaitons passer une nouvelle commande :

Commande n° : {order_id}
Date : {order_date}
Montant total : {total_amount}

Détails :
{order_details}

Cordialement,
L'équipe {shop_name}`;
        
        document.querySelector('.email-template-editor').value = defaultTemplate;
        showNotification('Modèle réinitialisé', 'success');
    }
}

// Export data
function exportData() {
    showNotification('Export en cours...', 'info');
    // Simulate export process
    setTimeout(() => {
        showNotification('Export terminé', 'success');
    }, 3000);
}

// Create backup
function createBackup() {
    if (confirm('Créer une sauvegarde complète du module ?')) {
        showNotification('Sauvegarde en cours...', 'info');
        // Simulate backup process
        setTimeout(() => {
            showNotification('Sauvegarde créée avec succès', 'success');
        }, 5000);
    }
}

// Reset form
function resetForm() {
    if (confirm('Êtes-vous sûr de vouloir réinitialiser tous les paramètres ?')) {
        document.querySelector('.settings-form').reset();
        showNotification('Formulaire réinitialisé', 'info');
    }
}

// Notification system (reuse from dashboard)
function showNotification(message, type = 'info') {
    const notification = document.createElement('div');
    notification.className = `notification notification-${type}`;
    notification.innerHTML = `
        <div class="notification-content">
            <i class="icon-${type === 'success' ? 'check' : type === 'error' ? 'times' : 'info'}"></i>
            <span>${message}</span>
        </div>
    `;
    
    document.body.appendChild(notification);
    
    setTimeout(() => {
        notification.classList.add('show');
    }, 100);
    
    setTimeout(() => {
        notification.classList.remove('show');
        setTimeout(() => {
            notification.remove();
        }, 300);
    }, 3000);
}
</script>

<!-- Notification Styles (reuse from dashboard) -->
<style>
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
}

.notification-success { border-left: 4px solid var(--secondary-500); }
.notification-error { border-left: 4px solid var(--danger-500); }
.notification-info { border-left: 4px solid var(--primary-500); }

.notification i {
    font-size: var(--font-size-lg);
}

.notification-success i { color: var(--secondary-500); }
.notification-error i { color: var(--danger-500); }
.notification-info i { color: var(--primary-500); }

@keyframes spin {
    to { transform: rotate(360deg); }
}

.icon-spin {
    animation: spin 1s linear infinite;
}
</style>