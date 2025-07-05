<?php
if (!defined('_PS_VERSION_')) {
    exit;
}

class AdminSupplierManagerSchedulesController extends ModuleAdminController
{
    public function __construct()
    {
        $this->bootstrap = true;
        $this->table = 'supplier_order_schedules';
        $this->className = 'SupplierOrderSchedule';
        $this->lang = false;
        $this->identifier = 'id_schedule';

        parent::__construct();

        $this->fields_list = [
            'id_schedule' => ['title' => $this->l('ID'), 'align' => 'center', 'class' => 'fixed-width-xs'],
            'supplier_name' => ['title' => $this->l('Fournisseur')],
            'shop_name' => ['title' => $this->l('Boutique')],
            'frequency_days' => ['title' => $this->l('Fréquence (jours)'), 'align' => 'center'],
            'last_order_date' => ['title' => $this->l('Dernière commande'), 'type' => 'date'],
            'next_order_date' => ['title' => $this->l('Prochaine commande'), 'type' => 'date'],
            'is_paused' => ['title' => $this->l('En pause'), 'align' => 'center', 'type' => 'bool', 'active' => 'pause'],
        ];

        $this->addRowAction('edit');
        $this->addRowAction('delete');
    }

    public function renderList()
    {
        $this->_select = 's.name as supplier_name, sh.name as shop_name';
        $this->_join = '
            LEFT JOIN `'._DB_PREFIX_.'supplier` s ON (a.id_supplier = s.id_supplier)
            LEFT JOIN `'._DB_PREFIX_.'shop` sh ON (a.id_shop = sh.id_shop)';
        
        return parent::renderList();
    }

    public function renderForm()
    {
        $this->fields_form = [
            'legend' => [
                'title' => $this->l('Cadencier de commande'),
                'icon' => 'icon-time'
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
                    'label' => $this->l('Fréquence (jours)'),
                    'name' => 'frequency_days',
                    'required' => true,
                    'desc' => $this->l('Ex: 7 pour une commande par semaine.')
                ],
                [
                    'type' => 'date',
                    'label' => $this->l('Date de la dernière commande'),
                    'name' => 'last_order_date',
                ],
                [
                    'type' => 'switch',
                    'label' => $this->l('Mettre en pause'),
                    'name' => 'is_paused',
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

    public function processSave()
    {
        $return = parent::processSave();
        if ($return && !Tools::isSubmit('submitAdd'.$this->table)) {
            $this->object->updateNextOrderDate();
        }
        return $return;
    }
}
