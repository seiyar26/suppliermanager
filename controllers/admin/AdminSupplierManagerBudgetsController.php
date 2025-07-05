<?php
if (!defined('_PS_VERSION_')) {
    exit;
}

class AdminSupplierManagerBudgetsController extends ModuleAdminController
{
    public function __construct()
    {
        $this->bootstrap = true;
        $this->table = 'shop_budgets';
        $this->className = 'ShopBudget';
        $this->lang = false;
        $this->identifier = 'id_budget';

        parent::__construct();

        $this->fields_list = [
            'id_budget' => ['title' => $this->l('ID'), 'align' => 'center', 'class' => 'fixed-width-xs'],
            'shop_name' => ['title' => $this->l('Boutique')],
            'period_year' => ['title' => $this->l('Année')],
            'period_month' => ['title' => $this->l('Mois')],
            'budget_amount' => ['title' => $this->l('Budget'), 'type' => 'price'],
        ];

        $this->addRowAction('edit');
        $this->addRowAction('delete');
    }

    public function renderList()
    {
        $this->_select = 'sh.name as shop_name';
        $this->_join = 'LEFT JOIN `'._DB_PREFIX_.'shop` sh ON (a.id_shop = sh.id_shop)';
        
        return parent::renderList();
    }

    public function renderForm()
    {
        $this->fields_form = [
            'legend' => [
                'title' => $this->l('Budget de la boutique'),
                'icon' => 'icon-money'
            ],
            'input' => [
                [
                    'type' => 'select',
                    'label' => $this->l('Boutique'),
                    'name' => 'id_shop',
                    'options' => [
                        'query' => Shop::getShops(),
                        'id' => 'id_shop',
                        'name' => 'name'
                    ],
                    'required' => true,
                ],
                [
                    'type' => 'text',
                    'label' => $this->l('Année'),
                    'name' => 'period_year',
                    'required' => true,
                ],
                [
                    'type' => 'text',
                    'label' => $this->l('Mois'),
                    'name' => 'period_month',
                    'required' => true,
                ],
                [
                    'type' => 'text',
                    'label' => $this->l('Montant du budget'),
                    'name' => 'budget_amount',
                    'required' => true,
                    'class' => 'input-group-addon',
                    'prefix' => '€'
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
