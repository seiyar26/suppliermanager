<div class="panel">
    <div class="panel-heading">
        <i class="icon-undo"></i> {l s='Retour Fournisseur' mod='suppliermanager'} #{$return->id|intval}
    </div>
    <div class="row">
        <div class="col-lg-6">
            <div class="panel">
                <div class="panel-heading">
                    <i class="icon-info-circle"></i> {l s='Informations sur le retour' mod='suppliermanager'}
                </div>
                <div class="panel-body">
                    <p><strong>{l s='ID du retour' mod='suppliermanager'}:</strong> #{$return->id|intval}</p>
                    <p><strong>{l s='Date' mod='suppliermanager'}:</strong> {$return->return_date|date_format:'%Y-%m-%d'}</p>
                    <p><strong>{l s='Statut' mod='suppliermanager'}:</strong> {$return->status|escape:'html':'UTF-8'}</p>
                    <p><strong>{l s='Montant total' mod='suppliermanager'}:</strong> {displayPrice price=$return->total_amount}</p>
                    {if $return->id_order}
                        <p><strong>{l s='Commande d\'origine' mod='suppliermanager'}:</strong>
                            <a href="{$link->getAdminLink('AdminSupplierManagerOrders')}&id_order={$return->id_order|intval}&view">
                                #{$return->id_order|intval}
                            </a>
                        </p>
                    {/if}
                </div>
            </div>
        </div>
        <div class="col-lg-6">
            <div class="panel">
                <div class="panel-heading">
                    <i class="icon-truck"></i> {l s='Informations sur le fournisseur' mod='suppliermanager'}
                </div>
                <div class="panel-body">
                    <p><strong>{l s='Nom' mod='suppliermanager'}:</strong> {$supplier->name|escape:'html':'UTF-8'}</p>
                    <p><strong>{l s='E-mail' mod='suppliermanager'}:</strong> {if isset($supplier->email) && $supplier->email}{$supplier->email|escape:'html':'UTF-8'}{else}{l s='N/D' mod='suppliermanager'}{/if}</p>
                </div>
            </div>
        </div>
    </div>

    <div class="panel">
        <div class="panel-heading">
            <i class="icon-archive"></i> {l s='Produits retournés' mod='suppliermanager'}
        </div>
        <div class="panel-body">
            <table class="table product-table">
                <thead>
                    <tr>
                        <th>{l s='ID Produit' mod='suppliermanager'}</th>
                        <th>{l s='Référence' mod='suppliermanager'}</th>
                        <th>{l s='Nom' mod='suppliermanager'}</th>
                        <th>{l s='Quantité' mod='suppliermanager'}</th>
                        <th>{l s='Motif' mod='suppliermanager'}</th>
                        <th>{l s='Prix unitaire' mod='suppliermanager'}</th>
                        <th>{l s='Total' mod='suppliermanager'}</th>
                    </tr>
                </thead>
                <tbody>
                    {if isset($details) && count($details) > 0}
                        {foreach from=$details item=detail}
                            <tr>
                                <td>{$detail.id_product|intval}</td>
                                <td>{$detail.reference|escape:'html':'UTF-8'}</td>
                                <td>{$detail.product_name|escape:'html':'UTF-8'}</td>
                                <td>{$detail.quantity|intval}</td>
                                <td>{$detail.reason|escape:'html':'UTF-8'}</td>
                                <td>{displayPrice price=$detail.unit_price}</td>
                                <td>{displayPrice price=$detail.quantity * $detail.unit_price}</td>
                            </tr>
                        {/foreach}
                    {else}
                        <tr>
                            <td colspan="7" class="text-center">{l s='Aucun produit dans ce retour' mod='suppliermanager'}</td>
                        </tr>
                    {/if}
                </tbody>
            </table>
        </div>
    </div>
</div>
