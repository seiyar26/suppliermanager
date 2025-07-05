<div class="panel">
    <div class="panel-heading">
        <i class="icon-truck"></i> {l s='Supplier Details' mod='suppliermanager'}: {$supplier->name|escape:'html':'UTF-8'}
    </div>
    <div class="row">
        <div class="col-lg-6">
            <div class="panel">
                <div class="panel-heading">
                    <i class="icon-info-circle"></i> {l s='General Information' mod='suppliermanager'}
                </div>
                <div class="panel-body">
                    <div class="row">
                        <div class="col-lg-6">
                            <p><strong>{l s='Name' mod='suppliermanager'}:</strong> {$supplier->name|escape:'html':'UTF-8'}</p>
                            <p><strong>{l s='Phone' mod='suppliermanager'}:</strong> {$supplier->phone|escape:'html':'UTF-8'}</p>
                            <p><strong>{l s='Mobile' mod='suppliermanager'}:</strong> {$supplier->phone_mobile|escape:'html':'UTF-8'}</p>
                            <p><strong>{l s='Email' mod='suppliermanager'}:</strong> {$supplier->email|escape:'html':'UTF-8'}</p>
                        </div>
                        <div class="col-lg-6">
                            <p><strong>{l s='Address' mod='suppliermanager'}:</strong> {$supplier->address1|escape:'html':'UTF-8'}</p>
                            {if $supplier->address2}
                                <p><strong>{l s='Address (2)' mod='suppliermanager'}:</strong> {$supplier->address2|escape:'html':'UTF-8'}</p>
                            {/if}
                            <p><strong>{l s='City' mod='suppliermanager'}:</strong> {$supplier->city|escape:'html':'UTF-8'}</p>
                            <p><strong>{l s='Postal Code' mod='suppliermanager'}:</strong> {$supplier->postcode|escape:'html':'UTF-8'}</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-lg-6">
            <div class="panel">
                <div class="panel-heading">
                    <i class="icon-cogs"></i> {l s='Order Conditions' mod='suppliermanager'}
                </div>
                <div class="panel-body">
                    <div class="row">
                        <div class="col-lg-6">
                            <p><strong>{l s='Minimum Order Quantity' mod='suppliermanager'}:</strong> {$supplierExtended->min_order_quantity|intval}</p>
                            <p><strong>{l s='Minimum Order Amount' mod='suppliermanager'}:</strong> {displayPrice price=$supplierExtended->min_order_amount}</p>
                        </div>
                        <div class="col-lg-6">
                            <p><strong>{l s='Delivery Delay' mod='suppliermanager'}:</strong> {$supplierExtended->delivery_delay|intval} {l s='days' mod='suppliermanager'}</p>
                            <p><strong>{l s='Payment Terms' mod='suppliermanager'}:</strong> {$supplierExtended->payment_terms|escape:'html':'UTF-8'}</p>
                            <p><strong>{l s='Auto Order Enabled' mod='suppliermanager'}:</strong> 
                                {if $supplierExtended->auto_order_enabled}
                                    <span class="badge badge-success">{l s='Yes' mod='suppliermanager'}</span>
                                {else}
                                    <span class="badge badge-danger">{l s='No' mod='suppliermanager'}</span>
                                {/if}
                            </p>
                        </div>
                    </div>
                </div>
                <div class="panel-footer">
                    <a href="{$link->getAdminLink('AdminSupplierManagerSuppliers')}&id_supplier={$supplier->id|intval}&updatesupplier" class="btn btn-default">
                        <i class="icon-pencil"></i> {l s='Edit Supplier' mod='suppliermanager'}
                    </a>
                </div>
            </div>
        </div>
    </div>

    <div class="panel">
        <div class="panel-heading">
            <i class="icon-archive"></i> {l s='Products' mod='suppliermanager'}
        </div>
        <div class="panel-body">
            <table class="table product-table">
                <thead>
                    <tr>
                        <th>{l s='ID' mod='suppliermanager'}</th>
                        <th>{l s='Reference' mod='suppliermanager'}</th>
                        <th>{l s='Name' mod='suppliermanager'}</th>
                        <th>{l s='Min Quantity' mod='suppliermanager'}</th>
                        <th>{l s='Current Price' mod='suppliermanager'}</th>
                        <th>{l s='Last Update' mod='suppliermanager'}</th>
                        <th>{l s='Actions' mod='suppliermanager'}</th>
                    </tr>
                </thead>
                <tbody>
                    {if isset($products) && count($products) > 0}
                        {foreach from=$products item=product}
                            <tr>
                                <td>{$product.id_product|intval}</td>
                                <td>{$product.reference|escape:'html':'UTF-8'}</td>
                                <td>{$product.product_name|escape:'html':'UTF-8'}</td>
                                <td>
                                    <input type="number" class="form-control product-min-quantity" 
                                           data-id-product="{$product.id_product|intval}" 
                                           value="{$product.min_quantity|intval}" min="0">
                                </td>
                                <td>
                                    <div class="input-group">
                                        <span class="input-group-addon">{$currency->sign}</span>
                                        <input type="number" class="form-control product-price" 
                                               data-id-product="{$product.id_product|intval}" 
                                               value="{$product.current_price|floatval}" min="0" step="0.01">
                                    </div>
                                </td>
                                <td>{$product.last_update|date_format:'%Y-%m-%d %H:%M'}</td>
                                <td>
                                    <button class="btn btn-default btn-xs update-product-condition" 
                                            data-id-product="{$product.id_product|intval}">
                                        <i class="icon-refresh"></i> {l s='Update' mod='suppliermanager'}
                                    </button>
                                    <a href="{$link->getAdminLink('AdminSupplierManagerOrders')}&add=1&id_supplier={$supplier->id|intval}&id_product={$product.id_product|intval}" 
                                       class="btn btn-default btn-xs">
                                        <i class="icon-plus"></i> {l s='Order' mod='suppliermanager'}
                                    </a>
                                </td>
                            </tr>
                        {/foreach}
                    {else}
                        <tr>
                            <td colspan="7" class="text-center">{l s='No products found for this supplier' mod='suppliermanager'}</td>
                        </tr>
                    {/if}
                </tbody>
            </table>
        </div>
    </div>

    <div class="row">
        <div class="col-lg-6">
            <div class="panel">
                <div class="panel-heading">
                    <i class="icon-shopping-cart"></i> {l s='Recent Orders' mod='suppliermanager'}
                </div>
                <div class="panel-body">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>{l s='ID' mod='suppliermanager'}</th>
                                <th>{l s='Date' mod='suppliermanager'}</th>
                                <th>{l s='Shop' mod='suppliermanager'}</th>
                                <th>{l s='Status' mod='suppliermanager'}</th>
                                <th>{l s='Total' mod='suppliermanager'}</th>
                                <th>{l s='Actions' mod='suppliermanager'}</th>
                            </tr>
                        </thead>
                        <tbody>
                            {if isset($orders) && count($orders) > 0}
                                {foreach from=$orders item=order}
                                    <tr>
                                        <td>{$order.id_order|intval}</td>
                                        <td>{$order.order_date|date_format:'%Y-%m-%d'}</td>
                                        <td>{$order.shop_name|escape:'html':'UTF-8'}</td>
                                        <td>
                                            {if $order.status == 'draft'}
                                                <span class="badge badge-info">{l s='Draft' mod='suppliermanager'}</span>
                                            {elseif $order.status == 'pending'}
                                                <span class="badge badge-warning">{l s='Pending' mod='suppliermanager'}</span>
                                            {elseif $order.status == 'sent'}
                                                <span class="badge badge-warning">{l s='Sent' mod='suppliermanager'}</span>
                                            {elseif $order.status == 'confirmed'}
                                                <span class="badge badge-info">{l s='Confirmed' mod='suppliermanager'}</span>
                                            {elseif $order.status == 'received'}
                                                <span class="badge badge-success">{l s='Received' mod='suppliermanager'}</span>
                                            {elseif $order.status == 'cancelled'}
                                                <span class="badge badge-danger">{l s='Cancelled' mod='suppliermanager'}</span>
                                            {/if}
                                        </td>
                                        <td>{displayPrice price=$order.total_amount}</td>
                                        <td>
                                            <a href="{$link->getAdminLink('AdminSupplierManagerOrders')}&id_order={$order.id_order|intval}&viewsupplier_orders" 
                                               class="btn btn-default btn-xs">
                                                <i class="icon-eye"></i> {l s='View' mod='suppliermanager'}
                                            </a>
                                        </td>
                                    </tr>
                                {/foreach}
                            {else}
                                <tr>
                                    <td colspan="6" class="text-center">{l s='No orders found for this supplier' mod='suppliermanager'}</td>
                                </tr>
                            {/if}
                        </tbody>
                    </table>
                </div>
                <div class="panel-footer">
                    <a href="{$link->getAdminLink('AdminSupplierManagerOrders')}&add=1&id_supplier={$supplier->id|intval}" class="btn btn-default">
                        <i class="icon-plus"></i> {l s='Create New Order' mod='suppliermanager'}
                    </a>
                </div>
            </div>
        </div>
        <div class="col-lg-6">
            <div class="panel">
                <div class="panel-heading">
                    <i class="icon-file-text"></i> {l s='Recent Invoices' mod='suppliermanager'}
                </div>
                <div class="panel-body">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>{l s='Number' mod='suppliermanager'}</th>
                                <th>{l s='Date' mod='suppliermanager'}</th>
                                <th>{l s='Amount' mod='suppliermanager'}</th>
                                <th>{l s='Order' mod='suppliermanager'}</th>
                                <th>{l s='Processed' mod='suppliermanager'}</th>
                                <th>{l s='Actions' mod='suppliermanager'}</th>
                            </tr>
                        </thead>
                        <tbody>
                            {if isset($invoices) && count($invoices) > 0}
                                {foreach from=$invoices item=invoice}
                                    <tr>
                                        <td>{$invoice.invoice_number|escape:'html':'UTF-8'}</td>
                                        <td>{$invoice.invoice_date|date_format:'%Y-%m-%d'}</td>
                                        <td>{displayPrice price=$invoice.amount}</td>
                                        <td>
                                            {if $invoice.id_order}
                                                <a href="{$link->getAdminLink('AdminSupplierManagerOrders')}&id_order={$invoice.id_order|intval}&viewsupplier_orders">
                                                    #{$invoice.id_order|intval}
                                                </a>
                                            {else}
                                                -
                                            {/if}
                                        </td>
                                        <td>
                                            {if $invoice.processed}
                                                <span class="badge badge-success">{l s='Yes' mod='suppliermanager'}</span>
                                            {else}
                                                <span class="badge badge-danger">{l s='No' mod='suppliermanager'}</span>
                                            {/if}
                                        </td>
                                        <td>
                                            <a href="{$link->getAdminLink('AdminSupplierManagerInvoices')}&id_invoice={$invoice.id_invoice|intval}&viewsupplier_invoices" 
                                               class="btn btn-default btn-xs">
                                                <i class="icon-eye"></i> {l s='View' mod='suppliermanager'}
                                            </a>
                                        </td>
                                    </tr>
                                {/foreach}
                            {else}
                                <tr>
                                    <td colspan="6" class="text-center">{l s='No invoices found for this supplier' mod='suppliermanager'}</td>
                                </tr>
                            {/if}
                        </tbody>
                    </table>
                </div>
                <div class="panel-footer">
                    <a href="{$link->getAdminLink('AdminSupplierManagerInvoices')}&add=1&id_supplier={$supplier->id|intval}" class="btn btn-default">
                        <i class="icon-plus"></i> {l s='Add New Invoice' mod='suppliermanager'}
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript">
    $(document).ready(function() {
        $('.update-product-condition').click(function() {
            var idProduct = $(this).data('id-product');
            var minQuantity = $('.product-min-quantity[data-id-product="' + idProduct + '"]').val();
            var currentPrice = $('.product-price[data-id-product="' + idProduct + '"]').val();
            
            $.ajax({
                url: '{$link->getAdminLink('AdminSupplierManagerSuppliers')|addslashes}',
                type: 'POST',
                data: {
                    ajax: 1,
                    action: 'UpdateProductCondition',
                    id_supplier: {$supplier->id|intval},
                    id_product: idProduct,
                    min_quantity: minQuantity,
                    current_price: currentPrice
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
                    showErrorMessage('{l s='Error communicating with server' js=1 mod='suppliermanager'}');
                }
            });
        });
    });
</script>