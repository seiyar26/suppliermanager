<?php
if (!defined('_PS_VERSION_')) {
    exit;
}

class AdminSupplierManagerStocksController extends ModuleAdminController
{
    public function __construct()
    {
        $this->bootstrap = true;
        $this->display = 'view';
        
        parent::__construct();

        $this->meta_title = $this->l('Gestion des stocks');
        
        if (!$this->module->active) {
            Tools::redirectAdmin($this->context->link->getAdminLink('AdminHome'));
        }
    }

    public function initContent()
    {
        $this->content = $this->renderView();
        
        parent::initContent();
    }

    public function renderView()
    {
        // Récupérer les filtres
        $id_supplier = (int)Tools::getValue('id_supplier', 0);
        $id_shop = (int)Tools::getValue('id_shop', $this->context->shop->id);
        $stockThreshold = (int)Tools::getValue('stock_threshold', 5);
        
        // Récupérer la liste des fournisseurs
        $suppliers = Supplier::getSuppliers(false, $this->context->language->id);
        array_unshift($suppliers, ['id_supplier' => 0, 'name' => $this->l('Tous les fournisseurs')]);
        
        // Récupérer la liste des boutiques
        $shops = Shop::getShops(true);
        
        // Récupérer les produits avec leurs informations de stock
        $products = StockService::getProductsWithStockInfo($id_shop, $id_supplier);
        
        // Filtrer les produits avec un stock bas si demandé
        $lowStockOnly = (bool)Tools::getValue('low_stock_only', false);
        if ($lowStockOnly) {
            $products = array_filter($products, function($product) use ($stockThreshold) {
                return $product['quantity'] <= $stockThreshold;
            });
        }
        
        // Assigner les variables au template
        $this->context->smarty->assign([
            'suppliers' => $suppliers,
            'shops' => $shops,
            'products' => $products,
            'selected_supplier' => $id_supplier,
            'selected_shop' => $id_shop,
            'stock_threshold' => $stockThreshold,
            'low_stock_only' => $lowStockOnly,
            'link' => $this->context->link
        ]);
        
        return $this->module->fetch('module:suppliermanager/views/templates/admin/stocks.tpl');
    }

    public function postProcess()
    {
        // Gérer les actions spéciales
        if (Tools::isSubmit('updateStock')) {
            $this->processUpdateStock();
        } elseif (Tools::isSubmit('generateSuggestions')) {
            $this->processGenerateSuggestions();
        } elseif (Tools::isSubmit('createOrder')) {
            $this->processCreateOrder();
        }
        
        return parent::postProcess();
    }

    protected function processUpdateStock()
    {
        $id_product = (int)Tools::getValue('id_product');
        $id_shop = (int)Tools::getValue('id_shop');
        $quantity = (int)Tools::getValue('quantity');
        $id_product_attribute = (int)Tools::getValue('id_product_attribute', 0);
        
        if (!$id_product || !$id_shop) {
            $this->errors[] = $this->l('Champs requis manquants');
            return;
        }
        
        $result = StockService::updateProductStock($id_product, $id_shop, $quantity, $id_product_attribute);
        
        if ($result) {
            $this->confirmations[] = $this->l('Stock mis à jour avec succès');
        } else {
            $this->errors[] = $this->l('Erreur lors de la mise à jour du stock');
        }
    }

    protected function processGenerateSuggestions()
    {
        $id_shop = (int)Tools::getValue('id_shop');
        $id_supplier = (int)Tools::getValue('id_supplier', 0);
        
        $geminiService = new GeminiAIService();
        $suggestions = $geminiService->generateSuggestionsForAllProducts($id_shop, $id_supplier);
        
        if (count($suggestions) > 0) {
            $this->confirmations[] = sprintf($this->l('%d suggestions générées'), count($suggestions));
        } else {
            $this->errors[] = $this->l('Aucune suggestion n\'a pu être générée');
        }
    }

    protected function processCreateOrder()
    {
        $id_supplier = (int)Tools::getValue('id_supplier');
        $id_shop = (int)Tools::getValue('id_shop');
        $products = Tools::getValue('products', []);
        
        if (!$id_supplier || !$id_shop || empty($products)) {
            $this->errors[] = $this->l('Champs requis manquants');
            return;
        }
        
        // Créer une nouvelle commande
        $order = new SupplierOrder();
        $order->id_supplier = $id_supplier;
        $order->id_shop = $id_shop;
        $order->id_employee = $this->context->employee->id;
        $order->order_date = date('Y-m-d H:i:s');
        $order->status = SupplierOrder::STATUS_DRAFT;
        $order->ai_suggested = 0;
        
        if ($order->save()) {
            // Ajouter les produits à la commande
            foreach ($products as $productData) {
                $id_product = (int)$productData['id_product'];
                $quantity = (int)$productData['quantity'];
                $unit_price = (float)$productData['unit_price'];
                
                if ($id_product && $quantity > 0) {
                    $order->addOrderDetail($id_product, 0, $quantity, $unit_price);
                }
            }
            
            // Mettre à jour le montant total
            $order->updateTotalAmount();
            
            $this->confirmations[] = $this->l('Commande créée avec succès');
            
            // Rediriger vers la page de la commande
            Tools::redirectAdmin($this->context->link->getAdminLink('AdminSupplierManagerOrders').'&id_order='.$order->id.'&viewsupplier_orders');
        } else {
            $this->errors[] = $this->l('Erreur lors de la création de la commande');
        }
    }

    public function ajaxProcessGetProductStockHistory()
    {
        $id_product = (int)Tools::getValue('id_product');
        $id_shop = (int)Tools::getValue('id_shop');
        $days = (int)Tools::getValue('days', 30);
        
        if (!$id_product || !$id_shop) {
            die(json_encode([]));
        }
        
        $history = StockService::getStockMovementHistory($id_product, $id_shop, $days);
        
        die(json_encode($history));
    }

    public function ajaxProcessGetProductSuggestion()
    {
        $id_product = (int)Tools::getValue('id_product');
        $id_shop = (int)Tools::getValue('id_shop');
        
        if (!$id_product || !$id_shop) {
            die(json_encode([]));
        }
        
        $geminiService = new GeminiAIService();
        $suggestion = $geminiService->suggestOrderQuantities($id_product, $id_shop);
        
        die(json_encode($suggestion));
    }

    public function ajaxProcessUpdateMultipleStocks()
    {
        $stocks = Tools::getValue('stocks', []);
        $id_shop = (int)Tools::getValue('id_shop');
        
        if (empty($stocks) || !$id_shop) {
            die(json_encode([
                'success' => false,
                'message' => $this->l('Champs requis manquants')
            ]));
        }
        
        $success = true;
        $updated = 0;
        
        foreach ($stocks as $stock) {
            $id_product = (int)$stock['id_product'];
            $quantity = (int)$stock['quantity'];
            
            if ($id_product && $quantity >= 0) {
                $result = StockService::updateProductStock($id_product, $id_shop, $quantity);
                $success = $success && $result;
                
                if ($result) {
                    $updated++;
                }
            }
        }
        
        die(json_encode([
            'success' => $success,
            'message' => sprintf($this->l('%d stocks mis à jour'), $updated),
            'updated' => $updated
        ]));
    }
}