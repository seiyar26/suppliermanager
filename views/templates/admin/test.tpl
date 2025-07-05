<div class="bootstrap">
    <div class="page-title">
        <h3>
            <i class="icon-cog"></i>
            Test Template - Supplier Manager
        </h3>
        <p class="page-subtitle">Template de test pour vérifier le CSS</p>
    </div>
    
    <div class="row stats-section">
        <div class="col-lg-3">
            <div class="stat-card total-value">
                <div class="stat-icon">
                    <i class="icon-check"></i>
                </div>
                <div class="stat-content">
                    <h3>CSS</h3>
                    <p>Fonctionne</p>
                    <div class="stat-trend positive">
                        <i class="icon-arrow-up"></i>
                        <span>Styles chargés</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <div class="panel">
        <div class="panel-heading">
            <i class="icon-info"></i>
            Test Panel
        </div>
        <div class="panel-body">
            <p>Si vous voyez ce contenu avec des styles modernes, le CSS fonctionne correctement.</p>
            
            <div class="action-bar">
                <div class="action-left">
                    <div class="search-container">
                        <div class="search-input-group">
                            <i class="icon-search"></i>
                            <input type="text" class="form-control search-input" placeholder="Test de recherche...">
                        </div>
                    </div>
                </div>
                <div class="action-right">
                    <button class="btn btn-primary" onclick="showNotification('Test réussi!', 'success')">
                        <i class="icon-check"></i>
                        Test Notification
                    </button>
                </div>
            </div>
            
            <table class="table modern-table">
                <thead>
                    <tr>
                        <th>Colonne 1</th>
                        <th>Colonne 2</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>Données test 1</td>
                        <td>Valeur 1</td>
                        <td>
                            <span class="status-badge confirmed">
                                <i class="icon-check"></i>
                                Confirmé
                            </span>
                        </td>
                    </tr>
                    <tr>
                        <td>Données test 2</td>
                        <td>Valeur 2</td>
                        <td>
                            <span class="status-badge pending">
                                <i class="icon-clock-o"></i>
                                En attente
                            </span>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script>
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