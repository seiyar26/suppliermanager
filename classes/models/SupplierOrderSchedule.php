<?php
if (!defined('_PS_VERSION_')) {
    exit;
}

class SupplierOrderSchedule extends ObjectModel
{
    public $id_schedule;
    public $id_supplier;
    public $id_shop;
    public $frequency_days;
    public $last_order_date;
    public $next_order_date;
    public $is_paused;
    public $created_date;
    public $updated_date;

    public static $definition = [
        'table' => 'supplier_order_schedules',
        'primary' => 'id_schedule',
        'fields' => [
            'id_supplier' => ['type' => self::TYPE_INT, 'validate' => 'isUnsignedId', 'required' => true],
            'id_shop' => ['type' => self::TYPE_INT, 'validate' => 'isUnsignedId', 'required' => true],
            'frequency_days' => ['type' => self::TYPE_INT, 'validate' => 'isUnsignedInt', 'required' => true],
            'last_order_date' => ['type' => self::TYPE_DATE, 'validate' => 'isDate'],
            'next_order_date' => ['type' => self::TYPE_DATE, 'validate' => 'isDate'],
            'is_paused' => ['type' => self::TYPE_BOOL, 'validate' => 'isBool'],
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

    /**
     * Met à jour la prochaine date de commande en fonction de la fréquence
     */
    public function updateNextOrderDate()
    {
        if ($this->last_order_date) {
            $lastDate = new DateTime($this->last_order_date);
            $lastDate->add(new DateInterval('P' . $this->frequency_days . 'D'));
            $this->next_order_date = $lastDate->format('Y-m-d');
        } else {
            // Si pas de dernière commande, programmer pour demain
            $tomorrow = new DateTime();
            $tomorrow->add(new DateInterval('P1D'));
            $this->next_order_date = $tomorrow->format('Y-m-d');
        }
        return $this->update();
    }

    /**
     * Récupère les fournisseurs qui doivent être commandés aujourd'hui
     */
    public static function getSuppliersToOrderToday($id_shop = null)
    {
        $today = date('Y-m-d');
        $where = 'WHERE sos.next_order_date <= "' . $today . '" AND sos.is_paused = 0';
        
        if ($id_shop) {
            $where .= ' AND sos.id_shop = ' . (int)$id_shop;
        }

        $sql = 'SELECT sos.*, s.name as supplier_name, sh.name as shop_name,
                       DATEDIFF("' . $today . '", sos.next_order_date) as days_late
                FROM `'._DB_PREFIX_.'supplier_order_schedules` sos
                JOIN `'._DB_PREFIX_.'supplier` s ON (sos.id_supplier = s.id_supplier)
                JOIN `'._DB_PREFIX_.'shop` sh ON (sos.id_shop = sh.id_shop)
                ' . $where . '
                ORDER BY days_late DESC, s.name ASC';

        return Db::getInstance()->executeS($sql);
    }

    /**
     * Récupère le cadencier pour un fournisseur et une boutique
     */
    public static function getBySupplierAndShop($id_supplier, $id_shop)
    {
        $sql = 'SELECT `id_schedule` FROM `'._DB_PREFIX_.'supplier_order_schedules` 
                WHERE `id_supplier` = ' . (int)$id_supplier . ' AND `id_shop` = ' . (int)$id_shop;
        
        $id = Db::getInstance()->getValue($sql);
        if ($id) {
            return new SupplierOrderSchedule($id);
        }
        return false;
    }

    /**
     * Crée ou met à jour un cadencier
     */
    public static function createOrUpdate($id_supplier, $id_shop, $frequency_days)
    {
        $schedule = self::getBySupplierAndShop($id_supplier, $id_shop);
        
        if (!$schedule) {
            $schedule = new SupplierOrderSchedule();
            $schedule->id_supplier = $id_supplier;
            $schedule->id_shop = $id_shop;
        }
        
        $schedule->frequency_days = $frequency_days;
        $schedule->updateNextOrderDate();
        
        if ($schedule->id) {
            return $schedule->update();
        } else {
            return $schedule->add();
        }
    }

    /**
     * Met en pause ou reprend le cadencier d'un fournisseur
     */
    public function togglePause()
    {
        $this->is_paused = !$this->is_paused;
        return $this->update();
    }

    /**
     * Enregistre qu'une commande a été passée aujourd'hui
     */
    public function recordOrderPlaced()
    {
        $this->last_order_date = date('Y-m-d');
        $this->updateNextOrderDate();
        return $this->update();
    }

    /**
     * Récupère tous les cadenciers pour le dashboard
     */
    public static function getAllSchedulesWithInfo($id_shop = null)
    {
        $where = $id_shop ? 'WHERE sos.id_shop = ' . (int)$id_shop : '';
        
        $sql = 'SELECT sos.*, s.name as supplier_name, sh.name as shop_name,
                       CASE 
                           WHEN sos.next_order_date < CURDATE() THEN "En retard"
                           WHEN sos.next_order_date = CURDATE() THEN "Aujourd\'hui"
                           WHEN sos.is_paused = 1 THEN "En pause"
                           ELSE "Programmé"
                       END as status_text,
                       DATEDIFF(sos.next_order_date, CURDATE()) as days_until_order
                FROM `'._DB_PREFIX_.'supplier_order_schedules` sos
                JOIN `'._DB_PREFIX_.'supplier` s ON (sos.id_supplier = s.id_supplier)
                JOIN `'._DB_PREFIX_.'shop` sh ON (sos.id_shop = sh.id_shop)
                ' . $where . '
                ORDER BY sos.next_order_date ASC, s.name ASC';

        return Db::getInstance()->executeS($sql);
    }
}
