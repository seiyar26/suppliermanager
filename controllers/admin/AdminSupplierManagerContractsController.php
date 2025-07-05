<?php

class AdminSupplierManagerContractsController extends ModuleAdminController
{
    public function __construct()
    {
        $this->bootstrap = true;
        $this->table = 'supplier_contracts';
        $this->className = 'SupplierContract';
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
        $this->_orderBy = 'end_date';
        $this->_orderWay = 'ASC';

        $this->fields_list = [
            'id_contract' => [
                'title' => $this->l('ID'),
                'align' => 'center',
                'class' => 'fixed-width-xs'
            ],
            'name' => [
                'title' => $this->l('Nom du contrat')
            ],
            'supplier_name' => [
                'title' => $this->l('Fournisseur'),
                'filter_key' => 's!name'
            ],
            'reference' => [
                'title' => $this->l('Référence')
            ],
            'start_date' => [
                'title' => $this->l('Date de début'),
                'type' => 'date'
            ],
            'end_date' => [
                'title' => $this->l('Date de fin'),
                'type' => 'date'
            ]
        ];
    }

    public function renderView()
    {
        return $this->module->fetch('module:suppliermanager/views/templates/admin/contracts.tpl');
    }

    public function renderList()
    {
        return parent::renderList();
    }

    public function renderForm()
    {
        $this->fields_form = [
            'legend' => [
                'title' => $this->l('Contrat Fournisseur'),
                'icon' => 'icon-file-text'
            ],
            'input' => [
                [
                    'type' => 'text',
                    'label' => $this->l('Nom du contrat'),
                    'name' => 'name',
                    'required' => true,
                ],
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
                    'label' => $this->l('Référence'),
                    'name' => 'reference',
                ],
                [
                    'type' => 'date',
                    'label' => $this->l('Date de début'),
                    'name' => 'start_date',
                    'required' => true,
                ],
                [
                    'type' => 'date',
                    'label' => $this->l('Date de fin'),
                    'name' => 'end_date',
                    'required' => true,
                ],
                [
                    'type' => 'textarea',
                    'label' => $this->l('Termes et conditions'),
                    'name' => 'terms',
                    'autoload_rte' => true,
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
