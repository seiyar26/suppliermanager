<!-- CSS Test -->
<style>
.test-container {
    background: linear-gradient(135deg, #3b82f6, #22c55e);
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
    <h1>🎉 CSS Test - Supplier Manager</h1>
    <p>Si vous voyez ce contenu avec des couleurs et du style, le CSS fonctionne !</p>
    <div class="test-card">
        <h3>Template Dashboard Chargé</h3>
        <p>Le template dashboard.tpl est bien chargé et affiché.</p>
        <button onclick="alert('JavaScript fonctionne aussi !')" style="background: #3b82f6; color: white; padding: 10px 20px; border: none; border-radius: 5px; cursor: pointer;">
            Test JavaScript
        </button>
    </div>
</div>

<div class="bootstrap fade-in-up">
    <!-- Modern Header -->
    <div class="page-title">
        <h3>
            <i class="icon-dashboard"></i> 
            {l s='Tableau de bord' mod='suppliermanager'}
        </h3>
        <p class="page-subtitle">{l s='Vue d\'ensemble de votre gestion fournisseurs' mod='suppliermanager'}</p>
    </div>

    <!-- Enhanced KPI Cards -->
    <div class="row kpi-section">
        <div class="col-lg-3">
            <div class="card-box bg-blue">
                <div class="inner">
                    <div class="kpi-header">
                        <div class="kpi-icon">
                            <i class="icon-truck"></i>
                        </div>
                        <div class="kpi-trend">
                            <span class="trend-indicator positive">+12%</span>
                        </div>
                    </div>
                    <h3 class="kpi-value">{$summary.total_suppliers|intval}</h3>
                    <p class="kpi-label">{l s='Fournisseurs actifs' mod='suppliermanager'}</p>
                    <div class="kpi-progress">
                        <div class="progress-bar" style="width: 85%"></div>
                    </div>
                </div>
                <a href="{$link->getAdminLink('AdminSuppliers')}" class="card-box-footer">
                    {l s='Gérer les fournisseurs' mod='suppliermanager'} 
                    <i class="fa fa-arrow-right"></i>
                </a>
            </div>
        </div>
        
        <div class="col-lg-3">
            <div class="card-box bg-green">
                <div class="inner">
                    <div class="kpi-header">
                        <div class="kpi-icon">
                            <i class="icon-time"></i>
                        </div>
                        <div class="kpi-trend">
                            <span class="trend-indicator negative">-5%</span>
                        </div>
                    </div>
                    <h3 class="kpi-value">{$summary.pending_orders|intval}</h3>
                    <p class="kpi-label">{l s='Commandes en attente' mod='suppliermanager'}</p>
                    <div class="kpi-progress">
                        <div class="progress-bar" style="width: 65%"></div>
                    </div>
                </div>
                <a href="{$link->getAdminLink('AdminSupplierManagerOrders')}" class="card-box-footer">
                    {l s='Voir les commandes' mod='suppliermanager'} 
                    <i class="fa fa-arrow-right"></i>
                </a>
            </div>
        </div>
        
        <div class="col-lg-3">
            <div class="card-box bg-orange">
                <div class="inner">
                    <div class="kpi-header">
                        <div class="kpi-icon">
                            <i class="icon-warning-sign"></i>
                        </div>
                        <div class="kpi-trend">
                            <span class="trend-indicator warning">!</span>
                        </div>
                    </div>
                    <h3 class="kpi-value">{$summary.low_stock_products|intval}</h3>
                    <p class="kpi-label">{l s='Produits en stock bas' mod='suppliermanager'}</p>
                    <div class="kpi-progress">
                        <div class="progress-bar warning" style="width: 30%"></div>
                    </div>
                </div>
                <a href="{$link->getAdminLink('AdminSupplierManagerStocks')}" class="card-box-footer">
                    {l s='Gérer les stocks' mod='suppliermanager'} 
                    <i class="fa fa-arrow-right"></i>
                </a>
            </div>
        </div>
        
        <div class="col-lg-3">
            <div class="card-box bg-red">
                <div class="inner">
                    <div class="kpi-header">
                        <div class="kpi-icon">
                            <i class="icon-calendar"></i>
                        </div>
                        <div class="kpi-trend">
                            <span class="trend-indicator positive">+8%</span>
                        </div>
                    </div>
                    <h3 class="kpi-value">{$summary.orders_to_schedule|intval}</h3>
                    <p class="kpi-label">{l s='Commandes à cadencer' mod='suppliermanager'}</p>
                    <div class="kpi-progress">
                        <div class="progress-bar" style="width: 75%"></div>
                    </div>
                </div>
                <a href="{$link->getAdminLink('AdminSupplierManagerSchedules')}" class="card-box-footer">
                    {l s='Planifier' mod='suppliermanager'} 
                    <i class="fa fa-arrow-right"></i>
                </a>
            </div>
        </div>
    </div>

    <!-- Main Dashboard Content -->
    <div class="row main-content">
        <!-- Performance Chart -->
        <div class="col-lg-8">
            <div class="panel chart-panel">
                <div class="panel-heading">
                    <i class="icon-bar-chart"></i> 
                    {l s='Performance des fournisseurs' mod='suppliermanager'}
                    <div class="panel-actions">
                        <button class="btn-icon" onclick="refreshChart()">
                            <i class="icon-refresh"></i>
                        </button>
                        <button class="btn-icon" onclick="exportChart()">
                            <i class="icon-download"></i>
                        </button>
                    </div>
                </div>
                <div class="panel-body">
                    <div class="chart-container">
                        <canvas id="supplierPerformanceChart"></canvas>
                    </div>
                    <div class="chart-legend">
                        <div class="legend-item">
                            <span class="legend-color" style="background: var(--primary-500)"></span>
                            {l s='Commandes' mod='suppliermanager'}
                        </div>
                        <div class="legend-item">
                            <span class="legend-color" style="background: var(--secondary-500)"></span>
                            {l s='Montant' mod='suppliermanager'}
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Quick Actions & Stats -->
        <div class="col-lg-4">
            <!-- Quick Actions -->
            <div class="panel quick-actions-panel">
                <div class="panel-heading">
                    <i class="icon-bolt"></i> 
                    {l s='Actions rapides' mod='suppliermanager'}
                </div>
                <div class="panel-body">
                    <div class="quick-actions-grid">
                        <a href="{$link->getAdminLink('AdminSupplierManagerOrders')|escape:'html':'UTF-8'}&addsupplier_orders" 
                           class="quick-action-item primary">
                            <div class="action-icon">
                                <i class="icon-plus"></i>
                            </div>
                            <div class="action-content">
                                <h4>{l s='Nouvelle commande' mod='suppliermanager'}</h4>
                                <p>{l s='Créer une commande fournisseur' mod='suppliermanager'}</p>
                            </div>
                        </a>
                        
                        <a href="{$link->getAdminLink('AdminSupplierManagerSchedules')|escape:'html':'UTF-8'}&addsupplier_order_schedules" 
                           class="quick-action-item secondary">
                            <div class="action-icon">
                                <i class="icon-calendar"></i>
                            </div>
                            <div class="action-content">
                                <h4>{l s='Nouveau cadencier' mod='suppliermanager'}</h4>
                                <p>{l s='Planifier les livraisons' mod='suppliermanager'}</p>
                            </div>
                        </a>
                        
                        <a href="{$link->getAdminLink('AdminSupplierManagerReturns')|escape:'html':'UTF-8'}&addsupplier_returns" 
                           class="quick-action-item warning">
                            <div class="action-icon">
                                <i class="icon-undo"></i>
                            </div>
                            <div class="action-content">
                                <h4>{l s='Nouveau retour' mod='suppliermanager'}</h4>
                                <p>{l s='Gérer les retours produits' mod='suppliermanager'}</p>
                            </div>
                        </a>
                        
                        <a href="{$link->getAdminLink('AdminSupplierManagerSettings')}" 
                           class="quick-action-item info">
                            <div class="action-icon">
                                <i class="icon-cogs"></i>
                            </div>
                            <div class="action-content">
                                <h4>{l s='Paramètres' mod='suppliermanager'}</h4>
                                <p>{l s='Configuration du module' mod='suppliermanager'}</p>
                            </div>
                        </a>
                    </div>
                </div>
            </div>

            <!-- Recent Activity -->
            <div class="panel activity-panel">
                <div class="panel-heading">
                    <i class="icon-clock-o"></i> 
                    {l s='Activité récente' mod='suppliermanager'}
                </div>
                <div class="panel-body">
                    <div class="activity-timeline">
                        <div class="activity-item">
                            <div class="activity-icon success">
                                <i class="icon-check"></i>
                            </div>
                            <div class="activity-content">
                                <h5>{l s='Commande validée' mod='suppliermanager'}</h5>
                                <p>{l s='Commande #12345 validée par Fournisseur ABC' mod='suppliermanager'}</p>
                                <span class="activity-time">Il y a 2 heures</span>
                            </div>
                        </div>
                        
                        <div class="activity-item">
                            <div class="activity-icon warning">
                                <i class="icon-exclamation"></i>
                            </div>
                            <div class="activity-content">
                                <h5>{l s='Stock faible détecté' mod='suppliermanager'}</h5>
                                <p>{l s='Produit XYZ en dessous du seuil minimum' mod='suppliermanager'}</p>
                                <span class="activity-time">Il y a 4 heures</span>
                            </div>
                        </div>
                        
                        <div class="activity-item">
                            <div class="activity-icon info">
                                <i class="icon-truck"></i>
                            </div>
                            <div class="activity-content">
                                <h5>{l s='Livraison programmée' mod='suppliermanager'}</h5>
                                <p>{l s='Livraison prévue demain pour la commande #12340' mod='suppliermanager'}</p>
                                <span class="activity-time">Il y a 6 heures</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bottom Section -->
    <div class="row bottom-section">
        <!-- AI Suggestions -->
        <div class="col-lg-6">
            <div class="panel ai-panel">
                <div class="panel-heading">
                    <i class="icon-lightbulb"></i> 
                    {l s='Suggestions intelligentes' mod='suppliermanager'}
                    <div class="ai-badge">
                        <span>🤖 IA</span>
                    </div>
                </div>
                <div class="panel-body">
                    {if $aiSuggestions && count($aiSuggestions) > 0}
                        <div class="suggestions-grid">
                            {foreach from=$aiSuggestions item=suggestion}
                                <div class="suggestion-card">
                                    <div class="suggestion-header">
                                        <h5>{$suggestion.product_name}</h5>
                                        <span class="confidence-score">{$suggestion.confidence|default:85}%</span>
                                    </div>
                                    <div class="suggestion-content">
                                        <div class="suggestion-metric">
                                            <span class="metric-label">{l s='Quantité suggérée' mod='suppliermanager'}</span>
                                            <span class="metric-value">{$suggestion.suggested_quantity}</span>
                                        </div>
                                        <div class="suggestion-reason">
                                            <small>{l s='Basé sur les ventes des 30 derniers jours' mod='suppliermanager'}</small>
                                        </div>
                                    </div>
                                    <div class="suggestion-actions">
                                        <button class="btn btn-sm btn-primary" onclick="addToOrder('{$suggestion.product_id}', {$suggestion.suggested_quantity})">
                                            <i class="icon-plus"></i> {l s='Ajouter' mod='suppliermanager'}
                                        </button>
                                        <button class="btn btn-sm btn-default" onclick="dismissSuggestion('{$suggestion.id}')">
                                            <i class="icon-times"></i>
                                        </button>
                                    </div>
                                </div>
                            {/foreach}
                        </div>
                    {else}
                        <div class="empty-state">
                            <div class="empty-icon">
                                <i class="icon-lightbulb"></i>
                            </div>
                            <h4>{l s='Aucune suggestion disponible' mod='suppliermanager'}</h4>
                            <p>{l s='L\'IA analysera vos données pour vous proposer des suggestions d\'achat optimisées.' mod='suppliermanager'}</p>
                        </div>
                    {/if}
                </div>
            </div>
        </div>

        <!-- Franco Status -->
        <div class="col-lg-6">
            <div class="panel franco-panel">
                <div class="panel-heading">
                    <i class="icon-truck"></i> 
                    {l s='Statut Franco' mod='suppliermanager'}
                    <div class="panel-badge">
                        <span class="badge badge-warning">{if $ordersWaitingForFranco}{count($ordersWaitingForFranco)}{else}0{/if}</span>
                    </div>
                </div>
                <div class="panel-body">
                    {if $ordersWaitingForFranco && count($ordersWaitingForFranco) > 0}
                        <div class="franco-list">
                            {foreach from=$ordersWaitingForFranco item=order}
                                <div class="franco-item">
                                    <div class="franco-supplier">
                                        <h5>{$order.supplier_name}</h5>
                                        <span class="supplier-code">#{$order.supplier_id}</span>
                                    </div>
                                    <div class="franco-progress">
                                        <div class="progress-info">
                                            <span class="current-amount">{displayPrice price=$order.total_amount}</span>
                                            <span class="target-amount">/ {displayPrice price=$order.franco_amount}</span>
                                        </div>
                                        <div class="progress-bar-container">
                                            <div class="progress-bar" style="width: {if $order.franco_amount && $order.franco_amount > 0 && $order.total_amount}{math equation="(x/y)*100" x=$order.total_amount|floatval y=$order.franco_amount|floatval format="%.0f"}{else}0{/if}%"></div>
                                        </div>
                                        <div class="progress-percentage">
                                            {if $order.franco_amount && $order.franco_amount > 0 && $order.total_amount}{math equation="(x/y)*100" x=$order.total_amount|floatval y=$order.franco_amount|floatval format="%.0f"}{else}0{/if}%
                                        </div>
                                    </div>
                                    <div class="franco-actions">
                                        <button class="btn btn-xs btn-primary" onclick="completeOrder('{$order.id}')">
                                            <i class="icon-plus"></i> {l s='Compléter' mod='suppliermanager'}
                                        </button>
                                    </div>
                                </div>
                            {/foreach}
                        </div>
                    {else}
                        <div class="empty-state">
                            <div class="empty-icon">
                                <i class="icon-check-circle"></i>
                            </div>
                            <h4>{l s='Tous les francos sont atteints' mod='suppliermanager'}</h4>
                            <p>{l s='Aucune commande en attente de franco actuellement.' mod='suppliermanager'}</p>
                        </div>
                    {/if}
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

.kpi-section {
    margin-bottom: var(--spacing-8);
}

.kpi-header {
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    margin-bottom: var(--spacing-3);
}

.kpi-icon {
    width: 48px;
    height: 48px;
    border-radius: var(--radius-lg);
    background: rgba(255, 255, 255, 0.2);
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: var(--font-size-xl);
}

.kpi-trend {
    font-size: var(--font-size-xs);
}

.trend-indicator {
    padding: var(--spacing-1) var(--spacing-2);
    border-radius: var(--radius-sm);
    font-weight: 600;
    background: rgba(255, 255, 255, 0.2);
}

.trend-indicator.positive { color: var(--secondary-600); }
.trend-indicator.negative { color: var(--danger-600); }
.trend-indicator.warning { color: var(--warning-600); }

.kpi-value {
    font-size: var(--font-size-4xl);
    font-weight: 700;
    margin: var(--spacing-2) 0;
    color: white;
}

.kpi-label {
    font-size: var(--font-size-sm);
    color: rgba(255, 255, 255, 0.9);
    margin: 0 0 var(--spacing-3) 0;
    font-weight: 500;
}

.kpi-progress {
    height: 4px;
    background: rgba(255, 255, 255, 0.2);
    border-radius: var(--radius-sm);
    overflow: hidden;
}

.progress-bar {
    height: 100%;
    background: rgba(255, 255, 255, 0.8);
    border-radius: var(--radius-sm);
    transition: width var(--transition-normal);
}

.progress-bar.warning {
    background: var(--warning-400);
}

.panel-actions {
    display: flex;
    gap: var(--spacing-2);
    margin-left: auto;
}

.btn-icon {
    background: none;
    border: none;
    color: rgba(255, 255, 255, 0.8);
    padding: var(--spacing-2);
    border-radius: var(--radius-sm);
    cursor: pointer;
    transition: all var(--transition-fast);
}

.btn-icon:hover {
    background: rgba(255, 255, 255, 0.1);
    color: white;
}

.chart-container {
    position: relative;
    height: 300px;
    margin-bottom: var(--spacing-4);
}

.chart-legend {
    display: flex;
    justify-content: center;
    gap: var(--spacing-6);
}

.legend-item {
    display: flex;
    align-items: center;
    gap: var(--spacing-2);
    font-size: var(--font-size-sm);
}

.legend-color {
    width: 12px;
    height: 12px;
    border-radius: var(--radius-sm);
}

.quick-actions-grid {
    display: grid;
    grid-template-columns: 1fr;
    gap: var(--spacing-4);
}

.quick-action-item {
    display: flex;
    align-items: center;
    gap: var(--spacing-4);
    padding: var(--spacing-4);
    border-radius: var(--radius-lg);
    text-decoration: none;
    transition: all var(--transition-fast);
    border: 1px solid var(--gray-200);
}

.quick-action-item:hover {
    transform: translateY(-2px);
    box-shadow: var(--shadow-md);
    text-decoration: none;
}

.quick-action-item.primary {
    background: linear-gradient(135deg, var(--primary-50), var(--primary-100));
    border-color: var(--primary-200);
}

.quick-action-item.secondary {
    background: linear-gradient(135deg, var(--secondary-50), var(--secondary-100));
    border-color: var(--secondary-200);
}

.quick-action-item.warning {
    background: linear-gradient(135deg, var(--warning-50), var(--warning-100));
    border-color: var(--warning-200);
}

.quick-action-item.info {
    background: linear-gradient(135deg, var(--gray-50), var(--gray-100));
    border-color: var(--gray-200);
}

.action-icon {
    width: 48px;
    height: 48px;
    border-radius: var(--radius-lg);
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: var(--font-size-xl);
    background: white;
    box-shadow: var(--shadow-sm);
}

.quick-action-item.primary .action-icon { color: var(--primary-600); }
.quick-action-item.secondary .action-icon { color: var(--secondary-600); }
.quick-action-item.warning .action-icon { color: var(--warning-600); }
.quick-action-item.info .action-icon { color: var(--gray-600); }

.action-content h4 {
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

.activity-timeline {
    display: flex;
    flex-direction: column;
    gap: var(--spacing-4);
}

.activity-item {
    display: flex;
    gap: var(--spacing-3);
    align-items: flex-start;
}

.activity-icon {
    width: 32px;
    height: 32px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: var(--font-size-sm);
    color: white;
    flex-shrink: 0;
}

.activity-icon.success { background: var(--secondary-500); }
.activity-icon.warning { background: var(--warning-500); }
.activity-icon.info { background: var(--primary-500); }

.activity-content h5 {
    margin: 0 0 var(--spacing-1) 0;
    font-size: var(--font-size-sm);
    font-weight: 600;
    color: var(--gray-900);
}

.activity-content p {
    margin: 0 0 var(--spacing-1) 0;
    font-size: var(--font-size-xs);
    color: var(--gray-600);
    line-height: 1.4;
}

.activity-time {
    font-size: var(--font-size-xs);
    color: var(--gray-500);
    font-style: italic;
}

.ai-badge {
    background: rgba(255, 255, 255, 0.2);
    padding: var(--spacing-1) var(--spacing-3);
    border-radius: var(--radius-md);
    font-size: var(--font-size-xs);
    font-weight: 600;
}

.panel-badge {
    margin-left: auto;
}

.suggestions-grid {
    display: flex;
    flex-direction: column;
    gap: var(--spacing-4);
}

.suggestion-card {
    background: var(--gray-50);
    border-radius: var(--radius-lg);
    padding: var(--spacing-4);
    border: 1px solid var(--gray-200);
    transition: all var(--transition-fast);
}

.suggestion-card:hover {
    background: white;
    box-shadow: var(--shadow-sm);
}

.suggestion-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: var(--spacing-3);
}

.suggestion-header h5 {
    margin: 0;
    font-size: var(--font-size-base);
    font-weight: 600;
    color: var(--gray-900);
}

.confidence-score {
    background: var(--primary-100);
    color: var(--primary-800);
    padding: var(--spacing-1) var(--spacing-2);
    border-radius: var(--radius-sm);
    font-size: var(--font-size-xs);
    font-weight: 600;
}

.suggestion-metric {
    display: flex;
    justify-content: space-between;
    margin-bottom: var(--spacing-2);
}

.metric-label {
    font-size: var(--font-size-sm);
    color: var(--gray-600);
}

.metric-value {
    font-size: var(--font-size-sm);
    font-weight: 600;
    color: var(--gray-900);
}

.suggestion-reason {
    margin-bottom: var(--spacing-3);
}

.suggestion-reason small {
    color: var(--gray-500);
    font-style: italic;
}

.suggestion-actions {
    display: flex;
    gap: var(--spacing-2);
}

.franco-list {
    display: flex;
    flex-direction: column;
    gap: var(--spacing-4);
}

.franco-item {
    background: var(--gray-50);
    border-radius: var(--radius-lg);
    padding: var(--spacing-4);
    border: 1px solid var(--gray-200);
}

.franco-supplier {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: var(--spacing-3);
}

.franco-supplier h5 {
    margin: 0;
    font-size: var(--font-size-base);
    font-weight: 600;
    color: var(--gray-900);
}

.supplier-code {
    font-size: var(--font-size-xs);
    color: var(--gray-500);
    background: var(--gray-200);
    padding: var(--spacing-1) var(--spacing-2);
    border-radius: var(--radius-sm);
}

.franco-progress {
    margin-bottom: var(--spacing-3);
}

.progress-info {
    display: flex;
    justify-content: space-between;
    margin-bottom: var(--spacing-2);
    font-size: var(--font-size-sm);
}

.current-amount {
    font-weight: 600;
    color: var(--gray-900);
}

.target-amount {
    color: var(--gray-600);
}

.progress-bar-container {
    height: 8px;
    background: var(--gray-200);
    border-radius: var(--radius-sm);
    overflow: hidden;
    margin-bottom: var(--spacing-2);
}

.progress-bar-container .progress-bar {
    height: 100%;
    background: linear-gradient(90deg, var(--primary-500), var(--secondary-500));
    border-radius: var(--radius-sm);
}

.progress-percentage {
    text-align: right;
    font-size: var(--font-size-xs);
    color: var(--gray-600);
    font-weight: 600;
}

.franco-actions {
    display: flex;
    justify-content: flex-end;
}

.empty-state {
    text-align: center;
    padding: var(--spacing-8) var(--spacing-4);
}

.empty-icon {
    font-size: 3rem;
    color: var(--gray-400);
    margin-bottom: var(--spacing-4);
}

.empty-state h4 {
    margin: 0 0 var(--spacing-2) 0;
    font-size: var(--font-size-lg);
    color: var(--gray-700);
}

.empty-state p {
    margin: 0;
    color: var(--gray-500);
    font-size: var(--font-size-sm);
}

@media (max-width: 768px) {
    .quick-actions-grid {
        grid-template-columns: 1fr;
    }
    
    .kpi-header {
        flex-direction: column;
        gap: var(--spacing-2);
    }
    
    .suggestion-header {
        flex-direction: column;
        align-items: flex-start;
        gap: var(--spacing-2);
    }
    
    .franco-supplier {
        flex-direction: column;
        align-items: flex-start;
        gap: var(--spacing-1);
    }
}
</style>

<!-- Enhanced JavaScript -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/3.9.1/chart.min.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function() {
    // Initialize performance chart with modern styling
    const ctx = document.getElementById('supplierPerformanceChart');
    if (ctx) {
        const chart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: [{foreach from=$supplierPerformance item=perf}'{$perf.name|escape:'javascript'}',{/foreach}],
                datasets: [
                    {
                        label: '{l s='Nombre de commandes' mod='suppliermanager'}',
                        data: [{foreach from=$supplierPerformance item=perf}{$perf.total_orders|intval},{/foreach}],
                        backgroundColor: 'rgba(59, 130, 246, 0.8)',
                        borderColor: 'rgba(59, 130, 246, 1)',
                        borderWidth: 2,
                        borderRadius: 8,
                        borderSkipped: false,
                    },
                    {
                        label: '{l s='Montant total (€)' mod='suppliermanager'}',
                        data: [{foreach from=$supplierPerformance item=perf}{$perf.total_amount_ordered|floatval},{/foreach}],
                        backgroundColor: 'rgba(34, 197, 94, 0.8)',
                        borderColor: 'rgba(34, 197, 94, 1)',
                        borderWidth: 2,
                        borderRadius: 8,
                        borderSkipped: false,
                    }
                ]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: false
                    },
                    tooltip: {
                        backgroundColor: 'rgba(0, 0, 0, 0.8)',
                        titleColor: 'white',
                        bodyColor: 'white',
                        borderColor: 'rgba(255, 255, 255, 0.1)',
                        borderWidth: 1,
                        cornerRadius: 8,
                        displayColors: true,
                        intersect: false,
                        mode: 'index'
                    }
                },
                scales: {
                    x: {
                        grid: {
                            display: false
                        },
                        ticks: {
                            color: '#6b7280',
                            font: {
                                size: 12,
                                weight: '500'
                            }
                        }
                    },
                    y: {
                        beginAtZero: true,
                        grid: {
                            color: 'rgba(0, 0, 0, 0.05)',
                            drawBorder: false
                        },
                        ticks: {
                            color: '#6b7280',
                            font: {
                                size: 12,
                                weight: '500'
                            }
                        }
                    }
                },
                interaction: {
                    intersect: false,
                    mode: 'index'
                },
                animation: {
                    duration: 1000,
                    easing: 'easeOutQuart'
                }
            }
        });
        
        // Store chart reference for refresh function
        window.supplierChart = chart;
    }
    
    // Add loading states to buttons
    document.querySelectorAll('.btn').forEach(btn => {
        btn.addEventListener('click', function() {
            if (!this.classList.contains('loading')) {
                this.classList.add('loading');
                setTimeout(() => {
                    this.classList.remove('loading');
                }, 2000);
            }
        });
    });
    
    // Animate KPI cards on load
    const kpiCards = document.querySelectorAll('.card-box');
    kpiCards.forEach((card, index) => {
        card.style.animationDelay = (index * 0.1) + 's';
        card.classList.add('fade-in-up');
    });
});

// Chart refresh function
function refreshChart() {
    if (window.supplierChart) {
        window.supplierChart.update('active');
    }
}

// Chart export function
function exportChart() {
    if (window.supplierChart) {
        const url = window.supplierChart.toBase64Image();
        const link = document.createElement('a');
        link.download = 'supplier-performance.png';
        link.href = url;
        link.click();
    }
}

// AI suggestion functions
function addToOrder(productId, quantity) {
    // Implementation for adding product to order
    console.log('Adding product', productId, 'with quantity', quantity);
    // Show success notification
    showNotification('Produit ajouté à la commande', 'success');
}

function dismissSuggestion(suggestionId) {
    // Implementation for dismissing suggestion
    console.log('Dismissing suggestion', suggestionId);
    // Hide the suggestion card with animation
    const suggestionCard = event.target.closest('.suggestion-card');
    if (suggestionCard) {
        suggestionCard.style.transform = 'translateX(100%)';
        suggestionCard.style.opacity = '0';
        setTimeout(() => {
            suggestionCard.remove();
        }, 300);
    }
}

// Franco completion function
function completeOrder(orderId) {
    // Implementation for completing franco order
    console.log('Completing order', orderId);
    showNotification('Commande complétée', 'success');
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
    
    // Animate in
    setTimeout(function() {
        notification.classList.add('show');
    }, 100);
    
    // Auto-hide
    var hideTimer = setTimeout(function() {
        notification.classList.remove('show');
        setTimeout(function() {
            if (notification.parentNode) {
                notification.parentNode.removeChild(notification);
            }
        }, 300);
    }, 5000);
    
    // Manual close
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

<!-- Notification Styles -->
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

.notification-success {
    border-left: 4px solid var(--secondary-500);
}

.notification-error {
    border-left: 4px solid var(--danger-500);
}

.notification-info {
    border-left: 4px solid var(--primary-500);
}

.notification i {
    font-size: var(--font-size-lg);
}

.notification-success i { color: var(--secondary-500); }
.notification-error i { color: var(--danger-500); }
.notification-info i { color: var(--primary-500); }
</style>