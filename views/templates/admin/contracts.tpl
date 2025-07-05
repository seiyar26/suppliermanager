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
                        <div class="contract-item active" data-status="active" data-type="supply" data-contract-id="1">
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
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Enhanced JavaScript -->
<script>
document.addEventListener('DOMContentLoaded', function() {
    // Initialize search functionality
    var searchInput = document.getElementById('contractSearch');
    var statusFilter = document.getElementById('statusFilter');
    var typeFilter = document.getElementById('typeFilter');
    
    function filterContracts() {
        var searchTerm = searchInput.value.toLowerCase();
        var statusValue = statusFilter.value;
        var typeValue = typeFilter.value;
        
        var contracts = document.querySelectorAll('.contract-item');
        
        contracts.forEach(function(contract) {
            var text = contract.textContent.toLowerCase();
            var status = contract.dataset.status;
            var type = contract.dataset.type;
            
            var matchesSearch = text.indexOf(searchTerm) !== -1;
            var matchesStatus = !statusValue || status === statusValue;
            var matchesType = !typeValue || type === typeValue;
            
            if (matchesSearch && matchesStatus && matchesType) {
                contract.style.display = 'block';
                contract.style.animation = 'fadeInUp 0.3s ease-out';
            } else {
                contract.style.display = 'none';
            }
        });
    }
    
    if (searchInput) searchInput.addEventListener('input', filterContracts);
    if (statusFilter) statusFilter.addEventListener('change', filterContracts);
    if (typeFilter) typeFilter.addEventListener('change', filterContracts);
    
    // Animate contract items on load
    var contractItems = document.querySelectorAll('.contract-item');
    contractItems.forEach(function(item, index) {
        item.style.animationDelay = (index * 0.1) + 's';
        item.classList.add('fade-in-up');
    });
});

// Contract management functions
function createContract() {
    showNotification('Ouverture du formulaire de création de contrat...', 'info');
}

function viewContract(id) {
    showNotification('Ouverture du contrat #' + id + '...', 'info');
}

function editContract(id) {
    showNotification('Modification du contrat #' + id + '...', 'info');
}

function renewContract(id) {
    if (confirm('Êtes-vous sûr de vouloir renouveler ce contrat ?')) {
        showNotification('Renouvellement du contrat #' + id + ' en cours...', 'info');
    }
}

function exportContracts() {
    showNotification('Export des contrats en cours...', 'info');
}

function refreshContracts() {
    showNotification('Actualisation des contrats...', 'info');
}

function toggleView() {
    var contractsList = document.getElementById('contractsList');
    if (contractsList) {
        var isGridView = contractsList.classList.contains('grid-view');
        
        if (isGridView) {
            contractsList.classList.remove('grid-view');
            showNotification('Vue liste activée', 'info');
        } else {
            contractsList.classList.add('grid-view');
            showNotification('Vue grille activée', 'info');
        }
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
        '</div>';
    
    document.body.appendChild(notification);
    
    setTimeout(function() {
        notification.classList.add('show');
    }, 100);
    
    setTimeout(function() {
        notification.classList.remove('show');
        setTimeout(function() {
            notification.remove();
        }, 300);
    }, 3000);
}
</script>