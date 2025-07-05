<?php
if (!defined('_PS_VERSION_')) {
    exit;
}

class AdminSupplierManagerSettingsController extends ModuleAdminController
{
    public function __construct()
    {
        $this->bootstrap = true;
        $this->display = 'view';
        
        parent::__construct();
        
        $this->meta_title = $this->l('Paramètres du gestionnaire de fournisseurs');

        if (!$this->module->active) {
            Tools::redirectAdmin($this->context->link->getAdminLink('AdminHome'));
        }
    }

    public function setMedia($isNewTheme = false)
    {
        parent::setMedia($isNewTheme);
        $this->addJquery();
        $this->addJS(_PS_JS_DIR_.'tiny_mce/tiny_mce.js');
        $this->addJS(_PS_JS_DIR_.'admin/tinymce.inc.js');
    }

    public function initContent()
    {
        parent::initContent();
    }

    public function renderView()
    {
        // Récupérer les valeurs actuelles des configurations
        $geminiApiKey = Configuration::get('SUPPLIERMANAGER_GEMINI_API_KEY');
        $emailServer = Configuration::get('SUPPLIERMANAGER_EMAIL_SERVER');
        $emailPort = Configuration::get('SUPPLIERMANAGER_EMAIL_PORT');
        $emailUsername = Configuration::get('SUPPLIERMANAGER_EMAIL_USERNAME');
        $emailPassword = Configuration::get('SUPPLIERMANAGER_EMAIL_PASSWORD');
        $emailEncryption = Configuration::get('SUPPLIERMANAGER_EMAIL_ENCRYPTION');
        $cronToken = Configuration::get('SUPPLIERMANAGER_CRON_TOKEN');

        if (empty($cronToken)) {
            $cronToken = Tools::passwdGen(16);
            Configuration::updateValue('SUPPLIERMANAGER_CRON_TOKEN', $cronToken);
        }

        $emailTemplate = Configuration::get('SUPPLIERMANAGER_EMAIL_TEMPLATE', $this->context->language->id);
        if (empty($emailTemplate)) {
            $emailTemplate = file_get_contents(_PS_MODULE_DIR_.'suppliermanager/mails/fr/supplier_order_modern.html');
        }
        
        // Assigner les variables au template
        $this->context->smarty->assign([
            'geminiApiKey' => $geminiApiKey,
            'emailServer' => $emailServer,
            'emailPort' => $emailPort,
            'emailUsername' => $emailUsername,
            'emailPassword' => $emailPassword,
            'emailEncryption' => $emailEncryption,
            'encryptionOptions' => [
                ['value' => 'ssl', 'label' => 'SSL'],
                ['value' => 'tls', 'label' => 'TLS'],
                ['value' => 'notls', 'label' => 'Pas de TLS']
            ],
            'cronUrl' => $this->context->link->getModuleLink('suppliermanager', 'cron', ['token' => $cronToken]),
            'supplier_order_email_template' => $emailTemplate,
            'cronToken' => $cronToken,
            'link' => $this->context->link
        ]);
        
        return $this->module->fetch('module:suppliermanager/views/templates/admin/settings.tpl');
    }

    public function postProcess()
    {
        if (Tools::isSubmit('submitSettings')) {
            $this->processSubmitSettings();
        } elseif (Tools::isSubmit('testGeminiApi')) {
            $this->processTestGeminiApi();
        } elseif (Tools::isSubmit('testEmailConnection')) {
            $this->processTestEmailConnection();
        } elseif (Tools::isSubmit('importSuppliers')) {
            $this->processImportSuppliers();
        }
        
        return parent::postProcess();
    }

    protected function processSubmitSettings()
    {
        $geminiApiKey = Tools::getValue('gemini_api_key');
        $emailServer = Tools::getValue('email_server');
        $emailPort = Tools::getValue('email_port');
        $emailUsername = Tools::getValue('email_username');
        $emailPassword = Tools::getValue('email_password');
        $emailEncryption = Tools::getValue('email_encryption');
        $cronToken = Tools::getValue('cron_token');
        
        // Valider les données
        $errors = [];
        
        if (empty($geminiApiKey)) {
            $errors[] = $this->l('La clé API Gemini est requise');
        }
        
        if (empty($emailServer)) {
            $errors[] = $this->l('Le serveur de messagerie est requis');
        }
        
        if (empty($emailPort)) {
            $errors[] = $this->l('Le port de messagerie est requis');
        } elseif (!Validate::isUnsignedInt($emailPort)) {
            $errors[] = $this->l('Le port de messagerie doit être un nombre valide');
        }
        
        if (empty($emailUsername)) {
            $errors[] = $this->l('Le nom d\'utilisateur de l\'e-mail est requis');
        }
        
        if (empty($emailPassword)) {
            $errors[] = $this->l('Le mot de passe de l\'e-mail est requis');
        }
        
        if (!in_array($emailEncryption, ['ssl', 'tls', 'notls'])) {
            $errors[] = $this->l('Option de cryptage invalide');
        }
        
        if (!empty($errors)) {
            $this->errors = array_merge($this->errors, $errors);
            return;
        }
        
        // Sauvegarder les configurations
        Configuration::updateValue('SUPPLIERMANAGER_GEMINI_API_KEY', $geminiApiKey);
        Configuration::updateValue('SUPPLIERMANAGER_EMAIL_SERVER', $emailServer);
        Configuration::updateValue('SUPPLIERMANAGER_EMAIL_PORT', $emailPort);
        Configuration::updateValue('SUPPLIERMANAGER_EMAIL_USERNAME', $emailUsername);
        Configuration::updateValue('SUPPLIERMANAGER_EMAIL_PASSWORD', $emailPassword);
        Configuration::updateValue('SUPPLIERMANAGER_EMAIL_ENCRYPTION', $emailEncryption);
        Configuration::updateValue('SUPPLIERMANAGER_CRON_TOKEN', $cronToken);
        Configuration::updateValue('SUPPLIERMANAGER_EMAIL_TEMPLATE', Tools::getValue('supplier_order_email_template'), true);
        
        $this->confirmations[] = $this->l('Paramètres mis à jour avec succès');
    }

    protected function processTestGeminiApi()
    {
        $geminiApiKey = Tools::getValue('gemini_api_key');
        
        if (empty($geminiApiKey)) {
            $this->errors[] = $this->l('La clé API Gemini est requise');
            return;
        }
        
        // Tester l'API Gemini
        $geminiService = new GeminiAIService();
        
        // Forcer l'utilisation de la clé API fournie
        $reflection = new ReflectionClass($geminiService);
        $property = $reflection->getProperty('apiKey');
        $property->setAccessible(true);
        $property->setValue($geminiService, $geminiApiKey);
        
        $response = $geminiService->callGeminiAPI('Test connection to Gemini API');
        
        if (isset($response['error'])) {
            $this->errors[] = $this->l('La connexion à l\'API Gemini a échoué : ') . $response['error']['message'];
        } else {
            $this->confirmations[] = $this->l('Connexion à l\'API Gemini réussie');
        }
    }

    protected function processTestEmailConnection()
    {
        $emailServer = Tools::getValue('email_server');
        $emailPort = Tools::getValue('email_port');
        $emailUsername = Tools::getValue('email_username');
        $emailPassword = Tools::getValue('email_password');
        $emailEncryption = Tools::getValue('email_encryption');
        
        // Valider les données
        $errors = [];
        
        if (empty($emailServer)) {
            $errors[] = $this->l('Le serveur de messagerie est requis');
        }
        
        if (empty($emailPort)) {
            $errors[] = $this->l('Le port de messagerie est requis');
        } elseif (!Validate::isUnsignedInt($emailPort)) {
            $errors[] = $this->l('Le port de messagerie doit être un nombre valide');
        }
        
        if (empty($emailUsername)) {
            $errors[] = $this->l('Le nom d\'utilisateur de l\'e-mail est requis');
        }
        
        if (empty($emailPassword)) {
            $errors[] = $this->l('Le mot de passe de l\'e-mail est requis');
        }
        
        if (!in_array($emailEncryption, ['ssl', 'tls', 'notls'])) {
            $errors[] = $this->l('Option de cryptage invalide');
        }
        
        if (!empty($errors)) {
            $this->errors = array_merge($this->errors, $errors);
            return;
        }
        
        // Tester la connexion email
        $mailboxString = '{'.$emailServer.':'.$emailPort.'/'.$emailEncryption.'}INBOX';
        
        $mailbox = @imap_open($mailboxString, $emailUsername, $emailPassword);
        
        if ($mailbox) {
            imap_close($mailbox);
            $this->confirmations[] = $this->l('Connexion e-mail réussie');
        } else {
            $this->errors[] = $this->l('La connexion par e-mail a échoué : ') . imap_last_error();
        }
    }

    protected function processImportSuppliers()
    {
        $suppliers = Supplier::getSuppliers(false, 0, true);
        $imported_count = 0;
        $skipped_count = 0;

        foreach ($suppliers as $supplier_data) {
            $id_supplier = (int)$supplier_data['id_supplier'];

            // Check if supplier already exists in the extended table
            $sql = 'SELECT id_supplier FROM `'._DB_PREFIX_.'suppliers_extended` WHERE id_supplier = ' . $id_supplier;
            $exists = Db::getInstance()->getValue($sql);

            if (!$exists) {
                // If not, insert the supplier with default values
                $sql = 'INSERT INTO `'._DB_PREFIX_.'suppliers_extended` (id_supplier) VALUES (' . $id_supplier . ')';
                if (Db::getInstance()->execute($sql)) {
                    $imported_count++;
                }
            } else {
                $skipped_count++;
            }
        }

        $this->confirmations[] = sprintf($this->l('Importation terminée. %d fournisseurs importés, %d déjà existants.'), $imported_count, $skipped_count);
    }
}
