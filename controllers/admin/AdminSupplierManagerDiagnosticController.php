<?php
/**
 * Contrôleur de diagnostic pour résoudre les problèmes d'affichage
 */
class AdminSupplierManagerDiagnosticController extends ModuleAdminController
{
    public function __construct()
    {
        parent::__construct();
        $this->bootstrap = true;
        $this->display = 'view';
    }

    public function initContent()
    {
        parent::initContent();
        
        // Afficher la page de diagnostic sans les templates PrestaShop standard
        $this->context->smarty->assign([
            'module_dir' => _MODULE_DIR_ . 'suppliermanager/',
        ]);
        
        // Désactiver l'affichage du header et footer PrestaShop standard
        $this->context->smarty->assign('display_header', false);
        $this->context->smarty->assign('display_footer', false);
        $this->context->smarty->assign('display_header_javascript', false);
        
        $this->setTemplate('module:suppliermanager/views/templates/admin/diagnostic.tpl');
    }
    
    public function postProcess()
    {
        // Aucun traitement de formulaire à faire
    }
}
