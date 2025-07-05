<?php
if (!defined('_PS_VERSION_')) {
    exit;
}

class AdminSupplierManagerPcbController extends ModuleAdminController
{
    public function __construct()
    {
        $this->bootstrap = true;
        $this->table = 'product_pcb_conditions';
        $this->className = 'ProductPCBCondition';
        $this->lang = false;
        $this->identifier = 'id_pcb';

        parent::__construct();

        $this->fields_list = [
            'id_pcb' => ['title' => $this->l('ID'), 'align' => 'center', 'class' => 'fixed-width-xs'],
            'supplier_name' => ['title' => $this->l('Fournisseur')],
            'product_name' => ['title' => $this->l('Produit')],
            'pcb_quantity' => ['title' => $this->l('PCB'), 'align' => 'center'],
            'supplier_reference' => ['title' => $this->l('Référence Fournisseur')],
            'last_update' => ['title' => $this->l('Dernière MAJ'), 'type' => 'datetime'],
        ];

        $this->addRowAction('edit');
        $this->addRowAction('delete');
    }

    public function renderList()
    {
        $this->_select = 's.name as supplier_name, pl.name as product_name';
        $this->_join = '
            LEFT JOIN `'._DB_PREFIX_.'supplier` s ON (a.id_supplier = s.id_supplier)
            LEFT JOIN `'._DB_PREFIX_.'product` p ON (a.id_product = p.id_product)
            LEFT JOIN `'._DB_PREFIX_.'product_lang` pl ON (p.id_product = pl.id_product AND pl.id_lang = '.(int)$this->context->language->id.')';
        
        return parent::renderList();
    }

    public function renderForm()
    {
        $this->fields_form = [
            'legend' => [
                'title' => $this->l('Condition de PCB'),
                'icon' => 'icon-archive'
            ],
            'input' => [
                [
                    'type' => 'select',
                    'label' => $this->l('Fournisseur'),
                    'name' => 'id_supplier',
                    'options' => [
                        'query' => Supplier::getSuppliers(),
                        'id' => 'id_supplier',
                        'name' => 'name'
                    ],
                    'required' => true,
                ],
                [
                    'type' => 'text',
                    'label' => $this->l('Produit'),
                    'name' => 'id_product',
                    'required' => true,
                    'desc' => $this->l('Entrez l\'ID du produit.')
                ],
                [
                    'type' => 'text',
                    'label' => $this->l('Quantité PCB'),
                    'name' => 'pcb_quantity',
                    'required' => true,
                ],
                [
                    'type' => 'text',
                    'label' => $this->l('Référence Fournisseur'),
                    'name' => 'supplier_reference',
                ],
            ],
            'submit' => [
                'title' => $this->l('Enregistrer'),
                'class' => 'btn btn-default pull-right'
            ]
        ];

        return parent::renderForm();
    }
}
