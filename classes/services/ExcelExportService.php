<?php
if (!defined('_PS_VERSION_')) {
    exit;
}

class ExcelExportService
{
    /**
     * Génère un fichier Excel/CSV pour une commande fournisseur
     * Format : Nom produit, Déclinaison, EAN, Ref fournisseur, Catégorie, UV commandée
     * Tri : (1) Catégorie (2) Nom produit (3) Déclinaison
     *
     * @param SupplierOrder $order Commande fournisseur
     * @param string $format Format d'export (xlsx ou csv)
     * @return string|false Chemin du fichier généré ou false en cas d'erreur
     */
    public static function generateOrderExport($order, $format = 'xlsx')
    {
        if (!$order || !$order->id) {
            return false;
        }

        $order_details = $order->getOrderDetails();
        if (empty($order_details)) {
            return false;
        }

        $export_data = [];

        // Récupérer les données pour chaque produit
        foreach ($order_details as $detail) {
            $product_data = self::getProductExportData($detail, $order->id_supplier);
            if ($product_data) {
                $export_data[] = $product_data;
            }
        }

        // Tri selon les spécifications : Catégorie, Nom produit, Déclinaison
        usort($export_data, function($a, $b) {
            if ($a['category'] !== $b['category']) {
                return strcasecmp($a['category'], $b['category']);
            }
            if ($a['product_name'] !== $b['product_name']) {
                return strcasecmp($a['product_name'], $b['product_name']);
            }
            return strcasecmp($a['declination'], $b['declination']);
        });

        if ($format === 'csv') {
            return self::generateCSV($export_data, $order);
        } else {
            return self::generateExcel($export_data, $order);
        }
    }

    private static function getProductExportData($order_detail, $id_supplier)
    {
        $id_product = $order_detail['id_product'];
        $id_product_attribute = $order_detail['id_product_attribute'] ?? 0;

        $sql = 'SELECT p.reference, p.ean13, pl.name as product_name, p.id_category_default
                FROM `'._DB_PREFIX_.'product` p
                JOIN `'._DB_PREFIX_.'product_lang` pl ON (p.id_product = pl.id_product)
                WHERE p.id_product = ' . (int)$id_product . '
                AND pl.id_lang = ' . (int)Context::getContext()->language->id;
        $product_info = Db::getInstance()->getRow($sql);
        if (!$product_info) return false;

        $category_name = self::getCategoryName($product_info['id_category_default']);
        $declination = $id_product_attribute > 0 ? self::getProductAttributeName($id_product, $id_product_attribute) : '';
        $supplier_reference = self::getSupplierReference($id_product, $id_supplier);

        return [
            'product_name' => $product_info['product_name'],
            'declination' => $declination ?: 'Standard',
            'ean13' => $product_info['ean13'] ?: '',
            'supplier_reference' => $supplier_reference ?: $product_info['reference'],
            'category' => $category_name,
            'quantity' => $order_detail['quantity']
        ];
    }

    private static function getCategoryName($id_category)
    {
        $sql = 'SELECT name FROM `'._DB_PREFIX_.'category_lang` WHERE id_category = ' . (int)$id_category . ' AND id_lang = ' . (int)Context::getContext()->language->id;
        return Db::getInstance()->getValue($sql) ?: 'Non classé';
    }

    private static function getProductAttributeName($id_product, $id_product_attribute)
    {
        $sql = 'SELECT GROUP_CONCAT(CONCAT(agl.name, ": ", al.name) SEPARATOR ", ") as combination_name
                FROM `'._DB_PREFIX_.'product_attribute_combination` pac
                JOIN `'._DB_PREFIX_.'attribute` a ON (pac.id_attribute = a.id_attribute)
                JOIN `'._DB_PREFIX_.'attribute_lang` al ON (a.id_attribute = al.id_attribute)
                JOIN `'._DB_PREFIX_.'attribute_group_lang` agl ON (a.id_attribute_group = agl.id_attribute_group)
                WHERE pac.id_product_attribute = ' . (int)$id_product_attribute . '
                AND al.id_lang = ' . (int)Context::getContext()->language->id . ' AND agl.id_lang = ' . (int)Context::getContext()->language->id . '
                GROUP BY pac.id_product_attribute';
        return Db::getInstance()->getValue($sql) ?: '';
    }

    private static function getSupplierReference($id_product, $id_supplier)
    {
        $sql = 'SELECT supplier_reference FROM `'._DB_PREFIX_.'product_pcb_conditions` WHERE id_product = ' . (int)$id_product . ' AND id_supplier = ' . (int)$id_supplier . ' AND is_active = 1';
        $ref = Db::getInstance()->getValue($sql);
        if ($ref) return $ref;

        $sql = 'SELECT product_supplier_reference FROM `'._DB_PREFIX_.'product_supplier` WHERE id_product = ' . (int)$id_product . ' AND id_supplier = ' . (int)$id_supplier;
        return Db::getInstance()->getValue($sql) ?: '';
    }

    private static function generateCSV($data, $order)
    {
        $filename = 'commande_' . $order->id . '_' . date('Y-m-d_H-i-s') . '.csv';
        $filepath = _PS_MODULE_DIR_ . 'suppliermanager/orders/' . $filename;
        if (!file_exists(dirname($filepath))) mkdir(dirname($filepath), 0755, true);

        $file = fopen($filepath, 'w');
        if (!$file) return false;

        fwrite($file, "\xEF\xBB\xBF");
        $headers = ['Nom du produit', 'Déclinaison', 'EAN', 'Référence fournisseur', 'Catégorie', 'Nombre d\'UV commandée'];
        fputcsv($file, $headers, ';');

        foreach ($data as $row) {
            fputcsv($file, array_values($row), ';');
        }

        fclose($file);
        return $filepath;
    }

    private static function generateExcel($data, $order)
    {
        $filename = 'commande_' . $order->id . '_' . date('Y-m-d_H-i-s') . '.xls';
        $filepath = _PS_MODULE_DIR_ . 'suppliermanager/orders/' . $filename;
        if (!file_exists(dirname($filepath))) mkdir(dirname($filepath), 0755, true);

        $xml_content = self::generateExcelXML($data, $order);
        return file_put_contents($filepath, $xml_content) ? $filepath : false;
    }

    private static function generateExcelXML($data, $order)
    {
        $xml = '<?xml version="1.0" encoding="UTF-8"?>
<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet" xmlns:html="http://www.w3.org/TR/REC-html40">
<DocumentProperties xmlns="urn:schemas-microsoft-com:office:office"><Title>Commande Fournisseur ' . $order->id . '</Title><Author>TWO Tails</Author><Created>' . date('Y-m-d\TH:i:s\Z') . '</Created></DocumentProperties>
<Styles><Style ss:ID="Default" ss:Name="Normal"><Alignment ss:Vertical="Bottom"/><Borders/><Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/><Interior/><NumberFormat/><Protection/></Style><Style ss:ID="s1"><Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000" ss:Bold="1"/><Interior ss:Color="#D9D9D9" ss:Pattern="Solid"/></Style></Styles>
<Worksheet ss:Name="Commande"><Table ss:ExpandedColumnCount="6" ss:ExpandedRowCount="' . (count($data) + 1) . '" x:FullColumns="1" x:FullRows="1">
<Column ss:AutoFitWidth="0" ss:Width="200"/><Column ss:AutoFitWidth="0" ss:Width="150"/><Column ss:AutoFitWidth="0" ss:Width="100"/><Column ss:AutoFitWidth="0" ss:Width="150"/><Column ss:AutoFitWidth="0" ss:Width="120"/><Column ss:AutoFitWidth="0" ss:Width="80"/>
<Row><Cell ss:StyleID="s1"><Data ss:Type="String">Nom du produit</Data></Cell><Cell ss:StyleID="s1"><Data ss:Type="String">Déclinaison</Data></Cell><Cell ss:StyleID="s1"><Data ss:Type="String">EAN</Data></Cell><Cell ss:StyleID="s1"><Data ss:Type="String">Référence fournisseur</Data></Cell><Cell ss:StyleID="s1"><Data ss:Type="String">Catégorie</Data></Cell><Cell ss:StyleID="s1"><Data ss:Type="String">Nombre d\'UV commandée</Data></Cell></Row>';
        foreach ($data as $row) {
            $xml .= '<Row><Cell><Data ss:Type="String">' . htmlspecialchars($row['product_name']) . '</Data></Cell><Cell><Data ss:Type="String">' . htmlspecialchars($row['declination']) . '</Data></Cell><Cell><Data ss:Type="String">' . htmlspecialchars($row['ean13']) . '</Data></Cell><Cell><Data ss:Type="String">' . htmlspecialchars($row['supplier_reference']) . '</Data></Cell><Cell><Data ss:Type="String">' . htmlspecialchars($row['category']) . '</Data></Cell><Cell><Data ss:Type="Number">' . $row['quantity'] . '</Data></Cell></Row>';
        }
        $xml .= '</Table></Worksheet></Workbook>';
        return $xml;
    }

    public static function sendOrderToSupplier($order_id, $format = 'xlsx')
    {
        $order = new SupplierOrder($order_id);
        if (!$order->id) return false;

        $file_path = self::generateOrderExport($order, $format);
        if (!$file_path) return false;

        $order->export_file_path = basename($file_path);
        $order->update();

        $supplier_email = self::getSupplierEmail($order->id_supplier, $order->id_shop);
        if (!$supplier_email) return false;

        $subject = self::getEmailSubject($order);
        $message = self::getEmailMessage($order);

        $result = self::sendEmailWithAttachment($supplier_email, $subject, $message, $file_path, true);

        if ($result) {
            $order->email_sent_date = date('Y-m-d H:i:s');
            $order->update();
        }
        return $result;
    }

    private static function getSupplierEmail($id_supplier, $id_shop)
    {
        $sql = 'SELECT commercial_email FROM `'._DB_PREFIX_.'supplier_email_configs` WHERE id_supplier = ' . (int)$id_supplier . ' AND (id_shop = ' . (int)$id_shop . ' OR id_shop IS NULL) AND is_active = 1 ORDER BY id_shop DESC LIMIT 1';
        $email = Db::getInstance()->getValue($sql);
        if ($email) return $email;

        $supplier = new Supplier($id_supplier);
        return $supplier->email ?: false;
    }

    private static function getEmailSubject($order)
    {
        $sql = 'SELECT email_subject_template FROM `'._DB_PREFIX_.'supplier_email_configs` WHERE id_supplier = ' . (int)$order->id_supplier . ' AND (id_shop = ' . (int)$order->id_shop . ' OR id_shop IS NULL) AND is_active = 1 ORDER BY id_shop DESC LIMIT 1';
        $template = Db::getInstance()->getValue($sql);
        if (!$template) {
            $template = 'Commande TWO Tails - {order_number}';
        }
        return str_replace('{order_number}', $order->id, $template);
    }

    private static function getEmailMessage($order)
    {
        $supplier = new Supplier($order->id_supplier);
        $shop = new Shop($order->id_shop);
        $context = Context::getContext();
        $context->smarty->assign([
            'order' => $order,
            'supplier' => $supplier,
            'shop' => $shop
        ]);
        return $context->smarty->fetch(_PS_MODULE_DIR_ . 'suppliermanager/mails/fr/supplier_order_modern.html');
    }

    private static function sendEmailWithAttachment($to, $subject, $message, $attachment_path, $receipt = false)
    {
        $from = 'commande@twotails.fr';
        $fromName = 'TWO Tails Commandes';
        $mail_dir = _PS_MODULE_DIR_ . 'suppliermanager/mails/';

        $headers = [
            'From' => $fromName . ' <' . $from . '>',
            'Reply-To' => $from,
            'X-Mailer' => 'PHP/' . phpversion()
        ];
        if ($receipt) {
            $headers['Disposition-Notification-To'] = $from;
        }

        return Mail::Send(
            (int)Context::getContext()->language->id,
            'supplier_order_modern',
            $subject,
            ['{message}' => $message],
            $to,
            null,
            $from,
            $fromName,
            [$attachment_path],
            null,
            $mail_dir,
            false,
            (int)Context::getContext()->shop->id,
            null,
            '',
            $headers
        );
    }
}
