<?php if (!defined('_PS_VERSION_')) { exit; } 
class ProductPCBCondition extends ObjectModel { 
    public $id_pcb; 
    public $id_supplier; 
    public $id_product; 
    public $pcb_quantity; 
    public $supplier_reference; 
    public $is_active; 
    public $last_update; 
    public static $definition = [ 
        'table' => 'product_pcb_conditions', 
        'primary' => 'id_pcb', 
        'fields' => [ 
            'id_supplier' => ['type' => self::TYPE_INT, 'validate' => 'isUnsignedId', 'required' => true], 
            'id_product' => ['type' => self::TYPE_INT, 'validate' => 'isUnsignedId', 'required' => true], 
            'pcb_quantity' => ['type' => self::TYPE_INT, 'validate' => 'isUnsignedInt', 'required' => true], 
            'supplier_reference' => ['type' => self::TYPE_STRING, 'validate' => 'isGenericName', 'size' => 64], 
            'is_active' => ['type' => self::TYPE_BOOL, 'validate' => 'isBool'], 
            'last_update' => ['type' => self::TYPE_DATE, 'validate' => 'isDate', 'required' => true], 
            ], 
        ]; 
        public function add($autoDate = true, $nullValues = false) { 
            $this->last_update = date('Y-m-d H:i:s'); 
            return parent::add($autoDate, $nullValues); 
        } 
        public function update($nullValues = false) { 
            $this->last_update = date('Y-m-d H:i:s'); 
            return parent::update($nullValues); 
        } 
        /** * Récupère le PCB pour un produit et un fournisseur spécifique */ 
        public static function getBySupplierAndProduct($id_supplier, $id_product) { 
            $sql = 'SELECT `id_pcb` FROM `'._DB_PREFIX_.'product_pcb_conditions` WHERE `id_supplier` = ' . (int)$id_supplier . ' AND `id_product` = ' . (int)$id_product . ' AND `is_active` = 1'; $id = Db::getInstance()->getValue($sql); if ($id) { return new ProductPCBCondition($id); 
        } 
        return false; 
    } 
    /** * Récupère tous les PCB pour un fournisseur */ 
    public static function getBySupplier($id_supplier) { 
        $sql = 'SELECT pcb.*, pl.name as product_name, p.reference FROM `'._DB_PREFIX_.'product_pcb_conditions` pcb JOIN `'._DB_PREFIX_.'product` p ON (pcb.id_product = p.id_product) JOIN `'._DB_PREFIX_.'product_lang` pl ON (p.id_product = pl.id_product) WHERE pcb.id_supplier = ' . (int)$id_supplier . ' AND pcb.is_active = 1 AND pl.id_lang = ' . (int)Context::getContext()->language->id . ' ORDER BY pl.name ASC'; 
        return Db::getInstance()->executeS($sql); 
    } 
    /** * Calcule la quantité à commander en respectant le PCB * @param int $suggested_quantity Quantité suggérée * @param int $id_supplier ID du fournisseur * @param int $id_product ID du produit * @return int Quantité ajustée au PCB */ 
    public static function adjustQuantityToPCB($suggested_quantity, $id_supplier, $id_product) { 
        $pcbCondition = self::getBySupplierAndProduct($id_supplier, $id_product); 
        if (!$pcbCondition) { 
            return $suggested_quantity; 
        } 
        $pcb = $pcbCondition->pcb_quantity; if ($pcb <= 1) { return $suggested_quantity; 
    } 
    $remainder = $suggested_quantity % $pcb; if ($remainder == 0) { return $suggested_quantity; 
} 
$lower_multiple = $suggested_quantity - $remainder; 
$upper_multiple = $lower_multiple + $pcb; 
$threshold = $lower_multiple * 1.2; 
if ($suggested_quantity >= $threshold) { 
    return $upper_multiple; 
} else { 
    return $lower_multiple; 
} 
} 
/** * Crée ou met à jour un PCB pour un produit/fournisseur */ 
public static function createOrUpdate($id_supplier, $id_product, $pcb_quantity, $supplier_reference = null) { 
    $pcbCondition = self::getBySupplierAndProduct($id_supplier, $id_product); 
    if (!$pcbCondition) { 
        $pcbCondition = new ProductPCBCondition(); 
        $pcbCondition->id_supplier = $id_supplier; 
        $pcbCondition->id_product = $id_product; 
        $pcbCondition->is_active = 1; 
    } 
    $pcbCondition->pcb_quantity = $pcb_quantity; 
    if ($supplier_reference) { 
        $pcbCondition->supplier_reference = $supplier_reference; 
    } 
    if ($pcbCondition->id) { 
        return $pcbCondition->update(); 
    } else { 
        return $pcbCondition->add(); 
    } 
} 
/** * Récupère les PCB pour plusieurs produits d'un fournisseur */ 
public static function getPCBForProducts($id_supplier, $product_ids) { 
    if (empty($product_ids)) { 
        return []; 
    } 
    $product_ids = array_map('intval', $product_ids); 
    $sql = 'SELECT pcb.id_product, pcb.pcb_quantity, pcb.supplier_reference FROM `'._DB_PREFIX_.'product_pcb_conditions` pcb WHERE pcb.id_supplier = ' . (int)$id_supplier . ' AND pcb.id_product IN (' . implode(',', $product_ids) . ') AND pcb.is_active = 1'; 
    $results = Db::getInstance()->executeS($sql); 
    $pcb_data = []; 
    foreach ($results as $row) { 
        $pcb_data[$row['id_product']] = [ 'pcb_quantity' => $row['pcb_quantity'], 
        'supplier_reference' => $row['supplier_reference'] ]; 
    } 
    return $pcb_data; 
} 
/** * Vérifie si un produit a un PCB défini pour un fournisseur */ 
public static function hasPCB($id_supplier, $id_product) { 
    $sql = 'SELECT COUNT(*) FROM `'._DB_PREFIX_.'product_pcb_conditions` WHERE `id_supplier` = ' . (int)$id_supplier . ' AND `id_product` = ' . (int)$id_product . ' AND `is_active` = 1'; 
    return (bool)Db::getInstance()->getValue($sql); 
} 
/** * Import en masse des PCB depuis un tableau */ 
public static function bulkImport($id_supplier, $pcb_data) { 
    $success_count = 0; 
    $error_count = 0; 
    foreach ($pcb_data as $data) { 
        if (!isset($data['id_product']) || !isset($data['pcb_quantity'])) { 
            $error_count++; continue; 
        } 
        try { 
            $result = self::createOrUpdate( $data['id_supplier'] ?? $id_supplier, $data['id_product'], $data['pcb_quantity'], $data['supplier_reference'] ?? null ); 
            if ($result) { 
                $success_count++; 
            } else { 
                $error_count++; 
            } 
        } catch (Exception $e) { 
            $error_count++; 
        } 
    } 
    return [ 'success' => $success_count, 'errors' => $error_count ]; 
} 
}
?>
