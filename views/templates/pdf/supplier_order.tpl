<style>
    table {
        width: 100%;
        border-collapse: collapse;
    }
    
    table.products {
        margin-top: 20px;
        margin-bottom: 20px;
    }
    
    table.products th {
        background-color: #f0f0f0;
        padding: 8px;
        text-align: left;
        border-bottom: 1px solid #ddd;
    }
    
    table.products td {
        padding: 8px;
        border-bottom: 1px solid #ddd;
    }
    
    .header {
        margin-bottom: 30px;
    }
    
    .footer {
        margin-top: 30px;
        font-size: 12px;
    }
    
    .address-block {
        margin-bottom: 20px;
    }
    
    .text-right {
        text-align: right;
    }
    
    .total-row {
        font-weight: bold;
    }
</style>

<div class="header">
    <table>
        <tr>
            <td width="50%">
                <h1>{l s='SUPPLIER ORDER' mod='suppliermanager'}</h1>
                <p>{l s='Order Number' mod='suppliermanager'}: {$order_data.order.id}</p>
                <p>{l s='Date' mod='suppliermanager'}: {$order_data.order.date}</p>
            </td>
            <td width="50%" class="text-right">
                <h3>{$order_data.shop.name}</h3>
                <p>{$order_data.shop.address}</p>
                <p>{$order_data.shop.postcode} {$order_data.shop.city}</p>
                <p>{$order_data.shop.country}</p>
                <p>{l s='Phone' mod='suppliermanager'}: {$order_data.shop.phone}</p>
                <p>{l s='Email' mod='suppliermanager'}: {$order_data.shop.email}</p>
            </td>
        </tr>
    </table>
</div>

<div class="address-block">
    <table>
        <tr>
            <td width="50%" valign="top">
                <h3>{l s='Supplier' mod='suppliermanager'}</h3>
                <p>{$order_data.supplier.name}</p>
                <p>{$order_data.supplier.address}</p>
                <p>{$order_data.supplier.postcode} {$order_data.supplier.city}</p>
                <p>{$order_data.supplier.country}</p>
                <p>{l s='Phone' mod='suppliermanager'}: {$order_data.supplier.phone}</p>
                <p>{l s='Email' mod='suppliermanager'}: {$order_data.supplier.email}</p>
            </td>
            <td width="50%" valign="top">
                <h3>{l s='Delivery Address' mod='suppliermanager'}</h3>
                <p>{$order_data.shop.name}</p>
                <p>{$order_data.shop.address}</p>
                <p>{$order_data.shop.postcode} {$order_data.shop.city}</p>
                <p>{$order_data.shop.country}</p>
                <p>{l s='Phone' mod='suppliermanager'}: {$order_data.shop.phone}</p>
            </td>
        </tr>
    </table>
</div>

<table class="products">
    <thead>
        <tr>
            <th>{l s='Reference' mod='suppliermanager'}</th>
            <th>{l s='Product' mod='suppliermanager'}</th>
            <th class="text-right">{l s='Quantity' mod='suppliermanager'}</th>
            <th class="text-right">{l s='Unit Price' mod='suppliermanager'}</th>
            <th class="text-right">{l s='Total' mod='suppliermanager'}</th>
        </tr>
    </thead>
    <tbody>
        {foreach from=$order_data.products item=product}
            <tr>
                <td>{$product.reference}</td>
                <td>{$product.product_name}</td>
                <td class="text-right">{$product.quantity}</td>
                <td class="text-right">{Tools::displayPrice($product.unit_price)}</td>
                <td class="text-right">{Tools::displayPrice($product.quantity * $product.unit_price)}</td>
            </tr>
        {/foreach}
    </tbody>
    <tfoot>
        <tr class="total-row">
            <td colspan="3"></td>
            <td class="text-right">{l s='Total' mod='suppliermanager'}:</td>
            <td class="text-right">{$order_data.order.total_amount}</td>
        </tr>
    </tfoot>
</table>

<div class="footer">
    <p>{l s='Please process this order as soon as possible.' mod='suppliermanager'}</p>
    <p>{l s='For any questions regarding this order, please contact us at' mod='suppliermanager'} {$order_data.shop.email}</p>
</div>