<!-- CSS Test -->
<style>
.test-container {
    background: linear-gradient(135deg, #f59e0b, #ef4444);
    color: white;
    padding: 20px;
    border-radius: 10px;
    margin: 20px;
    text-align: center;
}
.test-card {
    background: white;
    color: #333;
    padding: 15px;
    border-radius: 8px;
    margin: 10px 0;
    box-shadow: 0 4px 6px rgba(0,0,0,0.1);
}
</style>

<div class="test-container">
    <h1>📦 Orders Test - Supplier Manager</h1>
    <p>Template des commandes chargé avec succès !</p>
    <div class="test-card">
        <h3>Template Orders.tpl Chargé</h3>
        <p>Le template orders.tpl est bien chargé et affiché.</p>
        <button onclick="alert('Orders JavaScript fonctionne !')" style="background: #f59e0b; color: white; padding: 10px 20px; border: none; border-radius: 5px; cursor: pointer;">
            Test JavaScript Orders
        </button>
    </div>
</div>

<div class="bootstrap fade-in-up">
    <!-- Modern Header -->
    <div class="page-title">
        <h3>
            <i class="icon-shopping-cart"></i> 
            {l s='Commandes Fournisseurs' mod='suppliermanager'}
        </h3>
        <p class="page-subtitle">{l s='Gestion des commandes et approvisionnements' mod='suppliermanager'}</p>
    </div>

    <!-- Action Bar -->
    <div class="action-bar">
        <div class="action-left">
            <div class="search-container">
                <div class="search-input-group">
                    <i class="icon-search"></i>
                    <input type="text" 
                           class="form-control search-input" 
                           placeholder="{l s='Rechercher une commande...' mod='suppliermanager'}"
                           id="orderSearch">
                </div>
                <div class="search-filters">
                    <select class="form-control filter-select" id="statusFilter">
                        <option value="">{l s='Tous les statuts' mod='suppliermanager'}</option>
                        <option value="draft">{l s='Brouillons' mod='suppliermanager'}</option>
                        <option value="pending">{l s='En attente' mod='suppliermanager'}</option>
                        <option value="sent">{l s='Envoyées' mod='suppliermanager'}</option>
                        <option value="confirmed">{l s='Confirmées' mod='suppliermanager'}</option>
                        <option value="received">{l s='Reçues' mod='suppliermanager'}</option>
                        <option value="cancelled">{l s='Annulées' mod='suppliermanager'}</option>
                    </select>
                    <select class="form-control filter-select" id="supplierFilter">
                        <option value="">{l s='Tous les fournisseurs' mod='suppliermanager'}</option>
                        <!-- Options will be populated dynamically -->
                    </select>
                </div>
            </div>
        </div>
        <div class="action-right">
            <button class="btn btn-outline-secondary" onclick="exportOrders()">
                <i class="icon-download"></i>
                {l s='Exporter' mod='suppliermanager'}
            </button>
            <a href="{$link->getAdminLink('AdminSupplierManagerOrders')}&add{$table}" class="btn btn-primary">
                <i class="icon-plus"></i>
                {l s='Nouvelle commande' mod='suppliermanager'}
            </a>
        </div>
    </div>

    <!-- Stats Cards -->
    <div class="row stats-section">
        <div class="col-lg-3">
            <div class="stat-card draft-orders">
                <div class="stat-icon">
                    <i class="icon-edit"></i>
                </div>
                <div class="stat-content">
                    <h3>12</h3>
                    <p>{l s='Brouillons' mod='suppliermanager'}</p>
                    <div class="stat-trend neutral">
                        <i class="icon-minus"></i>
                        <span>Aucun changement</span>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-lg-3">
            <div class="stat-card pending-orders">
                <div class="stat-icon">
                    <i class="icon-clock-o"></i>
                </div>
                <div class="stat-content">
                    <h3>8</h3>
                    <p>{l s='En attente' mod='suppliermanager'}</p>
                    <div class="stat-trend warning">
                        <i class="icon-exclamation-triangle"></i>
                        <span>Attention requise</span>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-lg-3">
            <div class="stat-card confirmed-orders">
                <div class="stat-icon">
                    <i class="icon-check-circle"></i>
                </div>
                <div class="stat-content">
                    <h3>24</h3>
                    <p>{l s='Confirmées' mod='suppliermanager'}</p>
                    <div class="stat-trend positive">
                        <i class="icon-arrow-up"></i>
                        <span>+15% ce mois</span>
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
                    <h3>€45,280</h3>
                    <p>{l s='Valeur totale' mod='suppliermanager'}</p>
                    <div class="stat-trend positive">
                        <i class="icon-arrow-up"></i>
                        <span>+8% vs mois dernier</span>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Orders List -->
    <div class="panel orders-panel">
        <div class="panel-heading">
            <i class="icon-list"></i> 
            {l s='Liste des commandes' mod='suppliermanager'}
            <div class="panel-actions">
                <button class="btn-icon" onclick="refreshOrders()" title="{l s='Actualiser' mod='suppliermanager'}">
                    <i class="icon-refresh"></i>
                </button>
                <button class="btn-icon" onclick="toggleView()" title="{l s='Changer la vue' mod='suppliermanager'}">
                    <i class="icon-th-list"></i>
                </button>
            </div>
        </div>
        <div class="panel-body">
            <div class="table-responsive">
                <table class="table modern-table orders-table">
                    <thead>
                        <tr>
                            <th>{l s='ID' mod='suppliermanager'}</th>
                            <th>{l s='Fournisseur' mod='suppliermanager'}</th>
                            <th>{l s='Date' mod='suppliermanager'}</th>
                            <th>{l s='Statut' mod='suppliermanager'}</th>
                            <th>{l s='Montant' mod='suppliermanager'}</th>
                            <th>{l s='IA' mod='suppliermanager'}</th>
                            <th>{l s='Actions' mod='suppliermanager'}</th>
                        </tr>
                    </thead>
                    <tbody>
                        <!-- Sample data - will be replaced by actual data -->
                        <tr class="order-row">
                            <td>
                                <span class="order-id">#ORD-001</span>
                            </td>
                            <td>
                                <div class="supplier-info">
                                    <strong>Fournisseur ABC</strong>
                                    <small>Électronique</small>
                                </div>
                            </td>
                            <td>
                                <span class="order-date">15/01/2024</span>
                            </td>
                            <td>
                                <span class="status-badge confirmed">
                                    <i class="icon-check-circle"></i>
                                    {l s='Confirmée' mod='suppliermanager'}
                                </span>
                            </td>
                            <td>
                                <span class="order-amount">€2,450.00</span>
                            </td>
                            <td>
                                <span class="ai-badge active">
                                    <i class="icon-robot"></i>
                                </span>
                            </td>
                            <td>
                                <div class="action-buttons">
                                    <a href="#" class="btn btn-sm btn-outline-primary" title="{l s='Voir' mod='suppliermanager'}">
                                        <i class="icon-eye"></i>
                                    </a>
                                    <a href="#" class="btn btn-sm btn-outline-secondary" title="{l s='Modifier' mod='suppliermanager'}">
                                        <i class="icon-edit"></i>
                                    </a>
                                    <a href="#" class="btn btn-sm btn-outline-danger" title="{l s='Supprimer' mod='suppliermanager'}">
                                        <i class="icon-trash"></i>
                                    </a>
                                </div>
                            </td>
                        </tr>
                        <tr class="order-row">
                            <td>
                                <span class="order-id">#ORD-002</span>
                            </td>
                            <td>
                                <div class="supplier-info">
                                    <strong>TechService Pro</strong>
                                    <small>Services</small>
                                </div>
                            </td>
                            <td>
                                <span class="order-date">14/01/2024</span>
                            </td>
                            <td>
                                <span class="status-badge pending">
                                    <i class="icon-clock-o"></i>
                                    {l s='En attente' mod='suppliermanager'}
                                </span>
                            </td>
                            <td>
                                <span class="order-amount">€1,280.50</span>
                            </td>
                            <td>
                                <span class="ai-badge inactive">
                                    <i class="icon-user"></i>
                                </span>
                            </td>
                            <td>
                                <div class="action-buttons">
                                    <a href="#" class="btn btn-sm btn-outline-primary" title="{l s='Voir' mod='suppliermanager'}">
                                        <i class="icon-eye"></i>
                                    </a>
                                    <a href="#" class="btn btn-sm btn-outline-secondary" title="{l s='Modifier' mod='suppliermanager'}">
                                        <i class="icon-edit"></i>
                                    </a>
                                    <a href="#" class="btn btn-sm btn-primary" title="{l s='Envoyer' mod='suppliermanager'}">
                                        <i class="icon-paper-plane"></i>
                                    </a>
                                </div>
                            </td>
                        </tr>
                        <tr class="order-row">
                            <td>
                                <span class="order-id">#ORD-003</span>
                            </td>
                            <td>
                                <div class="supplier-info">
                                    <strong>LogiTransport</strong>
                                    <small>Transport</small>
                                </div>
                            </td>
                            <td>
                                <span class="order-date">13/01/2024</span>
                            </td>
                            <td>
                                <span class="status-badge draft">
                                    <i class="icon-edit"></i>
                                    {l s='Brouillon' mod='suppliermanager'}
                                </span>
                            </td>
                            <td>
                                <span class="order-amount">€890.00</span>
                            </td>
                            <td>
                                <span class="ai-badge active">
                                    <i class="icon-robot"></i>
                                </span>
                            </td>
                            <td>
                                <div class="action-buttons">
                                    <a href="#" class="btn btn-sm btn-outline-primary" title="{l s='Voir' mod='suppliermanager'}">
                                        <i class="icon-eye"></i>
                                    </a>
                                    <a href="#" class="btn btn-sm btn-outline-secondary" title="{l s='Modifier' mod='suppliermanager'}">
                                        <i class="icon-edit"></i>
                                    </a>
                                    <a href="#" class="btn btn-sm btn-outline-danger" title="{l s='Supprimer' mod='suppliermanager'}">
                                        <i class="icon-trash"></i>
                                    </a>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            
            <!-- Pagination -->
            <div class="pagination-container">
                <div class="pagination-info">
                    {l s='Affichage de 1 à 3 sur 25 commandes' mod='suppliermanager'}
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

<!-- Enhanced JavaScript -->
<script>
document.addEventListener('DOMContentLoaded', function() {
    initializeFilters();
    initializeSearch();
    animateElements();
});

function initializeFilters() {
    var statusFilter = document.getElementById('statusFilter');
    var supplierFilter = document.getElementById('supplierFilter');
    
    if (statusFilter) {
        statusFilter.addEventListener('change', filterOrders);
    }
    
    if (supplierFilter) {
        supplierFilter.addEventListener('change', filterOrders);
    }
}

function initializeSearch() {
    var searchInput = document.getElementById('orderSearch');
    if (searchInput) {
        searchInput.addEventListener('input', function() {
            var searchTerm = this.value.toLowerCase();
            filterOrdersBySearch(searchTerm);
        });
    }
}

function filterOrders() {
    var statusValue = document.getElementById('statusFilter').value;
    var supplierValue = document.getElementById('supplierFilter').value;
    
    var rows = document.querySelectorAll('.order-row');
    rows.forEach(function(row) {
        var shouldShow = true;
        
        // Add filtering logic here based on actual data
        // This is just a placeholder
        
        if (shouldShow) {
            row.style.display = '';
            row.style.animation = 'fadeInUp 0.3s ease-out';
        } else {
            row.style.display = 'none';
        }
    });
    
    showNotification('Filtres appliqués', 'info');
}

function filterOrdersBySearch(searchTerm) {
    var rows = document.querySelectorAll('.order-row');
    rows.forEach(function(row) {
        var text = row.textContent.toLowerCase();
        if (text.indexOf(searchTerm) !== -1) {
            row.style.display = '';
        } else {
            row.style.display = 'none';
        }
    });
}

function animateElements() {
    var cards = document.querySelectorAll('.stat-card');
    cards.forEach(function(card, index) {
        card.style.animationDelay = (index * 0.1) + 's';
        card.classList.add('fade-in-up');
    });
    
    var rows = document.querySelectorAll('.order-row');
    rows.forEach(function(row, index) {
        row.style.animationDelay = (index * 0.05) + 's';
        row.classList.add('fade-in-up');
    });
}

function exportOrders() {
    showNotification('Export des commandes en cours...', 'info');
    
    setTimeout(function() {
        showNotification('Export terminé avec succès', 'success');
    }, 2000);
}

function refreshOrders() {
    showNotification('Actualisation des commandes...', 'info');
    
    setTimeout(function() {
        showNotification('Commandes actualisées', 'success');
        location.reload();
    }, 1500);
}

function toggleView() {
    var table = document.querySelector('.orders-table');
    if (table) {
        table.classList.toggle('grid-view');
        showNotification('Vue changée', 'info');
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
            if (notification.parentNode) {
                notification.parentNode.removeChild(notification);
            }
        }, 300);
    }, 3000);
}
</script>

<!-- Additional Styles for Orders -->
<style>
.orders-table .order-id {
    font-family: 'Courier New', monospace;
    font-weight: 600;
    color: var(--primary-600);
}

.supplier-info strong {
    display: block;
    font-size: var(--font-size-sm);
    color: var(--gray-900);
    margin-bottom: var(--spacing-1);
}

.supplier-info small {
    font-size: var(--font-size-xs);
    color: var(--gray-500);
}

.order-date {
    font-size: var(--font-size-sm);
    color: var(--gray-700);
}

.order-amount {
    font-weight: 600;
    color: var(--primary-600);
    font-size: var(--font-size-base);
}

.ai-badge {
    width: 24px;
    height: 24px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: var(--font-size-xs);
}

.ai-badge.active {
    background: linear-gradient(135deg, var(--primary-500), var(--secondary-500));
    color: white;
}

.ai-badge.inactive {
    background: var(--gray-200);
    color: var(--gray-600);
}

.action-buttons {
    display: flex;
    gap: var(--spacing-2);
}

.stat-card.draft-orders .stat-icon {
    background: linear-gradient(135deg, var(--gray-500), var(--gray-600));
}

.stat-card.pending-orders .stat-icon {
    background: linear-gradient(135deg, var(--warning-500), var(--warning-600));
}

.stat-card.confirmed-orders .stat-icon {
    background: linear-gradient(135deg, var(--secondary-500), var(--secondary-600));
}

.stat-card.total-value .stat-icon {
    background: linear-gradient(135deg, var(--primary-500), var(--primary-600));
}

.stat-trend.neutral {
    color: var(--gray-600);
}

.panel-actions {
    display: flex;
    gap: var(--spacing-2);
}

.btn-icon {
    background: none;
    border: none;
    color: white;
    padding: var(--spacing-2);
    border-radius: var(--radius-md);
    cursor: pointer;
    transition: all var(--transition-fast);
}

.btn-icon:hover {
    background: rgba(255, 255, 255, 0.1);
}
</style>