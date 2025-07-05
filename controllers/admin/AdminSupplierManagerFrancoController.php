<?php
if (!defined('_PS_VERSION_')) {
    exit;
}

class AdminSupplierManagerFrancoController extends ModuleAdminController
{
    public function __construct()
    {
        $this->bootstrap = true;
        $this->table = 'supplier_franco_conditions';
        $this->className = 'SupplierFrancoCondition';
        $this->lang = false;
        $this->identifier = 'id_franco';

        parent::__construct();

        $this->fields_list = [
            'id_franco' => ['title' => $this->l('ID'), 'align' => 'center', 'class' => 'fixed-width-xs'],
            'supplier_name' => ['title' => $this->l('Fournisseur')],
            'min_amount_ht' => ['title' => $this->l('Montant HT minimum'), 'type' => 'price'],
            'description' => ['title' => $this->l('Description')],
            'is_active' => ['title' => $this->l('Actif'), 'align' => 'center', 'type' => 'bool', 'active' => 'status'],
        ];

        $this->addRowAction('edit');
        $this->addRowAction('delete');
    }

    public function renderList()
    {
        $this->_select = 's.name as supplier_name';
        $this->_join = 'LEFT JOIN `'._DB_PREFIX_.'supplier` s ON (a.id_supplier = s.id_supplier)';
        
        return parent::renderList();
    }

    public function renderForm()
    {
        $this->fields_form = [
            'legend' => [
                'title' => $this->l('Condition de Franco'),
                'icon' => 'icon-truck'
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
                    'label' => $this->l('Montant HT minimum'),
                    'name' => 'min_amount_ht',
                    'required' => true,
                    'class' => 'input-group-addon',
                    'prefix' => '€'
                ],
                [
                    'type' => 'textarea',
                    'label' => $this->l('Description'),
                    'name' => 'description',
                ],
                [
                    'type' => 'switch',
                    'label' => $this->l('Actif'),
                    'name' => 'is_active',
                    'is_bool' => true,
                    'values' => [
                        ['id' => 'active_on', 'value' => 1, 'label' => $this->l('Oui')],
                        ['id' => 'active_off', 'value' => 0, 'label' => $this->l('Non')]
                    ]
                ]
            ],
            'submit' => [
                'title' => $this->l('Enregistrer'),
                'class' => 'btn btn-default pull-right'
            ]
        ];

        return parent::renderForm();
    }
}
