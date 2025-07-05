<div class="panel">
    <div class="panel-heading">
        <i class="icon-file-text"></i> {l s='Facture Fournisseur' mod='suppliermanager'}: {$invoice->invoice_number|escape:'html':'UTF-8'}
    </div>
    <div class="row">
        <div class="col-lg-6">
            <div class="panel">
                <div class="panel-heading">
                    <i class="icon-info-circle"></i> {l s='Informations sur la facture' mod='suppliermanager'}
                </div>
                <div class="panel-body">
                    <div class="row">
                        <div class="col-lg-6">
                            <p><strong>{l s='Numéro de facture' mod='suppliermanager'}:</strong> {$invoice->invoice_number|escape:'html':'UTF-8'}</p>
                            <p><strong>{l s='Date' mod='suppliermanager'}:</strong> {$invoice->invoice_date|date_format:'%Y-%m-%d'}</p>
                            <p><strong>{l s='Montant' mod='suppliermanager'}:</strong> {displayPrice price=$invoice->amount}</p>
                        </div>
                        <div class="col-lg-6">
                            <p><strong>{l s='Traité' mod='suppliermanager'}:</strong>
                                {if $invoice->processed}
                                    <span class="badge badge-success">{l s='Oui' mod='suppliermanager'}</span>
                                {else}
                                    <span class="badge badge-danger">{l s='Non' mod='suppliermanager'}</span>
                                {/if}
                            </p>
                            <p><strong>{l s='Commande associée' mod='suppliermanager'}:</strong>
                                {if $invoice->id_order}
                                    <a href="{$link->getAdminLink('AdminSupplierManagerOrders')}&id_order={$invoice->id_order|intval}&viewsupplier_orders">
                                        #{$invoice->id_order|intval}
                                    </a>
                                {else}
                                    <span class="text-muted">{l s='Aucune commande liée' mod='suppliermanager'}</span>
                                {/if}
                            </p>
                        </div>
                    </div>
                </div>
                <div class="panel-footer">
                    <div class="row">
                        <div class="col-lg-6">
                            <form action="{$link->getAdminLink('AdminSupplierManagerInvoices')}" method="post" class="form-horizontal">
                                <div class="form-group">
                                    <div class="col-lg-12">
                                        <input type="hidden" name="id_invoice" value="{$invoice->id|intval}" />
                                        <button type="submit" name="downloadInvoice" class="btn btn-default">
                                            <i class="icon-download"></i> {l s='Télécharger la facture' mod='suppliermanager'}
                                        </button>
                                    </div>
                                </div>
                            </form>
                        </div>
                        <div class="col-lg-6 text-right">
                            <a href="{$link->getAdminLink('AdminSupplierManagerInvoices')}&id_invoice={$invoice->id|intval}&updatesupplier_invoices" class="btn btn-default">
                                <i class="icon-pencil"></i> {l s='Modifier la facture' mod='suppliermanager'}
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-lg-6">
            <div class="panel">
                <div class="panel-heading">
                    <i class="icon-truck"></i> {l s='Informations sur le fournisseur' mod='suppliermanager'}
                </div>
                <div class="panel-body">
                    <div class="row">
                        <div class="col-lg-6">
                            <p><strong>{l s='Nom' mod='suppliermanager'}:</strong> {$supplier->name|escape:'html':'UTF-8'}</p>
                            <p><strong>{l s='Téléphone' mod='suppliermanager'}:</strong> {$supplier->phone|escape:'html':'UTF-8'}</p>
                            <p><strong>{l s='E-mail' mod='suppliermanager'}:</strong> {$supplier->email|escape:'html':'UTF-8'}</p>
                        </div>
                        <div class="col-lg-6">
                            <p><strong>{l s='Adresse' mod='suppliermanager'}:</strong> {$supplier->address1|escape:'html':'UTF-8'}</p>
                            {if $supplier->address2}
                                <p><strong>{l s='Adresse (2)' mod='suppliermanager'}:</strong> {$supplier->address2|escape:'html':'UTF-8'}</p>
                            {/if}
                            <p><strong>{l s='Ville' mod='suppliermanager'}:</strong> {$supplier->city|escape:'html':'UTF-8'}</p>
                            <p><strong>{l s='Code postal' mod='suppliermanager'}:</strong> {$supplier->postcode|escape:'html':'UTF-8'}</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    {if $invoice->id_order && isset($order) && isset($orderDetails) && count($orderDetails) > 0}
        <div class="panel">
            <div class="panel-heading">
                <i class="icon-archive"></i> {l s='Détails de la commande' mod='suppliermanager'}
            </div>
            <div class="panel-body">
                <table class="table product-table">
                    <thead>
                        <tr>
                            <th>{l s='ID' mod='suppliermanager'}</th>
                            <th>{l s='Référence' mod='suppliermanager'}</th>
                            <th>{l s='Nom' mod='suppliermanager'}</th>
                            <th>{l s='Quantité' mod='suppliermanager'}</th>
                            <th>{l s='Prix unitaire' mod='suppliermanager'}</th>
                            <th>{l s='Total' mod='suppliermanager'}</th>
                        </tr>
                    </thead>
                    <tbody>
                        {foreach from=$orderDetails item=detail}
                            <tr>
                                <td>{$detail.id_product|intval}</td>
                                <td>{$detail.reference|escape:'html':'UTF-8'}</td>
                                <td>{$detail.product_name|escape:'html':'UTF-8'}</td>
                                <td>{$detail.quantity|intval}</td>
                                <td>{displayPrice price=$detail.unit_price}</td>
                                <td>{displayPrice price=$detail.quantity * $detail.unit_price}</td>
                            </tr>
                        {/foreach}
                    </tbody>
                    <tfoot>
                        <tr>
                            <td colspan="5" class="text-right"><strong>{l s='Total' mod='suppliermanager'}:</strong></td>
                            <td><strong>{displayPrice price=$order->total_amount}</strong></td>
                        </tr>
                    </tfoot>
                </table>
            </div>
        </div>
    {elseif !$invoice->id_order}
        <div class="panel">
            <div class="panel-heading">
                <i class="icon-link"></i> {l s='Associer à une commande' mod='suppliermanager'}
            </div>
            <div class="panel-body">
                <p>{l s='Cette facture n\'est liée à aucune commande. Vous pouvez rechercher une commande correspondante ci-dessous :' mod='suppliermanager'}</p>
                
                <div id="matching-orders">
                    <div class="form-group">
                        <button id="find-matching-orders" class="btn btn-default">
                            <i class="icon-search"></i> {l s='Trouver des commandes correspondantes' mod='suppliermanager'}
                        </button>
                    </div>
                    
                    <div id="matching-orders-results" style="display: none;">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>{l s='ID de la commande' mod='suppliermanager'}</th>
                                    <th>{l s='Date' mod='suppliermanager'}</th>
                                    <th>{l s='Montant' mod='suppliermanager'}</th>
                                    <th>{l s='Statut' mod='suppliermanager'}</th>
                                    <th>{l s='Actions' mod='suppliermanager'}</th>
                                </tr>
                            </thead>
                            <tbody id="matching-orders-list">
                            </tbody>
                        </table>
                    </div>
                </div>
                
                <form id="match-order-form" action="{$link->getAdminLink('AdminSupplierManagerInvoices')}" method="post" class="form-horizontal">
                    <div class="form-group">
                        <label class="control-label col-lg-3">{l s='ID de commande manuel' mod='suppliermanager'}:</label>
                        <div class="col-lg-3">
                            <input type="text" name="id_order" class="form-control" />
                        </div>
                        <div class="col-lg-6">
                            <input type="hidden" name="id_invoice" value="{$invoice->id|intval}" />
                            <input type="hidden" name="matchOrder" value="1" />
                            <button type="submit" class="btn btn-default">
                                <i class="icon-link"></i> {l s='Lier à la commande' mod='suppliermanager'}
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    {/if}
</div>

{if !$invoice->id_order}
    <script type="text/javascript">
        $(document).ready(function() {
            $('#find-matching-orders').click(function() {
                $.ajax({
                    url: '{$link->getAdminLink('AdminSupplierManagerInvoices')|addslashes}',
                    type: 'POST',
                    data: {
                        ajax: 1,
                        action: 'findMatchingOrders',
                        id_supplier: {$supplier->id|intval},
                        amount: {$invoice->amount|floatval}
                    },
                    dataType: 'json',
                    success: function(orders) {
                        var html = '';
                        
                        if (orders.length > 0) {
                            $.each(orders, function(i, order) {
                                html += '<tr>';
                                html += '<td>' + order.id_order + '</td>';
                                html += '<td>' + order.order_date + '</td>';
                                html += '<td>' + order.total_amount + '</td>';
                                html += '<td>' + order.status + '</td>';
                                html += '<td>';
                                html += '<a href="#" class="btn btn-default btn-xs select-order" data-id-order="' + order.id_order + '">';
                                html += '<i class="icon-check"></i> {l s='Sélectionner' js=1 mod='suppliermanager'}';
                                html += '</a>';
                                html += '</td>';
                                html += '</tr>';
                            });
                        } else {
                            html = '<tr><td colspan="5" class="text-center">{l s='Aucune commande correspondante trouvée' js=1 mod='suppliermanager'}</td></tr>';
                        }
                        
                        $('#matching-orders-list').html(html);
                        $('#matching-orders-results').show();
                        
                        // Bind select order event
                        $('.select-order').click(function(e) {
                            e.preventDefault();
                            var idOrder = $(this).data('id-order');
                            $('input[name="id_order"]').val(idOrder);
                            $('#match-order-form').submit();
                        });
                    },
                    error: function() {
                        showErrorMessage('{l s='Erreur de communication avec le serveur' js=1 mod='suppliermanager'}');
                    }
                });
            });
        });
    </script>
{/if}