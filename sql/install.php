<?php
$sql = array();

$sql[] = 'CREATE TABLE IF NOT EXISTS `'._DB_PREFIX_.'suppliers_extended` (
    `id_supplier` int(10) unsigned NOT NULL,
    `min_order_quantity` int(10) unsigned DEFAULT 0,
    `min_order_amount` decimal(20,6) DEFAULT 0,
    `delivery_delay` int(10) unsigned DEFAULT 0,
    `payment_terms` varchar(255) DEFAULT NULL,
    `auto_order_enabled` tinyint(1) unsigned DEFAULT 0,
    PRIMARY KEY (`id_supplier`)
) ENGINE='._MYSQL_ENGINE_.' DEFAULT CHARSET=utf8;';

$sql[] = 'CREATE TABLE IF NOT EXISTS `'._DB_PREFIX_.'supplier_product_conditions` (
    `id_supplier_product_condition` int(10) unsigned NOT NULL AUTO_INCREMENT,
    `id_supplier` int(10) unsigned NOT NULL,
    `id_product` int(10) unsigned NOT NULL,
    `min_quantity` int(10) unsigned DEFAULT 0,
    `current_price` decimal(20,6) DEFAULT 0,
    `last_update` datetime DEFAULT NULL,
    PRIMARY KEY (`id_supplier_product_condition`),
    UNIQUE KEY `supplier_product` (`id_supplier`, `id_product`)
) ENGINE='._MYSQL_ENGINE_.' DEFAULT CHARSET=utf8;';

$sql[] = 'CREATE TABLE IF NOT EXISTS `'._DB_PREFIX_.'supplier_orders` (
    `id_order` int(10) unsigned NOT NULL AUTO_INCREMENT,
    `id_supplier` int(10) unsigned NOT NULL,
    `id_shop` int(10) unsigned NOT NULL,
    `id_employee` int(10) unsigned NOT NULL,
    `order_date` datetime NOT NULL,
    `status` varchar(32) NOT NULL,
    `total_amount` decimal(20,6) DEFAULT 0,
    `ai_suggested` tinyint(1) unsigned DEFAULT 0,
    PRIMARY KEY (`id_order`),
    KEY `id_supplier` (`id_supplier`),
    KEY `id_shop` (`id_shop`)
) ENGINE='._MYSQL_ENGINE_.' DEFAULT CHARSET=utf8;';

$sql[] = 'CREATE TABLE IF NOT EXISTS `'._DB_PREFIX_.'supplier_order_details` (
    `id_order_detail` int(10) unsigned NOT NULL AUTO_INCREMENT,
    `id_order` int(10) unsigned NOT NULL,
    `id_product` int(10) unsigned NOT NULL,
    `id_product_attribute` int(10) unsigned DEFAULT 0,
    `quantity` int(10) unsigned NOT NULL,
    `unit_price` decimal(20,6) DEFAULT 0,
    PRIMARY KEY (`id_order_detail`),
    KEY `id_order` (`id_order`),
    KEY `id_product` (`id_product`)
) ENGINE='._MYSQL_ENGINE_.' DEFAULT CHARSET=utf8;';

$sql[] = 'CREATE TABLE IF NOT EXISTS `'._DB_PREFIX_.'ai_suggestions` (
    `id_suggestion` int(10) unsigned NOT NULL AUTO_INCREMENT,
    `id_product` int(10) unsigned NOT NULL,
    `id_shop` int(10) unsigned NOT NULL,
    `suggested_quantity` int(10) unsigned NOT NULL,
    `reason` text DEFAULT NULL,
    `confidence_score` decimal(5,2) DEFAULT 0,
    `created_date` datetime NOT NULL,
    `applied` tinyint(1) unsigned DEFAULT 0,
    PRIMARY KEY (`id_suggestion`),
    KEY `id_product` (`id_product`),
    KEY `id_shop` (`id_shop`)
) ENGINE='._MYSQL_ENGINE_.' DEFAULT CHARSET=utf8;';

$sql[] = 'CREATE TABLE IF NOT EXISTS `'._DB_PREFIX_.'supplier_invoices` (
    `id_invoice` int(10) unsigned NOT NULL AUTO_INCREMENT,
    `id_supplier` int(10) unsigned NOT NULL,
    `invoice_number` varchar(64) NOT NULL,
    `invoice_date` date NOT NULL,
    `amount` decimal(20,6) DEFAULT 0,
    `file_path` varchar(255) DEFAULT NULL,
    `id_order` int(10) unsigned DEFAULT NULL,
    `processed` tinyint(1) unsigned DEFAULT 0,
    PRIMARY KEY (`id_invoice`),
    KEY `id_supplier` (`id_supplier`),
    KEY `id_order` (`id_order`)
) ENGINE='._MYSQL_ENGINE_.' DEFAULT CHARSET=utf8;';

$sql[] = 'CREATE TABLE IF NOT EXISTS `'._DB_PREFIX_.'supplier_returns` (
    `id_return` int(10) unsigned NOT NULL AUTO_INCREMENT,
    `id_supplier` int(10) unsigned NOT NULL,
    `id_order` int(10) unsigned DEFAULT NULL,
    `return_date` date NOT NULL,
    `status` varchar(32) NOT NULL,
    `total_amount` decimal(20,6) DEFAULT 0,
    PRIMARY KEY (`id_return`),
    KEY `id_supplier` (`id_supplier`)
) ENGINE='._MYSQL_ENGINE_.' DEFAULT CHARSET=utf8;';

$sql[] = 'CREATE TABLE IF NOT EXISTS `'._DB_PREFIX_.'supplier_return_details` (
    `id_return_detail` int(10) unsigned NOT NULL AUTO_INCREMENT,
    `id_return` int(10) unsigned NOT NULL,
    `id_product` int(10) unsigned NOT NULL,
    `id_product_attribute` int(10) unsigned DEFAULT 0,
    `quantity` int(10) unsigned NOT NULL,
    `unit_price` decimal(20,6) DEFAULT 0,
    PRIMARY KEY (`id_return_detail`),
    KEY `id_return` (`id_return`)
) ENGINE='._MYSQL_ENGINE_.' DEFAULT CHARSET=utf8;';

$sql[] = 'CREATE TABLE IF NOT EXISTS `'._DB_PREFIX_.'supplier_contracts` (
    `id_contract` int(10) unsigned NOT NULL AUTO_INCREMENT,
    `id_supplier` int(10) unsigned NOT NULL,
    `name` varchar(255) NOT NULL,
    `reference` varchar(64) DEFAULT NULL,
    `start_date` date NOT NULL,
    `end_date` date DEFAULT NULL,
    `description` text,
    `file_path` varchar(255) DEFAULT NULL,
    PRIMARY KEY (`id_contract`),
    KEY `id_supplier` (`id_supplier`)
) ENGINE='._MYSQL_ENGINE_.' DEFAULT CHARSET=utf8;';

foreach ($sql as $query) {
    if (Db::getInstance()->execute($query) == false) {
        return false;
    }
}

// Inclure les nouvelles tables v2
include(dirname(__FILE__).'/install_v2.php');
