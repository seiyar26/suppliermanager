<?php
if (!defined('_PS_VERSION_')) {
    exit;
}

require_once(dirname(__FILE__) . '/classes/models/SupplierExtended.php');
require_once(dirname(__FILE__) . '/classes/models/SupplierOrder.php');
require_once(dirname(__FILE__) . '/classes/models/SupplierOrderDetail.php');
require_once(dirname(__FILE__) . '/classes/models/AISuggestion.php');
require_once(dirname(__FILE__) . '/classes/models/SupplierInvoice.php');
require_once(dirname(__FILE__) . '/classes/models/SupplierProductCondition.php');
require_once(dirname(__FILE__) . '/classes/models/SupplierReturn.php');
require_once(dirname(__FILE__) . '/classes/models/SupplierReturnDetail.php');
require_once(dirname(__FILE__) . '/classes/models/SupplierContract.php');
require_once(dirname(__FILE__) . '/classes/models/SupplierOrderSchedule.php');
require_once(dirname(__FILE__) . '/classes/models/ProductPCBCondition.php');
require_once(dirname(__FILE__) . '/classes/models/SupplierFrancoCondition.php');
require_once(dirname(__FILE__) . '/classes/models/SupplierPerformanceMetric.php');
require_once(dirname(__FILE__) . '/classes/models/AutomaticOrderSetting.php');
require_once(dirname(__FILE__) . '/classes/models/ShopBudget.php');
require_once(dirname(__FILE__) . '/classes/models/SupplierEmailConfig.php');
require_once(dirname(__FILE__) . '/classes/services/StockService.php');
require_once(dirname(__FILE__) . '/classes/services/GeminiAIService.php');
require_once(dirname(__FILE__) . '/classes/services/EmailService.php');
require_once(dirname(__FILE__) . '/classes/services/PDFService.php');
require_once(dirname(__FILE__) . '/classes/services/AutomaticOrderService.php');
require_once(dirname(__FILE__) . '/classes/services/ExcelExportService.php');

class SupplierManager extends Module
{
    public function __construct()
    {
        $this->name = 'suppliermanager';
        $this->tab = 'administration';
        $this->version = '1.0.0';
        $this->author = 'PrestaShop Developer';
        $this->need_instance = 0;
        $this->ps_versions_compliancy = [
            'min' => '1.7.0.0',
            'max' => _PS_VERSION_
        ];
        $this->bootstrap = true;

        parent::__construct();

        $this->displayName = $this->l('Gestionnaire de commandes fournisseurs');
        $this->description = $this->l('Gérez les commandes fournisseurs avec des suggestions basées sur l\'IA et un traitement automatisé');
        $this->confirmUninstall = $this->l('Êtes-vous sûr de vouloir désinstaller ?');
    }

    public function install()
    {
        include(dirname(__FILE__).'/sql/install.php');
        
        return parent::install() &&
            $this->registerHook('displayBackOfficeHeader') &&
            $this->registerHook('actionAdminControllerSetMedia') &&
            $this->installTab() &&
            Configuration::updateValue('SUPPLIERMANAGER_GEMINI_API_KEY', '') &&
            Configuration::updateValue('SUPPLIERMANAGER_EMAIL_SERVER', '') &&
            Configuration::updateValue('SUPPLIERMANAGER_EMAIL_PORT', '993') &&
            Configuration::updateValue('SUPPLIERMANAGER_EMAIL_USERNAME', '') &&
            Configuration::updateValue('SUPPLIERMANAGER_EMAIL_PASSWORD', '') &&
            Configuration::updateValue('SUPPLIERMANAGER_EMAIL_ENCRYPTION', 'ssl') &&
            Configuration::updateValue('SUPPLIERMANAGER_CRON_TOKEN', Tools::passwdGen(16));
    }

    public function uninstall()
    {
        include(dirname(__FILE__).'/sql/uninstall.php');
        
        return parent::uninstall() &&
            $this->uninstallTab() &&
            Configuration::deleteByName('SUPPLIERMANAGER_GEMINI_API_KEY') &&
            Configuration::deleteByName('SUPPLIERMANAGER_EMAIL_SERVER') &&
            Configuration::deleteByName('SUPPLIERMANAGER_EMAIL_PORT') &&
            Configuration::deleteByName('SUPPLIERMANAGER_EMAIL_USERNAME') &&
            Configuration::deleteByName('SUPPLIERMANAGER_EMAIL_PASSWORD') &&
            Configuration::deleteByName('SUPPLIERMANAGER_EMAIL_ENCRYPTION') &&
            Configuration::deleteByName('SUPPLIERMANAGER_CRON_TOKEN');
    }

    public function installTab()
    {
        $tab = new Tab();
        $tab->active = 1;
        $tab->class_name = 'AdminSupplierManager';
        $tab->name = array();
        foreach (Language::getLanguages(true) as $lang) {
            $tab->name[$lang['id_lang']] = 'Gestionnaire Fournisseurs';
        }
        $tab->id_parent = (int)Tab::getIdFromClassName('SELL');
        $tab->module = $this->name;
        $result = $tab->add();

        // Create sub-tabs
        $subTabs = [
            'AdminSupplierManagerDashboard' => 'Tableau de bord',
            'AdminSupplierManagerSuppliers' => 'Fournisseurs',
            'AdminSupplierManagerOrders' => $this->l('Commandes'),
            'AdminSupplierManagerStocks' => $this->l('Stocks'),
            'AdminSupplierManagerInvoices' => $this->l('Factures'),
            'AdminSupplierManagerReturns' => $this->l('Retours'),
            'AdminSupplierManagerContracts' => $this->l('Contrats'),
            'AdminSupplierManagerSchedules' => $this->l('Cadencier'),
            'AdminSupplierManagerPcb' => $this->l('PCB'),
            'AdminSupplierManagerFranco' => $this->l('Franco'),
            'AdminSupplierManagerBudgets' => $this->l('Budgets'),
            'AdminSupplierManagerEmailConfigs' => $this->l('Emails'),
            'AdminSupplierManagerReports' => $this->l('Rapports'),
            'AdminSupplierManagerSettings' => $this->l('Paramètres')
        ];

        $parentId = Tab::getIdFromClassName('AdminSupplierManager');

        foreach ($subTabs as $className => $name) {
            $tab = new Tab();
            $tab->active = 1;
            $tab->class_name = $className;
            $tab->name = array();
            foreach (Language::getLanguages(true) as $lang) {
                $tab->name[$lang['id_lang']] = $name;
            }
            $tab->id_parent = $parentId;
            $tab->module = $this->name;
            $result = $tab->add() && $result;
        }

        return $result;
    }

    public function uninstallTab()
    {
        $subTabs = [
            'AdminSupplierManagerDashboard',
            'AdminSupplierManagerSuppliers',
            'AdminSupplierManagerOrders',
            'AdminSupplierManagerStocks',
            'AdminSupplierManagerInvoices',
            'AdminSupplierManagerReturns',
            'AdminSupplierManagerContracts',
            'AdminSupplierManagerSchedules',
            'AdminSupplierManagerPcb',
            'AdminSupplierManagerFranco',
            'AdminSupplierManagerBudgets',
            'AdminSupplierManagerEmailConfigs',
            'AdminSupplierManagerReports',
            'AdminSupplierManagerSettings'
        ];

        foreach ($subTabs as $className) {
            $id_tab = (int)Tab::getIdFromClassName($className);
            if ($id_tab) {
                $tab = new Tab($id_tab);
                $tab->delete();
            }
        }

        $id_tab = (int)Tab::getIdFromClassName('AdminSupplierManager');
        if ($id_tab) {
            $tab = new Tab($id_tab);
            return $tab->delete();
        }

        return true;
    }

    public function getContent()
    {
        Tools::redirectAdmin($this->context->link->getAdminLink('AdminSupplierManagerSettings'));
    }

    public function hookDisplayBackOfficeHeader()
    {
        if ($this->context->controller->controller_name == 'AdminSupplierManager' ||
            strpos($this->context->controller->controller_name, 'AdminSupplierManager') === 0) {
            $this->context->controller->addJS($this->_path . 'views/js/admin.js');
            $this->context->controller->addJS($this->_path . 'views/js/modern-utils.js');
            
            // Charger tous les fichiers CSS nécessaires
            $this->context->controller->addCSS($this->_path . 'views/css/admin.css');
            $this->context->controller->addCSS($this->_path . 'views/css/components.css');
            $this->context->controller->addCSS($this->_path . 'views/css/modern-enhancements.css');
            $this->context->controller->addCSS($this->_path . 'views/css/modern-fixes.css');
            $this->context->controller->addCSS($this->_path . 'views/css/order-view.css');
        }
    }

    public function hookActionAdminControllerSetMedia()
    {
        if ($this->context->controller->controller_name == 'AdminSupplierManager' ||
            strpos($this->context->controller->controller_name, 'AdminSupplierManager') === 0) {
            $this->context->controller->addJS($this->_path . 'views/js/admin.js');
            $this->context->controller->addJS($this->_path . 'views/js/modern-utils.js');
            
            // Charger tous les fichiers CSS nécessaires
            $this->context->controller->addCSS($this->_path . 'views/css/admin.css');
            $this->context->controller->addCSS($this->_path . 'views/css/components.css');
            $this->context->controller->addCSS($this->_path . 'views/css/modern-enhancements.css');
            $this->context->controller->addCSS($this->_path . 'views/css/modern-fixes.css');
            $this->context->controller->addCSS($this->_path . 'views/css/order-view.css');
        }
    }
}
