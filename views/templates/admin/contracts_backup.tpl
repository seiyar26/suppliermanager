<div class="bootstrap fade-in-up">
    <!-- Modern Header -->
    <div class="page-title">
        <h3>
            <i class="icon-file-text-o"></i> 
            {l s='Contrats Fournisseurs' mod='suppliermanager'}
        </h3>
        <p class="page-subtitle">{l s='Gestion et suivi de vos contrats avec les fournisseurs' mod='suppliermanager'}</p>
    </div>

    <!-- Action Bar -->
    <div class="action-bar">
        <div class="action-left">
            <div class="search-container">
                <div class="search-input-group">
                    <i class="icon-search"></i>
                    <input type="text" 
                           class="form-control search-input" 
                           placeholder="{l s='Rechercher un contrat ou fournisseur...' mod='suppliermanager'}"
                           id="contractSearch">
                </div>
                <div class="search-filters">
                    <select class="form-control filter-select" id="statusFilter">
                        <option value="">{l s='Tous les statuts' mod='suppliermanager'}</option>
                        <option value="active">{l s='Actifs' mod='suppliermanager'}</option>
                        <option value="expired">{l s='Expirés' mod='suppliermanager'}</option>
                        <option value="pending">{l s='En attente' mod='suppliermanager'}</option>
                        <option value="draft">{l s='Brouillons' mod='suppliermanager'}</option>
                    </select>
                    <select class="form-control filter-select" id="typeFilter">
                        <option value="">{l s='Tous les types' mod='suppliermanager'}</option>
                        <option value="supply">{l s='Approvisionnement' mod='suppliermanager'}</option>
                        <option value="service">{l s='Service' mod='suppliermanager'}</option>
                        <option value="maintenance">{l s='Maintenance' mod='suppliermanager'}</option>
                    </select>
                </div>
            </div>
        </div>
        <div class="action-right">
            <button class="btn btn-outline-secondary" onclick="exportContracts()">
                <i class="icon-download"></i>
                {l s='Exporter' mod='suppliermanager'}
            </button>
            <button class="btn btn-primary" onclick="createContract()">
                <i class="icon-plus"></i>
                {l s='Nouveau contrat' mod='suppliermanager'}
            </button>
        </div>
    </div>

    <!-- Stats Cards -->
    <div class="row stats-section">
        <div class="col-lg-3">
            <div class="stat-card active-contracts">
                <div class="stat-icon">
                    <i class="icon-check-circle"></i>
                </div>
                <div class="stat-content">
                    <h3>24</h3>
                    <p>{l s='Contrats actifs' mod='suppliermanager'}</p>
                    <div class="stat-trend positive">
                        <i class="icon-arrow-up"></i>
                        <span>+3 ce mois</span>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-lg-3">
            <div class="stat-card expiring-contracts">
                <div class="stat-icon">
                    <i class="icon-clock-o"></i>
                </div>
                <div class="stat-content">
                    <h3>5</h3>
                    <p>{l s='Expirent bientôt' mod='suppliermanager'}</p>
                    <div class="stat-trend warning">
                        <i class="icon-exclamation-triangle"></i>
                        <span>Dans 30 jours</span>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-lg-3">
            <div class="stat-card total-value">
                <div class="stat-icon">
                    <i class="icon-euro"></i>
                </div>
                <div class="stat-content">
                    <h3>€2.4M</h3>
                    <p>{l s='Valeur totale' mod='suppliermanager'}</p>
                    <div class="stat-trend positive">
                        <i class="icon-arrow-up"></i>
                        <span>+12% vs année dernière</span>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-lg-3">
            <div class="stat-card renewal-rate">
                <div class="stat-icon">
                    <i class="icon-refresh"></i>
                </div>
                <div class="stat-content">
                    <h3>89%</h3>
                    <p>{l s='Taux de renouvellement' mod='suppliermanager'}</p>
                    <div class="stat-trend positive">
                        <i class="icon-arrow-up"></i>
                        <span>+5% vs année dernière</span>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Main Content -->
    <div class="row main-content">
        <!-- Contracts List -->
        <div class="col-lg-8">
            <div class="panel contracts-panel">
                <div class="panel-heading">
                    <i class="icon-list"></i> 
                    {l s='Liste des contrats' mod='suppliermanager'}
                    <div class="panel-actions">
                        <button class="btn-icon" onclick="refreshContracts()" title="{l s='Actualiser' mod='suppliermanager'}">
                            <i class="icon-refresh"></i>
                        </button>
                        <button class="btn-icon" onclick="toggleView()" title="{l s='Changer la vue' mod='suppliermanager'}">
                            <i class="icon-th-list"></i>
                        </button>
                    </div>
                </div>
                <div class="panel-body">
                    <div class="contracts-list" id="contractsList">
                        <!-- Contract Item 1 -->
                        <div class="contract-item active" data-status="active" data-type="supply">
                            <div class="contract-header">
                                <div class="contract-info">
                                    <h4>Contrat d'approvisionnement - Fournisseur ABC</h4>
                                    <div class="contract-meta">
                                        <span class="contract-id">#CTR-2024-001</span>
                                        <span class="contract-type">
                                            <i class="icon-truck"></i>
                                            {l s='Approvisionnement' mod='suppliermanager'}
                                        </span>
                                    </div>
                                </div>
                                <div class="contract-status">
                                    <span class="status-badge active">
                                        <i class="icon-check"></i>
                                        {l s='Actif' mod='suppliermanager'}
                                    </span>
                                </div>
                            </div>
                            <div class="contract-details">
                                <div class="detail-row">
                                    <div class="detail-item">
                                        <i class="icon-calendar"></i>
                                        <span class="detail-label">{l s='Début' mod='suppliermanager'}</span>
                                        <span class="detail-value">01/01/2024</span>
                                    </div>
                                    <div class="detail-item">
                                        <i class="icon-calendar-o"></i>
                                        <span class="detail-label">{l s='Fin' mod='suppliermanager'}</span>
                                        <span class="detail-value">31/12/2024</span>
                                    </div>
                                    <div class="detail-item">
                                        <i class="icon-euro"></i>
                                        <span class="detail-label">{l s='Valeur' mod='suppliermanager'}</span>
                                        <span class="detail-value">€450,000</span>
                                    </div>
                                    <div class="detail-item">
                                        <i class="icon-clock-o"></i>
                                        <span class="detail-label">{l s='Renouvellement' mod='suppliermanager'}</span>
                                        <span class="detail-value">Dans 45 jours</span>
                                    </div>
                                </div>
                                <div class="contract-progress">
                                    <div class="progress-info">
                                        <span>{l s='Progression annuelle' mod='suppliermanager'}</span>
                                        <span>68%</span>
                                    </div>
                                    <div class="progress-bar-container">
                                        <div class="progress-bar" style="width: 68%"></div>
                                    </div>
                                </div>
                            </div>
                            <div class="contract-actions">
                                <button class="btn btn-sm btn-outline-primary" onclick="viewContract(1)">
                                    <i class="icon-eye"></i>
                                    {l s='Voir' mod='suppliermanager'}
                                </button>
                                <button class="btn btn-sm btn-outline-secondary" onclick="editContract(1)">
                                    <i class="icon-edit"></i>
                                    {l s='Modifier' mod='suppliermanager'}
                                </button>
                                <button class="btn btn-sm btn-outline-warning" onclick="renewContract(1)">
                                    <i class="icon-refresh"></i>
                                    {l s='Renouveler' mod='suppliermanager'}
                                </button>
                            </div>
                        </div>

                        <!-- Contract Item 2 -->
                        <div class="contract-item expiring" data-status="active" data-type="service">
                            <div class="contract-header">
                                <div class="contract-info">
                                    <h4>Contrat de maintenance - TechService Pro</h4>
                                    <div class="contract-meta">
                                        <span class="contract-id">#CTR-2024-002</span>
                                        <span class="contract-type">
                                            <i class="icon-cogs"></i>
                                            {l s='Service' mod='suppliermanager'}
                                        </span>
                                    </div>
                                </div>
                                <div class="contract-status">
                                    <span class="status-badge expiring">
                                        <i class="icon-clock-o"></i>
                                        {l s='Expire bientôt' mod='suppliermanager'}
                                    </span>
                                </div>
                            </div>
                            <div class="contract-details">
                                <div class="detail-row">
                                    <div class="detail-item">
                                        <i class="icon-calendar"></i>
                                        <span class="detail-label">{l s='Début' mod='suppliermanager'}</span>
                                        <span class="detail-value">15/03/2024</span>
                                    </div>
                                    <div class="detail-item">
                                        <i class="icon-calendar-o"></i>
                                        <span class="detail-label">{l s='Fin' mod='suppliermanager'}</span>
                                        <span class="detail-value">14/03/2025</span>
                                    </div>
                                    <div class="detail-item">
                                        <i class="icon-euro"></i>
                                        <span class="detail-label">{l s='Valeur' mod='suppliermanager'}</span>
                                        <span class="detail-value">€24,000</span>
                                    </div>
                                    <div class="detail-item">
                                        <i class="icon-clock-o"></i>
                                        <span class="detail-label">{l s='Renouvellement' mod='suppliermanager'}</span>
                                        <span class="detail-value">Dans 15 jours</span>
                                    </div>
                                </div>
                                <div class="contract-progress">
                                    <div class="progress-info">
                                        <span>{l s='Progression annuelle' mod='suppliermanager'}</span>
                                        <span>92%</span>
                                    </div>
                                    <div class="progress-bar-container">
                                        <div class="progress-bar warning" style="width: 92%"></div>
                                    </div>
                                </div>
                            </div>
                            <div class="contract-actions">
                                <button class="btn btn-sm btn-outline-primary" onclick="viewContract(2)">
                                    <i class="icon-eye"></i>
                                    {l s='Voir' mod='suppliermanager'}
                                </button>
                                <button class="btn btn-sm btn-outline-secondary" onclick="editContract(2)">
                                    <i class="icon-edit"></i>
                                    {l s='Modifier' mod='suppliermanager'}
                                </button>
                                <button class="btn btn-sm btn-warning" onclick="renewContract(2)">
                                    <i class="icon-refresh"></i>
                                    {l s='Renouveler maintenant' mod='suppliermanager'}
                                </button>
                            </div>
                        </div>

                        <!-- Contract Item 3 -->
                        <div class="contract-item draft" data-status="draft" data-type="supply">
                            <div class="contract-header">
                                <div class="contract-info">
                                    <h4>Nouveau contrat - Fournisseur XYZ</h4>
                                    <div class="contract-meta">
                                        <span class="contract-id">#CTR-2024-003</span>
                                        <span class="contract-type">
                                            <i class="icon-truck"></i>
                                            {l s='Approvisionnement' mod='suppliermanager'}
                                        </span>
                                    </div>
                                </div>
                                <div class="contract-status">
                                    <span class="status-badge draft">
                                        <i class="icon-edit"></i>
                                        {l s='Brouillon' mod='suppliermanager'}
                                    </span>
                                </div>
                            </div>
                            <div class="contract-details">
                                <div class="detail-row">
                                    <div class="detail-item">
                                        <i class="icon-calendar"></i>
                                        <span class="detail-label">{l s='Début prévu' mod='suppliermanager'}</span>
                                        <span class="detail-value">01/04/2024</span>
                                    </div>
                                    <div class="detail-item">
                                        <i class="icon-calendar-o"></i>
                                        <span class="detail-label">{l s='Durée' mod='suppliermanager'}</span>
                                        <span class="detail-value">12 mois</span>
                                    </div>
                                    <div class="detail-item">
                                        <i class="icon-euro"></i>
                                        <span class="detail-label">{l s='Valeur estimée' mod='suppliermanager'}</span>
                                        <span class="detail-value">€180,000</span>
                                    </div>
                                    <div class="detail-item">
                                        <i class="icon-user"></i>
                                        <span class="detail-label">{l s='Responsable' mod='suppliermanager'}</span>
                                        <span class="detail-value">J. Dupont</span>
                                    </div>
                                </div>
                                <div class="contract-progress">
                                    <div class="progress-info">
                                        <span>{l s='Progression de création' mod='suppliermanager'}</span>
                                        <span>35%</span>
                                    </div>
                                    <div class="progress-bar-container">
                                        <div class="progress-bar draft" style="width: 35%"></div>
                                    </div>
                                </div>
                            </div>
                            <div class="contract-actions">
                                <button class="btn btn-sm btn-primary" onclick="editContract(3)">
                                    <i class="icon-edit"></i>
                                    {l s='Continuer' mod='suppliermanager'}
                                </button>
                                <button class="btn btn-sm btn-outline-secondary" onclick="duplicateContract(3)">
                                    <i class="icon-copy"></i>
                                    {l s='Dupliquer' mod='suppliermanager'}
                                </button>
                                <button class="btn btn-sm btn-outline-danger" onclick="deleteContract(3)">
                                    <i class="icon-trash"></i>
                                    {l s='Supprimer' mod='suppliermanager'}
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- Pagination -->
                    <div class="pagination-container">
                        <div class="pagination-info">
                            {l s='Affichage de 1 à 3 sur 15 contrats' mod='suppliermanager'}
                        </div>
                        <div class="pagination-controls">
                            <button class="btn btn-sm btn-outline-secondary" disabled>
                                <i class="icon-chevron-left"></i>
                            </button>
                            <button class="btn btn-sm btn-primary">1</button>
                            <button class="btn btn-sm btn-outline-secondary">2</button>
                            <button class="btn btn-sm btn-outline-secondary">3</button>
                            <button class="btn btn-sm btn-outline-secondary">
                                <i class="icon-chevron-right"></i>
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Sidebar -->
        <div class="col-lg-4">
            <!-- Quick Actions -->
            <div class="panel quick-actions-panel">
                <div class="panel-heading">
                    <i class="icon-bolt"></i> 
                    {l s='Actions rapides' mod='suppliermanager'}
                </div>
                <div class="panel-body">
                    <div class="quick-actions-list">
                        <a href="#" class="quick-action-item" onclick="createContract()">
                            <div class="action-icon primary">
                                <i class="icon-plus"></i>
                            </div>
                            <div class="action-content">
                                <h5>{l s='Nouveau contrat' mod='suppliermanager'}</h5>
                                <p>{l s='Créer un nouveau contrat fournisseur' mod='suppliermanager'}</p>
                            </div>
                        </a>
                        
                        <a href="#" class="quick-action-item" onclick="importContracts()">
                            <div class="action-icon secondary">
                                <i class="icon-upload"></i>
                            </div>
                            <div class="action-content">
                                <h5>{l s='Importer des contrats' mod='suppliermanager'}</h5>
                                <p>{l s='Importer depuis un fichier Excel/CSV' mod='suppliermanager'}</p>
                            </div>
                        </a>
                        
                        <a href="#" class="quick-action-item" onclick="generateReport()">
                            <div class="action-icon warning">
                                <i class="icon-file-text"></i>
                            </div>
                            <div class="action-content">
                                <h5>{l s='Rapport de contrats' mod='suppliermanager'}</h5>
                                <p>{l s='Générer un rapport détaillé' mod='suppliermanager'}</p>
                            </div>
                        </a>
                    </div>
                </div>
            </div>

            <!-- Upcoming Renewals -->
            <div class="panel renewals-panel">
                <div class="panel-heading">
                    <i class="icon-clock-o"></i> 
                    {l s='Renouvellements à venir' mod='suppliermanager'}
                    <span class="badge badge-warning">5</span>
                </div>
                <div class="panel-body">
                    <div class="renewals-list">
                        <div class="renewal-item urgent">
                            <div class="renewal-info">
                                <h6>TechService Pro</h6>
                                <p>Contrat de maintenance</p>
                            </div>
                            <div class="renewal-date">
                                <span class="days-left">15j</span>
                                <small>14/03/2025</small>
                            </div>
                        </div>
                        
                        <div class="renewal-item warning">
                            <div class="renewal-info">
                                <h6>Fournisseur ABC</h6>
                                <p>Contrat d'approvisionnement</p>
                            </div>
                            <div class="renewal-date">
                                <span class="days-left">45j</span>
                                <small>31/12/2024</small>
                            </div>
                        </div>
                        
                        <div class="renewal-item normal">
                            <div class="renewal-info">
                                <h6>LogiTransport</h6>
                                <p>Contrat de transport</p>
                            </div>
                            <div class="renewal-date">
                                <span class="days-left">78j</span>
                                <small>15/05/2025</small>
                            </div>
                        </div>
                    </div>
                    
                    <div class="renewals-footer">
                        <a href="#" class="btn btn-sm btn-outline-primary btn-block">
                            {l s='Voir tous les renouvellements' mod='suppliermanager'}
                        </a>
                    </div>
                </div>
            </div>

            <!-- Contract Templates -->
            <div class="panel templates-panel">
                <div class="panel-heading">
                    <i class="icon-file-o"></i> 
                    {l s='Modèles de contrats' mod='suppliermanager'}
                </div>
                <div class="panel-body">
                    <div class="templates-list">
                        <div class="template-item">
                            <div class="template-icon">
                                <i class="icon-truck"></i>
                            </div>
                            <div class="template-info">
                                <h6>{l s='Approvisionnement standard' mod='suppliermanager'}</h6>
                                <p>{l s='Modèle pour contrats d\'approvisionnement' mod='suppliermanager'}</p>
                            </div>
                            <button class="btn btn-xs btn-outline-primary" onclick="useTemplate('supply')">
                                {l s='Utiliser' mod='suppliermanager'}
                            </button>
                        </div>
                        
                        <div class="template-item">
                            <div class="template-icon">
                                <i class="icon-cogs"></i>
                            </div>
                            <div class="template-info">
                                <h6>{l s='Service et maintenance' mod='suppliermanager'}</h6>
                                <p>{l s='Modèle pour contrats de service' mod='suppliermanager'}</p>
                            </div>
                            <button class="btn btn-xs btn-outline-primary" onclick="useTemplate('service')">
                                {l s='Utiliser' mod='suppliermanager'}
                            </button>
                        </div>
                        
                        <div class="template-item">
                            <div class="template-icon">
                                <i class="icon-handshake-o"></i>
                            </div>
                            <div class="template-info">
                                <h6>{l s='Partenariat commercial' mod='suppliermanager'}</h6>
                                <p>{l s='Modèle pour accords de partenariat' mod='suppliermanager'}</p>
                            </div>
                            <button class="btn btn-xs btn-outline-primary" onclick="useTemplate('partnership')">
                                {l s='Utiliser' mod='suppliermanager'}
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Enhanced Styles -->
<style>
.page-subtitle {
    color: var(--gray-600);
    font-size: var(--font-size-sm);
    margin: var(--spacing-2) 0 0 0;
    font-weight: 400;
}

.action-bar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: var(--spacing-6);
    padding: var(--spacing-5);
    background: white;
    border-radius: var(--radius-xl);
    box-shadow: var(--shadow-md);
    border: 1px solid var(--gray-200);
}

.action-left {
    flex: 1;
    max-width: 600px;
}

.search-container {
    display: flex;
    flex-direction: column;
    gap: var(--spacing-3);
}

.search-input-group {
    position: relative;
    display: flex;
    align-items: center;
}

.search-input-group i {
    position: absolute;
    left: var(--spacing-4);
    color: var(--gray-400);
    z-index: 2;
}

.search-input {
    padding-left: var(--spacing-10);
    border-radius: var(--radius-lg);
    border: 1px solid var(--gray-300);
    transition: all var(--transition-fast);
}

.search-input:focus {
    border-color: var(--primary-500);
    box-shadow: 0 0 0 3px var(--primary-100);
}

.search-filters {
    display: flex;
    gap: var(--spacing-3);
}

.filter-select {
    min-width: 150px;
    border-radius: var(--radius-md);
}

.action-right {
    display: flex;
    gap: var(--spacing-3);
    margin-left: var(--spacing-4);
}

.stats-section {
    margin-bottom: var(--spacing-8);
}

.stat-card {
    background: white;
    border-radius: var(--radius-xl);
    padding: var(--spacing-6);
    box-shadow: var(--shadow-md);
    border: 1px solid var(--gray-200);
    transition: all var(--transition-normal);
    position: relative;
    overflow: hidden;
}

.stat-card:hover {
    transform: translateY(-2px);
    box-shadow: var(--shadow-lg);
}

.stat-card::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    height: 4px;
}

.stat-card.active-contracts::before {
    background: linear-gradient(90deg, var(--secondary-500), var(--secondary-600));
}

.stat-card.expiring-contracts::before {
    background: linear-gradient(90deg, var(--warning-500), var(--warning-600));
}

.stat-card.total-value::before {
    background: linear-gradient(90deg, var(--primary-500), var(--primary-600));
}

.stat-card.renewal-rate::before {
    background: linear-gradient(90deg, var(--danger-500), var(--danger-600));
}

.stat-icon {
    width: 56px;
    height: 56px;
    border-radius: var(--radius-xl);
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: var(--font-size-2xl);
    margin-bottom: var(--spacing-4);
    color: white;
}

.active-contracts .stat-icon {
    background: linear-gradient(135deg, var(--secondary-500), var(--secondary-600));
}

.expiring-contracts .stat-icon {
    background: linear-gradient(135deg, var(--warning-500), var(--warning-600));
}

.total-value .stat-icon {
    background: linear-gradient(135deg, var(--primary-500), var(--primary-600));
}

.renewal-rate .stat-icon {
    background: linear-gradient(135deg, var(--danger-500), var(--danger-600));
}

.stat-content h3 {
    font-size: var(--font-size-3xl);
    font-weight: 700;
    margin: 0 0 var(--spacing-1) 0;
    color: var(--gray-900);
}

.stat-content p {
    font-size: var(--font-size-sm);
    color: var(--gray-600);
    margin: 0 0 var(--spacing-3) 0;
    font-weight: 500;
}

.stat-trend {
    display: flex;
    align-items: center;
    gap: var(--spacing-2);
    font-size: var(--font-size-xs);
    font-weight: 600;
}

.stat-trend.positive {
    color: var(--secondary-600);
}

.stat-trend.warning {
    color: var(--warning-600);
}

.contracts-list {
    display: flex;
    flex-direction: column;
    gap: var(--spacing-5);
}

.contract-item {
    background: var(--gray-50);
    border-radius: var(--radius-xl);
    padding: var(--spacing-6);
    border: 1px solid var(--gray-200);
    transition: all var(--transition-fast);
    position: relative;
}

.contract-item:hover {
    background: white;
    box-shadow: var(--shadow-md);
    transform: translateY(-1px);
}

.contract-item::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    bottom: 0;
    width: 4px;
    border-top-left-radius: var(--radius-xl);
    border-bottom-left-radius: var(--radius-xl);
}

.contract-item.active::before {
    background: var(--secondary-500);
}

.contract-item.expiring::before {
    background: var(--warning-500);
}

.contract-item.draft::before {
    background: var(--gray-400);
}

.contract-header {
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    margin-bottom: var(--spacing-4);
}

.contract-info h4 {
    margin: 0 0 var(--spacing-2) 0;
    font-size: var(--font-size-lg);
    font-weight: 600;
    color: var(--gray-900);
}

.contract-meta {
    display: flex;
    gap: var(--spacing-4);
    align-items: center;
}

.contract-id {
    font-size: var(--font-size-xs);
    color: var(--gray-500);
    background: var(--gray-200);
    padding: var(--spacing-1) var(--spacing-2);
    border-radius: var(--radius-sm);
    font-weight: 600;
}

.contract-type {
    display: flex;
    align-items: center;
    gap: var(--spacing-1);
    font-size: var(--font-size-xs);
    color: var(--gray-600);
}

.status-badge {
    display: flex;
    align-items: center;
    gap: var(--spacing-2);
    padding: var(--spacing-2) var(--spacing-3);
    border-radius: var(--radius-md);
    font-size: var(--font-size-xs);
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: 0.05em;
}

.status-badge.active {
    background: var(--secondary-100);
    color: var(--secondary-800);
}

.status-badge.expiring {
    background: var(--warning-100);
    color: var(--warning-800);
}

.status-badge.draft {
    background: var(--gray-100);
    color: var(--gray-800);
}

.contract-details {
    margin-bottom: var(--spacing-5);
}

.detail-row {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: var(--spacing-4);
    margin-bottom: var(--spacing-4);
}

.detail-item {
    display: flex;
    align-items: center;
    gap: var(--spacing-2);
}

.detail-item i {
    color: var(--primary-500);
    width: 16px;
    flex-shrink: 0;
}

.detail-label {
    font-size: var(--font-size-xs);
    color: var(--gray-500);
    min-width: 80px;
}

.detail-value {
    font-size: var(--font-size-sm);
    font-weight: 600;
    color: var(--gray-900);
}

.contract-progress {
    background: white;
    border-radius: var(--radius-lg);
    padding: var(--spacing-4);
    border: 1px solid var(--gray-200);
}

.progress-info {
    display: flex;
    justify-content: space-between;
    margin-bottom: var(--spacing-2);
    font-size: var(--font-size-sm);
}

.progress-info span:first-child {
    color: var(--gray-600);
}

.progress-info span:last-child {
    font-weight: 600;
    color: var(--gray-900);
}

.progress-bar-container {
    height: 8px;
    background: var(--gray-200);
    border-radius: var(--radius-sm);
    overflow: hidden;
}

.progress-bar {
    height: 100%;
    border-radius: var(--radius-sm);
    transition: width var(--transition-normal);
}

.contract-item.active .progress-bar {
    background: linear-gradient(90deg, var(--secondary-500), var(--secondary-600));
}

.contract-item.expiring .progress-bar.warning {
    background: linear-gradient(90deg, var(--warning-500), var(--warning-600));
}

.contract-item.draft .progress-bar.draft {
    background: linear-gradient(90deg, var(--gray-400), var(--gray-500));
}

.contract-actions {
    display: flex;
    gap: var(--spacing-2);
    flex-wrap: wrap;
}

.pagination-container {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-top: var(--spacing-6);
    padding-top: var(--spacing-5);
    border-top: 1px solid var(--gray-200);
}

.pagination-info {
    font-size: var(--font-size-sm);
    color: var(--gray-600);
}

.pagination-controls {
    display: flex;
    gap: var(--spacing-2);
}

.quick-actions-list {
    display: flex;
    flex-direction: column;
    gap: var(--spacing-4);
}

.quick-action-item {
    display: flex;
    gap: var(--spacing-4);
    padding: var(--spacing-4);
    background: var(--gray-50);
    border-radius: var(--radius-lg);
    border: 1px solid var(--gray-200);
    text-decoration: none;
    transition: all var(--transition-fast);
}

.quick-action-item:hover {
    background: white;
    box-shadow: var(--shadow-sm);
    transform: translateY(-1px);
    text-decoration: none;
}

.action-icon {
    width: 48px;
    height: 48px;
    border-radius: var(--radius-lg);
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: var(--font-size-xl);
    color: white;
    flex-shrink: 0;
}

.action-icon.primary {
    background: linear-gradient(135deg, var(--primary-500), var(--primary-600));
}

.action-icon.secondary {
    background: linear-gradient(135deg, var(--secondary-500), var(--secondary-600));
}

.action-icon.warning {
    background: linear-gradient(135deg, var(--warning-500), var(--warning-600));
}

.action-content h5 {
    margin: 0 0 var(--spacing-1) 0;
    font-size: var(--font-size-base);
    font-weight: 600;
    color: var(--gray-900);
}

.action-content p {
    margin: 0;
    font-size: var(--font-size-sm);
    color: var(--gray-600);
}

.renewals-list {
    display: flex;
    flex-direction: column;
    gap: var(--spacing-4);
}

.renewal-item {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: var(--spacing-4);
    background: var(--gray-50);
    border-radius: var(--radius-lg);
    border: 1px solid var(--gray-200);
    position: relative;
}

.renewal-item::before {
    content: '';
    position: absolute;
    left: 0;
    top: 0;
    bottom: 0;
    width: 4px;
    border-top-left-radius: var(--radius-lg);
    border-bottom-left-radius: var(--radius-lg);
}

.renewal-item.urgent::before {
    background: var(--danger-500);
}

.renewal-item.warning::before {
    background: var(--warning-500);
}

.renewal-item.normal::before {
    background: var(--secondary-500);
}

.renewal-info h6 {
    margin: 0 0 var(--spacing-1) 0;
    font-size: var(--font-size-sm);
    font-weight: 600;
    color: var(--gray-900);
}

.renewal-info p {
    margin: 0;
    font-size: var(--font-size-xs);
    color: var(--gray-600);
}

.renewal-date {
    text-align: right;
}

.days-left {
    display: block;
    font-size: var(--font-size-sm);
    font-weight: 700;
    color: var(--gray-900);
}

.renewal-date small {
    font-size: var(--font-size-xs);
    color: var(--gray-500);
}

.renewals-footer {
    margin-top: var(--spacing-4);
    padding-top: var(--spacing-4);
    border-top: 1px solid var(--gray-200);
}

.templates-list {
    display: flex;
    flex-direction: column;
    gap: var(--spacing-4);
}

.template-item {
    display: flex;
    gap: var(--spacing-3);
    align-items: center;
    padding: var(--spacing-4);
    background: var(--gray-50);
    border-radius: var(--radius-lg);
    border: 1px solid var(--gray-200);
    transition: all var(--transition-fast);
}

.template-item:hover {
    background: white;
    box-shadow: var(--shadow-sm);
}

.template-icon {
    width: 40px;
    height: 40px;
    border-radius: var(--radius-lg);
    background: linear-gradient(135deg, var(--primary-500), var(--primary-600));
    display: flex;
    align-items: center;
    justify-content: center;
    color: white;
    flex-shrink: 0;
}

.template-info {
    flex: 1;
}

.template-info h6 {
    margin: 0 0 var(--spacing-1) 0;
    font-size: var(--font-size-sm);
    font-weight: 600;
    color: var(--gray-900);
}

.template-info p {
    margin: 0;
    font-size: var(--font-size-xs);
    color: var(--gray-600);
}

@media (max-width: 768px) {
    .action-bar {
        flex-direction: column;
        gap: var(--spacing-4);
        align-items: stretch;
    }
    
    .search-filters {
        flex-direction: column;
    }
    
    .action-right {
        margin-left: 0;
        justify-content: center;
    }
    
    .detail-row {
        grid-template-columns: 1fr;
        gap: var(--spacing-3);
    }
    
    .contract-actions {
        justify-content: center;
    }
    
    .pagination-container {
        flex-direction: column;
        gap: var(--spacing-3);
        text-align: center;
    }
}
</style>

<!-- Enhanced JavaScript -->
<script>
document.addEventListener('DOMContentLoaded', function() {
    // Initialize search functionality
    const searchInput = document.getElementById('contractSearch');
    const statusFilter = document.getElementById('statusFilter');
    const typeFilter = document.getElementById('typeFilter');
    
    function filterContracts() {
        const searchTerm = searchInput.value.toLowerCase();
        const statusValue = statusFilter.value;
        const typeValue = typeFilter.value;
        
        const contracts = document.querySelectorAll('.contract-item');
        
        contracts.forEach(contract => {
            const text = contract.textContent.toLowerCase();
            const status = contract.dataset.status;
            const type = contract.dataset.type;
            
            const matchesSearch = text.includes(searchTerm);
            const matchesStatus = !statusValue || status === statusValue;
            const matchesType = !typeValue || type === typeValue;
            
            if (matchesSearch && matchesStatus && matchesType) {
                contract.style.display = 'block';
                contract.style.animation = 'fadeInUp 0.3s ease-out';
            } else {
                contract.style.display = 'none';
            }
        });
    }
    
    searchInput.addEventListener('input', filterContracts);
    statusFilter.addEventListener('change', filterContracts);
    typeFilter.addEventListener('change', filterContracts);
    
    // Animate contract items on load
    const contractItems = document.querySelectorAll('.contract-item');
    contractItems.forEach((item, index) => {
        item.style.animationDelay = (index * 0.1) + 's';
        item.classList.add('fade-in-up');
    });
});

// Contract management functions
function createContract() {
    showNotification('Ouverture du formulaire de création de contrat...', 'info');
    // Implementation for creating new contract
}

function viewContract(id) {
    showNotification('Ouverture du contrat #' + id + '...', 'info');
    // Implementation for viewing contract
}

function editContract(id) {
    showNotification('Modification du contrat #' + id + '...', 'info');
    // Implementation for editing contract
}

function renewContract(id) {
    if (confirm('Êtes-vous sûr de vouloir renouveler ce contrat ?')) {
        showNotification('Renouvellement du contrat #' + id + ' en cours...', 'info');
        // Implementation for renewing contract
    }
}

function duplicateContract(id) {
    if (confirm('Dupliquer ce contrat ?')) {
        showNotification('Duplication du contrat #' + id + '...', 'info');
        // Implementation for duplicating contract
    }
}

function deleteContract(id) {
    if (confirm('Êtes-vous sûr de vouloir supprimer ce contrat ? Cette action est irréversible.')) {
        showNotification('Suppression du contrat #' + id + '...', 'warning');
        // Implementation for deleting contract
        setTimeout(() => {
            const contractItem = document.querySelector('[data-contract-id="' + id + '"]');
            if (contractItem) {
                contractItem.style.animation = 'fadeOut 0.3s ease-out';
                setTimeout(() => {
                    contractItem.remove();
                }, 300);
            }
        }, 1000);
    }
}

function exportContracts() {
    showNotification('Export des contrats en cours...', 'info');
    // Implementation for exporting contracts
    setTimeout(() => {
        showNotification('Export terminé avec succès', 'success');
    }, 2000);
}

function importContracts() {
    showNotification('Ouverture de l\'assistant d\'import...', 'info');
    // Implementation for importing contracts
}

function generateReport() {
    showNotification('Génération du rapport en cours...', 'info');
    // Implementation for generating report
    setTimeout(() => {
        showNotification('Rapport généré avec succès', 'success');
    }, 3000);
}

function useTemplate(type) {
    showNotification('Utilisation du modèle ' + type + '...', 'info');
    // Implementation for using template
}

function refreshContracts() {
    showNotification('Actualisation des contrats...', 'info');
    // Implementation for refreshing contracts list
    setTimeout(() => {
        showNotification('Contrats actualisés', 'success');
    }, 1500);
}

function toggleView() {
    const contractsList = document.getElementById('contractsList');
    const isGridView = contractsList.classList.contains('grid-view');
    
    if (isGridView) {
        contractsList.classList.remove('grid-view');
        showNotification('Vue liste activée', 'info');
    } else {
        contractsList.classList.add('grid-view');
        showNotification('Vue grille activée', 'info');
    }
}

// Notification system (reuse from previous templates)
function showNotification(message, type = 'info') {
    const notification = document.createElement('div');
    notification.className = 'notification notification-' + type;
    notification.innerHTML =
        <div class="notification-content">
            <i class="icon-${type === 'success' ? 'check' : type === 'error' ? 'times' : type === 'warning' ? 'exclamation-triangle' : 'info'}"></i>
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

<!-- Additional animations -->
<style>
@keyframes fadeOut {
    from {
        opacity: 1;
        transform: translateY(0);
    }
    to {
        opacity: 0;
        transform: translateY(-20px);
    }
}

.contracts-list.grid-view {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
    gap: var(--spacing-4);
}

.contracts-list.grid-view .contract-item {
    margin-bottom: 0;
}

/* Notification styles (reuse from previous templates) */
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
.notification-warning { border-left: 4px solid var(--warning-500); }

.notification i {
    font-size: var(--font-size-lg);
}

.notification-success i { color: var(--secondary-500); }
.notification-error i { color: var(--danger-500); }
.notification-info i { color: var(--primary-500); }
.notification-warning i { color: var(--warning-500); }
</style>