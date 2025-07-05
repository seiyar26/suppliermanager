<div class="panel">
    <div class="panel-heading">
        <i class="icon-archive"></i> {l s='Gestion des stocks' mod='suppliermanager'}
    </div>
    <div class="panel-body">
        <form id="filter-form" class="form-horizontal" method="get">
            <input type="hidden" name="controller" value="AdminSupplierManagerStocks" />
            <input type="hidden" name="token" value="{$token|escape:'html':'UTF-8'}" />
            
            <div class="row">
                <div class="col-lg-3">
                    <div class="form-group">
                        <label class="control-label col-lg-4">{l s='Fournisseur' mod='suppliermanager'}:</label>
                        <div class="col-lg-8">
                            <select name="id_supplier" class="form-control">
                                {foreach from=$suppliers item=supplier}
                                    <option value="{$supplier.id_supplier|intval}" {if $selected_supplier == $supplier.id_supplier}selected="selected"{/if}>{$supplier.name|escape:'html':'UTF-8'}</option>
                                {/foreach}
                            </select>
                        </div>
                    </div>
                </div>
                <div class="col-lg-3">
                    <div class="form-group">
                        <label class="control-label col-lg-4">{l s='Boutique' mod='suppliermanager'}:</label>
                        <div class="col-lg-8">
                            <select name="id_shop" class="form-control">
                                {foreach from=$shops item=shop}
                                    <option value="{$shop.id_shop|intval}" {if $selected_shop == $shop.id_shop}selected="selected"{/if}>{$shop.name|escape:'html':'UTF-8'}</option>
                                {/foreach}
                            </select>
                        </div>
                    </div>
                </div>
                <div class="col-lg-3">
                    <div class="form-group">
                        <label class="control-label col-lg-6">{l s='Seuil de stock' mod='suppliermanager'}:</label>
                        <div class="col-lg-6">
                            <input type="number" name="stock_threshold" class="form-control" value="{$stock_threshold|intval}" min="0" />
                        </div>
                    </div>
                </div>
                <div class="col-lg-3">
                    <div class="form-group">
                        <div class="col-lg-9 col-lg-offset-3">
                            <div class="checkbox">
                                <label>
                                    <input type="checkbox" name="low_stock_only" value="1" {if $low_stock_only}checked="checked"{/if} />
                                    {l s='Afficher uniquement les produits en stock bas' mod='suppliermanager'}
                                </label>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-lg-12 text-center">
                    <button type="submit" class="btn btn-default">
                        <i class="icon-search"></i> {l s='Filtrer' mod='suppliermanager'}
                    </button>
                </div>
            </div>
        </form>
    </div>
</div>

<div class="panel">
    <div class="panel-heading">
        <i class="icon-archive"></i> {l s='Stock des produits' mod='suppliermanager'}
    </div>
    <div class="panel-body">
        <div class="table-responsive">
            <table class="table product-table">
                <thead>
                    <tr>
                        <th>{l s='ID' mod='suppliermanager'}</th>
                        <th>{l s='Référence' mod='suppliermanager'}</th>
                        <th>{l s='Nom' mod='suppliermanager'}</th>
                        <th>{l s='Fournisseur' mod='suppliermanager'}</th>
                        <th>{l s='Stock actuel' mod='suppliermanager'}</th>
                        <th>{l s='Actions' mod='suppliermanager'}</th>
                    </tr>
                </thead>
                <tbody>
                    {if isset($products) && count($products) > 0}
                        {foreach from=$products item=product}
                            <tr class="{if $product.quantity <= $stock_threshold}danger{/if}">
                                <td>{$product.id_product|intval}</td>
                                <td>{$product.reference|escape:'html':'UTF-8'}</td>
                                <td>{$product.name|escape:'html':'UTF-8'}</td>
                                <td>{$product.supplier_name|escape:'html':'UTF-8'}</td>
                                <td>
                                    <input type="number" class="form-control stock-quantity" 
                                           data-id-product="{$product.id_product|intval}" 
                                           value="{$product.quantity|intval}" min="0">
                                </td>
                                <td>
                                    <div class="btn-group">
                                        <button class="btn btn-default btn-xs update-stock" 
                                                data-id-product="{$product.id_product|intval}">
                                            <i class="icon-refresh"></i> {l s='Mettre à jour' mod='suppliermanager'}
                                        </button>
                                        <button class="btn btn-default btn-xs view-history" 
                                                data-id-product="{$product.id_product|intval}"
                                                data-product-name="{$product.name|escape:'html':'UTF-8'}">
                                            <i class="icon-history"></i> {l s='Historique' mod='suppliermanager'}
                                        </button>
                                        <button class="btn btn-default btn-xs get-suggestion" 
                                                data-id-product="{$product.id_product|intval}"
                                                data-product-name="{$product.name|escape:'html':'UTF-8'}">
                                            <i class="icon-lightbulb-o"></i> {l s='Suggestion IA' mod='suppliermanager'}
                                        </button>
                                        <button class="btn btn-default btn-xs add-to-order" 
                                                data-id-product="{$product.id_product|intval}"
                                                data-product-name="{$product.name|escape:'html':'UTF-8'}"
                                                data-id-supplier="{$product.id_supplier|intval}">
                                            <i class="icon-plus"></i> {l s='Commander' mod='suppliermanager'}
                                        </button>
                                    </div>
                                </td>
                            </tr>
                        {/foreach}
                    {else}
                        <tr>
                            <td colspan="6" class="text-center">{l s='Aucun produit trouvé' mod='suppliermanager'}</td>
                        </tr>
                    {/if}
                </tbody>
            </table>
        </div>
    </div>
    <div class="panel-footer">
        <div class="row">
            <div class="col-lg-6">
                <button id="update-all-stocks" class="btn btn-default">
                    <i class="icon-refresh"></i> {l s='Mettre à jour tous les stocks' mod='suppliermanager'}
                </button>
            </div>
            <div class="col-lg-6 text-right">
                <button id="generate-suggestions-btn" class="btn btn-default">
                    <i class="icon-lightbulb-o"></i> {l s='Générer des suggestions IA' mod='suppliermanager'}
                </button>
                <button id="create-order-btn" class="btn btn-default">
                    <i class="icon-plus"></i> {l s='Créer une commande à partir de la sélection' mod='suppliermanager'}
                </button>
            </div>
        </div>
    </div>
</div>

<div id="history-modal" class="modal fade">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">&times;</button>
                <h4 class="modal-title">{l s='Historique du stock' mod='suppliermanager'}: <span id="history-product-name"></span></h4>
            </div>
            <div class="modal-body">
                <div id="history-content">
                    <p class="text-center"><i class="icon-spinner icon-spin"></i> {l s='Chargement...' mod='suppliermanager'}</p>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">{l s='Fermer' mod='suppliermanager'}</button>
            </div>
        </div>
    </div>
</div>

<div id="suggestion-modal" class="modal fade">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">&times;</button>
                <h4 class="modal-title">{l s='Suggestion IA' mod='suppliermanager'}: <span id="suggestion-product-name"></span></h4>
            </div>
            <div class="modal-body">
                <div id="suggestion-content">
                    <p class="text-center"><i class="icon-spinner icon-spin"></i> {l s='Chargement...' mod='suppliermanager'}</p>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">{l s='Fermer' mod='suppliermanager'}</button>
                <button type="button" class="btn btn-primary" id="apply-suggestion">{l s='Appliquer la suggestion' mod='suppliermanager'}</button>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript">
    $(document).ready(function() {
        // Update stock
        $('.update-stock').click(function() {
            var idProduct = $(this).data('id-product');
            var quantity = $('.stock-quantity[data-id-product="' + idProduct + '"]').val();
            
            $.ajax({
                url: '{$link->getAdminLink('AdminSupplierManagerStocks')|addslashes}',
                type: 'POST',
                data: {
                    ajax: 1,
                    action: 'updateStock',
                    id_product: idProduct,
                    id_shop: {$selected_shop|intval},
                    quantity: quantity
                },
                dataType: 'json',
                success: function(response) {
                    if (response.success) {
                        showSuccessMessage('{l s='Stock mis à jour avec succès' js=1 mod='suppliermanager'}');
                    } else {
                        showErrorMessage('{l s='Erreur lors de la mise à jour du stock' js=1 mod='suppliermanager'}');
                    }
                },
                error: function() {
                    showErrorMessage('{l s='Erreur de communication avec le serveur' js=1 mod='suppliermanager'}');
                }
            });
        });

        // Update all stocks
        $('#update-all-stocks').click(function() {
            if (confirm('{l s='Êtes-vous sûr de vouloir mettre à jour tous les stocks ?' js=1 mod='suppliermanager'}')) {
                var stocks = [];
                
                $('.stock-quantity').each(function() {
                    stocks.push({
                        id_product: $(this).data('id-product'),
                        quantity: $(this).val()
                    });
                });
                
                $.ajax({
                    url: '{$link->getAdminLink('AdminSupplierManagerStocks')|addslashes}',
                    type: 'POST',
                    data: {
                        ajax: 1,
                        action: 'updateMultipleStocks',
                        id_shop: {$selected_shop|intval},
                        stocks: stocks
                    },
                    dataType: 'json',
                    success: function(response) {
                        if (response.success) {
                            showSuccessMessage(response.message);
                        } else {
                            showErrorMessage(response.message);
                        }
                    },
                    error: function() {
                        showErrorMessage('{l s='Erreur de communication avec le serveur' js=1 mod='suppliermanager'}');
                    }
                });
            }
        });

        // View history
        $('.view-history').click(function() {
            var idProduct = $(this).data('id-product');
            var productName = $(this).data('product-name');
            
            $('#history-product-name').text(productName);
            $('#history-content').html('<p class="text-center"><i class="icon-spinner icon-spin"></i> {l s='Chargement...' js=1 mod='suppliermanager'}</p>');
            $('#history-modal').modal('show');
            
            $.ajax({
                url: '{$link->getAdminLink('AdminSupplierManagerStocks')|addslashes}',
                type: 'POST',
                data: {
                    ajax: 1,
                    action: 'getProductStockHistory',
                    id_product: idProduct,
                    id_shop: {$selected_shop|intval}
                },
                dataType: 'json',
                success: function(history) {
                    var html = '';
                    
                    if (history.length > 0) {
                        html += '<table class="table">';
                        html += '<thead><tr><th>{l s='Date' js=1 mod='suppliermanager'}</th><th>{l s='Quantité' js=1 mod='suppliermanager'}</th><th>{l s='Type' js=1 mod='suppliermanager'}</th></tr></thead>';
                        html += '<tbody>';
                        
                        $.each(history, function(i, item) {
                            html += '<tr>';
                            html += '<td>' + item.date + '</td>';
                            html += '<td>' + item.quantity + '</td>';
                            html += '<td>' + (item.type == 'order' ? '{l s='Commande client' js=1 mod='suppliermanager'}' : '{l s='Commande fournisseur' js=1 mod='suppliermanager'}') + '</td>';
                            html += '</tr>';
                        });
                        
                        html += '</tbody></table>';
                    } else {
                        html = '<p class="text-center">{l s='Aucun historique disponible pour ce produit' js=1 mod='suppliermanager'}</p>';
                    }
                    
                    $('#history-content').html(html);
                },
                error: function() {
                    $('#history-content').html('<p class="text-center text-danger">{l s='Erreur lors du chargement de l\'historique' js=1 mod='suppliermanager'}</p>');
                }
            });
        });

        // Get AI suggestion
        $('.get-suggestion').click(function() {
            var idProduct = $(this).data('id-product');
            var productName = $(this).data('product-name');
            
            $('#suggestion-product-name').text(productName);
            $('#suggestion-content').html('<p class="text-center"><i class="icon-spinner icon-spin"></i> {l s='Chargement...' js=1 mod='suppliermanager'}</p>');
            $('#suggestion-modal').modal('show');
            
            $.ajax({
                url: '{$link->getAdminLink('AdminSupplierManagerStocks')|addslashes}',
                type: 'POST',
                data: {
                    ajax: 1,
                    action: 'getProductSuggestion',
                    id_product: idProduct,
                    id_shop: {$selected_shop|intval}
                },
                dataType: 'json',
                success: function(suggestion) {
                    var html = '';
                    
                    if (suggestion.quantity > 0) {
                        html += '<div class="alert alert-info">';
                        html += '<p><strong>{l s='Quantité de commande suggérée' js=1 mod='suppliermanager'}:</strong> ' + suggestion.quantity + '</p>';
                        html += '<p><strong>{l s='Confiance' js=1 mod='suppliermanager'}:</strong> ' + (suggestion.confidence * 100).toFixed(0) + '%</p>';
                        html += '</div>';
                        html += '<h4>{l s='Explication' js=1 mod='suppliermanager'}:</h4>';
                        html += '<p>' + suggestion.explanation + '</p>';
                        
                        // Store the suggestion for later use
                        $('#apply-suggestion').data('id-product', idProduct);
                        $('#apply-suggestion').data('quantity', suggestion.quantity);
                        $('#apply-suggestion').show();
                    } else {
                        html = '<p class="text-center">{l s='Aucune suggestion disponible pour ce produit' js=1 mod='suppliermanager'}</p>';
                        $('#apply-suggestion').hide();
                    }
                    
                    $('#suggestion-content').html(html);
                },
                error: function() {
                    $('#suggestion-content').html('<p class="text-center text-danger">{l s='Erreur lors du chargement de la suggestion' js=1 mod='suppliermanager'}</p>');
                    $('#apply-suggestion').hide();
                }
            });
        });

        // Apply suggestion
        $('#apply-suggestion').click(function() {
            var idProduct = $(this).data('id-product');
            var quantity = $(this).data('quantity');
            
            // Add to order selection
            addProductToOrderSelection(idProduct, quantity);
            
            $('#suggestion-modal').modal('hide');
            showSuccessMessage('{l s='Produit ajouté à la sélection de commande' js=1 mod='suppliermanager'}');
        });

        // Generate AI suggestions
        $('#generate-suggestions-btn').click(function() {
            if (confirm('{l s='Cela générera de nouvelles suggestions d\'IA pour tous les produits. Continuer ?' js=1 mod='suppliermanager'}')) {
                $.ajax({
                    url: '{$link->getAdminLink('AdminSupplierManagerStocks')|addslashes}',
                    type: 'POST',
                    data: {
                        ajax: 1,
                        action: 'generateSuggestions',
                        id_shop: {$selected_shop|intval},
                        id_supplier: {$selected_supplier|intval}
                    },
                    dataType: 'json',
                    success: function(response) {
                        if (response.success) {
                            showSuccessMessage(response.message);
                        } else {
                            showErrorMessage(response.message);
                        }
                    },
                    error: function() {
                        showErrorMessage('{l s='Erreur de communication avec le serveur' js=1 mod='suppliermanager'}');
                    }
                });
            }
        });

        // Order selection
        var orderSelection = [];

        function addProductToOrderSelection(idProduct, quantity) {
            // Check if product already exists in selection
            var exists = false;
            
            for (var i = 0; i < orderSelection.length; i++) {
                if (orderSelection[i].id_product == idProduct) {
                    orderSelection[i].quantity = quantity;
                    exists = true;
                    break;
                }
            }
            
            if (!exists) {
                orderSelection.push({
                    id_product: idProduct,
                    quantity: quantity
                });
            }
        }

        // Add to order
        $('.add-to-order').click(function() {
            var idProduct = $(this).data('id-product');
            var productName = $(this).data('product-name');
            var idSupplier = $(this).data('id-supplier');
            
            // Get current stock
            var currentStock = $('.stock-quantity[data-id-product="' + idProduct + '"]').val();
            
            // Ask for quantity
            var quantity = prompt('{l s='Entrez la quantité à commander pour' js=1 mod='suppliermanager'} ' + productName + ':', '1');
            
            if (quantity !== null && quantity > 0) {
                addProductToOrderSelection(idProduct, quantity);
                showSuccessMessage('{l s='Produit ajouté à la sélection de commande' js=1 mod='suppliermanager'}');
            }
        });

        // Create order from selection
        $('#create-order-btn').click(function() {
            if (orderSelection.length === 0) {
                showErrorMessage('{l s='Aucun produit sélectionné pour la commande' js=1 mod='suppliermanager'}');
                return;
            }
            
            // Create form and submit
            var form = $('<form action="{$link->getAdminLink('AdminSupplierManagerStocks')}" method="post"></form>');
            form.append('<input type="hidden" name="createOrder" value="1">');
            form.append('<input type="hidden" name="id_supplier" value="{$selected_supplier|intval}">');
            form.append('<input type="hidden" name="id_shop" value="{$selected_shop|intval}">');
            
            // Add products
            for (var i = 0; i < orderSelection.length; i++) {
                form.append('<input type="hidden" name="products[' + i + '][id_product]" value="' + orderSelection[i].id_product + '">');
                form.append('<input type="hidden" name="products[' + i + '][quantity]" value="' + orderSelection[i].quantity + '">');
                form.append('<input type="hidden" name="products[' + i + '][unit_price]" value="0">');
            }
            
            $('body').append(form);
            form.submit();
        });
    });
</script>