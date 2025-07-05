<?php
if (!defined('_PS_VERSION_')) {
    exit;
}

class StockService
{
    public static function getProductStock($id_product, $id_shop, $id_product_attribute = 0)
    {
        $id_product = (int)$id_product;
        $id_shop = (int)$id_shop;
        $id_product_attribute = (int)$id_product_attribute;
        
        $sql = 'SELECT `quantity` FROM `'._DB_PREFIX_.'stock_available` 
                WHERE `id_product` = '.$id_product.' 
                AND `id_shop` = '.$id_shop.' 
                AND `id_product_attribute` = '.$id_product_attribute;
        
        return (int)Db::getInstance()->getValue($sql);
    }

    public static function updateProductStock($id_product, $id_shop, $quantity, $id_product_attribute = 0)
    {
        $id_product = (int)$id_product;
        $id_shop = (int)$id_shop;
        $quantity = (int)$quantity;
        $id_product_attribute = (int)$id_product_attribute;
        
        $sql = 'UPDATE `'._DB_PREFIX_.'stock_available` 
                SET `quantity` = '.$quantity.' 
                WHERE `id_product` = '.$id_product.' 
                AND `id_shop` = '.$id_shop.' 
                AND `id_product_attribute` = '.$id_product_attribute;
        
        return Db::getInstance()->execute($sql);
    }

    public static function getProductsWithLowStock($id_shop, $threshold = 5)
    {
        $id_shop = (int)$id_shop;
        $threshold = (int)$threshold;
        
        $sql = 'SELECT p.id_product, pl.name, sa.quantity, p.reference, p.ean13, p.upc 
                FROM `'._DB_PREFIX_.'product` p 
                JOIN `'._DB_PREFIX_.'stock_available` sa ON (p.id_product = sa.id_product AND sa.id_product_attribute = 0) 
                JOIN `'._DB_PREFIX_.'product_lang` pl ON (p.id_product = pl.id_product) 
                WHERE sa.id_shop = '.$id_shop.' 
                AND sa.quantity <= '.$threshold.' 
                AND pl.id_lang = '.(int)Context::getContext()->language->id.' 
                AND p.active = 1
                ORDER BY sa.quantity ASC, pl.name ASC';
        
        return Db::getInstance()->executeS($sql);
    }

    public static function getProductsWithStockInfo($id_shop, $id_supplier = null)
    {
        $id_shop = (int)$id_shop;
        $supplierFilter = '';
        
        if ($id_supplier) {
            $id_supplier = (int)$id_supplier;
            $supplierFilter = ' AND ps.id_supplier = '.$id_supplier;
        }
        
        $sql = 'SELECT p.id_product, pl.name, sa.quantity, p.reference, p.ean13, p.upc, 
                       ps.id_supplier, s.name as supplier_name
                FROM `'._DB_PREFIX_.'product` p 
                JOIN `'._DB_PREFIX_.'stock_available` sa ON (p.id_product = sa.id_product AND sa.id_product_attribute = 0) 
                JOIN `'._DB_PREFIX_.'product_lang` pl ON (p.id_product = pl.id_product) 
                LEFT JOIN `'._DB_PREFIX_.'product_supplier` ps ON (p.id_product = ps.id_product)
                LEFT JOIN `'._DB_PREFIX_.'supplier` s ON (ps.id_supplier = s.id_supplier)
                WHERE sa.id_shop = '.$id_shop.' 
                AND pl.id_lang = '.(int)Context::getContext()->language->id.' 
                AND p.active = 1'.$supplierFilter.'
                ORDER BY pl.name ASC';
        
        return Db::getInstance()->executeS($sql);
    }

    public static function getStockMovementHistory($id_product, $id_shop, $days = 30)
    {
        $id_product = (int)$id_product;
        $id_shop = (int)$id_shop;
        $days = (int)$days;
        
        // Cette requête est une simulation car PrestaShop ne stocke pas nativement l'historique des mouvements de stock
        // Dans une implémentation réelle, il faudrait créer une table dédiée pour stocker ces mouvements
        
        $sql = 'SELECT o.date_add as date, od.product_quantity as quantity, "order" as type
                FROM `'._DB_PREFIX_.'orders` o 
                JOIN `'._DB_PREFIX_.'order_detail` od ON (o.id_order = od.id_order) 
                WHERE od.product_id = '.$id_product.' 
                AND o.id_shop = '.$id_shop.' 
                AND o.date_add >= DATE_SUB(NOW(), INTERVAL '.$days.' DAY) 
                AND o.valid = 1 
                
                UNION ALL
                
                SELECT so.order_date as date, sod.quantity, "supplier_order" as type
                FROM `'._DB_PREFIX_.'supplier_orders` so
                JOIN `'._DB_PREFIX_.'supplier_order_details` sod ON (so.id_order = sod.id_order)
                WHERE sod.id_product = '.$id_product.'
                AND so.id_shop = '.$id_shop.'
                AND so.order_date >= DATE_SUB(NOW(), INTERVAL '.$days.' DAY)
                AND so.status = "received"
                
                ORDER BY date DESC';
        
        return Db::getInstance()->executeS($sql);
    }

    public static function updateStockFromSupplierOrder($id_order)
    {
        $id_order = (int)$id_order;
        
        $order = new SupplierOrder($id_order);
        if (!Validate::isLoadedObject($order) || $order->status != SupplierOrder::STATUS_RECEIVED) {
            return false;
        }
        
        $details = $order->getOrderDetails();
        $success = true;
        
        foreach ($details as $detail) {
            $currentStock = self::getProductStock($detail['id_product'], $order->id_shop, $detail['id_product_attribute']);
            $newStock = $currentStock + $detail['quantity'];
            
            $result = self::updateProductStock($detail['id_product'], $order->id_shop, $newStock, $detail['id_product_attribute']);
            $success = $success && $result;
        }
        
        return $success;
    }
}