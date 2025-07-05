<?php
if (!defined('_PS_VERSION_')) {
    exit;
}

class AdminSupplierManagerOrdersController extends ModuleAdminController
{
    public function __construct()
    {
        $this->bootstrap = true;
        $this->table = 'supplier_orders';
        $this->className = 'SupplierOrder';
        $this->lang = false;
        $this->addRowAction('view');
        $this->addRowAction('edit');
        $this->addRowAction('delete');
        $this->explicitSelect = true;
        $this->allow_export = true;
        $this->deleted = false;
        $this->context = Context::getContext();
        $this->identifier = 'id_order';

        parent::__construct();
        
        if (!$this->module->active) {
            Tools::redirectAdmin($this->context->link->getAdminLink('AdminHome'));
        }

        $this->_select = '
            s.name as supplier_name, 
            CONCAT(e.firstname, " ", e.lastname) as employee_name, 
            sh.name as shop_name';
        
        $this->_join = '
            LEFT JOIN `'._DB_PREFIX_.'supplier` s ON (a.id_supplier = s.id_supplier)
            LEFT JOIN `'._DB_PREFIX_.'employee` e ON (a.id_employee = e.id_employee)
            LEFT JOIN `'._DB_PREFIX_.'shop` sh ON (a.id_shop = sh.id_shop)';
        
        $this->_orderBy = 'order_date';
        $this->_orderWay = 'DESC';
        
        $this->fields_list = [
            'id_order' => [
                'title' => $this->l('ID'),
                'align' => 'center',
                'class' => 'fixed-width-xs'
            ],
            'supplier_name' => [
                'title' => $this->l('Fournisseur'),
                'filter_key' => 's!name'
            ],
            'shop_name' => [
                'title' => $this->l('Boutique'),
                'filter_key' => 'sh!name'
            ],
            'employee_name' => [
                'title' => $this->l('Employé'),
                'filter_key' => 'employee_name'
            ],
            'order_date' => [
                'title' => $this->l('Date'),
                'type' => 'date'
            ],
            'status' => [
                'title' => $this->l('Statut'),
                'type' => 'select',
                'list' => [
                    SupplierOrder::STATUS_DRAFT => $this->l('Brouillon'),
                    SupplierOrder::STATUS_PENDING => $this->l('En attente'),
                    SupplierOrder::STATUS_SENT => $this->l('Envoyée'),
                    SupplierOrder::STATUS_CONFIRMED => $this->l('Confirmée'),
                    SupplierOrder::STATUS_RECEIVED => $this->l('Reçue'),
                    SupplierOrder::STATUS_CANCELLED => $this->l('Annulée')
                ],
                'filter_key' => 'a!status',
                'badge_success' => [SupplierOrder::STATUS_RECEIVED],
                'badge_warning' => [SupplierOrder::STATUS_PENDING, SupplierOrder::STATUS_SENT],
                'badge_danger' => [SupplierOrder::STATUS_CANCELLED]
            ],
            'total_amount' => [
                'title' => $this->l('Total'),
                'type' => 'price',
                'align' => 'right'
            ],
            'ai_suggested' => [
                'title' => $this->l('Suggéré par IA'),
                'align' => 'center',
                'type' => 'bool',
                'active' => 'ai'
            ]
        ];
    }

    public function setMedia($isNewTheme = false)
    {
        parent::setMedia($isNewTheme);
        $this->addJquery();
        $this->addJqueryUI('ui.autocomplete');
    }

    public function renderList()
    {
        // Use our debug template to test
        $this->context->smarty->assign([
            'link' => $this->context->link,
            'table' => $this->table,
            'token' => $this->token
        ]);
        
        return $this->module->fetch('module:suppliermanager/views/templates/admin/debug.tpl');
    }

    public function renderView()
    {
        $id_order = (int)Tools::getValue('id_order');
        
        if (!$id_order) {
            return $this->displayError($this->l('L\'ID de la commande est manquant'));
        }
        
        $order = new SupplierOrder($id_order);
        
        if (!Validate::isLoadedObject($order)) {
            return $this->displayError($this->l('Commande non trouvée'));
        }
        
        // Récupérer les détails de la commande
        $orderDetails = $order->getOrderDetailsWithProductInfo();
        
        // Récupérer les informations du fournisseur
        $supplier = new Supplier($order->id_supplier);
        $supplierExtended = SupplierExtended::getByIdSupplier($order->id_supplier);
        
        // Récupérer les factures liées à cette commande
        $invoices = SupplierInvoice::getInvoicesByOrder($id_order);

        // Calculer la quantité totale
        $totalQuantity = 0;
        foreach ($orderDetails as $detail) {
            $totalQuantity += $detail['quantity'];
        }
        
        $currency = new Currency(Configuration::get('PS_CURRENCY_DEFAULT'));
        $this->context->smarty->assign([
            'order' => $order,
            'orderDetails' => $orderDetails,
            'totalQuantity' => $totalQuantity,
            'supplier' => $supplier,
            'supplierExtended' => $supplierExtended,
            'invoices' => $invoices,
            'statusList' => [
                SupplierOrder::STATUS_DRAFT => $this->l('Brouillon'),
                SupplierOrder::STATUS_PENDING => $this->l('En attente'),
                SupplierOrder::STATUS_SENT => $this->l('Envoyée'),
                SupplierOrder::STATUS_CONFIRMED => $this->l('Confirmée'),
                SupplierOrder::STATUS_RECEIVED => $this->l('Reçue'),
                SupplierOrder::STATUS_CANCELLED => $this->l('Annulée')
            ],
            'link' => $this->context->link,
            'currency' => $currency
        ]);
        
        return $this->module->fetch('module:suppliermanager/views/templates/admin/order_view.tpl');
    }

    /**
     * Affiche un message d'erreur formaté
     */
    protected function displayError($message)
    {
        return '<div class="alert alert-danger"><strong>Erreur :</strong> ' . $message . '</div>';
    }

    public function renderForm()
    {
        // Récupérer la liste des fournisseurs
        $suppliers = Supplier::getSuppliers(false, $this->context->language->id);
        
        // Récupérer la liste des boutiques
        $shops = Shop::getShops(true);
        
        $this->fields_form = [
            'legend' => [
                'title' => $this->l('Commande Fournisseur'),
                'icon' => 'icon-shopping-cart'
            ],
            'input' => [
                [
                    'type' => 'select',
                    'label' => $this->l('Fournisseur'),
                    'name' => 'id_supplier',
                    'required' => true,
                    'options' => [
                        'query' => $suppliers,
                        'id' => 'id_supplier',
                        'name' => 'name'
                    ],
                    'hint' => $this->l('Sélectionnez le fournisseur pour cette commande')
                ],
                [
                    'type' => 'select',
                    'label' => $this->l('Boutique'),
                    'name' => 'id_shop',
                    'required' => true,
                    'options' => [
                        'query' => $shops,
                        'id' => 'id_shop',
                        'name' => 'name'
                    ],
                    'hint' => $this->l('Sélectionnez la boutique pour cette commande')
                ],
                [
                    'type' => 'date',
                    'label' => $this->l('Date de la commande'),
                    'name' => 'order_date',
                    'required' => true
                ],
                [
                    'type' => 'select',
                    'label' => $this->l('Statut'),
                    'name' => 'status',
                    'required' => true,
                    'options' => [
                        'query' => [
                            ['id' => SupplierOrder::STATUS_DRAFT, 'name' => $this->l('Brouillon')],
                            ['id' => SupplierOrder::STATUS_PENDING, 'name' => $this->l('En attente')],
                            ['id' => SupplierOrder::STATUS_SENT, 'name' => $this->l('Envoyée')],
                            ['id' => SupplierOrder::STATUS_CONFIRMED, 'name' => $this->l('Confirmée')],
                            ['id' => SupplierOrder::STATUS_RECEIVED, 'name' => $this->l('Reçue')],
                            ['id' => SupplierOrder::STATUS_CANCELLED, 'name' => $this->l('Annulée')]
                        ],
                        'id' => 'id',
                        'name' => 'name'
                    ]
                ],
                [
                    'type' => 'switch',
                    'label' => $this->l('Suggéré par IA'),
                    'name' => 'ai_suggested',
                    'required' => false,
                    'is_bool' => true,
                    'values' => [
                        [
                            'id' => 'active_on',
                            'value' => 1,
                            'label' => $this->l('Oui')
                        ],
                        [
                            'id' => 'active_off',
                            'value' => 0,
                            'label' => $this->l('Non')
                        ]
                    ]
                ]
            ],
            'submit' => [
                'title' => $this->l('Enregistrer')
            ]
        ];
        
        // Si c'est une édition, on ne peut pas modifier le fournisseur et la boutique
        if (Tools::isSubmit('id_order')) {
            $this->fields_form['input'][0]['disabled'] = true;
            $this->fields_form['input'][1]['disabled'] = true;

            // Charger les détails de la commande pour le template des produits
            $order = new SupplierOrder((int)Tools::getValue('id_order'));
            $this->context->smarty->assign([
                'order' => $order,
                'orderDetails' => $order->getOrderDetailsWithProductInfo(),
                'currentToken' => Tools::getAdminTokenLite('AdminSupplierManagerOrders')
            ]);

            $this->fields_form['input'][] = [
                'type' => 'html',
                'name' => 'products',
                'html_content' => $this->context->smarty->fetch('module:suppliermanager/views/templates/admin/order_products.tpl'),
            ];
        }
        
        // Définir l'employé actuel comme créateur de la commande
        if (!Tools::isSubmit('id_order')) {
            $this->fields_value['id_employee'] = $this->context->employee->id;
            $this->fields_value['order_date'] = date('Y-m-d');
            $this->fields_value['status'] = SupplierOrder::STATUS_DRAFT;
            $this->informations[] = $this->l('Vous pourrez ajouter des produits à la commande après l\'avoir enregistrée.');
        }
        
        return parent::renderForm();
    }

    public function postProcess()
    {
        if (Tools::isSubmit('submitAdd'.$this->table)) {
            $_POST['id_employee'] = $this->context->employee->id;
            $order = parent::postProcess();
            if ($order) {
                $this->redirect_after = self::$currentIndex.'&id_order='.$order->id.'&update'.$this->table.'&token='.$this->token;
            }
            return $order;
        }

        // Gérer les actions spéciales
        if (Tools::isSubmit('sendOrder')) {
            $this->processSendOrder();
        } elseif (Tools::isSubmit('generatePdf')) {
            $this->processGeneratePdf();
        } elseif (Tools::isSubmit('updateStatus')) {
            $this->processUpdateStatus();
        } elseif (Tools::isSubmit('addProduct')) {
            $this->processAddProduct();
        } elseif (Tools::isSubmit('removeProduct')) {
            $this->processRemoveProduct();
        } elseif (Tools::isSubmit('updateQuantity')) {
            $this->processUpdateQuantity();
        } elseif (Tools::isSubmit('receiveOrder')) {
            $this->processReceiveOrder();
        }
        
        return parent::postProcess();
    }

    protected function processSendOrder()
    {
        $id_order = (int)Tools::getValue('id_order');
        
        if (!$id_order) {
            $this->errors[] = $this->l('L\'ID de la commande est manquant');
            return;
        }
        
        $order = new SupplierOrder($id_order);
        
        if (!Validate::isLoadedObject($order)) {
            $this->errors[] = $this->l('Commande non trouvée');
            return;
        }
        
        // Vérifier que la commande est en statut "pending"
        if ($order->status != SupplierOrder::STATUS_PENDING) {
            $this->errors[] = $this->l('Seules les commandes en attente peuvent être envoyées');
            return;
        }
        
        // Envoyer la commande par email
        $emailService = new EmailService();
        $result = $emailService->sendOrderByEmail($order);
        
        if ($result) {
            $this->confirmations[] = $this->l('Commande envoyée avec succès');
        } else {
            $this->errors[] = $this->l('Erreur lors de l\'envoi de la commande');
        }
    }

    protected function processGeneratePdf()
    {
        $id_order = (int)Tools::getValue('id_order');
        
        if (!$id_order) {
            $this->errors[] = $this->l('L\'ID de la commande est manquant');
            return;
        }
        
        $order = new SupplierOrder($id_order);
        
        if (!Validate::isLoadedObject($order)) {
            $this->errors[] = $this->l('Commande non trouvée');
            return;
        }
        
        // Générer le PDF
        $pdfService = new PDFService();
        $pdfPath = $pdfService->generateOrderPdf($order);
        
        if ($pdfPath) {
            // Télécharger le PDF
            header('Content-Type: application/pdf');
            header('Content-Disposition: attachment; filename="order_'.$order->id.'.pdf"');
            readfile($pdfPath);
            exit;
        } else {
            $this->errors[] = $this->l('Erreur lors de la génération du PDF');
        }
    }

    protected function processUpdateStatus()
    {
        $id_order = (int)Tools::getValue('id_order');
        $status = Tools::getValue('status');
        
        if (!$id_order) {
            $this->errors[] = $this->l('L\'ID de la commande est manquant');
            return;
        }
        
        $order = new SupplierOrder($id_order);
        
        if (!Validate::isLoadedObject($order)) {
            $this->errors[] = $this->l('Commande non trouvée');
            return;
        }
        
        // Vérifier que le statut est valide
        $validStatuses = [
            SupplierOrder::STATUS_DRAFT,
            SupplierOrder::STATUS_PENDING,
            SupplierOrder::STATUS_SENT,
            SupplierOrder::STATUS_CONFIRMED,
            SupplierOrder::STATUS_RECEIVED,
            SupplierOrder::STATUS_CANCELLED
        ];
        
        if (!in_array($status, $validStatuses)) {
            $this->errors[] = $this->l('Statut invalide');
            return;
        }
        
        // Mettre à jour le statut
        $order->status = $status;
        
        if ($order->update()) {
            $this->confirmations[] = $this->l('Statut mis à jour avec succès');
            
            // Si le statut est "received", mettre à jour les stocks
            if ($status == SupplierOrder::STATUS_RECEIVED) {
                StockService::updateStockFromSupplierOrder($id_order);
            }
        } else {
            $this->errors[] = $this->l('Erreur lors de la mise à jour du statut');
        }
    }

    protected function processAddProduct()
    {
        $id_order = (int)Tools::getValue('id_order');
        $id_product = (int)Tools::getValue('id_product');
        $id_product_attribute = (int)Tools::getValue('id_product_attribute', 0);
        $quantity = (int)Tools::getValue('quantity');
        $unit_price = (float)Tools::getValue('unit_price');
        
        if (!$id_order || !$id_product || !$quantity) {
            $this->errors[] = $this->l('Champs requis manquants');
            return;
        }
        
        $order = new SupplierOrder($id_order);
        
        if (!Validate::isLoadedObject($order)) {
            $this->errors[] = $this->l('Commande non trouvée');
            return;
        }
        
        // Vérifier si le produit existe déjà dans la commande
        $existingDetail = SupplierOrderDetail::getByOrderAndProduct($id_order, $id_product, $id_product_attribute);
        
        if ($existingDetail) {
            // Mettre à jour la quantité
            $existingDetail->quantity += $quantity;
            $existingDetail->unit_price = $unit_price;
            
            if ($existingDetail->update()) {
                $this->confirmations[] = $this->l('Quantité du produit mise à jour');
            } else {
                $this->errors[] = $this->l('Erreur lors de la mise à jour de la quantité du produit');
            }
        } else {
            // Ajouter le produit
            $result = $order->addOrderDetail($id_product, $id_product_attribute, $quantity, $unit_price);
            
            if ($result) {
                $this->confirmations[] = $this->l('Produit ajouté à la commande');
            } else {
                $this->errors[] = $this->l('Erreur lors de l\'ajout du produit à la commande');
            }
        }
        
        // Mettre à jour le montant total de la commande
        $order->updateTotalAmount();
    }

    protected function processRemoveProduct()
    {
        $id_order_detail = (int)Tools::getValue('id_order_detail');
        
        if (!$id_order_detail) {
            $this->errors[] = $this->l('L\'ID du détail de la commande est manquant');
            return;
        }
        
        $orderDetail = new SupplierOrderDetail($id_order_detail);
        
        if (!Validate::isLoadedObject($orderDetail)) {
            $this->errors[] = $this->l('Détail de la commande non trouvé');
            return;
        }
        
        $id_order = $orderDetail->id_order;
        
        if ($orderDetail->delete()) {
            $this->confirmations[] = $this->l('Produit supprimé de la commande');
            
            // Mettre à jour le montant total de la commande
            $order = new SupplierOrder($id_order);
            $order->updateTotalAmount();
        } else {
            $this->errors[] = $this->l('Erreur lors de la suppression du produit de la commande');
        }
    }

    protected function processUpdateQuantity()
    {
        $id_order_detail = (int)Tools::getValue('id_order_detail');
        $quantity = (int)Tools::getValue('quantity');
        
        if (!$id_order_detail || !$quantity) {
            $this->errors[] = $this->l('Champs requis manquants');
            return;
        }
        
        $orderDetail = new SupplierOrderDetail($id_order_detail);
        
        if (!Validate::isLoadedObject($orderDetail)) {
            $this->errors[] = $this->l('Détail de la commande non trouvé');
            return;
        }
        
        $id_order = $orderDetail->id_order;
        
        // Mettre à jour la quantité
        $orderDetail->quantity = $quantity;
        
        if ($orderDetail->update()) {
            $this->confirmations[] = $this->l('Quantité mise à jour');
            
            // Mettre à jour le montant total de la commande
            $order = new SupplierOrder($id_order);
            $order->updateTotalAmount();
        } else {
            $this->errors[] = $this->l('Erreur lors de la mise à jour de la quantité');
        }
    }

    protected function processReceiveOrder()
    {
        $id_order = (int)Tools::getValue('id_order');
        
        if (!$id_order) {
            $this->errors[] = $this->l('L\'ID de la commande est manquant');
            return;
        }
        
        $order = new SupplierOrder($id_order);
        
        if (!Validate::isLoadedObject($order)) {
            $this->errors[] = $this->l('Commande non trouvée');
            return;
        }
        
        // Vérifier que la commande est en statut "confirmed"
        if ($order->status != SupplierOrder::STATUS_CONFIRMED) {
            $this->errors[] = $this->l('Seules les commandes confirmées peuvent être reçues');
            return;
        }
        
        // Mettre à jour le statut
        $order->status = SupplierOrder::STATUS_RECEIVED;
        
        if ($order->update()) {
            // Mettre à jour les stocks
            $result = StockService::updateStockFromSupplierOrder($id_order);
            
            if ($result) {
                $this->confirmations[] = $this->l('Commande reçue et stocks mis à jour');
            } else {
                $this->errors[] = $this->l('Commande reçue mais erreur lors de la mise à jour des stocks');
            }
        } else {
            $this->errors[] = $this->l('Erreur lors de la mise à jour du statut de la commande');
        }
    }

    public function initPageHeaderToolbar()
    {
        if ($this->display == 'view') {
            $id_order = (int)Tools::getValue('id_order');
            $order = new SupplierOrder($id_order);
            
            if (Validate::isLoadedObject($order)) {
                // Ajouter les boutons d'action
                $this->page_header_toolbar_btn['generate_pdf'] = [
                    'href' => self::$currentIndex.'&token='.$this->token.'&id_order='.$id_order.'&generatePdf',
                    'desc' => $this->l('Générer le PDF'),
                    'icon' => 'process-icon-download'
                ];
                
                if ($order->status == SupplierOrder::STATUS_PENDING) {
                    $this->page_header_toolbar_btn['send_order'] = [
                        'href' => self::$currentIndex.'&token='.$this->token.'&id_order='.$id_order.'&sendOrder',
                        'desc' => $this->l('Envoyer la commande'),
                        'icon' => 'process-icon-envelope'
                    ];
                }
                
                if ($order->status == SupplierOrder::STATUS_CONFIRMED) {
                    $this->page_header_toolbar_btn['receive_order'] = [
                        'href' => self::$currentIndex.'&token='.$this->token.'&id_order='.$id_order.'&receiveOrder',
                        'desc' => $this->l('Recevoir la commande'),
                        'icon' => 'process-icon-truck'
                    ];
                }
            }
        } elseif ($this->display == 'list') {
            $this->page_header_toolbar_btn['new_order'] = [
                'href' => self::$currentIndex.'&token='.$this->token.'&add'.$this->table,
                'desc' => $this->l('Ajouter une nouvelle commande'),
                'icon' => 'process-icon-new'
            ];
        }
        
        parent::initPageHeaderToolbar();
    }

    public function ajaxProcessSearchProducts()
    {
        $query = Tools::getValue('q');
        $id_supplier = (int)Tools::getValue('id_supplier');
        $limit = 20;
        
    if (!$query) {
        die(json_encode(['error' => 'No query provided']));
    }
        
        $sql = 'SELECT p.id_product, pl.name, p.reference, p.ean13, p.upc,
                       pcb.supplier_reference as product_supplier_reference,
                       spc.current_price as product_supplier_price_te
                FROM `'._DB_PREFIX_.'product` p
                JOIN `'._DB_PREFIX_.'product_lang` pl ON (p.id_product = pl.id_product)
                JOIN `'._DB_PREFIX_.'product_pcb_conditions` pcb ON (p.id_product = pcb.id_product)
                LEFT JOIN `'._DB_PREFIX_.'supplier_product_conditions` spc ON (p.id_product = spc.id_product AND spc.id_supplier = pcb.id_supplier)
                WHERE pcb.id_supplier = '.(int)$id_supplier.'
                AND (pl.name LIKE "%'.pSQL($query).'%"
                       OR p.reference LIKE "%'.pSQL($query).'%"
                       OR p.ean13 LIKE "%'.pSQL($query).'%"
                       OR p.upc LIKE "%'.pSQL($query).'%"
                       OR pcb.supplier_reference LIKE "%'.pSQL($query).'%")
                AND pl.id_lang = '.(int)$this->context->language->id.'
                AND p.active = 1
                GROUP BY p.id_product
                LIMIT '.$limit;
        
        $products = Db::getInstance()->executeS($sql);
        
        die(json_encode($products));
    }
    

    public function ajaxProcessGetProductAttributes()
    {
        $id_product = (int)Tools::getValue('id_product');
        
        if (!$id_product) {
            die(json_encode([]));
        }
        
        $product = new Product($id_product);
        $attributes = $product->getAttributesResume($this->context->language->id);
        
        die(json_encode($attributes));
    }

    public function ajaxProcessGetProductInfo()
    {
        $id_product = (int)Tools::getValue('id_product');
        $id_supplier = (int)Tools::getValue('id_supplier');
        
        if (!$id_product || !$id_supplier) {
            die(json_encode([]));
        }
        
        $sql = 'SELECT p.*, pl.name, ps.product_supplier_reference, ps.product_supplier_price_te,
                       spc.min_quantity, spc.current_price
                FROM `'._DB_PREFIX_.'product` p
                JOIN `'._DB_PREFIX_.'product_lang` pl ON (p.id_product = pl.id_product)
                LEFT JOIN `'._DB_PREFIX_.'product_supplier` ps ON (p.id_product = ps.id_product AND ps.id_supplier = '.$id_supplier.')
                LEFT JOIN `'._DB_PREFIX_.'supplier_product_conditions` spc ON (p.id_product = spc.id_product AND spc.id_supplier = '.$id_supplier.')
                WHERE p.id_product = '.$id_product.'
                AND pl.id_lang = '.(int)$this->context->language->id;
        
        $product = Db::getInstance()->getRow($sql);
        
        die(json_encode($product));
    }
}
