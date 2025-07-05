<?php
// Nouvelles tables pour les fonctionnalités avancées du module Supplier Manager

$sql_v2 = array();

// Table pour le cadencier des commandes par fournisseur
$sql_v2[] = 'CREATE TABLE IF NOT EXISTS `'._DB_PREFIX_.'supplier_order_schedules` (
    `id_schedule` int(10) unsigned NOT NULL AUTO_INCREMENT,
    `id_supplier` int(10) unsigned NOT NULL,
    `id_shop` int(10) unsigned NOT NULL,
    `frequency_days` int(10) unsigned NOT NULL DEFAULT 7,
    `last_order_date` date DEFAULT NULL,
    `next_order_date` date DEFAULT NULL,
    `is_paused` tinyint(1) unsigned DEFAULT 0,
    `created_date` datetime NOT NULL,
    `updated_date` datetime DEFAULT NULL,
    PRIMARY KEY (`id_schedule`),
    UNIQUE KEY `supplier_shop` (`id_supplier`, `id_shop`),
    KEY `next_order_date` (`next_order_date`)
) ENGINE='._MYSQL_ENGINE_.' DEFAULT CHARSET=utf8;';

// Table pour les conditions de franco par fournisseur
$sql_v2[] = 'CREATE TABLE IF NOT EXISTS `'._DB_PREFIX_.'supplier_franco_conditions` (
    `id_franco` int(10) unsigned NOT NULL AUTO_INCREMENT,
    `id_supplier` int(10) unsigned NOT NULL,
    `min_amount_ht` decimal(20,6) NOT NULL DEFAULT 0,
    `description` varchar(255) DEFAULT NULL,
    `is_active` tinyint(1) unsigned DEFAULT 1,
    `created_date` datetime NOT NULL,
    PRIMARY KEY (`id_franco`),
    UNIQUE KEY `id_supplier` (`id_supplier`)
) ENGINE='._MYSQL_ENGINE_.' DEFAULT CHARSET=utf8;';

// Table pour les PCB (Plus petit Conditionnement de Base) par produit/fournisseur
$sql_v2[] = 'CREATE TABLE IF NOT EXISTS `'._DB_PREFIX_.'product_pcb_conditions` (
    `id_pcb` int(10) unsigned NOT NULL AUTO_INCREMENT,
    `id_supplier` int(10) unsigned NOT NULL,
    `id_product` int(10) unsigned NOT NULL,
    `pcb_quantity` int(10) unsigned NOT NULL DEFAULT 1,
    `supplier_reference` varchar(64) DEFAULT NULL,
    `is_active` tinyint(1) unsigned DEFAULT 1,
    `last_update` datetime NOT NULL,
    PRIMARY KEY (`id_pcb`),
    UNIQUE KEY `supplier_product` (`id_supplier`, `id_product`),
    KEY `id_supplier` (`id_supplier`),
    KEY `id_product` (`id_product`)
) ENGINE='._MYSQL_ENGINE_.' DEFAULT CHARSET=utf8;';

// Table pour les métriques de performance des fournisseurs
$sql_v2[] = 'CREATE TABLE IF NOT EXISTS `'._DB_PREFIX_.'supplier_performance_metrics` (
    `id_metric` int(10) unsigned NOT NULL AUTO_INCREMENT,
    `id_supplier` int(10) unsigned NOT NULL,
    `period_start` date NOT NULL,
    `period_end` date NOT NULL,
    `disputes_count` int(10) unsigned DEFAULT 0,
    `total_orders` int(10) unsigned DEFAULT 0,
    `complete_deliveries` int(10) unsigned DEFAULT 0,
    `avg_delivery_days` decimal(5,2) DEFAULT 0,
    `complete_delivery_rate` decimal(5,2) DEFAULT 0,
    `calculated_date` datetime NOT NULL,
    PRIMARY KEY (`id_metric`),
    KEY `id_supplier` (`id_supplier`),
    KEY `period` (`period_start`, `period_end`)
) ENGINE='._MYSQL_ENGINE_.' DEFAULT CHARSET=utf8;';

// Table pour les paramètres de commandes automatiques
$sql_v2[] = 'CREATE TABLE IF NOT EXISTS `'._DB_PREFIX_.'automatic_order_settings` (
    `id_setting` int(10) unsigned NOT NULL AUTO_INCREMENT,
    `id_shop` int(10) unsigned NOT NULL,
    `id_supplier` int(10) unsigned NOT NULL,
    `stock_days_desired` int(10) unsigned DEFAULT 15,
    `auto_enabled` tinyint(1) unsigned DEFAULT 0,
    `exclude_inactive_products` tinyint(1) unsigned DEFAULT 1,
    `rupture_increase_percent` int(10) unsigned DEFAULT 20,
    `history_period_days` int(10) unsigned DEFAULT 30,
    `updated_date` datetime NOT NULL,
    PRIMARY KEY (`id_setting`),
    UNIQUE KEY `shop_supplier` (`id_shop`, `id_supplier`)
) ENGINE='._MYSQL_ENGINE_.' DEFAULT CHARSET=utf8;';

// Table pour les budgets théoriques par boutique
$sql_v2[] = 'CREATE TABLE IF NOT EXISTS `'._DB_PREFIX_.'shop_budgets` (
    `id_budget` int(10) unsigned NOT NULL AUTO_INCREMENT,
    `id_shop` int(10) unsigned NOT NULL,
    `period_year` int(4) unsigned NOT NULL,
    `period_month` int(2) unsigned NOT NULL,
    `budget_amount` decimal(20,6) NOT NULL DEFAULT 0,
    `created_date` datetime NOT NULL,
    `updated_date` datetime DEFAULT NULL,
    PRIMARY KEY (`id_budget`),
    UNIQUE KEY `shop_period` (`id_shop`, `period_year`, `period_month`)
) ENGINE='._MYSQL_ENGINE_.' DEFAULT CHARSET=utf8;';

// Table pour la configuration des emails par région/fournisseur
$sql_v2[] = 'CREATE TABLE IF NOT EXISTS `'._DB_PREFIX_.'supplier_email_configs` (
    `id_config` int(10) unsigned NOT NULL AUTO_INCREMENT,
    `id_supplier` int(10) unsigned NOT NULL,
    `id_shop` int(10) unsigned DEFAULT NULL,
    `commercial_email` varchar(255) NOT NULL,
    `email_subject_template` varchar(255) DEFAULT "Commande TWO Tails - {order_number}",
    `bcc_emails` text DEFAULT NULL,
    `is_active` tinyint(1) unsigned DEFAULT 1,
    `created_date` datetime NOT NULL,
    PRIMARY KEY (`id_config`),
    KEY `id_supplier` (`id_supplier`),
    KEY `id_shop` (`id_shop`)
) ENGINE='._MYSQL_ENGINE_.' DEFAULT CHARSET=utf8;';

// Extensions de la table suppliers_extended existante
$sql_v2[] = 'ALTER TABLE `'._DB_PREFIX_.'suppliers_extended` 
    ADD COLUMN `franco_amount` decimal(20,6) DEFAULT 0 AFTER `auto_order_enabled`,
    ADD COLUMN `order_frequency_days` int(10) unsigned DEFAULT 7 AFTER `franco_amount`,
    ADD COLUMN `is_paused` tinyint(1) unsigned DEFAULT 0 AFTER `order_frequency_days`,
    ADD COLUMN `rupture_increase_percent` int(10) unsigned DEFAULT 20 AFTER `is_paused`,
    ADD COLUMN `region_nice_email` varchar(255) DEFAULT NULL AFTER `rupture_increase_percent`,
    ADD COLUMN `region_paris_email` varchar(255) DEFAULT NULL AFTER `region_nice_email`';

// Extensions de la table supplier_orders existante
$sql_v2[] = 'ALTER TABLE `'._DB_PREFIX_.'supplier_orders` 
    ADD COLUMN `is_automatic` tinyint(1) unsigned DEFAULT 0 AFTER `ai_suggested`,
    ADD COLUMN `franco_respected` tinyint(1) unsigned DEFAULT 0 AFTER `is_automatic`,
    ADD COLUMN `scheduled_date` date DEFAULT NULL AFTER `franco_respected`,
    ADD COLUMN `email_sent_date` datetime DEFAULT NULL AFTER `scheduled_date`,
    ADD COLUMN `delivery_receipt_received` tinyint(1) unsigned DEFAULT 0 AFTER `email_sent_date`,
    ADD COLUMN `export_file_path` varchar(255) DEFAULT NULL AFTER `delivery_receipt_received`';

// Extensions de la table supplier_return_details
$sql_v2[] = 'ALTER TABLE `'._DB_PREFIX_.'supplier_return_details` ADD COLUMN `reason` TEXT DEFAULT NULL AFTER `unit_price`';

// Exécution des requêtes
foreach ($sql_v2 as $query) {
    if (Db::getInstance()->execute($query) == false) {
        return false;
    }
}

return true;
