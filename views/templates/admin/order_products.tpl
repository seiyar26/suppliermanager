<div class="panel products-management-panel">
    <div class="panel-heading">
        <i class="icon-list-ul"></i> 
        {l s='Gestion des produits' mod='suppliermanager'}
    </div>
    <div class="panel-body">
        <!-- Product Search -->
        <div class="product-search-section">
            <div class="form-group">
                <label class="control-label">{l s='Ajouter un produit' mod='suppliermanager'}</label>
                <div class="search-input-container">
                    <input type="text" id="product_search" class="form-control" 
                           placeholder="{l s='Rechercher par nom, référence, code-barres...' mod='suppliermanager'}">
                    <i class="icon-search search-icon"></i>
                </div>
                <div id="search-results" class="search-results"></div>
            </div>
        </div>

        <!-- Products Table -->
        <div class="products-table-container">
            <table class="table modern-products-table" id="order-products-table">
                <thead>
                    <tr>
                        <th>{l s='Produit' mod='suppliermanager'}</th>
                        <th>{l s='Référence' mod='suppliermanager'}</th>
                        <th class="text-center">{l s='Prix unitaire' mod='suppliermanager'}</th>
                        <th class="text-center">{l s='Quantité' mod='suppliermanager'}</th>
                        <th class="text-right">{l s='Total' mod='suppliermanager'}</th>
                        <th class="text-center">{l s='Actions' mod='suppliermanager'}</th>
                    </tr>
                </thead>
                <tbody>
                    {if isset($orderDetails) && count($orderDetails) > 0}
                        {foreach from=$orderDetails item=detail}
                            <tr class="product-row" data-product-id="{$detail.id_product}">
                                <td>
                                    <div class="product-info">
                                        <strong class="product-name">{$detail.product_name|escape:'html':'UTF-8'}</strong>
                                        <small class="product-id">ID: {$detail.id_product|intval}</small>
                                    </div>
                                </td>
                                <td>
                                    <span class="product-reference">{$detail.reference|escape:'html':'UTF-8'}</span>
                                </td>
                                <td class="text-center">
                                    <span class="price-display">{displayPrice price=$detail.unit_price|default:0}</span>
                                </td>
                                <td class="text-center">
                                    <div class="quantity-controls">
                                        <form action="{$link->getAdminLink('AdminSupplierManagerOrders')|escape:'html':'UTF-8'}&id_order={$order->id|intval}" 
                                              method="post" class="quantity-form">
                                            <input type="hidden" name="id_order_detail" value="{$detail.id_order_detail}">
                                            <input type="hidden" name="token" value="{$currentToken|escape:'html':'UTF-8'}">
                                            <div class="quantity-input-group">
                                                <button type="button" class="quantity-btn quantity-minus" data-action="decrease">
                                                    <i class="icon-minus"></i>
                                                </button>
                                                <input type="number" name="quantity" value="{$detail.quantity|intval}" 
                                                       class="form-control quantity-input" min="1" max="9999">
                                                <button type="button" class="quantity-btn quantity-plus" data-action="increase">
                                                    <i class="icon-plus"></i>
                                                </button>
                                            </div>
                                            <button type="submit" name="updateQuantity" class="btn btn-sm btn-primary update-btn">
                                                <i class="icon-save"></i>
                                                {l s='Sauver' mod='suppliermanager'}
                                            </button>
                                        </form>
                                    </div>
                                </td>
                                <td class="text-right">
                                    <span class="total-price">{displayPrice price=($detail.unit_price|default:0 * $detail.quantity|default:0)}</span>
                                </td>
                                <td class="text-center">
                                    <form action="{$link->getAdminLink('AdminSupplierManagerOrders')|escape:'html':'UTF-8'}&id_order={$order->id|intval}" 
                                          method="post" class="remove-form">
                                        <input type="hidden" name="id_order_detail" value="{$detail.id_order_detail}">
                                        <input type="hidden" name="token" value="{$currentToken|escape:'html':'UTF-8'}">
                                        <button type="submit" name="removeProduct" class="btn btn-sm btn-danger remove-btn"
                                                onclick="return confirm('{l s='Supprimer ce produit de la commande ?' js=1 mod='suppliermanager'}');">
                                            <i class="icon-trash"></i>
                                            {l s='Supprimer' mod='suppliermanager'}
                                        </button>
                                    </form>
                                </td>
                            </tr>
                        {/foreach}
                    {else}
                        <tr>
                            <td colspan="6" class="text-center empty-products">
                                <div class="empty-state">
                                    <i class="icon-archive empty-icon"></i>
                                    <p>{l s='Aucun produit dans cette commande' mod='suppliermanager'}</p>
                                    <small>{l s='Utilisez la recherche ci-dessus pour ajouter des produits' mod='suppliermanager'}</small>
                                </div>
                            </td>
                        </tr>
                    {/if}
                </tbody>
                {if isset($orderDetails) && count($orderDetails) > 0}
                    <tfoot>
                        <tr class="total-row">
                            <td colspan="3"><strong>{l s='Total de la commande' mod='suppliermanager'}</strong></td>
                            <td class="text-center">
                                <strong id="total-quantity">
                                    {assign var="totalQty" value=0}
                                    {foreach from=$orderDetails item=detail}
                                        {assign var="totalQty" value=$totalQty+$detail.quantity}
                                    {/foreach}
                                    {$totalQty}
                                </strong>
                            </td>
                            <td class="text-right">
                                <strong id="total-amount">
                                    {assign var="totalAmount" value=0}
                                    {foreach from=$orderDetails item=detail}
                                        {assign var="totalAmount" value=$totalAmount+($detail.unit_price*$detail.quantity)}
                                    {/foreach}
                                    {displayPrice price=$totalAmount}
                                </strong>
                            </td>
                            <td></td>
                        </tr>
                    </tfoot>
                {/if}
            </table>
        </div>
    </div>
</div>

<!-- Enhanced Styles -->
<style>
.products-management-panel {
    margin-bottom: var(--spacing-6);
}

.product-search-section {
    background: var(--gray-50);
    padding: var(--spacing-5);
    border-radius: var(--radius-lg);
    margin-bottom: var(--spacing-6);
    border: 1px solid var(--gray-200);
}

.search-input-container {
    position: relative;
}

.search-icon {
    position: absolute;
    right: var(--spacing-4);
    top: 50%;
    transform: translateY(-50%);
    color: var(--gray-400);
    pointer-events: none;
}

.search-results {
    position: absolute;
    z-index: 1000;
    background: white;
    border: 1px solid var(--gray-300);
    border-radius: var(--radius-md);
    box-shadow: var(--shadow-lg);
    width: 100%;
    max-height: 300px;
    overflow-y: auto;
    margin-top: var(--spacing-1);
    display: none;
}

.search-results.show {
    display: block;
}

.search-result-item {
    padding: var(--spacing-3) var(--spacing-4);
    border-bottom: 1px solid var(--gray-200);
    cursor: pointer;
    transition: all var(--transition-fast);
}

.search-result-item:hover {
    background: var(--primary-50);
    color: var(--primary-700);
}

.search-result-item:last-child {
    border-bottom: none;
}

.modern-products-table {
    border-collapse: separate;
    border-spacing: 0;
    border-radius: var(--radius-lg);
    overflow: hidden;
    box-shadow: var(--shadow-sm);
}

.modern-products-table thead th {
    background: linear-gradient(135deg, var(--primary-600), var(--primary-700));
    color: white;
    font-weight: 600;
    padding: var(--spacing-4);
    text-transform: uppercase;
    font-size: var(--font-size-xs);
    letter-spacing: 0.05em;
    border: none;
}

.modern-products-table tbody tr {
    transition: all var(--transition-fast);
    border-bottom: 1px solid var(--gray-200);
}

.modern-products-table tbody tr:hover {
    background: var(--gray-50);
    transform: scale(1.01);
}

.modern-products-table tbody td {
    padding: var(--spacing-4);
    vertical-align: middle;
    border: none;
}

.product-info {
    display: flex;
    flex-direction: column;
    gap: var(--spacing-1);
}

.product-name {
    font-size: var(--font-size-base);
    color: var(--gray-900);
    font-weight: 600;
}

.product-id {
    font-size: var(--font-size-xs);
    color: var(--gray-500);
}

.product-reference {
    font-family: 'Courier New', monospace;
    background: var(--gray-100);
    padding: var(--spacing-1) var(--spacing-2);
    border-radius: var(--radius-sm);
    font-size: var(--font-size-xs);
    color: var(--gray-700);
}

.price-display {
    font-weight: 600;
    color: var(--primary-600);
    font-size: var(--font-size-base);
}

.quantity-controls {
    display: flex;
    flex-direction: column;
    gap: var(--spacing-3);
    align-items: center;
}

.quantity-input-group {
    display: flex;
    align-items: center;
    border: 1px solid var(--gray-300);
    border-radius: var(--radius-md);
    overflow: hidden;
    background: white;
}

.quantity-btn {
    background: var(--gray-100);
    border: none;
    width: 32px;
    height: 32px;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    transition: all var(--transition-fast);
    color: var(--gray-600);
}

.quantity-btn:hover {
    background: var(--primary-100);
    color: var(--primary-600);
}

.quantity-input {
    border: none;
    width: 60px;
    text-align: center;
    padding: var(--spacing-2);
    font-weight: 600;
    background: white;
}

.quantity-input:focus {
    outline: none;
    background: var(--primary-50);
}

.update-btn {
    font-size: var(--font-size-xs);
    padding: var(--spacing-1) var(--spacing-3);
}

.total-price {
    font-weight: 600;
    color: var(--gray-900);
    font-size: var(--font-size-base);
}

.remove-btn {
    font-size: var(--font-size-xs);
    padding: var(--spacing-1) var(--spacing-3);
}

.empty-products {
    padding: var(--spacing-8) var(--spacing-4);
}

.empty-state {
    text-align: center;
    color: var(--gray-500);
}

.empty-icon {
    font-size: 48px;
    color: var(--gray-300);
    margin-bottom: var(--spacing-4);
}

.empty-state p {
    font-size: var(--font-size-base);
    margin: 0 0 var(--spacing-2) 0;
    color: var(--gray-600);
}

.empty-state small {
    font-size: var(--font-size-sm);
    color: var(--gray-500);
}

.total-row {
    background: linear-gradient(135deg, var(--gray-50), var(--gray-100));
    font-weight: 600;
}

.total-row td {
    border-top: 2px solid var(--primary-500);
    padding: var(--spacing-5) var(--spacing-4);
}

#total-quantity {
    color: var(--primary-600);
    font-size: var(--font-size-lg);
}

#total-amount {
    color: var(--primary-600);
    font-size: var(--font-size-lg);
}

/* Responsive Design */
@media (max-width: 768px) {
    .modern-products-table {
        font-size: var(--font-size-sm);
    }
    
    .modern-products-table thead th,
    .modern-products-table tbody td {
        padding: var(--spacing-3);
    }
    
    .quantity-controls {
        flex-direction: row;
        gap: var(--spacing-2);
    }
    
    .update-btn,
    .remove-btn {
        padding: var(--spacing-1) var(--spacing-2);
        font-size: var(--font-size-xs);
    }
    
    .product-info {
        gap: var(--spacing-1);
    }
    
    .product-name {
        font-size: var(--font-size-sm);
    }
}
</style>

<!-- Enhanced JavaScript -->
<script>
var currentToken = '{$currentToken|escape:'html':'UTF-8'}';
var addOrderFormAction = '{$link->getAdminLink('AdminSupplierManagerOrders')|escape:'html':'UTF-8'}&id_order={$order->id|intval}';
var quantityPromptText = '{l s='Quantité à ajouter :' mod='suppliermanager' js=1}';
var supplierId = {$order->id_supplier|intval};

document.addEventListener('DOMContentLoaded', function() {
    console.log('Initializing product management with supplier ID:', supplierId);
    
    // Quantity controls
    var quantityBtns = document.querySelectorAll('.quantity-btn');
    quantityBtns.forEach(function(btn) {
        btn.addEventListener('click', function() {
            var action = this.getAttribute('data-action');
            var input = this.parentNode.querySelector('.quantity-input');
            var currentValue = parseInt(input.value) || 1;
            
            if (action === 'increase') {
                input.value = currentValue + 1;
            } else if (action === 'decrease' && currentValue > 1) {
                input.value = currentValue - 1;
            }
            
            // Update total for this row
            updateRowTotal(input.closest('tr'));
        });
    });
    
    // Product search functionality
    var searchInput = document.getElementById('product_search');
    var searchResults = document.getElementById('search-results');
    var searchTimeout;
    
    if (searchInput) {
        searchInput.addEventListener('keyup', function() {
            clearTimeout(searchTimeout);
            var query = this.value.trim();
            
            if (query.length < 3) {
                hideSearchResults();
                return;
            }
            
            searchTimeout = setTimeout(function() {
                performProductSearch(query);
            }, 500);
        });
        
        // Hide search results when clicking outside
        document.addEventListener('click', function(e) {
            if (!searchInput.contains(e.target) && !searchResults.contains(e.target)) {
                hideSearchResults();
            }
        });
    }
    
    function performProductSearch(query) {
        var xhr = new XMLHttpRequest();
        xhr.open('POST', '{$link->getAdminLink('AdminSupplierManagerOrders')|escape:'html':'UTF-8'}');
        xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
        
        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4) {
                if (xhr.status === 200) {
                    try {
                        var products = JSON.parse(xhr.responseText);
                        displaySearchResults(products);
                    } catch (e) {
                        console.error('Error parsing search results:', e);
                        hideSearchResults();
                    }
                } else {
                    console.error('Search request failed:', xhr.status);
                    hideSearchResults();
                }
            }
        };
        
        var params = 'ajax=1&action=SearchProducts&q=' + encodeURIComponent(query) + 
                    '&id_supplier=' + supplierId + '&token=' + encodeURIComponent(currentToken);
        xhr.send(params);
    }
    
    function displaySearchResults(products) {
        var html = '';
        
        if (products.length > 0) {
            products.forEach(function(product) {
                html += '<div class="search-result-item" data-product=\'' + JSON.stringify(product) + '\'>';
                html += '<div class="product-name">' + product.name + '</div>';
                if (product.reference) {
                    html += '<div class="product-ref">Réf: ' + product.reference + '</div>';
                }
                if (product.product_supplier_price_te) {
                    html += '<div class="product-price">Prix: ' + product.product_supplier_price_te + ' €</div>';
                }
                html += '</div>';
            });
        } else {
            html = '<div class="search-result-item no-results">Aucun produit trouvé</div>';
        }
        
        searchResults.innerHTML = html;
        searchResults.classList.add('show');
        
        // Add click handlers
        var resultItems = searchResults.querySelectorAll('.search-result-item[data-product]');
        resultItems.forEach(function(item) {
            item.addEventListener('click', function() {
                var product = JSON.parse(this.getAttribute('data-product'));
                addProductToOrder(product);
            });
        });
    }
    
    function hideSearchResults() {
        if (searchResults) {
            searchResults.classList.remove('show');
            searchResults.innerHTML = '';
        }
    }
    
    function addProductToOrder(product) {
        var quantity = prompt(quantityPromptText, "1");
        if (quantity != null && parseInt(quantity) > 0) {
            var price = product.product_supplier_price_te ? product.product_supplier_price_te : '0.00';
            
            var form = document.createElement('form');
            form.action = addOrderFormAction;
            form.method = 'post';
            form.style.display = 'none';
            
            var fields = {
                'addProduct': '1',
                'id_product': product.id_product,
                'quantity': quantity,
                'unit_price': price,
                'token': currentToken
            };
            
            for (var key in fields) {
                var input = document.createElement('input');
                input.type = 'hidden';
                input.name = key;
                input.value = fields[key];
                form.appendChild(input);
            }
            
            document.body.appendChild(form);
            form.submit();
        }
    }
    
    function updateRowTotal(row) {
        var quantityInput = row.querySelector('.quantity-input');
        var priceElement = row.querySelector('.price-display');
        var totalElement = row.querySelector('.total-price');
        
        if (quantityInput && priceElement && totalElement) {
            var quantity = parseInt(quantityInput.value) || 0;
            var priceText = priceElement.textContent.replace(/[^\d.,]/g, '').replace(',', '.');
            var price = parseFloat(priceText) || 0;
            var total = quantity * price;
            
            // Format the total (basic formatting)
            totalElement.textContent = total.toFixed(2) + ' €';
        }
        
        // Update global totals
        updateGlobalTotals();
    }
    
    function updateGlobalTotals() {
        var totalQuantity = 0;
        var totalAmount = 0;
        
        var rows = document.querySelectorAll('.product-row');
        rows.forEach(function(row) {
            var quantityInput = row.querySelector('.quantity-input');
            var priceElement = row.querySelector('.price-display');
            
            if (quantityInput && priceElement) {
                var quantity = parseInt(quantityInput.value) || 0;
                var priceText = priceElement.textContent.replace(/[^\d.,]/g, '').replace(',', '.');
                var price = parseFloat(priceText) || 0;
                
                totalQuantity += quantity;
                totalAmount += quantity * price;
            }
        });
        
        var totalQtyElement = document.getElementById('total-quantity');
        var totalAmountElement = document.getElementById('total-amount');
        
        if (totalQtyElement) {
            totalQtyElement.textContent = totalQuantity;
        }
        
        if (totalAmountElement) {
            totalAmountElement.textContent = totalAmount.toFixed(2) + ' €';
        }
    }
    
    // Initialize totals
    updateGlobalTotals();
});
</script>