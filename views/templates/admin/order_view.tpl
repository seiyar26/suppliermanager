<div class="bootstrap fade-in-up">
    <!-- Modern Header -->
    <div class="page-title">
        <h3>
            <i class="icon-shopping-cart"></i> 
            {l s='Commande Fournisseur' mod='suppliermanager'} #{$order->id|intval}
        </h3>
        <p class="page-subtitle">{l s='Détails et gestion de la commande fournisseur' mod='suppliermanager'}</p>
    </div>

    <!-- Action Bar -->
    <div class="action-bar">
        <div class="action-left">
            <div class="status-indicator">
                {if $order->status == 'draft'}
                    <span class="status-badge draft">
                        <i class="icon-edit"></i>
                        {l s='Brouillon' mod='suppliermanager'}
                    </span>
                {elseif $order->status == 'pending'}
                    <span class="status-badge pending">
                        <i class="icon-clock-o"></i>
                        {l s='En attente' mod='suppliermanager'}
                    </span>
                {elseif $order->status == 'sent'}
                    <span class="status-badge sent">
                        <i class="icon-paper-plane"></i>
                        {l s='Envoyée' mod='suppliermanager'}
                    </span>
                {elseif $order->status == 'confirmed'}
                    <span class="status-badge confirmed">
                        <i class="icon-check-circle"></i>
                        {l s='Confirmée' mod='suppliermanager'}
                    </span>
                {elseif $order->status == 'received'}
                    <span class="status-badge received">
                        <i class="icon-truck"></i>
                        {l s='Reçue' mod='suppliermanager'}
                    </span>
                {elseif $order->status == 'cancelled'}
                    <span class="status-badge cancelled">
                        <i class="icon-times"></i>
                        {l s='Annulée' mod='suppliermanager'}
                    </span>
                {/if}
            </div>
        </div>
        <div class="action-right">
            <a href="{$link->getAdminLink('AdminSupplierManagerOrders')}&id_order={$order->id|intval}&generatePdf" class="btn btn-outline-secondary">
                <i class="icon-file-pdf-o"></i>
                {l s='Générer PDF' mod='suppliermanager'}
            </a>
            {if $order->status == 'pending'}
                <a href="{$link->getAdminLink('AdminSupplierManagerOrders')}&id_order={$order->id|intval}&sendOrder" class="btn btn-primary">
                    <i class="icon-envelope"></i>
                    {l s='Envoyer' mod='suppliermanager'}
                </a>
            {/if}
            {if $order->status == 'confirmed'}
                <a href="{$link->getAdminLink('AdminSupplierManagerOrders')}&id_order={$order->id|intval}&receiveOrder" class="btn btn-success">
                    <i class="icon-truck"></i>
                    {l s='Recevoir' mod='suppliermanager'}
                </a>
            {/if}
        </div>
    </div>

    <!-- Main Content -->
    <div class="row main-content">
        <!-- Order Information -->
        <div class="col-lg-8">
            <div class="panel order-details-panel">
                <div class="panel-heading">
                    <i class="icon-info-circle"></i> 
                    {l s='Informations de la commande' mod='suppliermanager'}
                </div>
                <div class="panel-body">
                    <div class="row">
                        <div class="col-lg-6">
                            <div class="info-group">
                                <h6>{l s='Détails généraux' mod='suppliermanager'}</h6>
                                <div class="info-item">
                                    <span class="info-label">{l s='ID Commande' mod='suppliermanager'}</span>
                                    <span class="info-value">#{$order->id|intval}</span>
                                </div>
                                <div class="info-item">
                                    <span class="info-label">{l s='Date' mod='suppliermanager'}</span>
                                    <span class="info-value">{$order->order_date|date_format:'%d/%m/%Y'}</span>
                                </div>
                                <div class="info-item">
                                    <span class="info-label">{l s='Montant total' mod='suppliermanager'}</span>
                                    <span class="info-value amount">{displayPrice price=$order->total_amount|default:0}</span>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-6">
                            <div class="info-group">
                                <h6>{l s='Fournisseur' mod='suppliermanager'}</h6>
                                <div class="info-item">
                                    <span class="info-label">{l s='Nom' mod='suppliermanager'}</span>
                                    <span class="info-value">{$supplier->name|escape:'html':'UTF-8'}</span>
                                </div>
                                <div class="info-item">
                                    <span class="info-label">{l s='Email' mod='suppliermanager'}</span>
                                    <span class="info-value">{if isset($supplier->email) && $supplier->email}{$supplier->email|escape:'html':'UTF-8'}{else}{l s='N/D' mod='suppliermanager'}{/if}</span>
                                </div>
                                <div class="info-item">
                                    <span class="info-label">{l s='IA Suggérée' mod='suppliermanager'}</span>
                                    <span class="info-value">
                                        {if $order->ai_suggested}
                                            <span class="ai-badge active">
                                                <i class="icon-robot"></i>
                                                {l s='Oui' mod='suppliermanager'}
                                            </span>
                                        {else}
                                            <span class="ai-badge inactive">
                                                {l s='Non' mod='suppliermanager'}
                                            </span>
                                        {/if}
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Products Table -->
            <div class="panel products-panel">
                <div class="panel-heading">
                    <i class="icon-archive"></i> 
                    {l s='Produits commandés' mod='suppliermanager'}
                    {if $order->status == 'draft'}
                        <div class="panel-actions">
                            <button class="btn btn-sm btn-primary" id="add-product-btn">
                                <i class="icon-plus"></i>
                                {l s='Ajouter produit' mod='suppliermanager'}
                            </button>
                        </div>
                    {/if}
                </div>
                <div class="panel-body">
                    <div class="table-responsive">
                        <table class="table modern-table">
                            <thead>
                                <tr>
                                    <th>{l s='Produit' mod='suppliermanager'}</th>
                                    <th>{l s='Référence' mod='suppliermanager'}</th>
                                    <th>{l s='Quantité' mod='suppliermanager'}</th>
                                    <th>{l s='Prix unitaire' mod='suppliermanager'}</th>
                                    <th>{l s='Total' mod='suppliermanager'}</th>
                                    {if $order->status == 'draft'}
                                        <th>{l s='Actions' mod='suppliermanager'}</th>
                                    {/if}
                                </tr>
                            </thead>
                            <tbody>
                                {if isset($orderDetails) && count($orderDetails) > 0}
                                    {foreach from=$orderDetails item=detail}
                                        <tr class="product-row">
                                            <td>
                                                <div class="product-info">
                                                    <strong>{$detail.product_name|escape:'html':'UTF-8'}</strong>
                                                    <small>ID: {$detail.id_product|intval}</small>
                                                </div>
                                            </td>
                                            <td>
                                                <span class="product-reference">{$detail.reference|escape:'html':'UTF-8'}</span>
                                            </td>
                                            <td>
                                                {if $order->status == 'draft'}
                                                    <div class="quantity-input">
                                                        <input type="number" class="form-control product-quantity" 
                                                               data-id-order-detail="{$detail.id_order_detail|intval}" 
                                                               value="{$detail.quantity|intval}" min="1">
                                                    </div>
                                                {else}
                                                    <span class="quantity-display">{$detail.quantity|intval}</span>
                                                {/if}
                                            </td>
                                            <td>
                                                <span class="price-display">{displayPrice price=$detail.unit_price|default:0}</span>
                                            </td>
                                            <td>
                                                <span class="total-display">{displayPrice price=($detail.quantity * $detail.unit_price)|default:0}</span>
                                            </td>
                                            {if $order->status == 'draft'}
                                                <td>
                                                    <div class="action-buttons">
                                                        <button class="btn btn-sm btn-outline-primary update-quantity" 
                                                                data-id-order-detail="{$detail.id_order_detail|intval}">
                                                            <i class="icon-refresh"></i>
                                                        </button>
                                                        <a href="{$link->getAdminLink('AdminSupplierManagerOrders')}&id_order={$order->id|intval}&id_order_detail={$detail.id_order_detail|intval}&removeProduct" 
                                                           class="btn btn-sm btn-outline-danger" 
                                                           onclick="return confirm('{l s='Supprimer ce produit ?' js=1 mod='suppliermanager'}');">
                                                            <i class="icon-trash"></i>
                                                        </a>
                                                    </div>
                                                </td>
                                            {/if}
                                        </tr>
                                    {/foreach}
                                {else}
                                    <tr>
                                        <td colspan="{if $order->status == 'draft'}6{else}5{/if}" class="text-center empty-state">
                                            <div class="empty-icon">
                                                <i class="icon-archive"></i>
                                            </div>
                                            <p>{l s='Aucun produit dans cette commande' mod='suppliermanager'}</p>
                                        </td>
                                    </tr>
                                {/if}
                            </tbody>
                            {if isset($orderDetails) && count($orderDetails) > 0}
                                <tfoot>
                                    <tr class="total-row">
                                        <td colspan="2"><strong>{l s='Total' mod='suppliermanager'}</strong></td>
                                        <td><strong id="total-quantity">{$totalQuantity|intval}</strong></td>
                                        <td></td>
                                        <td><strong class="total-amount">{displayPrice price=$order->total_amount|default:0}</strong></td>
                                        {if $order->status == 'draft'}
                                            <td></td>
                                        {/if}
                                    </tr>
                                </tfoot>
                            {/if}
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <!-- Sidebar -->
        <div class="col-lg-4">
            <!-- Status Management -->
            <div class="panel status-panel">
                <div class="panel-heading">
                    <i class="icon-cogs"></i> 
                    {l s='Gestion du statut' mod='suppliermanager'}
                </div>
                <div class="panel-body">
                    <form action="{$link->getAdminLink('AdminSupplierManagerOrders')}" method="post">
                        <div class="form-group">
                            <label>{l s='Changer le statut' mod='suppliermanager'}</label>
                            <select name="status" class="form-control">
                                {foreach from=$statusList key=statusKey item=statusName}
                                    <option value="{$statusKey|escape:'html':'UTF-8'}" {if $order->status == $statusKey}selected="selected"{/if}>
                                        {$statusName|escape:'html':'UTF-8'}
                                    </option>
                                {/foreach}
                            </select>
                        </div>
                        <input type="hidden" name="id_order" value="{$order->id|intval}" />
                        <button type="submit" name="updateStatus" class="btn btn-primary btn-block">
                            <i class="icon-refresh"></i> 
                            {l s='Mettre à jour' mod='suppliermanager'}
                        </button>
                    </form>
                </div>
            </div>

            <!-- Supplier Details -->
            {if $supplierExtended}
                <div class="panel supplier-panel">
                    <div class="panel-heading">
                        <i class="icon-truck"></i> 
                        {l s='Conditions fournisseur' mod='suppliermanager'}
                    </div>
                    <div class="panel-body">
                        <div class="supplier-conditions">
                            <div class="condition-item">
                                <span class="condition-label">{l s='Commande min (qté)' mod='suppliermanager'}</span>
                                <span class="condition-value">{$supplierExtended->min_order_quantity|intval}</span>
                            </div>
                            <div class="condition-item">
                                <span class="condition-label">{l s='Commande min (€)' mod='suppliermanager'}</span>
                                <span class="condition-value">{displayPrice price=$supplierExtended->min_order_amount|default:0}</span>
                            </div>
                            <div class="condition-item">
                                <span class="condition-label">{l s='Délai livraison' mod='suppliermanager'}</span>
                                <span class="condition-value">{$supplierExtended->delivery_delay|intval} jours</span>
                            </div>
                        </div>
                    </div>
                </div>
            {/if}

            <!-- Invoices -->
            {if isset($invoices) && count($invoices) > 0}
                <div class="panel invoices-panel">
                    <div class="panel-heading">
                        <i class="icon-file-text"></i> 
                        {l s='Factures associées' mod='suppliermanager'}
                        <span class="badge">{count($invoices)}</span>
                    </div>
                    <div class="panel-body">
                        <div class="invoices-list">
                            {foreach from=$invoices item=invoice}
                                <div class="invoice-item">
                                    <div class="invoice-info">
                                        <strong>{$invoice.invoice_number|escape:'html':'UTF-8'}</strong>
                                        <small>{$invoice.invoice_date|date_format:'%d/%m/%Y'}</small>
                                    </div>
                                    <div class="invoice-amount">
                                        {displayPrice price=$invoice.amount|default:0}
                                    </div>
                                    <div class="invoice-status">
                                        {if $invoice.processed}
                                            <span class="status-badge processed">
                                                <i class="icon-check"></i>
                                            </span>
                                        {else}
                                            <span class="status-badge pending">
                                                <i class="icon-clock-o"></i>
                                            </span>
                                        {/if}
                                    </div>
                                    <div class="invoice-actions">
                                        <a href="{$link->getAdminLink('AdminSupplierManagerInvoices')}&id_invoice={$invoice.id_invoice|intval}&viewsupplier_invoices" 
                                           class="btn btn-xs btn-outline-primary">
                                            <i class="icon-eye"></i>
                                        </a>
                                    </div>
                                </div>
                            {/foreach}
                        </div>
                    </div>
                </div>
            {/if}
        </div>
    </div>
</div>

{if $order->status == 'draft'}
    <!-- Add Product Modal -->
    <div id="add-product-modal" class="modal fade">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title">
                        <i class="icon-plus"></i>
                        {l s='Ajouter un produit' mod='suppliermanager'}
                    </h4>
                </div>
                <div class="modal-body">
                    <form id="add-product-form" action="{$link->getAdminLink('AdminSupplierManagerOrders')}" method="post">
                        <div class="row">
                            <div class="col-lg-8">
                                <div class="form-group">
                                    <label>{l s='Rechercher un produit' mod='suppliermanager'}</label>
                                    <input type="text" id="product-search" class="form-control" 
                                           placeholder="{l s='Tapez le nom, référence ou code-barres...' mod='suppliermanager'}" />
                                    <div id="product-results" class="search-results"></div>
                                    <input type="hidden" name="id_product" id="selected-product-id" />
                                </div>
                                <div id="selected-product-info" class="selected-product" style="display: none;">
                                    <div class="product-card">
                                        <div class="product-details">
                                            <h6 id="selected-product-name"></h6>
                                            <p id="selected-product-ref"></p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-lg-4">
                                <div class="form-group">
                                    <label>{l s='Quantité' mod='suppliermanager'}</label>
                                    <input type="number" name="quantity" class="form-control" value="1" min="1" />
                                </div>
                                <div class="form-group">
                                    <label>{l s='Prix unitaire' mod='suppliermanager'}</label>
                                    <div class="input-group">
                                        {if isset($currency) && $currency->sign}
                                            <span class="input-group-addon">{$currency->sign}</span>
                                        {/if}
                                        <input type="number" name="unit_price" class="form-control" value="0" min="0" step="0.01" />
                                    </div>
                                </div>
                            </div>
                        </div>
                        <input type="hidden" name="id_order" value="{$order->id|intval}" />
                        <input type="hidden" name="addProduct" value="1" />
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-secondary" data-dismiss="modal">
                        {l s='Annuler' mod='suppliermanager'}
                    </button>
                    <button type="button" class="btn btn-primary" id="add-product-submit">
                        <i class="icon-plus"></i>
                        {l s='Ajouter le produit' mod='suppliermanager'}
                    </button>
                </div>
            </div>
        </div>
    </div>
{/if}

<!-- Enhanced JavaScript -->
<script>
document.addEventListener('DOMContentLoaded', function() {
    // Update quantity functionality
    var updateButtons = document.querySelectorAll('.update-quantity');
    updateButtons.forEach(function(button) {
        button.addEventListener('click', function() {
            var idOrderDetail = this.getAttribute('data-id-order-detail');
            var quantityInput = document.querySelector('.product-quantity[data-id-order-detail="' + idOrderDetail + '"]');
            var quantity = quantityInput.value;
            
            if (quantity < 1) {
                showNotification('La quantité doit être supérieure à 0', 'error');
                return;
            }
            
            // Show loading state
            this.classList.add('loading');
            
            var xhr = new XMLHttpRequest();
            xhr.open('POST', '{$link->getAdminLink('AdminSupplierManagerOrders')|addslashes}');
            xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
            
            var self = this;
            xhr.onreadystatechange = function() {
                if (xhr.readyState === 4) {
                    self.classList.remove('loading');
                    if (xhr.status === 200) {
                        showNotification('Quantité mise à jour avec succès', 'success');
                        setTimeout(function() {
                            location.reload();
                        }, 1000);
                    } else {
                        showNotification('Erreur lors de la mise à jour', 'error');
                    }
                }
            };
            
            xhr.send('ajax=1&action=updateQuantity&id_order_detail=' + idOrderDetail + '&quantity=' + quantity);
        });
    });

    {if $order->status == 'draft'}
        // Add product modal
        var addProductBtn = document.getElementById('add-product-btn');
        if (addProductBtn) {
            addProductBtn.addEventListener('click', function() {
                var modal = document.getElementById('add-product-modal');
                if (modal) {
                    modal.style.display = 'block';
                    modal.classList.add('show');
                }
            });
        }

        // Product search functionality
        var searchInput = document.getElementById('product-search');
        var searchTimeout;
        
        if (searchInput) {
            searchInput.addEventListener('keyup', function() {
                clearTimeout(searchTimeout);
                var query = this.value;
                
                if (query.length < 3) {
                    document.getElementById('product-results').innerHTML = '';
                    return;
                }
                
                searchTimeout = setTimeout(function() {
                    var xhr = new XMLHttpRequest();
                    xhr.open('POST', '{$link->getAdminLink('AdminSupplierManagerOrders')|addslashes}');
                    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
                    
                    xhr.onreadystatechange = function() {
                        if (xhr.readyState === 4 && xhr.status === 200) {
                            try {
                                var products = JSON.parse(xhr.responseText);
                                var html = '';
                                
                                if (products.length > 0) {
                                    html += '<div class="search-results-list">';
                                    products.forEach(function(product) {
                                        html += '<div class="search-item" data-id="' + product.id_product + '" data-name="' + product.name + '" data-ref="' + (product.reference || '') + '" data-price="' + (product.product_supplier_price_te || 0) + '">';
                                        html += '<div class="product-name">' + product.name + '</div>';
                                        if (product.reference) {
                                            html += '<div class="product-ref">Réf: ' + product.reference + '</div>';
                                        }
                                        html += '</div>';
                                    });
                                    html += '</div>';
                                } else {
                                    html = '<div class="no-results">Aucun produit trouvé</div>';
                                }
                                
                                document.getElementById('product-results').innerHTML = html;
                                
                                // Add click handlers to search results
                                var searchItems = document.querySelectorAll('.search-item');
                                searchItems.forEach(function(item) {
                                    item.addEventListener('click', function() {
                                        var id = this.getAttribute('data-id');
                                        var name = this.getAttribute('data-name');
                                        var ref = this.getAttribute('data-ref');
                                        var price = this.getAttribute('data-price');
                                        
                                        document.getElementById('selected-product-id').value = id;
                                        document.getElementById('selected-product-name').textContent = name;
                                        document.getElementById('selected-product-ref').textContent = 'Réf: ' + ref;
                                        document.querySelector('input[name="unit_price"]').value = price;
                                        
                                        document.getElementById('product-results').innerHTML = '';
                                        document.getElementById('product-search').value = '';
                                        document.getElementById('selected-product-info').style.display = 'block';
                                    });
                                });
                            } catch (e) {
                                console.error('Error parsing search results:', e);
                            }
                        }
                    };
                    
                    xhr.send('ajax=1&action=SearchProducts&q=' + encodeURIComponent(query) + '&id_supplier={$supplier->id|intval}');
                }, 500);
            });
        }

        // Add product form submission
        var addProductSubmit = document.getElementById('add-product-submit');
        if (addProductSubmit) {
            addProductSubmit.addEventListener('click', function() {
                var productId = document.getElementById('selected-product-id').value;
                if (!productId) {
                    showNotification('Veuillez sélectionner un produit', 'error');
                    return;
                }
                
                document.getElementById('add-product-form').submit();
            });
        }

        // Modal close functionality
        var modal = document.getElementById('add-product-modal');
        if (modal) {
            var closeBtn = modal.querySelector('.close');
            var cancelBtn = modal.querySelector('.btn-outline-secondary');
            
            function closeModal() {
                modal.style.display = 'none';
                modal.classList.remove('show');
            }
            
            if (closeBtn) closeBtn.addEventListener('click', closeModal);
            if (cancelBtn) cancelBtn.addEventListener('click', closeModal);
            
            modal.addEventListener('click', function(e) {
                if (e.target === modal) {
                    closeModal();
                }
            });
        }
    {/if}
});

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