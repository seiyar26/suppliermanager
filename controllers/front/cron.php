<?php

class suppliermanagercronModuleFrontController extends ModuleFrontController
{
    public function initContent()
    {
        parent::initContent();

        // Sécuriser le cron avec un token
        if (Tools::getValue('token') != Configuration::get('SUPPLIERMANAGER_CRON_TOKEN')) {
            die('Invalid token');
        }

        // Lancer le traitement des commandes automatiques
        $processed_orders = AutomaticOrderService::processAutomaticOrders();

        // Log ou output des résultats
        echo "Cron job executed.\n";
        echo count($processed_orders) . " automatic orders processed.\n";
        print_r($processed_orders);

        exit;
    }
}
