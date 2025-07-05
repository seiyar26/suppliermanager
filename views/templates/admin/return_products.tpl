<div class="panel">
    <div class="panel-heading">
        <i class="icon-list-ul"></i> {l s='Produits du retour' mod='suppliermanager'}
    </div>

    <!-- Product Search -->
    <div class="form-group">
        <label class="control-label col-lg-3">{l s='Ajouter un produit' mod='suppliermanager'}</label>
        <div class="col-lg-9">
            <div class="input-group">
                <input type="text" id="product_search_return" class="form-control" placeholder="{l s='Rechercher un produit par nom, référence...' mod='suppliermanager'}">
                <span class="input-group-addon"><i class="icon-search"></i></span>
            </div>
        </div>
    </div>

    <!-- Product List -->
    <table class="table" id="return-products-table">
        <thead>
            <tr>
                <th>{l s='Produit' mod='suppliermanager'}</th>
                <th>{l s='Référence' mod='suppliermanager'}</th>
                <th class="text-center">{l s='Quantité' mod='suppliermanager'}</th>
                <th>{l s='Motif' mod='suppliermanager'}</th>
                <th class="text-right">{l s='Total (HT)' mod='suppliermanager'}</th>
                <th></th>
            </tr>
        </thead>
        <tbody>
            {if isset($details) && $details}
                {foreach from=$details item=detail}
                <tr>
                    <td>{$detail.product_name}</td>
                    <td>{$detail.reference}</td>
                    <td class="text-center">{$detail.quantity|intval}</td>
                    <td>{$detail.reason|escape:'html':'UTF-8'}</td>
                    <td class="text-right">{displayPrice price=($detail.unit_price * $detail.quantity)}</td>
                    <td class="text-right">
                        <form action="{$link->getAdminLink('AdminSupplierManagerReturns')|escape:'html':'UTF-8'}&id_return={$return->id|intval}" method="post">
                            <input type="hidden" name="id_return_detail" value="{$detail.id_return_detail}">
                            <input type="hidden" name="token" value="{$currentToken|escape:'html':'UTF-8'}">
                            <button type="submit" name="removeProduct" class="btn btn-danger">
                                <i class="icon-trash"></i>
                            </button>
                        </form>
                    </td>
                </tr>
                {/foreach}
            {else}
                <tr>
                    <td colspan="6" class="text-center">{l s='Aucun produit dans ce retour pour le moment.' mod='suppliermanager'}</td>
                </tr>
            {/if}
        </tbody>
    </table>
</div>

<script type="text/javascript">
var currentToken = '{$currentToken|escape:'html':'UTF-8'}';
var addReturnFormAction = '{$link->getAdminLink('AdminSupplierManagerReturns')|escape:'html':'UTF-8'}&id_return={$return->id|intval}';
var quantityPromptText = '{l s='Quantité à retourner :' mod='suppliermanager' js=1}';
var reasonPromptText = '{l s='Motif du retour (ex: abîmé, erreur de livraison) :' mod='suppliermanager' js=1}';
var supplierId = {$return->id_supplier|intval};

{literal}
$(document).ready(function() {
    if (typeof $.fn.autocomplete === 'undefined') {
        console.error('jQuery UI autocomplete not loaded');
        return;
    }
    
    function addProductToReturn(product) {
        var quantity = prompt(quantityPromptText, "1");
        if (quantity != null && parseInt(quantity) > 0) {
            var reason = prompt(reasonPromptText, "");
            var price = product.product_supplier_price_te ? product.product_supplier_price_te : '0.00';
            
            var form = $('<form>', {
                'action': addReturnFormAction,
                'method': 'post'
            });
            
            form.append($('<input>', {'type': 'hidden', 'name': 'addProduct', 'value': '1'}));
            form.append($('<input>', {'type': 'hidden', 'name': 'id_product', 'value': product.id_product}));
            form.append($('<input>', {'type': 'hidden', 'name': 'quantity', 'value': quantity}));
            form.append($('<input>', {'type': 'hidden', 'name': 'reason', 'value': reason}));
            form.append($('<input>', {'type': 'hidden', 'name': 'unit_price', 'value': price}));
            form.append($('<input>', {'type': 'hidden', 'name': 'token', 'value': currentToken}));
            
            $('body').append(form);
            form.submit();
        }
    }
    
    $('#product_search_return').autocomplete({
        source: function(request, response) {
            $.ajax({
                url: '{/literal}{$link->getAdminLink('AdminSupplierManagerOrders')|escape:'html':'UTF-8'}{literal}', // Use order controller to search products
                type: 'POST',
                dataType: 'json',
                data: {
                    ajax: 1,
                    action: 'SearchProducts',
                    q: request.term,
                    id_supplier: supplierId,
                    token: '{/literal}{$currentToken|escape:'html':'UTF-8'}{literal}'
                },
                success: function(data) {
                    response($.map(data, function(item) {
                        return {
                            label: item.name + ' (Ref: ' + (item.reference || 'N/A') + ')',
                            value: item.name,
                            product: item
                        };
                    }));
                }
            });
        },
        minLength: 3,
        select: function(event, ui) {
            addProductToReturn(ui.item.product);
            $(this).val('');
            return false;
        }
    });
});
{/literal}
</script>
