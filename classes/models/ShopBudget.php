<?php
if (!defined('_PS_VERSION_')) {
    exit;
}

class ShopBudget extends ObjectModel
{
    public $id_budget;
    public $id_shop;
    public $period_year;
    public $period_month;
    public $budget_amount;
    public $created_date;
    public $updated_date;

    public static $definition = [
        'table' => 'shop_budgets',
        'primary' => 'id_budget',
        'fields' => [
            'id_shop' => ['type' => self::TYPE_INT, 'validate' => 'isUnsignedId', 'required' => true],
            'period_year' => ['type' => self::TYPE_INT, 'validate' => 'isUnsignedInt', 'required' => true],
            'period_month' => ['type' => self::TYPE_INT, 'validate' => 'isUnsignedInt', 'required' => true],
            'budget_amount' => ['type' => self::TYPE_FLOAT, 'validate' => 'isPrice', 'required' => true],
            'created_date' => ['type' => self::TYPE_DATE, 'validate' => 'isDate', 'required' => true],
            'updated_date' => ['type' => self::TYPE_DATE, 'validate' => 'isDate'],
        ],
    ];

    public function add($autoDate = true, $nullValues = false)
    {
        $this->created_date = date('Y-m-d H:i:s');
        return parent::add($autoDate, $nullValues);
    }

    public function update($nullValues = false)
    {
        $this->updated_date = date('Y-m-d H:i:s');
        return parent::update($nullValues);
    }
}
