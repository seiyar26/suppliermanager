<?php
if (!defined('_PS_VERSION_')) {
    exit;
}

class SupplierProductCondition extends ObjectModel
{
    public $id_supplier_product_condition;
    public $id_supplier;
    public $id_product;
    public $min_quantity;
    public $current_price;
    public $last_update;

    public static $definition = [
        'table' => 'supplier_product_conditions',
        'primary' => 'id_supplier_product_condition',
        'fields' => [
            'id_supplier' => ['type' => self::TYPE_INT, 'validate' => 'isUnsignedId', 'required' => true],
            'id_product' => ['type' => self::TYPE_INT, 'validate' => 'isUnsignedId', 'required' => true],
            'min_quantity' => ['type' => self::TYPE_INT, 'validate' => 'isUnsignedInt'],
            'current_price' => ['type' => self::TYPE_FLOAT, 'validate' => 'isPrice'],
            'last_update' => ['type' => self::TYPE_DATE, 'validate' => 'isDate'],
        ],
    ];

    public static function getBySupplierAndProduct($id_supplier, $id_product)
    {
        $id_supplier = (int)$id_supplier;
        $id_product = (int)$id_product;
        
        $sql = 'SELECT `id_supplier_product_condition` 
                FROM `'._DB_PREFIX_.'supplier_product_conditions` 
                WHERE `id_supplier` = '.$id_supplier.' 
                AND `id_product` = '.$id_product;
        
        $id = Db::getInstance()->getValue($sql);
        
        if ($id) {
            return new SupplierProductCondition($id);
        }
        
        return false;
    }

    public static function getProductsBySupplier($id_supplier)
    {
        $id_supplier = (int)$id_supplier;
        
        $sql = 'SELECT spc.*, pl.name as product_name, p.reference
                FROM `'._DB_PREFIX_.'supplier_product_conditions` spc
                JOIN `'._DB_PREFIX_.'product` p ON (spc.id_product = p.id_product)
                JOIN `'._DB_PREFIX_.'product_lang` pl ON (p.id_product = pl.id_product)
                WHERE spc.id_supplier = '.$id_supplier.'
                AND pl.id_lang = '.(int)Context::getContext()->language->id.'
                ORDER BY pl.name ASC';
        
        return Db::getInstance()->executeS($sql);
    }

    public static function getSuppliersByProduct($id_product)
    {
        $id_product = (int)$id_product;
        
        $sql = 'SELECT spc.*, s.name as supplier_name
                FROM `'._DB_PREFIX_.'supplier_product_conditions` spc
                JOIN `'._DB_PREFIX_.'supplier` s ON (spc.id_supplier = s.id_supplier)
                WHERE spc.id_product = '.$id_product.'
                ORDER BY s.name ASC';
        
        return Db::getInstance()->executeS($sql);
    }
}