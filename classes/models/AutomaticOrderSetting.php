<?php
if (!defined('_PS_VERSION_')) {
    exit;
}

class AutomaticOrderSetting extends ObjectModel
{
    public $id_setting;
    public $id_shop;
    public $id_supplier;
    public $stock_days_desired;
    public $auto_enabled;
    public $exclude_inactive_products;
    public $rupture_increase_percent;
    public $history_period_days;
    public $updated_date;

    public static $definition = [
        'table' => 'automatic_order_settings',
        'primary' => 'id_setting',
        'fields' => [
            'id_shop' => ['type' => self::TYPE_INT, 'validate' => 'isUnsignedId', 'required' => true],
            'id_supplier' => ['type' => self::TYPE_INT, 'validate' => 'isUnsignedId', 'required' => true],
            'stock_days_desired' => ['type' => self::TYPE_INT, 'validate' => 'isUnsignedInt'],
            'auto_enabled' => ['type' => self::TYPE_BOOL, 'validate' => 'isBool'],
            'exclude_inactive_products' => ['type' => self::TYPE_BOOL, 'validate' => 'isBool'],
            'rupture_increase_percent' => ['type' => self::TYPE_INT, 'validate' => 'isUnsignedInt'],
            'history_period_days' => ['type' => self::TYPE_INT, 'validate' => 'isUnsignedInt'],
            'updated_date' => ['type' => self::TYPE_DATE, 'validate' => 'isDate', 'required' => true],
        ],
    ];

    public function add($autoDate = true, $nullValues = false)
    {
        $this->updated_date = date('Y-m-d H:i:s');
        return parent::add($autoDate, $nullValues);
    }

    public function update($nullValues = false)
    {
        $this->updated_date = date('Y-m-d H:i:s');
        return parent::update($nullValues);
    }
}
