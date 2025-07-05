<?php

class AdminSupplierManagerReportsController extends ModuleAdminController
{
    public function __construct()
    {
        $this->bootstrap = true;
        $this->display = 'view';
        
        parent::__construct();
        
        $this->meta_title = $this->l('Rapports');

        if (!$this->module->active) {
            Tools::redirectAdmin($this->context->link->getAdminLink('AdminHome'));
        }
    }

    public function initContent()
    {
        parent::initContent();
        $this->content .= $this->renderView();
    }

    public function renderView()
    {
        // Données pour les rapports (à développer)
        $supplierPerformance = []; // Données sur la performance des fournisseurs
        $costEvolution = []; // Données sur l'évolution des coûts
        $deliveryTimes = []; // Données sur les délais de livraison

        $this->context->smarty->assign([
            'supplierPerformance' => $supplierPerformance,
            'costEvolution' => $costEvolution,
            'deliveryTimes' => $deliveryTimes,
        ]);

        return $this->module->fetch('module:suppliermanager/views/templates/admin/reports.tpl');
    }
}