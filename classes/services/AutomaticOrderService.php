<?php

if (!defined('_PS_VERSION_')) {
    exit;
}

require_once(dirname(__FILE__) . '/../models/SupplierOrderSchedule.php');
require_once(dirname(__FILE__) . '/../models/ProductPCBCondition.php');
require_once(dirname(__FILE__) . '/../models/SupplierFrancoCondition.php');
require_once(dirname(__FILE__) . '/../models/SupplierOrder.php');
require_once(dirname(__FILE__) . '/../models/SupplierOrderDetail.php');

class AutomaticOrderService {
    /**
     * Génère une proposition de commande basée sur l'historique des ventes
     *
     * @param int $id_supplier ID du fournisseur
     * @param int $id_shop ID de la boutique
     * @param int $history_period_days Période d'historique en jours
     * @param int $stock_days_desired Nombre de jours de stock souhaité
     * @param bool $exclude_inactive_products Exclure les produits inactifs
     * @return array Proposition de commande
     */
    public static function generateOrderProposal($id_supplier, $id_shop, $history_period_days = 30, $stock_days_desired = 15, $exclude_inactive_products = true)
    {
        $proposal = [];
        $products = self::getSupplierProducts($id_supplier, $exclude_inactive_products);
        $supplierExtended = SupplierExtended::getByIdSupplier($id_supplier);
        $delivery_delay = $supplierExtended ? $supplierExtended->delivery_delay : 3;

        foreach ($products as $product) {
            $suggestion = self::calculateProductSuggestion(
                $product['id_product'],
                $id_shop,
                $id_supplier,
                $history_period_days,
                $stock_days_desired,
                $delivery_delay
            );

            if ($suggestion['suggested_quantity'] > 0) {
                $proposal[] = $suggestion;
            }
        }

        return $proposal;
    }

    /**
     * Calcule la suggestion pour un produit spécifique
     * Formule : (Ventes période / jours période * jours stock souhaité + délai livraison) - stock disponible
     */
    private static function calculateProductSuggestion($id_product, $id_shop, $id_supplier, $history_period_days, $stock_days_desired, $delivery_delay)
    {
        // Récupérer les ventes sur la période
        $sales_data = self::getSalesHistory($id_product, $id_shop, $history_period_days);
        $sales_quantity = $sales_data['total_quantity'];
        $sales_days = $sales_data['sales_days'];

        // Stock actuel
        $current_stock = self::getCurrentStock($id_product, $id_shop);

        // Calcul de la suggestion selon la formule
        $daily_sales = $sales_days > 0 ? $sales_quantity / $sales_days : 0;
        $needed_stock = ($daily_sales * $stock_days_desired) + ($daily_sales * $delivery_delay);
        $suggested_quantity = max(0, ceil($needed_stock - $current_stock));

        // Gestion des produits en rupture récurrente (+20%)
        if (self::isRecurrentOutOfStock($id_product, $id_shop, $id_supplier)) {
            $suggested_quantity = ceil($suggested_quantity * 1.2);
        }

        // Ajustement au PCB
        $suggested_quantity = ProductPCBCondition::adjustQuantityToPCB($suggested_quantity, $id_supplier, $id_product);

        // Récupérer les informations produit
        $product_info = self::getProductInfo($id_product);
        $pcb_info = ProductPCBCondition::getBySupplierAndProduct($id_supplier, $id_product);

        return [
            'id_product' => $id_product,
            'product_name' => $product_info['name'],
            'reference' => $product_info['reference'],
            'ean13' => $product_info['ean13'],
            'current_stock' => $current_stock,
            'daily_sales' => round($daily_sales, 2),
            'suggested_quantity' => $suggested_quantity,
            'pcb_quantity' => $pcb_info ? $pcb_info->pcb_quantity : 1,
            'supplier_reference' => $pcb_info ? $pcb_info->supplier_reference : '',
            'unit_price' => self::getSupplierPrice($id_product, $id_supplier),
            'is_recurrent_outofstock' => self::isRecurrentOutOfStock($id_product, $id_shop, $id_supplier)
        ];
    }

    /**
     * Récupère l'historique des ventes pour un produit
     */
    private static function getSalesHistory($id_product, $id_shop, $days)
    {
        $date_from = date('Y-m-d', strtotime('-' . $days . ' days'));
        $sql = 'SELECT SUM(od.product_quantity) as total_quantity, COUNT(DISTINCT DATE(o.date_add)) as sales_days
                FROM `'._DB_PREFIX_.'order_detail` od
                JOIN `'._DB_PREFIX_.'orders` o ON (od.id_order = o.id_order)
                WHERE od.product_id = ' . (int)$id_product . '
                  AND o.id_shop = ' . (int)$id_shop . '
                  AND o.date_add >= "' . pSQL($date_from) . '"
                  AND o.valid = 1';
        $result = Db::getInstance()->getRow($sql);

        return [
            'total_quantity' => $result['total_quantity'] ?: 0,
            'sales_days' => $result['sales_days'] ?: 0
        ];
    }

    /**
     * Récupère le stock actuel d'un produit
     */
    private static function getCurrentStock($id_product, $id_shop)
    {
        $sql = 'SELECT SUM(physical_quantity) as stock
                FROM `'._DB_PREFIX_.'stock_available`
                WHERE id_product = ' . (int)$id_product . '
                  AND id_shop = ' . (int)$id_shop;
        return (int)Db::getInstance()->getValue($sql);
    }

    /**
     * Vérifie si un produit est en rupture récurrente
     */
    private static function isRecurrentOutOfStock($id_product, $id_shop, $id_supplier)
    {
        // Vérifier les 3 dernières commandes
        $sql = 'SELECT COUNT(*) as rupture_count
                FROM `'._DB_PREFIX_.'supplier_order_details` sod
                JOIN `'._DB_PREFIX_.'supplier_orders` so ON (sod.id_order = so.id_order)
                WHERE sod.id_product = ' . (int)$id_product . '
                  AND so.id_supplier = ' . (int)$id_supplier . '
                  AND so.id_shop = ' . (int)$id_shop . '
                  AND so.status = "received"
                ORDER BY so.order_date DESC
                LIMIT 3';
        $total_orders = Db::getInstance()->getValue($sql);

        // Si moins de 3 commandes, pas assez de données
        if ($total_orders < 3) {
            return false;
        }

        // Vérifier les ruptures de stock pendant ces commandes
        $sql = 'SELECT COUNT(*) as outofstock_count
                FROM `'._DB_PREFIX_.'supplier_order_details` sod
                JOIN `'._DB_PREFIX_.'supplier_orders` so ON (sod.id_order = so.id_order)
                LEFT JOIN `'._DB_PREFIX_.'stock_available` sa ON (sod.id_product = sa.id_product AND sa.id_shop = so.id_shop)
                WHERE sod.id_product = ' . (int)$id_product . '
                  AND so.id_supplier = ' . (int)$id_supplier . '
                  AND so.id_shop = ' . (int)$id_shop . '
                  AND so.status = "received"
                  AND (sa.physical_quantity <= 0 OR sa.physical_quantity IS NULL)
                ORDER BY so.order_date DESC
                LIMIT 3';
        $outofstock_count = Db::getInstance()->getValue($sql);

        // Si 2 ou 3 ruptures sur les 3 dernières commandes
        return $outofstock_count >= 2;
    }

    /**
     * Récupère les produits d'un fournisseur
     */
    private static function getSupplierProducts($id_supplier, $exclude_inactive = true)
    {
        $active_condition = $exclude_inactive ? 'AND p.active = 1' : '';
        $sql = 'SELECT DISTINCT p.id_product, pl.name, p.reference, p.ean13
                FROM `'._DB_PREFIX_.'product_supplier` ps
                JOIN `'._DB_PREFIX_.'product` p ON (ps.id_product = p.id_product)
                JOIN `'._DB_PREFIX_.'product_lang` pl ON (p.id_product = pl.id_product)
                WHERE ps.id_supplier = ' . (int)$id_supplier . ' ' . $active_condition . '
                  AND pl.id_lang = ' . (int)Context::getContext()->language->id . '
                ORDER BY pl.name ASC';
        return Db::getInstance()->executeS($sql);
    }

    /**
     * Récupère les informations d'un produit
     */
    private static function getProductInfo($id_product)
    {
        $sql = 'SELECT p.reference, p.ean13, pl.name
                FROM `'._DB_PREFIX_.'product` p
                JOIN `'._DB_PREFIX_.'product_lang` pl ON (p.id_product = pl.id_product)
                WHERE p.id_product = ' . (int)$id_product . '
                  AND pl.id_lang = ' . (int)Context::getContext()->language->id;
        return Db::getInstance()->getRow($sql);
    }

    /**
     * Récupère le prix fournisseur d'un produit
     */
    private static function getSupplierPrice($id_product, $id_supplier)
    {
        $sql = 'SELECT product_supplier_price_te
                FROM `'._DB_PREFIX_.'product_supplier`
                WHERE id_product = ' . (int)$id_product . '
                  AND id_supplier = ' . (int)$id_supplier;
        return (float)Db::getInstance()->getValue($sql);
    }

    /**
     * Crée une commande automatique
     */
    public static function createAutomaticOrder($id_supplier, $id_shop, $proposal_data)
    {
        $order = new SupplierOrder();
        $order->id_supplier = $id_supplier;
        $order->id_shop = $id_shop;
        $order->id_employee = Context::getContext()->employee->id;
        $order->order_date = date('Y-m-d H:i:s');
        $order->status = SupplierOrder::STATUS_DRAFT;
        $order->ai_suggested = 1;
        $order->is_automatic = 1;

        // Calculer le montant total
        $total_amount = 0;
        foreach ($proposal_data as $item) {
            $total_amount += $item['quantity'] * $item['unit_price'];
        }
        $order->total_amount = $total_amount;

        // Vérifier le franco
        $franco_respected = SupplierFrancoCondition::checkFrancoRespected($id_supplier, $total_amount);
        $order->franco_respected = $franco_respected ? 1 : 0;

        if (!$franco_respected) {
            $order->status = SupplierOrder::STATUS_PENDING; // En attente si franco non respecté
        }

        if ($order->add()) {
            // Ajouter les détails de commande
            foreach ($proposal_data as $item) {
                $order->addOrderDetail(
                    $item['id_product'],
                    $item['id_product_attribute'] ?? 0,
                    $item['quantity'],
                    $item['unit_price']
                );
            }

            // Mettre à jour le cadencier
            $schedule = SupplierOrderSchedule::getBySupplierAndShop($id_supplier, $id_shop);
            if ($schedule) {
                $schedule->recordOrderPlaced();
            }

            return $order;
        }

        return false;
    }

    /**
     * Traite les commandes automatiques quotidiennes
     */
    public static function processAutomaticOrders($id_shop = null)
    {
        $suppliers_to_order = SupplierOrderSchedule::getSuppliersToOrderToday($id_shop);
        $processed_orders = [];

        foreach ($suppliers_to_order as $supplier_data) {
            // Vérifier si les commandes automatiques sont activées
            $settings = self::getAutomaticOrderSettings($supplier_data['id_shop'], $supplier_data['id_supplier']);
            if (!$settings || !$settings['auto_enabled']) {
                continue;
            }

            // Générer la proposition
            $proposal = self::generateOrderProposal(
                $supplier_data['id_supplier'],
                $supplier_data['id_shop'],
                $settings['history_period_days'],
                $settings['stock_days_desired'],
                $settings['exclude_inactive_products']
            );

            if (!empty($proposal)) {
                $order = self::createAutomaticOrder(
                    $supplier_data['id_supplier'],
                    $supplier_data['id_shop'],
                    $proposal
                );

                if ($order) {
                    $processed_orders[] = [
                        'supplier_name' => $supplier_data['supplier_name'],
                        'shop_name' => $supplier_data['shop_name'],
                        'order_id' => $order->id,
                        'total_amount' => $order->total_amount,
                        'franco_respected' => $order->franco_respected
                    ];
                }
            }
        }

        return $processed_orders;
    }

    /**
     * Récupère les paramètres de commandes automatiques
     */
    private static function getAutomaticOrderSettings($id_shop, $id_supplier)
    {
        $sql = 'SELECT *
                FROM `'._DB_PREFIX_.'automatic_order_settings`
                WHERE id_shop = ' . (int)$id_shop . '
                  AND id_supplier = ' . (int)$id_supplier;
        return Db::getInstance()->getRow($sql);
    }
}
