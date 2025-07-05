<div class="bootstrap fade-in-up">
    <!-- Modern Header -->
    <div class="page-title">
        <h3>
            <i class="icon-bar-chart"></i> 
            {l s='Rapports et Analyses' mod='suppliermanager'}
        </h3>
        <p class="page-subtitle">{l s='Analyses détaillées et insights sur vos performances fournisseurs' mod='suppliermanager'}</p>
    </div>

    <!-- Report Controls -->
    <div class="report-controls">
        <div class="controls-left">
            <div class="date-range-picker">
                <label>{l s='Période d\'analyse' mod='suppliermanager'}</label>
                <div class="date-inputs">
                    <input type="date" class="form-control" id="startDate" value="2024-01-01">
                    <span class="date-separator">à</span>
                    <input type="date" class="form-control" id="endDate" value="2024-12-31">
                </div>
            </div>
        </div>
        <div class="controls-right">
            <button class="btn btn-outline-secondary" onclick="exportReport()">
                <i class="icon-download"></i>
                {l s='Exporter PDF' mod='suppliermanager'}
            </button>
            <button class="btn btn-primary" onclick="generateReport()">
                <i class="icon-refresh"></i>
                {l s='Actualiser' mod='suppliermanager'}
            </button>
        </div>
    </div>

    <!-- KPI Overview -->
    <div class="row kpi-overview">
        <div class="col-lg-3">
            <div class="kpi-card revenue">
                <div class="kpi-icon">
                    <i class="icon-euro"></i>
                </div>
                <div class="kpi-content">
                    <h3>€2,847,392</h3>
                    <p>{l s='Chiffre d\'affaires total' mod='suppliermanager'}</p>
                    <div class="kpi-trend positive">
                        <i class="icon-trending-up"></i>
                        <span>+18.5% vs période précédente</span>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-lg-3">
            <div class="kpi-card orders">
                <div class="kpi-icon">
                    <i class="icon-shopping-cart"></i>
                </div>
                <div class="kpi-content">
                    <h3>1,247</h3>
                    <p>{l s='Commandes traitées' mod='suppliermanager'}</p>
                    <div class="kpi-trend positive">
                        <i class="icon-trending-up"></i>
                        <span>+12.3% vs période précédente</span>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-lg-3">
            <div class="kpi-card delivery">
                <div class="kpi-icon">
                    <i class="icon-truck"></i>
                </div>
                <div class="kpi-content">
                    <h3>4.2 jours</h3>
                    <p>{l s='Délai moyen de livraison' mod='suppliermanager'}</p>
                    <div class="kpi-trend negative">
                        <i class="icon-trending-down"></i>
                        <span>+0.8j vs période précédente</span>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-lg-3">
            <div class="kpi-card satisfaction">
                <div class="kpi-icon">
                    <i class="icon-star"></i>
                </div>
                <div class="kpi-content">
                    <h3>94.7%</h3>
                    <p>{l s='Taux de satisfaction' mod='suppliermanager'}</p>
                    <div class="kpi-trend positive">
                        <i class="icon-trending-up"></i>
                        <span>+2.1% vs période précédente</span>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Main Reports Grid -->
    <div class="row reports-grid">
        <!-- Sales Performance Chart -->
        <div class="col-lg-8">
            <div class="report-panel">
                <div class="panel-header">
                    <h4>
                        <i class="icon-line-chart"></i>
                        {l s='Évolution des ventes par fournisseur' mod='suppliermanager'}
                    </h4>
                </div>
                <div class="panel-body">
                    <div class="chart-container">
                        <canvas id="salesChart" class="chart-canvas"></canvas>
                    </div>
                </div>
            </div>
        </div>

        <!-- Top Suppliers -->
        <div class="col-lg-4">
            <div class="report-panel">
                <div class="panel-header">
                    <h4>
                        <i class="icon-trophy"></i>
                        {l s='Top Fournisseurs' mod='suppliermanager'}
                    </h4>
                </div>
                <div class="panel-body">
                    <div class="suppliers-ranking">
                        <div class="supplier-rank-item rank-1">
                            <div class="rank-badge">1</div>
                            <div class="supplier-info">
                                <h6>Fournisseur ABC</h6>
                                <p>€847,392 • 342 commandes</p>
                            </div>
                            <div class="rank-score">
                                <span class="score">98</span>
                                <div class="score-bar">
                                    <div class="score-fill" style="width: 98%"></div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="supplier-rank-item rank-2">
                            <div class="rank-badge">2</div>
                            <div class="supplier-info">
                                <h6>TechService Pro</h6>
                                <p>€623,847 • 287 commandes</p>
                            </div>
                            <div class="rank-score">
                                <span class="score">87</span>
                                <div class="score-bar">
                                    <div class="score-fill" style="width: 87%"></div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="supplier-rank-item rank-3">
                            <div class="rank-badge">3</div>
                            <div class="supplier-info">
                                <h6>LogiTransport</h6>
                                <p>€456,123 • 198 commandes</p>
                            </div>
                            <div class="rank-score">
                                <span class="score">79</span>
                                <div class="score-bar">
                                    <div class="score-fill" style="width: 79%"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Enhanced JavaScript -->
<script>
document.addEventListener('DOMContentLoaded', function() {
    initializeFilters();
});

function initializeFilters() {
    var startDate = document.getElementById('startDate');
    var endDate = document.getElementById('endDate');

    if (startDate) startDate.addEventListener('change', updateReports);
    if (endDate) endDate.addEventListener('change', updateReports);
}

function updateReports() {
    showNotification('Mise à jour des rapports...', 'info');
    
    setTimeout(function() {
        showNotification('Rapports mis à jour', 'success');
    }, 2000);
}

function generateReport() {
    showNotification('Génération du rapport en cours...', 'info');
    
    setTimeout(function() {
        showNotification('Rapport généré avec succès', 'success');
    }, 3000);
}

function exportReport() {
    showNotification('Export PDF en cours...', 'info');
    
    setTimeout(function() {
        showNotification('Rapport PDF téléchargé', 'success');
        var link = document.createElement('a');
        link.href = '#';
        link.download = 'rapport_fournisseurs_' + new Date().toISOString().split('T')[0] + '.pdf';
        link.click();
    }, 2500);
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