<?php
if (!defined('_PS_VERSION_')) {
    exit;
}

class SupplierFrancoCondition extends ObjectModel
{
    public $id_franco;
    public $id_supplier;
    public $min_amount_ht;
    public $description;
    public $is_active;
    public $created_date;

    public static $definition = [
        'table' => 'supplier_franco_conditions',
        'primary' => 'id_franco',
        'fields' => [
            'id_supplier' => ['type' => self::TYPE_INT, 'validate' => 'isUnsignedId', 'required' => true],
            'min_amount_ht' => ['type' => self::TYPE_FLOAT, 'validate' => 'isPrice', 'required' => true],
            'description' => ['type' => self::TYPE_STRING, 'validate' => 'isGenericName', 'size' => 255],
            'is_active' => ['type' => self::TYPE_BOOL, 'validate' => 'isBool'],
            'created_date' => ['type' => self::TYPE_DATE, 'validate' => 'isDate', 'required' => true],
        ],
    ];

    public function add($autoDate = true, $nullValues = false)
    {
        $this->created_date = date('Y-m-d H:i:s');
        return parent::add($autoDate, $nullValues);
    }

    /**
     * Récupère la condition de franco pour un fournisseur
     */
    public static function getBySupplier($id_supplier)
    {
        $sql = 'SELECT `id_franco` FROM `'._DB_PREFIX_.'supplier_franco_conditions` 
                WHERE `id_supplier` = ' . (int)$id_supplier . ' AND `is_active` = 1';
        $id = Db::getInstance()->getValue($sql);
        if ($id) {
            return new SupplierFrancoCondition($id);
        }
        return false;
    }

    /**
     * Vérifie si une commande respecte le franco
     */
    public static function checkFrancoRespected($id_supplier, $order_amount)
    {
        $francoCondition = self::getBySupplier($id_supplier);
        if (!$francoCondition) {
            return true; // Pas de condition de franco, donc respecté
        }
        return $order_amount >= $francoCondition->min_amount_ht;
    }

    /**
     * Récupère le montant minimum pour respecter le franco
     */
    public static function getFrancoAmount($id_supplier)
    {
        $francoCondition = self::getBySupplier($id_supplier);
        if (!$francoCondition) {
            return 0;
        }
        return $francoCondition->min_amount_ht;
    }

    /**
     * Crée ou met à jour une condition de franco
     */
    public static function createOrUpdate($id_supplier, $min_amount_ht, $description = null)
    {
        $francoCondition = self::getBySupplier($id_supplier);
        if (!$francoCondition) {
            $francoCondition = new SupplierFrancoCondition();
            $francoCondition->id_supplier = $id_supplier;
            $francoCondition->is_active = 1;
        }

        $francoCondition->min_amount_ht = $min_amount_ht;
        if ($description) {
            $francoCondition->description = $description;
        }

        if ($francoCondition->id) {
            return $francoCondition->update();
        } else {
            return $francoCondition->add();
        }
    }

    /**
     * Récupère toutes les conditions de franco actives
     */
    public static function getAllActiveWithSupplierInfo()
    {
        $sql = 'SELECT fc.*, s.name as supplier_name 
                FROM `'._DB_PREFIX_.'supplier_franco_conditions` fc
                JOIN `'._DB_PREFIX_.'supplier` s ON (fc.id_supplier = s.id_supplier)
                WHERE fc.is_active = 1
                ORDER BY s.name ASC';
        return Db::getInstance()->executeS($sql);
    }

    /**
     * Calcule combien il manque pour atteindre le franco
     */
    public static function getAmountNeededForFranco($id_supplier, $current_amount)
    {
        $francoAmount = self::getFrancoAmount($id_supplier);
        if ($francoAmount == 0) {
            return 0; // Pas de franco défini
        }
        
        $needed = $francoAmount - $current_amount;
        return max(0, $needed);
    }

    /**
     * Récupère les commandes en attente qui ne respectent pas le franco
     */
    public static function getOrdersWaitingForFranco($id_shop = null)
    {
        $where = 'WHERE so.status = "pending" AND so.franco_respected = 0';
        if ($id_shop) {
            $where .= ' AND so.id_shop = ' . (int)$id_shop;
        }

        $sql = 'SELECT so.*, s.name as supplier_name, fc.min_amount_ht as franco_amount,
                (fc.min_amount_ht - so.total_amount) as amount_needed
                FROM `'._DB_PREFIX_.'supplier_orders` so
                JOIN `'._DB_PREFIX_.'supplier` s ON (so.id_supplier = s.id_supplier)
                LEFT JOIN `'._DB_PREFIX_.'supplier_franco_conditions` fc ON (s.id_supplier = fc.id_supplier AND fc.is_active = 1)
                ' . $where . '
                ORDER BY so.order_date ASC';
        
        return Db::getInstance()->executeS($sql);
    }

    /**
     * Désactive une condition de franco
     */
    public function deactivate()
    {
        $this->is_active = 0;
        return $this->update();
    }

    /**
     * Active une condition de franco
     */
    public function activate()
    {
        $this->is_active = 1;
        return $this->update();
    }
}
