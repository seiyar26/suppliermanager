<?php

class SupplierReturn extends ObjectModel
{
    public $id;
    public $id_supplier;
    public $id_order;
    public $return_date;
    public $status;
    public $total_amount;

    public static $definition = [
        'table' => 'supplier_returns',
        'primary' => 'id_return',
        'fields' => [
            'id_supplier' => ['type' => self::TYPE_INT, 'validate' => 'isUnsignedId', 'required' => true],
            'id_order' => ['type' => self::TYPE_INT, 'validate' => 'isUnsignedId'],
            'return_date' => ['type' => self::TYPE_DATE, 'validate' => 'isDate', 'required' => true],
            'status' => ['type' => self::TYPE_STRING, 'validate' => 'isGenericName', 'required' => true],
            'total_amount' => ['type' => self::TYPE_FLOAT, 'validate' => 'isPrice'],
        ],
    ];

    public function getReturnDetails()
    {
        if (!$this->id) {
            return [];
        }

        $sql = new DbQuery();
        $sql->select('srd.*, p.reference, pl.name AS product_name');
        $sql->from('supplier_return_details', 'srd');
        $sql->leftJoin('product', 'p', 'p.id_product = srd.id_product');
        $sql->leftJoin('product_lang', 'pl', 'p.id_product = pl.id_product AND pl.id_lang = ' . (int)Context::getContext()->language->id);
        $sql->where('srd.id_return = ' . (int)$this->id);

        return Db::getInstance()->executeS($sql);
    }

    public function updateTotalAmount()
    {
        if (!$this->id) {
            return;
        }

        $sql = 'SELECT SUM(quantity * unit_price) 
                FROM `'._DB_PREFIX_.'supplier_return_details` 
                WHERE id_return = '.(int)$this->id;
        
        $total = (float)Db::getInstance()->getValue($sql);
        
        $this->total_amount = $total;
        return $this->update();
    }
}
