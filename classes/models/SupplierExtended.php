<?php
if (!defined('_PS_VERSION_')) {
    exit;
}

class SupplierExtended extends ObjectModel
{
    public $id_supplier;
    public $min_order_quantity;
    public $min_order_amount = 0;
    public $delivery_delay;
    public $payment_terms;
    public $auto_order_enabled;

    public static $definition = [
        'table' => 'suppliers_extended',
        'primary' => 'id_supplier',
        'fields' => [
            'id_supplier' => ['type' => self::TYPE_INT, 'validate' => 'isUnsignedId', 'required' => true],
            'min_order_quantity' => ['type' => self::TYPE_INT, 'validate' => 'isUnsignedInt'],
            'min_order_amount' => ['type' => self::TYPE_FLOAT, 'validate' => 'isPrice'],
            'delivery_delay' => ['type' => self::TYPE_INT, 'validate' => 'isUnsignedInt'],
            'payment_terms' => ['type' => self::TYPE_STRING, 'validate' => 'isGenericName', 'size' => 255],
            'auto_order_enabled' => ['type' => self::TYPE_BOOL, 'validate' => 'isBool'],
        ],
    ];

    public static function getByIdSupplier($id_supplier)
    {
        $id_supplier = (int)$id_supplier;
        $sql = 'SELECT `id_supplier` FROM `'._DB_PREFIX_.'suppliers_extended` WHERE `id_supplier` = '.$id_supplier;
        $result = Db::getInstance()->getValue($sql);
        
        if ($result) {
            return new SupplierExtended($id_supplier);
        }
        
        return false;
    }

    public static function getSupplierWithExtendedInfo($id_supplier)
    {
        $id_supplier = (int)$id_supplier;
        
        $sql = 'SELECT s.*, se.* 
                FROM `'._DB_PREFIX_.'supplier` s
                LEFT JOIN `'._DB_PREFIX_.'suppliers_extended` se ON (s.id_supplier = se.id_supplier)
                WHERE s.id_supplier = '.$id_supplier;
        
        return Db::getInstance()->getRow($sql);
    }

    public static function getAllSuppliersWithExtendedInfo()
    {
        $sql = 'SELECT s.*, se.* 
                FROM `'._DB_PREFIX_.'supplier` s
                LEFT JOIN `'._DB_PREFIX_.'suppliers_extended` se ON (s.id_supplier = se.id_supplier)
                ORDER BY s.name ASC';
        
        return Db::getInstance()->executeS($sql);
    }
}