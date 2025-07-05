<?php
if (!defined('_PS_VERSION_')) {
    exit;
}

class AdminSupplierManagerDashboardController extends ModuleAdminController
{
    public function __construct()
    {
        $this->bootstrap = true;
        $this->display = 'view';
        
        parent::__construct();

        // Vérifier si le module est disponible avant d'utiliser ses méthodes
        if (isset($this->module) && $this->module !== null) {
            $this->meta_title = $this->l('Tableau de bord du gestionnaire de fournisseurs');
            
            if (!$this->module->active) {
                Tools::redirectAdmin($this->context->link->getAdminLink('AdminHome'));
            }
        } else {
            // Fallback si le module n'est pas disponible
            $this->meta_title = 'Tableau de bord du gestionnaire de fournisseurs';
            
            // Rediriger vers la page d'accueil si le module n'est pas disponible
            Tools::redirectAdmin($this->context->link->getAdminLink('AdminHome'));
        }
    }


    public function renderView()
    {
        try {
            // Vérifier si le contexte est disponible
            if (!isset($this->context) || $this->context === null) {
                return $this->displayError('Le contexte n\'est pas disponible');
            }
            
            // Récupérer les données pour le dashboard
            $lowStockProducts = $this->getLowStockProducts();
            $aiSuggestions = $this->getAISuggestions();
            $recentOrders = $this->getRecentOrders();
            $recentInvoices = $this->getRecentInvoices();
            $schedules = $this->getSchedules();
            $ordersWaitingForFranco = $this->getOrdersWaitingForFranco();
            $supplierPerformance = $this->getSupplierPerformance();
            
            // Vérifier si Smarty est disponible
            if (!isset($this->context->smarty) || $this->context->smarty === null) {
                return $this->displayError('Smarty n\'est pas disponible');
            }
            
            // Assigner les variables au template
            $summary = $this->getDashboardSummary();

            $this->context->smarty->assign([
                'lowStockProducts' => $lowStockProducts,
                'aiSuggestions' => $aiSuggestions,
                'recentOrders' => $recentOrders,
                'recentInvoices' => $recentInvoices,
                'schedules' => $schedules,
                'ordersWaitingForFranco' => $ordersWaitingForFranco,
                'supplierPerformance' => $supplierPerformance,
                'summary' => $summary,
                'link' => $this->context->link
            ]);
            
            // Vérifier si le module est disponible
            if (!isset($this->module) || $this->module === null) {
                return $this->displayError('Le module n\'est pas disponible');
            }
            
            // Utiliser try/catch pour capturer les erreurs de Smarty
            try {
                return $this->module->fetch('module:suppliermanager/views/templates/admin/dashboard.tpl');
            } catch (Exception $e) {
                return $this->displayError('Erreur lors du rendu du template : ' . $e->getMessage());
            }
        } catch (Exception $e) {
            return $this->displayError('Erreur dans renderView : ' . $e->getMessage());
        }
    }
    
    /**
     * Affiche un message d'erreur formaté
     */
    protected function displayError($message)
    {
        return '<div class="alert alert-danger"><strong>Erreur :</strong> ' . $message . '</div>';
    }

    protected function getLowStockProducts()
    {
        $id_shop = (int)$this->context->shop->id;
        $threshold = 5; // Seuil de stock bas
        
        return StockService::getProductsWithLowStock($id_shop, $threshold);
    }

    protected function getAISuggestions()
    {
        $id_shop = (int)$this->context->shop->id;
        
        return AISuggestion::getActiveSuggestions($id_shop, 10);
    }

    protected function getRecentOrders()
    {
        return SupplierOrder::getRecentOrders(10);
    }

    protected function getRecentInvoices()
    {
        return SupplierInvoice::getRecentInvoices(10);
    }

    protected function getSchedules()
    {
        return SupplierOrderSchedule::getAllSchedulesWithInfo($this->context->shop->id);
    }

    protected function getOrdersWaitingForFranco()
    {
        return SupplierFrancoCondition::getOrdersWaitingForFranco($this->context->shop->id);
    }

    protected function getSupplierPerformance()
    {
        $performance_data = Db::getInstance()->executeS('
            SELECT s.name, COUNT(so.id_order) as total_orders, SUM(so.total_amount) as total_amount_ordered
            FROM `'._DB_PREFIX_.'supplier_orders` so
            JOIN `'._DB_PREFIX_.'supplier` s ON so.id_supplier = s.id_supplier
            GROUP BY s.id_supplier
            ORDER BY total_orders DESC
            LIMIT 5
        ');
        return $performance_data;
    }

    protected function getDashboardSummary()
    {
        $summary = [];
        $summary['total_suppliers'] = Db::getInstance()->getValue('SELECT COUNT(*) FROM `'._DB_PREFIX_.'supplier` WHERE active = 1');
        $summary['pending_orders'] = Db::getInstance()->getValue('SELECT COUNT(*) FROM `'._DB_PREFIX_.'supplier_orders` WHERE status = "pending"');
        $summary['low_stock_products'] = count($this->getLowStockProducts());
        $summary['orders_to_schedule'] = Db::getInstance()->getValue('SELECT COUNT(*) FROM `'._DB_PREFIX_.'supplier_order_schedules` WHERE next_order_date <= CURDATE() AND is_paused = 0');
        return $summary;
    }

    public function ajaxProcessGenerateSuggestions()
    {
        $id_shop = (int)$this->context->shop->id;
        $id_supplier = Tools::getValue('id_supplier');
        
        $geminiService = new GeminiAIService();
        $suggestions = $geminiService->generateSuggestionsForAllProducts($id_shop, $id_supplier);
        
        die(json_encode([
            'success' => true,
            'suggestions' => $suggestions,
            'count' => count($suggestions)
        ]));
    }

    public function ajaxProcessProcessInvoices()
    {
        $emailService = new EmailService();
        $processed = $emailService->processInvoices();
        
        die(json_encode([
            'success' => true,
            'processed' => $processed,
            'count' => count($processed)
        ]));
    }
}
