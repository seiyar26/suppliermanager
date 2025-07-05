<?php
if (!defined('_PS_VERSION_')) {
    exit;
}

class SupplierPerformanceMetric extends ObjectModel
{
    public $id_metric;
    public $id_supplier;
    public $period_start;
    public $period_end;
    public $disputes_count;
    public $total_orders;
    public $complete_deliveries;
    public $avg_delivery_days;
    public $complete_delivery_rate;
    public $calculated_date;

    public static $definition = [
        'table' => 'supplier_performance_metrics',
        'primary' => 'id_metric',
        'fields' => [
            'id_supplier' => ['type' => self::TYPE_INT, 'validate' => 'isUnsignedId', 'required' => true],
            'period_start' => ['type' => self::TYPE_DATE, 'validate' => 'isDate', 'required' => true],
            'period_end' => ['type' => self::TYPE_DATE, 'validate' => 'isDate', 'required' => true],
            'disputes_count' => ['type' => self::TYPE_INT, 'validate' => 'isUnsignedInt'],
            'total_orders' => ['type' => self::TYPE_INT, 'validate' => 'isUnsignedInt'],
            'complete_deliveries' => ['type' => self::TYPE_INT, 'validate' => 'isUnsignedInt'],
            'avg_delivery_days' => ['type' => self::TYPE_FLOAT, 'validate' => 'isFloat'],
            'complete_delivery_rate' => ['type' => self::TYPE_FLOAT, 'validate' => 'isFloat'],
            'calculated_date' => ['type' => self::TYPE_DATE, 'validate' => 'isDate', 'required' => true],
        ],
    ];

    public function add($autoDate = true, $nullValues = false)
    {
        $this->calculated_date = date('Y-m-d H:i:s');
        return parent::add($autoDate, $nullValues);
    }
}
