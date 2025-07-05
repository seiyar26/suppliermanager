<?php
if (!defined('_PS_VERSION_')) {
    exit;
}

class SupplierOrderDetail extends ObjectModel
{
    public $id_order_detail;
    public $id_order;
    public $id_product;
    public $id_product_attribute;
    public $quantity;
    public $unit_price = 0;

    public static $definition = [
        'table' => 'supplier_order_details',
        'primary' => 'id_order_detail',
        'fields' => [
            'id_order' => ['type' => self::TYPE_INT, 'validate' => 'isUnsignedId', 'required' => true],
            'id_product' => ['type' => self::TYPE_INT, 'validate' => 'isUnsignedId', 'required' => true],
            'id_product_attribute' => ['type' => self::TYPE_INT, 'validate' => 'isUnsignedId'],
            'quantity' => ['type' => self::TYPE_INT, 'validate' => 'isUnsignedInt', 'required' => true],
            'unit_price' => ['type' => self::TYPE_FLOAT, 'validate' => 'isPrice'],
        ],
    ];

    public static function getByOrderAndProduct($id_order, $id_product, $id_product_attribute = 0)
    {
        $id_order = (int)$id_order;
        $id_product = (int)$id_product;
        $id_product_attribute = (int)$id_product_attribute;
        
        $sql = 'SELECT `id_order_detail` 
                FROM `'._DB_PREFIX_.'supplier_order_details` 
                WHERE `id_order` = '.$id_order.' 
                AND `id_product` = '.$id_product.' 
                AND `id_product_attribute` = '.$id_product_attribute;
        
        $id = Db::getInstance()->getValue($sql);
        
        if ($id) {
            return new SupplierOrderDetail($id);
        }
        
        return false;
    }

    public static function getDetailsByOrder($id_order)
    {
        $id_order = (int)$id_order;
        
        $sql = 'SELECT sod.*, pl.name as product_name, p.reference
                FROM `'._DB_PREFIX_.'supplier_order_details` sod
                JOIN `'._DB_PREFIX_.'product` p ON (sod.id_product = p.id_product)
                JOIN `'._DB_PREFIX_.'product_lang` pl ON (p.id_product = pl.id_product)
                WHERE sod.id_order = '.$id_order.'
                AND pl.id_lang = '.(int)Context::getContext()->language->id.'
                ORDER BY pl.name ASC';
        
        return Db::getInstance()->executeS($sql);
    }

    public static function updateQuantity($id_order_detail, $quantity)
    {
        $id_order_detail = (int)$id_order_detail;
        $quantity = (int)$quantity;
        
        $sql = 'UPDATE `'._DB_PREFIX_.'supplier_order_details` 
                SET `quantity` = '.$quantity.' 
                WHERE `id_order_detail` = '.$id_order_detail;
        
        return Db::getInstance()->execute($sql);
    }

    public static function deleteByOrder($id_order)
    {
        $id_order = (int)$id_order;
        
        $sql = 'DELETE FROM `'._DB_PREFIX_.'supplier_order_details` 
                WHERE `id_order` = '.$id_order;
        
        return Db::getInstance()->execute($sql);
    }
}