<?php
if (!defined('_PS_VERSION_')) {
    exit;
}

class AdminSupplierManagerInvoicesController extends ModuleAdminController
{
    public function __construct()
    {
        $this->bootstrap = true;
        $this->table = 'supplier_invoices';
        $this->className = 'SupplierInvoice';
        $this->lang = false;
        $this->addRowAction('view');
        $this->addRowAction('edit');
        $this->addRowAction('delete');
        $this->explicitSelect = true;
        $this->allow_export = true;
        $this->deleted = false;
        $this->context = Context::getContext();

        parent::__construct();
        
        if (!$this->module->active) {
            Tools::redirectAdmin($this->context->link->getAdminLink('AdminHome'));
        }

        $this->_select = 's.name as supplier_name';
        $this->_join = 'LEFT JOIN `'._DB_PREFIX_.'supplier` s ON (a.id_supplier = s.id_supplier)';
        $this->_orderBy = 'invoice_date';
        $this->_orderWay = 'DESC';
        
        $this->fields_list = [
            'id_invoice' => [
                'title' => $this->l('ID'),
                'align' => 'center',
                'class' => 'fixed-width-xs'
            ],
            'invoice_number' => [
                'title' => $this->l('Numéro de facture'),
                'filter_key' => 'a!invoice_number'
            ],
            'supplier_name' => [
                'title' => $this->l('Fournisseur'),
                'filter_key' => 's!name'
            ],
            'invoice_date' => [
                'title' => $this->l('Date'),
                'type' => 'date'
            ],
            'amount' => [
                'title' => $this->l('Montant'),
                'type' => 'price',
                'align' => 'right'
            ],
            'id_order' => [
                'title' => $this->l('ID Commande'),
                'align' => 'center',
                'callback' => 'displayOrderLink'
            ],
            'processed' => [
                'title' => $this->l('Traité'),
                'align' => 'center',
                'type' => 'bool',
                'active' => 'processed'
            ]
        ];
    }

    public function displayOrderLink($id_order, $row)
    {
        if (!$id_order) {
            return '-';
        }
        
        return '<a href="'.$this->context->link->getAdminLink('AdminSupplierManagerOrders').'&id_order='.$id_order.'&viewsupplier_orders">'.$id_order.'</a>';
    }

    public function renderView()
    {
        $id_invoice = (int)Tools::getValue('id_invoice');
        
        if (!$id_invoice) {
            return $this->displayError($this->l('L\'ID de la facture est manquant'));
        }
        
        $invoice = new SupplierInvoice($id_invoice);
        
        if (!Validate::isLoadedObject($invoice)) {
            return $this->displayError($this->l('Facture non trouvée'));
        }
        
        // Récupérer les informations du fournisseur
        $supplier = new Supplier($invoice->id_supplier);
        
        // Récupérer les informations de la commande associée
        $order = null;
        $orderDetails = [];
        
        if ($invoice->id_order) {
            $order = new SupplierOrder($invoice->id_order);
            
            if (Validate::isLoadedObject($order)) {
                $orderDetails = $order->getOrderDetailsWithProductInfo();
            }
        }
        
        $this->context->smarty->assign([
            'invoice' => $invoice,
            'supplier' => $supplier,
            'order' => $order,
            'orderDetails' => $orderDetails,
            'link' => $this->context->link
        ]);
        
        return $this->module->fetch('module:suppliermanager/views/templates/admin/invoice_view.tpl');
    }

    public function renderForm()
    {
        // Récupérer la liste des fournisseurs
        $suppliers = Supplier::getSuppliers(false, $this->context->language->id);
        
        // Récupérer la liste des commandes
        $orders = SupplierOrder::getRecentOrders(100);
        $orderOptions = [['id_order' => 0, 'name' => $this->l('-- Aucune commande --')]];
        
        foreach ($orders as $order) {
            $orderOptions[] = [
                'id_order' => $order['id_order'],
                'name' => sprintf('#%d - %s (%s)', $order['id_order'], $order['supplier_name'], Tools::displayDate($order['order_date']))
            ];
        }
        
        $this->fields_form = [
            'legend' => [
                'title' => $this->l('Facture Fournisseur'),
                'icon' => 'icon-file-text'
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
                    'hint' => $this->l('Sélectionnez le fournisseur pour cette facture')
                ],
                [
                    'type' => 'text',
                    'label' => $this->l('Numéro de facture'),
                    'name' => 'invoice_number',
                    'required' => true,
                    'hint' => $this->l('Numéro de facture tel que fourni par le fournisseur')
                ],
                [
                    'type' => 'date',
                    'label' => $this->l('Date de la facture'),
                    'name' => 'invoice_date',
                    'required' => true
                ],
                [
                    'type' => 'text',
                    'label' => $this->l('Montant'),
                    'name' => 'amount',
                    'required' => true,
                    'suffix' => $this->context->currency->sign,
                    'hint' => $this->l('Montant total de la facture')
                ],
                [
                    'type' => 'file',
                    'label' => $this->l('Fichier de la facture'),
                    'name' => 'invoice_file',
                    'display_image' => false,
                    'desc' => $this->l('Télécharger le fichier PDF de la facture')
                ],
                [
                    'type' => 'select',
                    'label' => $this->l('Commande associée'),
                    'name' => 'id_order',
                    'options' => [
                        'query' => $orderOptions,
                        'id' => 'id_order',
                        'name' => 'name'
                    ],
                    'hint' => $this->l('Sélectionnez la commande fournisseur associée, le cas échéant')
                ],
                [
                    'type' => 'switch',
                    'label' => $this->l('Traité'),
                    'name' => 'processed',
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
                    ],
                    'hint' => $this->l('Marquer comme traité lorsque la facture a été gérée')
                ]
            ],
            'submit' => [
                'title' => $this->l('Enregistrer')
            ]
        ];
        
        // Si c'est une édition, afficher le fichier actuel
        if (Tools::isSubmit('id_invoice')) {
            $id_invoice = (int)Tools::getValue('id_invoice');
            $invoice = new SupplierInvoice($id_invoice);
            
            if (Validate::isLoadedObject($invoice) && $invoice->file_path) {
                $this->fields_form['input'][] = [
                    'type' => 'free',
                    'label' => $this->l('Fichier actuel'),
                    'name' => 'current_file',
                    'desc' => '<a href="'.$this->context->link->getAdminLink('AdminSupplierManagerInvoices').'&id_invoice='.$id_invoice.'&downloadInvoice" class="btn btn-default"><i class="icon-download"></i> '.$this->l('Télécharger').'</a>'
                ];
            }
        }
        
        return parent::renderForm();
    }

    public function postProcess()
    {
        // Gérer les actions spéciales
        if (Tools::isSubmit('downloadInvoice')) {
            $this->processDownloadInvoice();
        } elseif (Tools::isSubmit('scanEmails')) {
            $this->processScanEmails();
        } elseif (Tools::isSubmit('matchOrder')) {
            $this->processMatchOrder();
        }
        
        // Gérer l'upload de fichier lors de la sauvegarde
        if (Tools::isSubmit('submitAddsupplier_invoices') || Tools::isSubmit('submitEditsupplier_invoices')) {
            if (isset($_FILES['invoice_file']) && !empty($_FILES['invoice_file']['name'])) {
                $id_supplier = (int)Tools::getValue('id_supplier');
                $extension = pathinfo($_FILES['invoice_file']['name'], PATHINFO_EXTENSION);
                
                if (strtolower($extension) != 'pdf') {
                    $this->errors[] = $this->l('Seuls les fichiers PDF sont autorisés');
                    return false;
                }
                
                $dir = _PS_MODULE_DIR_.'suppliermanager/invoices/'.$id_supplier;
                
                if (!is_dir($dir)) {
                    mkdir($dir, 0777, true);
                }
                
                $filename = time().'_'.Tools::str2url(pathinfo($_FILES['invoice_file']['name'], PATHINFO_FILENAME)).'.pdf';
                $path = $dir.'/'.$filename;
                
                if (move_uploaded_file($_FILES['invoice_file']['tmp_name'], $path)) {
                    $_POST['file_path'] = $path;
                } else {
                    $this->errors[] = $this->l('Erreur lors du téléchargement du fichier');
                    return false;
                }
            }
        }
        
        return parent::postProcess();
    }

    protected function processDownloadInvoice()
    {
        $id_invoice = (int)Tools::getValue('id_invoice');
        
        if (!$id_invoice) {
            $this->errors[] = $this->l('L\'ID de la facture est manquant');
            return;
        }
        
        $invoice = new SupplierInvoice($id_invoice);
        
        if (!Validate::isLoadedObject($invoice) || !$invoice->file_path || !file_exists($invoice->file_path)) {
            $this->errors[] = $this->l('Fichier de facture non trouvé');
            return;
        }
        
        header('Content-Type: application/pdf');
        header('Content-Disposition: attachment; filename="invoice_'.$invoice->invoice_number.'.pdf"');
        readfile($invoice->file_path);
        exit;
    }

    protected function processScanEmails()
    {
        $emailService = new EmailService();
        $processed = $emailService->processInvoices();
        
        if (count($processed) > 0) {
            $this->confirmations[] = sprintf($this->l('%d nouvelles factures traitées'), count($processed));
        } else {
            $this->informations[] = $this->l('Aucune nouvelle facture trouvée');
        }
    }

    protected function processMatchOrder()
    {
        $id_invoice = (int)Tools::getValue('id_invoice');
        $id_order = (int)Tools::getValue('id_order');
        
        if (!$id_invoice) {
            $this->errors[] = $this->l('L\'ID de la facture est manquant');
            return;
        }
        
        $invoice = new SupplierInvoice($id_invoice);
        
        if (!Validate::isLoadedObject($invoice)) {
            $this->errors[] = $this->l('Facture non trouvée');
            return;
        }
        
        // Vérifier que la commande existe
        if ($id_order) {
            $order = new SupplierOrder($id_order);
            
            if (!Validate::isLoadedObject($order)) {
                $this->errors[] = $this->l('Commande non trouvée');
                return;
            }
        }
        
        // Mettre à jour l'association
        $invoice->id_order = $id_order;
        
        if ($invoice->update()) {
            $this->confirmations[] = $this->l('Facture associée à la commande avec succès');
        } else {
            $this->errors[] = $this->l('Erreur lors de l\'association de la facture à la commande');
        }
    }

    public function initPageHeaderToolbar()
    {
        if ($this->display == 'list') {
            $this->page_header_toolbar_btn['scan_emails'] = [
                'href' => self::$currentIndex.'&token='.$this->token.'&scanEmails',
                'desc' => $this->l('Scanner les e-mails pour les factures'),
                'icon' => 'process-icon-envelope'
            ];
            
            $this->page_header_toolbar_btn['new_invoice'] = [
                'href' => self::$currentIndex.'&token='.$this->token.'&add'.$this->table,
                'desc' => $this->l('Ajouter une nouvelle facture'),
                'icon' => 'process-icon-new'
            ];
        }
        
        parent::initPageHeaderToolbar();
    }

    public function ajaxProcessFindMatchingOrders()
    {
        $id_supplier = (int)Tools::getValue('id_supplier');
        $amount = (float)Tools::getValue('amount');
        
        if (!$id_supplier || !$amount) {
            die(json_encode([]));
        }
        
        $sql = 'SELECT so.*, s.name as supplier_name
                FROM `'._DB_PREFIX_.'supplier_orders` so
                JOIN `'._DB_PREFIX_.'supplier` s ON (so.id_supplier = s.id_supplier)
                WHERE so.id_supplier = '.$id_supplier.'
                AND ABS(so.total_amount - '.$amount.') < 1
                ORDER BY so.order_date DESC
                LIMIT 10';
        
        $orders = Db::getInstance()->executeS($sql);
        
        die(json_encode($orders));
    }
}