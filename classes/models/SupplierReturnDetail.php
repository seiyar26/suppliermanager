<?php
if (!defined('_PS_VERSION_')) {
    exit;
}

class SupplierReturnDetail extends ObjectModel
{
    public $id_return_detail;
    public $id_return;
    public $id_product;
    public $id_product_attribute;
    public $quantity;
    public $reason;
    public $unit_price;

    public static $definition = [
        'table' => 'supplier_return_details',
        'primary' => 'id_return_detail',
        'fields' => [
            'id_return' => ['type' => self::TYPE_INT, 'validate' => 'isUnsignedId', 'required' => true],
            'id_product' => ['type' => self::TYPE_INT, 'validate' => 'isUnsignedId', 'required' => true],
            'id_product_attribute' => ['type' => self::TYPE_INT, 'validate' => 'isUnsignedId'],
            'quantity' => ['type' => self::TYPE_INT, 'validate' => 'isUnsignedInt', 'required' => true],
            'reason' => ['type' => self::TYPE_STRING, 'validate' => 'isString'],
            'unit_price' => ['type' => self::TYPE_FLOAT, 'validate' => 'isPrice'],
        ],
    ];
}
