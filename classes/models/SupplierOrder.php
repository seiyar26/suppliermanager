<?php
if (!defined('_PS_VERSION_')) {
    exit;
}

class SupplierOrder extends ObjectModel
{
    public $id;
    public $id_supplier;
    public $id_shop;
    public $id_employee;
    public $order_date;
    public $status;
    public $total_amount = 0;
    public $ai_suggested;

    const STATUS_DRAFT = 'draft';
    const STATUS_PENDING = 'pending';
    const STATUS_SENT = 'sent';
    const STATUS_CONFIRMED = 'confirmed';
    const STATUS_RECEIVED = 'received';
    const STATUS_CANCELLED = 'cancelled';

    public static $definition = [
        'table' => 'supplier_orders',
        'primary' => 'id_order',
        'fields' => [
            'id_supplier' => ['type' => self::TYPE_INT, 'validate' => 'isUnsignedId', 'required' => true],
            'id_shop' => ['type' => self::TYPE_INT, 'validate' => 'isUnsignedId', 'required' => true],
            'id_employee' => ['type' => self::TYPE_INT, 'validate' => 'isUnsignedId', 'required' => true],
            'order_date' => ['type' => self::TYPE_DATE, 'validate' => 'isDate', 'required' => true],
            'status' => ['type' => self::TYPE_STRING, 'validate' => 'isGenericName', 'required' => true, 'size' => 32],
            'total_amount' => ['type' => self::TYPE_FLOAT, 'validate' => 'isPrice'],
            'ai_suggested' => ['type' => self::TYPE_BOOL, 'validate' => 'isBool'],
        ],
    ];

    public function getOrderDetails()
    {
        $sql = 'SELECT * FROM `'._DB_PREFIX_.'supplier_order_details` WHERE `id_order` = '.(int)$this->id;
        return Db::getInstance()->executeS($sql);
    }

    public function getOrderDetailsWithProductInfo()
    {
        $sql = 'SELECT sod.*, pl.name as product_name, p.reference, p.ean13, p.upc
                FROM `'._DB_PREFIX_.'supplier_order_details` sod
                JOIN `'._DB_PREFIX_.'product` p ON (sod.id_product = p.id_product)
                JOIN `'._DB_PREFIX_.'product_lang` pl ON (p.id_product = pl.id_product)
                WHERE sod.id_order = '.(int)$this->id.'
                AND pl.id_lang = '.(int)Context::getContext()->language->id.'
                ORDER BY pl.name ASC';
        
        return Db::getInstance()->executeS($sql);
    }

    public function addOrderDetail($id_product, $id_product_attribute, $quantity, $unit_price)
    {
        $sql = 'INSERT INTO `'._DB_PREFIX_.'supplier_order_details` 
                (`id_order`, `id_product`, `id_product_attribute`, `quantity`, `unit_price`) 
                VALUES ('.(int)$this->id.', '.(int)$id_product.', '.(int)$id_product_attribute.', 
                '.(int)$quantity.', '.(float)$unit_price.')';
        
        return Db::getInstance()->execute($sql);
    }

    public function updateTotalAmount()
    {
        $sql = 'SELECT SUM(quantity * unit_price) as total 
                FROM `'._DB_PREFIX_.'supplier_order_details` 
                WHERE `id_order` = '.(int)$this->id;
        
        $result = Db::getInstance()->getRow($sql);
        
        if ($result && isset($result['total'])) {
            $this->total_amount = $result['total'];
            return $this->update();
        }
        
        return false;
    }

    public function generatePdf()
    {
        // Utilisation du service PDF pour générer le bon de commande
        $pdfService = new PDFService();
        return $pdfService->generateOrderPdf($this);
    }

    public function sendByEmail()
    {
        // Utilisation du service Email pour envoyer le bon de commande
        $emailService = new EmailService();
        return $emailService->sendOrderByEmail($this);
    }

    public static function getOrdersBySupplier($id_supplier, $limit = null)
    {
        $id_supplier = (int)$id_supplier;
        $limitClause = $limit ? ' LIMIT '.(int)$limit : '';
        
        $sql = 'SELECT so.*, s.name as supplier_name, CONCAT(e.firstname, " ", e.lastname) as employee_name, sh.name as shop_name
                FROM `'._DB_PREFIX_.'supplier_orders` so
                JOIN `'._DB_PREFIX_.'supplier` s ON (so.id_supplier = s.id_supplier)
                JOIN `'._DB_PREFIX_.'employee` e ON (so.id_employee = e.id_employee)
                JOIN `'._DB_PREFIX_.'shop` sh ON (so.id_shop = sh.id_shop)
                WHERE so.id_supplier = '.$id_supplier.'
                ORDER BY so.order_date DESC'.$limitClause;
        
        return Db::getInstance()->executeS($sql);
    }

    public static function getOrdersByShop($id_shop, $limit = null)
    {
        $id_shop = (int)$id_shop;
        $limitClause = $limit ? ' LIMIT '.(int)$limit : '';
        
        $sql = 'SELECT so.*, s.name as supplier_name, CONCAT(e.firstname, " ", e.lastname) as employee_name
                FROM `'._DB_PREFIX_.'supplier_orders` so
                JOIN `'._DB_PREFIX_.'supplier` s ON (so.id_supplier = s.id_supplier)
                JOIN `'._DB_PREFIX_.'employee` e ON (so.id_employee = e.id_employee)
                WHERE so.id_shop = '.$id_shop.'
                ORDER BY so.order_date DESC'.$limitClause;
        
        return Db::getInstance()->executeS($sql);
    }

    public static function getRecentOrders($limit = 10)
    {
        $limit = (int)$limit;
        
        $sql = 'SELECT so.*, s.name as supplier_name, CONCAT(e.firstname, " ", e.lastname) as employee_name, sh.name as shop_name
                FROM `'._DB_PREFIX_.'supplier_orders` so
                JOIN `'._DB_PREFIX_.'supplier` s ON (so.id_supplier = s.id_supplier)
                JOIN `'._DB_PREFIX_.'employee` e ON (so.id_employee = e.id_employee)
                JOIN `'._DB_PREFIX_.'shop` sh ON (so.id_shop = sh.id_shop)
                ORDER BY so.order_date DESC
                LIMIT '.$limit;
        
        return Db::getInstance()->executeS($sql);
    }
}
