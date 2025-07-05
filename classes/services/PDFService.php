<?php
if (!defined('_PS_VERSION_')) {
    exit;
}

class PDFService
{
    public function generateOrderPdf(SupplierOrder $order)
    {
        try {
            if (!Validate::isLoadedObject($order)) {
                return false;
            }
            
            // Récupérer les informations du fournisseur
            $supplier = new Supplier($order->id_supplier);
            if (!Validate::isLoadedObject($supplier)) {
                return false;
            }
            
            // Récupérer les détails de la commande
            $orderDetails = $order->getOrderDetailsWithProductInfo();
            if (!is_array($orderDetails)) {
                $orderDetails = array(); // Assurer que c'est un tableau même si vide
            }
            
            // Récupérer les informations de la boutique
            $shop = new Shop($order->id_shop);
            if (!Validate::isLoadedObject($shop)) {
                // Utiliser la boutique par défaut si celle spécifiée n'existe pas
                $shop = new Shop(Configuration::get('PS_SHOP_DEFAULT'));
            }
            
            // Vérifier si le contexte Smarty est disponible
            $smarty = null;
            if (class_exists('Context') && Context::getContext() && Context::getContext()->smarty) {
                $smarty = Context::getContext()->smarty;
            } else {
                // Créer une instance Smarty si le contexte n'est pas disponible
                $smarty = new Smarty();
                $smarty->setCompileDir(_PS_CACHE_DIR_.'smarty/compile');
                $smarty->setCacheDir(_PS_CACHE_DIR_.'smarty/cache');
            }
            
            // Créer le PDF
            $pdf = new PDF([$this->getPdfData($order, $supplier, $orderDetails, $shop)], 'SupplierOrderPdf', $smarty);
            
            // Générer le PDF
            $pdfContent = $pdf->render(null, false);
            
            // Sauvegarder le PDF
            $pdfDir = _PS_MODULE_DIR_.'suppliermanager/orders/';
            if (!is_dir($pdfDir)) {
                mkdir($pdfDir, 0777, true);
            }
            
            $pdfPath = $pdfDir.'order_'.$order->id.'.pdf';
            file_put_contents($pdfPath, $pdfContent);
            
            return $pdfPath;
        } catch (Exception $e) {
            // Log l'erreur
            PrestaShopLogger::addLog('Error generating PDF for supplier order #'.$order->id.': '.$e->getMessage(), 3);
            return false;
        }
    }

    private function getPdfData(SupplierOrder $order, Supplier $supplier, $orderDetails, Shop $shop)
    {
        // Calculer les totaux
        $totalQuantity = 0;
        $totalAmount = 0;
        
        foreach ($orderDetails as $detail) {
            $totalQuantity += $detail['quantity'];
            $totalAmount += $detail['quantity'] * $detail['unit_price'];
        }
        
        // Préparer les données pour le template PDF
        return [
            'order' => [
                'id' => $order->id,
                'date' => Tools::displayDate($order->order_date),
                'status' => $order->status,
                'total_quantity' => $totalQuantity,
                'total_amount' => Tools::displayPrice($totalAmount)
            ],
            'supplier' => [
                'name' => $supplier->name,
                'address' => $supplier->address1,
                'city' => $supplier->city,
                'postcode' => $supplier->postcode,
                'country' => Country::getNameById(Context::getContext()->language->id, $supplier->id_country),
                'phone' => $supplier->phone,
                'email' => $supplier->email
            ],
            'shop' => [
                'name' => $shop->name,
                'address' => Configuration::get('PS_SHOP_ADDR1', null, null, $shop->id),
                'city' => Configuration::get('PS_SHOP_CITY', null, null, $shop->id),
                'postcode' => Configuration::get('PS_SHOP_CODE', null, null, $shop->id),
                'country' => Country::getNameById(Context::getContext()->language->id, Configuration::get('PS_SHOP_COUNTRY_ID', null, null, $shop->id)),
                'phone' => Configuration::get('PS_SHOP_PHONE', null, null, $shop->id),
                'email' => Configuration::get('PS_SHOP_EMAIL', null, null, $shop->id)
            ],
            'products' => $orderDetails
        ];
    }
}

/**
 * Classe PDF personnalisée pour les bons de commande fournisseurs
 */
class PDF extends PDFGenerator
{
    const DEFAULT_TEMPLATE = 'supplier_order';
    
    protected $objects;
    protected $template;
    protected $smarty;
    
    public function __construct($objects, $template, $smarty)
    {
        $this->objects = $objects;
        $this->template = $template;
        $this->smarty = $smarty;
        
        parent::__construct(self::DEFAULT_TEMPLATE);
    }
    
    /**
     * Méthode render surchargée pour être compatible avec toutes les versions de PrestaShop
     * 
     * @param string $filename Nom du fichier (optionnel)
     * @param bool $display Afficher ou retourner le contenu
     * @return mixed
     */
    public function render($filename = null, $display = true)
    {
        try {
            // Vérifier si Smarty est disponible
            if (!$this->smarty || !method_exists($this->smarty, 'assign')) {
                // Fallback si Smarty n'est pas disponible
                $this->content = '<h1>Supplier Order</h1>';
            } else {
                try {
                    $this->smarty->assign([
                        'order_data' => $this->objects[0]
                    ]);
                    
                    $template_path = _PS_MODULE_DIR_.'suppliermanager/views/templates/pdf/supplier_order.tpl';
                    if (file_exists($template_path)) {
                        $this->content = $this->smarty->fetch($template_path);
                    } else {
                        // Fallback si le template n'existe pas
                        $this->content = '<h1>Supplier Order</h1>';
                    }
                } catch (Exception $e) {
                    // En cas d'erreur avec Smarty, utiliser un contenu par défaut
                    $this->content = '<h1>Supplier Order</h1><p>Error: ' . $e->getMessage() . '</p>';
                    
                    // Log l'erreur
                    if (class_exists('PrestaShopLogger')) {
                        PrestaShopLogger::addLog('Error in PDF template: ' . $e->getMessage(), 3);
                    }
                }
            }
            
            // Écrire la page
            $this->writePage();
            
            // Vérifier si la méthode parente attend un paramètre filename
            $reflection = new ReflectionMethod('PDFGenerator', 'render');
            $parameters = $reflection->getParameters();
            
            // Si la méthode parente attend un paramètre filename, l'appeler avec ce paramètre
            if (count($parameters) > 0 && $parameters[0]->getName() === 'filename') {
                return parent::render($filename, $display);
            } else {
                // Sinon, appeler la méthode parente sans paramètre
                return parent::render();
            }
        } catch (Exception $e) {
            // En cas d'erreur, retourner un message d'erreur
            if (class_exists('PrestaShopLogger')) {
                PrestaShopLogger::addLog('Error rendering PDF: ' . $e->getMessage(), 3);
            }
            
            // Retourner un contenu par défaut
            $this->content = '<h1>Error generating PDF</h1><p>' . $e->getMessage() . '</p>';
            $this->writePage();
            return $this->buffer;
        }
    }
}