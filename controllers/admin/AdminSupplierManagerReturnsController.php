<?php

class AdminSupplierManagerReturnsController extends ModuleAdminController
{
    public function __construct()
    {
        $this->bootstrap = true;
        $this->table = 'supplier_returns';
        $this->className = 'SupplierReturn';
        $this->lang = false;
        $this->addRowAction('view');
        $this->addRowAction('edit');
        $this->addRowAction('delete');
        $this->context = Context::getContext();

        parent::__construct();

        if (!$this->module->active) {
            Tools::redirectAdmin($this->context->link->getAdminLink('AdminHome'));
        }

        $this->_select = 's.name as supplier_name';
        $this->_join = 'LEFT JOIN `' . _DB_PREFIX_ . 'supplier` s ON (a.id_supplier = s.id_supplier)';
        $this->_orderBy = 'return_date';
        $this->_orderWay = 'DESC';

        $this->fields_list = [
            'id_return' => [
                'title' => $this->l('ID'),
                'align' => 'center',
                'class' => 'fixed-width-xs'
            ],
            'supplier_name' => [
                'title' => $this->l('Fournisseur'),
                'filter_key' => 's!name'
            ],
            'id_order' => [
                'title' => $this->l('ID Commande'),
                'align' => 'center'
            ],
            'return_date' => [
                'title' => $this->l('Date de retour'),
                'type' => 'date'
            ],
            'status' => [
                'title' => $this->l('Statut')
            ],
            'total_amount' => [
                'title' => $this->l('Montant total'),
                'type' => 'price',
                'align' => 'right'
            ]
        ];
    }

    public function renderView()
    {
        $id_return = (int)Tools::getValue('id_return');
        if (!$id_return) {
            return;
        }

        $return = new SupplierReturn($id_return);
        if (!Validate::isLoadedObject($return)) {
            $this->errors[] = $this->l('Return not found');
            return;
        }

        $this->context->smarty->assign([
            'return' => $return,
            'details' => $return->getReturnDetails(),
            'supplier' => new Supplier($return->id_supplier),
            'order' => new SupplierOrder($return->id_order),
        ]);

        return $this->module->fetch('module:suppliermanager/views/templates/admin/return_view.tpl');
    }

    public function renderForm()
    {
        $this->fields_form = [
            'legend' => [
                'title' => $this->l('Retour Fournisseur'),
                'icon' => 'icon-undo'
            ],
            'input' => [
                [
                    'type' => 'select',
                    'label' => $this->l('Fournisseur'),
                    'name' => 'id_supplier',
                    'required' => true,
                    'options' => [
                        'query' => Supplier::getSuppliers(false, $this->context->language->id),
                        'id' => 'id_supplier',
                        'name' => 'name'
                    ]
                ],
                [
                    'type' => 'text',
                    'label' => $this->l('Commande d\'origine (ID)'),
                    'name' => 'id_order',
                    'desc' => $this->l('Optionnel. Liez ce retour à une commande existante.')
                ],
                [
                    'type' => 'date',
                    'label' => $this->l('Date du retour'),
                    'name' => 'return_date',
                    'required' => true
                ],
                [
                    'type' => 'select',
                    'label' => $this->l('Statut'),
                    'name' => 'status',
                    'required' => true,
                    'options' => [
                        'query' => [
                            ['id' => 'draft', 'name' => $this->l('Brouillon')],
                            ['id' => 'pending', 'name' => $this->l('En attente d\'enlèvement')],
                            ['id' => 'returned', 'name' => $this->l('Retourné')],
                            ['id' => 'credited', 'name' => $this->l('Avoir reçu')],
                            ['id' => 'cancelled', 'name' => $this->l('Annulé')]
                        ],
                        'id' => 'id',
                        'name' => 'name'
                    ]
                ]
            ],
            'submit' => [
                'title' => $this->l('Enregistrer')
            ]
        ];

        if (Tools::isSubmit('id_return')) {
            $return = new SupplierReturn((int)Tools::getValue('id_return'));
            $this->context->smarty->assign([
                'return' => $return,
                'details' => $return->getReturnDetails(),
                'currentToken' => Tools::getAdminTokenLite('AdminSupplierManagerReturns')
            ]);

            $this->fields_form['input'][] = [
                'type' => 'html',
                'name' => 'products',
                'html_content' => $this->context->smarty->fetch('module:suppliermanager/views/templates/admin/return_products.tpl'),
            ];
        } else {
            $this->fields_value['return_date'] = date('Y-m-d');
            $this->fields_value['status'] = 'draft';
            $this->informations[] = $this->l('Vous pourrez ajouter des produits au retour après l\'avoir enregistré.');
        }

        return parent::renderForm();
    }

    public function postProcess()
    {
        if (Tools::isSubmit('submitAdd'.$this->table)) {
            $return = parent::postProcess();
            if ($return) {
                $this->redirect_after = self::$currentIndex.'&id_return='.$return->id.'&update'.$this->table.'&token='.$this->token;
            }
            return $return;
        }

        if (Tools::isSubmit('addProduct')) {
            return $this->processAddProduct();
        }

        if (Tools::isSubmit('removeProduct')) {
            return $this->processRemoveProduct();
        }

        return parent::postProcess();
    }

    protected function processAddProduct()
    {
        $id_return = (int)Tools::getValue('id_return');
        $id_product = (int)Tools::getValue('id_product');
        $quantity = (int)Tools::getValue('quantity');
        $reason = Tools::getValue('reason');
        $unit_price = (float)Tools::getValue('unit_price');

        if (!$id_return || !$id_product || !$quantity) {
            $this->errors[] = $this->l('Champs requis manquants pour ajouter un produit.');
            return false;
        }

        $return = new SupplierReturn($id_return);
        if (!Validate::isLoadedObject($return)) {
            $this->errors[] = $this->l('Retour non trouvé.');
            return false;
        }

        $returnDetail = new SupplierReturnDetail();
        $returnDetail->id_return = $id_return;
        $returnDetail->id_product = $id_product;
        $returnDetail->quantity = $quantity;
        $returnDetail->reason = $reason;
        $returnDetail->unit_price = $unit_price;

        if ($returnDetail->add()) {
            $this->confirmations[] = $this->l('Produit ajouté au retour.');
            $return->updateTotalAmount();
        } else {
            $this->errors[] = $this->l('Erreur lors de l\'ajout du produit.');
        }
        
        $this->redirect_after = self::$currentIndex.'&id_return='.$id_return.'&update'.$this->table.'&token='.$this->token;
        return true;
    }

    protected function processRemoveProduct()
    {
        $id_return_detail = (int)Tools::getValue('id_return_detail');
        if (!$id_return_detail) {
            $this->errors[] = $this->l('ID du détail de retour manquant.');
            return false;
        }

        $returnDetail = new SupplierReturnDetail($id_return_detail);
        if (!Validate::isLoadedObject($returnDetail)) {
            $this->errors[] = $this->l('Détail de retour non trouvé.');
            return false;
        }

        $id_return = $returnDetail->id_return;
        if ($returnDetail->delete()) {
            $this->confirmations[] = $this->l('Produit supprimé du retour.');
            $return = new SupplierReturn($id_return);
            $return->updateTotalAmount();
        } else {
            $this->errors[] = $this->l('Erreur lors de la suppression du produit.');
        }

        $this->redirect_after = self::$currentIndex.'&id_return='.$id_return.'&update'.$this->table.'&token='.$this->token;
        return true;
    }
}
