<?php
if (!defined('_PS_VERSION_')) {
    exit;
}

class AdminSupplierManagerEmailConfigsController extends ModuleAdminController
{
    public function __construct()
    {
        $this->bootstrap = true;
        $this->table = 'supplier_email_configs';
        $this->className = 'SupplierEmailConfig';
        $this->lang = false;
        $this->identifier = 'id_config';

        parent::__construct();

        $this->fields_list = [
            'id_config' => ['title' => $this->l('ID'), 'align' => 'center', 'class' => 'fixed-width-xs'],
            'supplier_name' => ['title' => $this->l('Fournisseur')],
            'shop_name' => ['title' => $this->l('Boutique')],
            'commercial_email' => ['title' => $this->l('Email Commercial')],
            'is_active' => ['title' => $this->l('Actif'), 'align' => 'center', 'type' => 'bool', 'active' => 'status'],
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
                'title' => $this->l('Configuration Email Fournisseur'),
                'icon' => 'icon-envelope'
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
                    'label' => $this->l('Boutique (Optionnel)'),
                    'name' => 'id_shop',
                    'options' => [
                        'query' => array_merge([['id_shop' => 0, 'name' => $this->l('Toutes les boutiques')]], Shop::getShops()),
                        'id' => 'id_shop',
                        'name' => 'name'
                    ],
                    'desc' => $this->l('Laissez vide pour appliquer à toutes les boutiques.')
                ],
                [
                    'type' => 'text',
                    'label' => $this->l('Email du commercial'),
                    'name' => 'commercial_email',
                    'required' => true,
                ],
                [
                    'type' => 'text',
                    'label' => $this->l('Template du sujet de l\'email'),
                    'name' => 'email_subject_template',
                    'desc' => $this->l('Utilisez {order_number} pour le numéro de commande. Ex: Commande TWO Tails - {order_number}')
                ],
                [
                    'type' => 'textarea',
                    'label' => $this->l('Emails en copie (BCC)'),
                    'name' => 'bcc_emails',
                    'desc' => $this->l('Séparez les emails par une virgule.')
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
