<?php
if (!defined('_PS_VERSION_')) {
    exit;
}

class SupplierInvoice extends ObjectModel
{
    public $id_invoice;
    public $id_supplier;
    public $invoice_number;
    public $invoice_date;
    public $amount = 0;
    public $file_path;
    public $id_order;
    public $processed;

    public static $definition = [
        'table' => 'supplier_invoices',
        'primary' => 'id_invoice',
        'fields' => [
            'id_supplier' => ['type' => self::TYPE_INT, 'validate' => 'isUnsignedId', 'required' => true],
            'invoice_number' => ['type' => self::TYPE_STRING, 'validate' => 'isGenericName', 'required' => true, 'size' => 64],
            'invoice_date' => ['type' => self::TYPE_DATE, 'validate' => 'isDate', 'required' => true],
            'amount' => ['type' => self::TYPE_FLOAT, 'validate' => 'isPrice'],
            'file_path' => ['type' => self::TYPE_STRING, 'validate' => 'isGenericName', 'size' => 255],
            'id_order' => ['type' => self::TYPE_INT, 'validate' => 'isUnsignedId'],
            'processed' => ['type' => self::TYPE_BOOL, 'validate' => 'isBool'],
        ],
    ];

    public static function getByInvoiceNumber($id_supplier, $invoice_number)
    {
        $id_supplier = (int)$id_supplier;
        $invoice_number = pSQL($invoice_number);
        
        $sql = 'SELECT `id_invoice` 
                FROM `'._DB_PREFIX_.'supplier_invoices` 
                WHERE `id_supplier` = '.$id_supplier.' 
                AND `invoice_number` = "'.$invoice_number.'"';
        
        $id = Db::getInstance()->getValue($sql);
        
        if ($id) {
            return new SupplierInvoice($id);
        }
        
        return false;
    }

    public static function getInvoicesBySupplier($id_supplier, $limit = null)
    {
        $id_supplier = (int)$id_supplier;
        $limitClause = $limit ? ' LIMIT '.(int)$limit : '';
        
        $sql = 'SELECT si.*, s.name as supplier_name
                FROM `'._DB_PREFIX_.'supplier_invoices` si
                JOIN `'._DB_PREFIX_.'supplier` s ON (si.id_supplier = s.id_supplier)
                WHERE si.id_supplier = '.$id_supplier.'
                ORDER BY si.invoice_date DESC'.$limitClause;
        
        return Db::getInstance()->executeS($sql);
    }

    public static function getInvoicesByOrder($id_order)
    {
        $id_order = (int)$id_order;
        
        $sql = 'SELECT si.*, s.name as supplier_name
                FROM `'._DB_PREFIX_.'supplier_invoices` si
                JOIN `'._DB_PREFIX_.'supplier` s ON (si.id_supplier = s.id_supplier)
                WHERE si.id_order = '.$id_order.'
                ORDER BY si.invoice_date DESC';
        
        return Db::getInstance()->executeS($sql);
    }

    public static function getRecentInvoices($limit = 10)
    {
        $limit = (int)$limit;
        
        $sql = 'SELECT si.*, s.name as supplier_name
                FROM `'._DB_PREFIX_.'supplier_invoices` si
                JOIN `'._DB_PREFIX_.'supplier` s ON (si.id_supplier = s.id_supplier)
                ORDER BY si.invoice_date DESC
                LIMIT '.$limit;
        
        return Db::getInstance()->executeS($sql);
    }

    public static function getUnprocessedInvoices()
    {
        $sql = 'SELECT si.*, s.name as supplier_name
                FROM `'._DB_PREFIX_.'supplier_invoices` si
                JOIN `'._DB_PREFIX_.'supplier` s ON (si.id_supplier = s.id_supplier)
                WHERE si.processed = 0
                ORDER BY si.invoice_date ASC';
        
        return Db::getInstance()->executeS($sql);
    }
}