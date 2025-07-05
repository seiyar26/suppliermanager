<?php
if (!defined('_PS_VERSION_')) {
    exit;
}

class AdminSupplierManagerController extends ModuleAdminController
{
    public function __construct()
    {
        $this->bootstrap = true;
        $this->display = 'view';
        
        parent::__construct();

        // Vérifier si le module est disponible avant d'utiliser ses méthodes
        if (isset($this->module) && $this->module !== null) {
            $this->meta_title = $this->l('Gestionnaire de commandes fournisseurs');
            
            if (!$this->module->active) {
                Tools::redirectAdmin($this->context->link->getAdminLink('AdminHome'));
            }
        } else {
            // Fallback si le module n'est pas disponible
            $this->meta_title = 'Gestionnaire de commandes fournisseurs';
            
            // Rediriger vers la page d'accueil si le module n'est pas disponible
            Tools::redirectAdmin($this->context->link->getAdminLink('AdminHome'));
        }
    }

    public function initContent()
    {
        // Rediriger vers le dashboard par défaut
        Tools::redirectAdmin($this->context->link->getAdminLink('AdminSupplierManagerDashboard'));
    }
}