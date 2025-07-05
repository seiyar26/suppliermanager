<?php
if (!defined('_PS_VERSION_')) {
    exit;
}

class AdminSupplierManagerSuppliersController extends ModuleAdminController
{
    public function __construct()
    {
        $this->bootstrap = true;
        $this->table = 'supplier';
        $this->className = 'Supplier';
        $this->lang = false;
        $this->addRowAction('view');
        $this->addRowAction('edit');
        $this->explicitSelect = true;
        $this->allow_export = true;
        $this->deleted = false;
        $this->context = Context::getContext();

        parent::__construct();
        
        if (!$this->module->active) {
            Tools::redirectAdmin($this->context->link->getAdminLink('AdminHome'));
        }

        $this->_select = '
            se.min_order_quantity, 
            se.min_order_amount, 
            se.delivery_delay, 
            se.payment_terms, 
            se.auto_order_enabled';
        
        $this->_join = '
            LEFT JOIN `'._DB_PREFIX_.'suppliers_extended` se ON (a.id_supplier = se.id_supplier)';
        
        $this->fields_list = [
            'id_supplier' => [
                'title' => $this->l('ID'),
                'align' => 'center',
                'class' => 'fixed-width-xs'
            ],
            'name' => [
                'title' => $this->l('Nom'),
                'filter_key' => 'a!name'
            ],
            'min_order_quantity' => [
                'title' => $this->l('Qté Min'),
                'align' => 'center',
                'type' => 'int'
            ],
            'min_order_amount' => [
                'title' => $this->l('Montant Min'),
                'align' => 'right',
                'type' => 'price'
            ],
            'delivery_delay' => [
                'title' => $this->l('Délai de livraison (jours)'),
                'align' => 'center',
                'type' => 'int'
            ],
            'payment_terms' => [
                'title' => $this->l('Conditions de paiement'),
                'filter_key' => 'se!payment_terms'
            ],
            'auto_order_enabled' => [
                'title' => $this->l('Commande auto'),
                'align' => 'center',
                'type' => 'bool',
                'active' => 'auto_order'
            ]
        ];
    }

    public function renderView()
    {
        $id_supplier = (int)Tools::getValue('id_supplier');
        
        if (!$id_supplier) {
            return $this->displayError($this->l('L\'ID du fournisseur est manquant'));
        }
        
        $supplier = new Supplier($id_supplier);
        
        if (!Validate::isLoadedObject($supplier)) {
            return $this->displayError($this->l('Fournisseur non trouvé'));
        }
        
        // Récupérer les informations étendues du fournisseur
        $supplierExtended = SupplierExtended::getByIdSupplier($id_supplier);
        
        if (!$supplierExtended) {
            $supplierExtended = new SupplierExtended();
            $supplierExtended->id_supplier = $id_supplier;
            $supplierExtended->save();
        }
        
        // Récupérer les produits du fournisseur
        $products = SupplierProductCondition::getProductsBySupplier($id_supplier);
        
        // Récupérer les commandes récentes du fournisseur
        $orders = SupplierOrder::getOrdersBySupplier($id_supplier, 10);
        
        // Récupérer les factures récentes du fournisseur
        $invoices = SupplierInvoice::getInvoicesBySupplier($id_supplier, 10);
        
        $this->context->smarty->assign([
            'supplier' => $supplier,
            'supplierExtended' => $supplierExtended,
            'products' => $products,
            'orders' => $orders,
            'invoices' => $invoices,
            'link' => $this->context->link
        ]);
        
        return $this->module->fetch('module:suppliermanager/views/templates/admin/supplier_view.tpl');
    }

    public function renderForm()
    {
        // Si c'est une édition, récupérer les données étendues du fournisseur
        if (Tools::isSubmit('id_supplier')) {
            $id_supplier = (int)Tools::getValue('id_supplier');
            $supplierExtended = SupplierExtended::getByIdSupplier($id_supplier);
            
            if (!$supplierExtended) {
                $supplierExtended = new SupplierExtended();
                $supplierExtended->id_supplier = $id_supplier;
            }
        } else {
            $supplierExtended = new SupplierExtended();
        }
        
        // Ajouter les champs étendus au formulaire standard de PrestaShop
        $this->fields_form = [
            'legend' => [
                'title' => $this->l('Fournisseurs'),
                'icon' => 'icon-truck'
            ],
            'input' => [
                [
                    'type' => 'text',
                    'label' => $this->l('Nom'),
                    'name' => 'name',
                    'required' => true,
                    'hint' => $this->l('Caractères invalides :').' &lt;&gt;;=#{}'
                ],
                [
                    'type' => 'textarea',
                    'label' => $this->l('Description'),
                    'name' => 'description',
                    'lang' => true,
                    'hint' => $this->l('Caractères invalides :').' &lt;&gt;;=#{}'
                ],
                [
                    'type' => 'text',
                    'label' => $this->l('Téléphone'),
                    'name' => 'phone',
                    'hint' => $this->l('Numéro de téléphone de ce fournisseur')
                ],
                [
                    'type' => 'text',
                    'label' => $this->l('Téléphone portable'),
                    'name' => 'phone_mobile',
                    'hint' => $this->l('Numéro de téléphone portable de ce fournisseur')
                ],
                [
                    'type' => 'text',
                    'label' => $this->l('Adresse'),
                    'name' => 'address',
                    'hint' => $this->l('Caractères invalides :').' &lt;&gt;;=#{}'
                ],
                [
                    'type' => 'text',
                    'label' => $this->l('Adresse (2)'),
                    'name' => 'address2',
                    'hint' => $this->l('Caractères invalides :').' &lt;&gt;;=#{}'
                ],
                [
                    'type' => 'text',
                    'label' => $this->l('Code postal'),
                    'name' => 'postcode',
                    'hint' => $this->l('Caractères invalides :').' &lt;&gt;;=#{}'
                ],
                [
                    'type' => 'text',
                    'label' => $this->l('Ville'),
                    'name' => 'city',
                    'hint' => $this->l('Caractères invalides :').' &lt;&gt;;=#{}'
                ],
                [
                    'type' => 'select',
                    'label' => $this->l('Pays'),
                    'name' => 'id_country',
                    'required' => true,
                    'options' => [
                        'query' => Country::getCountries($this->context->language->id),
                        'id' => 'id_country',
                        'name' => 'name'
                    ]
                ],
                [
                    'type' => 'select',
                    'label' => $this->l('État'),
                    'name' => 'id_state',
                    'options' => [
                        'query' => [],
                        'id' => 'id_state',
                        'name' => 'name'
                    ]
                ],
                [
                    'type' => 'text',
                    'label' => $this->l('Adresse e-mail'),
                    'name' => 'email',
                    'required' => true
                ],
                [
                    'type' => 'text',
                    'label' => $this->l('Quantité minimale de commande'),
                    'name' => 'min_order_quantity',
                    'desc' => $this->l('Quantité minimale requise pour les commandes auprès de ce fournisseur'),
                    'hint' => $this->l('Quantité minimale de produits requise pour une commande'),
                    'suffix' => $this->l('unités'),
                    'class' => 'fixed-width-sm'
                ],
                [
                    'type' => 'text',
                    'label' => $this->l('Montant minimum de commande'),
                    'name' => 'min_order_amount',
                    'desc' => $this->l('Montant minimum requis pour les commandes auprès de ce fournisseur'),
                    'hint' => $this->l('Montant minimum requis pour une commande'),
                    'suffix' => $this->context->currency->sign,
                    'class' => 'fixed-width-sm'
                ],
                [
                    'type' => 'text',
                    'label' => $this->l('Délai de livraison'),
                    'name' => 'delivery_delay',
                    'desc' => $this->l('Délai de livraison moyen pour les produits de ce fournisseur'),
                    'suffix' => $this->l('jours'),
                    'class' => 'fixed-width-sm'
                ],
                [
                    'type' => 'text',
                    'label' => $this->l('Conditions de paiement'),
                    'name' => 'payment_terms',
                    'desc' => $this->l('Conditions de paiement pour ce fournisseur (par ex. 30 jours nets)'),
                    'hint' => $this->l('Conditions de paiement convenues avec ce fournisseur')
                ],
                [
                    'type' => 'switch',
                    'label' => $this->l('Activer les commandes automatiques'),
                    'name' => 'auto_order_enabled',
                    'desc' => $this->l('Autoriser le système à générer automatiquement des commandes pour ce fournisseur'),
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
                ],
                [
                    'type' => 'switch',
                    'label' => $this->l('Actif'),
                    'name' => 'active',
                    'required' => false,
                    'is_bool' => true,
                    'values' => [
                        [
                            'id' => 'active_on',
                            'value' => 1,
                            'label' => $this->l('Activé')
                        ],
                        [
                            'id' => 'active_off',
                            'value' => 0,
                            'label' => $this->l('Désactivé')
                        ]
                    ]
                ]
            ],
            'submit' => [
                'title' => $this->l('Enregistrer')
            ]
        ];
        
        // Charger les valeurs des champs étendus
        if (Validate::isLoadedObject($supplierExtended)) {
            $this->fields_value['min_order_quantity'] = $supplierExtended->min_order_quantity;
            $this->fields_value['min_order_amount'] = $supplierExtended->min_order_amount;
            $this->fields_value['delivery_delay'] = $supplierExtended->delivery_delay;
            $this->fields_value['payment_terms'] = $supplierExtended->payment_terms;
            $this->fields_value['auto_order_enabled'] = $supplierExtended->auto_order_enabled;
        }
        
        return parent::renderForm();
    }

    public function processSave()
    {
        $result = parent::processSave();
        
        if ($result) {
            $id_supplier = (int)Tools::getValue('id_supplier');
            
            if ($id_supplier) {
                $supplierExtended = SupplierExtended::getByIdSupplier($id_supplier);
                
                if (!$supplierExtended) {
                    $supplierExtended = new SupplierExtended();
                    $supplierExtended->id_supplier = $id_supplier;
                }
                
                $supplierExtended->min_order_quantity = (int)Tools::getValue('min_order_quantity');
                $supplierExtended->min_order_amount = (float)Tools::getValue('min_order_amount');
                $supplierExtended->delivery_delay = (int)Tools::getValue('delivery_delay');
                $supplierExtended->payment_terms = Tools::getValue('payment_terms');
                $supplierExtended->auto_order_enabled = (int)Tools::getValue('auto_order_enabled');
                
                $supplierExtended->save();
            }
        }
        
        return $result;
    }

    public function ajaxProcessUpdateProductCondition()
    {
        $id_supplier = (int)Tools::getValue('id_supplier');
        $id_product = (int)Tools::getValue('id_product');
        $min_quantity = (int)Tools::getValue('min_quantity');
        $current_price = (float)Tools::getValue('current_price');
        
        if (!$id_supplier || !$id_product) {
            die(json_encode([
                'success' => false,
                'message' => $this->l('L\'ID du fournisseur ou du produit est manquant')
            ]));
        }
        
        $condition = SupplierProductCondition::getBySupplierAndProduct($id_supplier, $id_product);
        
        if (!$condition) {
            $condition = new SupplierProductCondition();
            $condition->id_supplier = $id_supplier;
            $condition->id_product = $id_product;
        }
        
        $condition->min_quantity = $min_quantity;
        $condition->current_price = $current_price;
        $condition->last_update = date('Y-m-d H:i:s');
        
        if ($condition->save()) {
            die(json_encode([
                'success' => true,
                'message' => $this->l('Condition du produit mise à jour avec succès')
            ]));
        } else {
            die(json_encode([
                'success' => false,
                'message' => $this->l('Erreur lors de la mise à jour de la condition du produit')
            ]));
        }
    }
}