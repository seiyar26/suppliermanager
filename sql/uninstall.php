<?php
$sql = array();

$sql[] = 'DROP TABLE IF EXISTS `'._DB_PREFIX_.'suppliers_extended`';
$sql[] = 'DROP TABLE IF EXISTS `'._DB_PREFIX_.'supplier_product_conditions`';
$sql[] = 'DROP TABLE IF EXISTS `'._DB_PREFIX_.'supplier_orders`';
$sql[] = 'DROP TABLE IF EXISTS `'._DB_PREFIX_.'supplier_order_details`';
$sql[] = 'DROP TABLE IF EXISTS `'._DB_PREFIX_.'ai_suggestions`';
$sql[] = 'DROP TABLE IF EXISTS `'._DB_PREFIX_.'supplier_invoices`';
$sql[] = 'DROP TABLE IF EXISTS `'._DB_PREFIX_.'supplier_returns`';
$sql[] = 'DROP TABLE IF EXISTS `'._DB_PREFIX_.'supplier_return_details`';
$sql[] = 'DROP TABLE IF EXISTS `'._DB_PREFIX_.'supplier_contracts`';

foreach ($sql as $query) {
    if (Db::getInstance()->execute($query) == false) {
        return false;
    }
}