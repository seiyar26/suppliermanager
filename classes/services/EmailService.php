<?php
if (!defined('_PS_VERSION_')) {
    exit;
}

class EmailService
{
    private $server;
    private $port;
    private $username;
    private $password;
    private $encryption;
    private $mailbox;

    public function __construct()
    {
        $this->server = Configuration::get('SUPPLIERMANAGER_EMAIL_SERVER');
        $this->port = Configuration::get('SUPPLIERMANAGER_EMAIL_PORT');
        $this->username = Configuration::get('SUPPLIERMANAGER_EMAIL_USERNAME');
        $this->password = Configuration::get('SUPPLIERMANAGER_EMAIL_PASSWORD');
        $this->encryption = Configuration::get('SUPPLIERMANAGER_EMAIL_ENCRYPTION');
    }

    public function sendOrderByEmail(SupplierOrder $order)
    {
        // Récupérer les informations du fournisseur
        $supplier = new Supplier($order->id_supplier);
        if (!Validate::isLoadedObject($supplier)) {
            return false;
        }
        
        // Générer le PDF du bon de commande
        $pdfService = new PDFService();
        $pdfPath = $pdfService->generateOrderPdf($order);
        
        if (!$pdfPath) {
            return false;
        }
        
        // Récupérer l'email du fournisseur
        $supplierEmail = $supplier->email;
        if (empty($supplierEmail)) {
            return false;
        }
        
        // Préparer le contenu de l'email
        $subject = sprintf('Bon de commande #%d - %s', $order->id, Configuration::get('PS_SHOP_NAME'));
        
        $orderDetails = $order->getOrderDetailsWithProductInfo();
        $orderDetailsHtml = '';
        $orderDetailsTxt = '';

        foreach ($orderDetails as $detail) {
            $orderDetailsHtml .= '<tr>';
            $orderDetailsHtml .= '<td>' . $detail['product_name'] . '</td>';
            $orderDetailsHtml .= '<td>' . $detail['quantity'] . '</td>';
            $orderDetailsHtml .= '<td>' . Tools::displayPrice($detail['unit_price']) . '</td>';
            $orderDetailsHtml .= '<td>' . Tools::displayPrice($detail['quantity'] * $detail['unit_price']) . '</td>';
            $orderDetailsHtml .= '</tr>';

            $orderDetailsTxt .= $detail['product_name'] . ' - Qty: ' . $detail['quantity'] . ' - Price: ' . Tools::displayPrice($detail['unit_price']) . "\n";
        }

        $template = Configuration::get('SUPPLIERMANAGER_EMAIL_TEMPLATE', Context::getContext()->language->id);
        if (empty($template)) {
            $template = file_get_contents(_PS_MODULE_DIR_.'suppliermanager/mails/fr/supplier_order_modern.html');
        }

        $template = str_replace('{order_id}', $order->id, $template);
        $template = str_replace('{supplier_name}', $supplier->name, $template);
        $template = str_replace('{order_date}', Tools::displayDate($order->order_date), $template);
        $template = str_replace('{total_amount}', Tools::displayPrice($order->total_amount), $template);
        $template = str_replace('{shop_name}', Configuration::get('PS_SHOP_NAME'), $template);
        $template = str_replace('{order_details}', $orderDetailsHtml, $template);
        $template = str_replace('{current_year}', date('Y'), $template);

        $templateVars = [
            '{order_id}' => $order->id,
            '{supplier_name}' => $supplier->name,
            '{order_date}' => Tools::displayDate($order->order_date),
            '{total_amount}' => Tools::displayPrice($order->total_amount),
            '{shop_name}' => Configuration::get('PS_SHOP_NAME'),
            '{order_details_txt}' => $orderDetailsTxt,
            '{current_year}' => date('Y'),
        ];
        
        // Envoyer l'email avec la pièce jointe
        $attachments = [
            'content' => Tools::file_get_contents($pdfPath),
            'name' => sprintf('order_%d.pdf', $order->id),
            'mime' => 'application/pdf'
        ];
        
        $result = Mail::send(
            Context::getContext()->language->id,
            'supplier_order_modern',  // Nom du template d'email
            $subject,
            $templateVars,
            $supplierEmail,
            $supplier->name,
            null,
            null,
            $attachments,
            null,
            _PS_MODULE_DIR_.'suppliermanager/mails/'
        );
        
        // Mettre à jour le statut de la commande si l'email a été envoyé
        if ($result) {
            $order->status = SupplierOrder::STATUS_SENT;
            $order->update();
        }
        
        return $result;
    }

    public function connectToMailbox()
    {
        if (empty($this->server) || empty($this->username) || empty($this->password)) {
            return false;
        }
        
        $mailboxString = '{'.$this->server.':'.$this->port.'/'.$this->encryption.'}INBOX';
        
        $this->mailbox = imap_open($mailboxString, $this->username, $this->password);
        
        return $this->mailbox !== false;
    }

    public function scanForInvoices()
    {
        if (!$this->mailbox) {
            if (!$this->connectToMailbox()) {
                return false;
            }
        }
        
        // Rechercher les emails non lus
        $emails = imap_search($this->mailbox, 'UNSEEN');
        
        if (!$emails) {
            return [];
        }
        
        $invoices = [];
        
        foreach ($emails as $emailId) {
            $header = imap_headerinfo($this->mailbox, $emailId);
            $fromEmail = $header->from[0]->mailbox . '@' . $header->from[0]->host;
            
            // Vérifier si l'email provient d'un fournisseur connu
            $supplierId = $this->getSupplierIdByEmail($fromEmail);
            
            if ($supplierId) {
                // Récupérer la structure de l'email
                $structure = imap_fetchstructure($this->mailbox, $emailId);
                
                // Vérifier s'il y a des pièces jointes
                if (isset($structure->parts) && count($structure->parts)) {
                    // Parcourir les pièces jointes
                    for ($i = 0; $i < count($structure->parts); $i++) {
                        $attachments[$i] = [
                            'is_attachment' => false,
                            'filename' => '',
                            'name' => '',
                            'attachment' => ''
                        ];
                        
                        if ($structure->parts[$i]->ifdparameters) {
                            foreach ($structure->parts[$i]->dparameters as $object) {
                                if (strtolower($object->attribute) == 'filename') {
                                    $attachments[$i]['is_attachment'] = true;
                                    $attachments[$i]['filename'] = $object->value;
                                }
                            }
                        }
                        
                        if ($structure->parts[$i]->ifparameters) {
                            foreach ($structure->parts[$i]->parameters as $object) {
                                if (strtolower($object->attribute) == 'name') {
                                    $attachments[$i]['is_attachment'] = true;
                                    $attachments[$i]['name'] = $object->value;
                                }
                            }
                        }
                        
                        if ($attachments[$i]['is_attachment']) {
                            $attachments[$i]['attachment'] = imap_fetchbody($this->mailbox, $emailId, $i+1);
                            
                            // Si c'est encodé en base64
                            if ($structure->parts[$i]->encoding == 3) {
                                $attachments[$i]['attachment'] = base64_decode($attachments[$i]['attachment']);
                            }
                            // Si c'est encodé en quoted-printable
                            elseif ($structure->parts[$i]->encoding == 4) {
                                $attachments[$i]['attachment'] = quoted_printable_decode($attachments[$i]['attachment']);
                            }
                            
                            // Vérifier si c'est un PDF
                            $filename = $attachments[$i]['filename'] ?: $attachments[$i]['name'];
                            if (strtolower(pathinfo($filename, PATHINFO_EXTENSION)) == 'pdf') {
                                // Sauvegarder le PDF
                                $pdfPath = $this->savePdfAttachment($attachments[$i]['attachment'], $filename, $supplierId);
                                
                                if ($pdfPath) {
                                    // Extraire les données de la facture
                                    $invoiceData = $this->extractInvoiceData($pdfPath);
                                    
                                    if ($invoiceData) {
                                        $invoiceData['supplier_id'] = $supplierId;
                                        $invoiceData['file_path'] = $pdfPath;
                                        $invoiceData['email_id'] = $emailId;
                                        $invoices[] = $invoiceData;
                                    }
                                }
                            }
                        }
                    }
                }
                
                // Marquer l'email comme lu
                imap_setflag_full($this->mailbox, $emailId, "\\Seen");
            }
        }
        
        return $invoices;
    }

    public function processInvoices()
    {
        $invoices = $this->scanForInvoices();
        $processed = [];
        
        foreach ($invoices as $invoiceData) {
            // Vérifier si la facture existe déjà
            $existingInvoice = SupplierInvoice::getByInvoiceNumber($invoiceData['supplier_id'], $invoiceData['invoice_number']);
            
            if (!$existingInvoice) {
                // Créer une nouvelle facture
                $invoice = new SupplierInvoice();
                $invoice->id_supplier = $invoiceData['supplier_id'];
                $invoice->invoice_number = $invoiceData['invoice_number'];
                $invoice->invoice_date = $invoiceData['invoice_date'];
                $invoice->amount = $invoiceData['amount'];
                $invoice->file_path = $invoiceData['file_path'];
                $invoice->processed = 0;
                
                // Essayer de trouver une commande correspondante
                $invoice->id_order = $this->findMatchingOrder($invoiceData['supplier_id'], $invoiceData['invoice_number'], $invoiceData['amount']);
                
                if ($invoice->save()) {
                    $processed[] = [
                        'id_invoice' => $invoice->id,
                        'invoice_number' => $invoice->invoice_number,
                        'supplier_id' => $invoice->id_supplier,
                        'amount' => $invoice->amount,
                        'matched_order' => $invoice->id_order
                    ];
                }
            }
        }
        
        return $processed;
    }

    private function getSupplierIdByEmail($email)
    {
        $email = pSQL($email);
        
        $sql = 'SELECT `id_supplier` FROM `'._DB_PREFIX_.'supplier` WHERE `email` = "'.$email.'"';
        
        return Db::getInstance()->getValue($sql);
    }

    private function savePdfAttachment($content, $filename, $supplierId)
    {
        $dir = _PS_MODULE_DIR_.'suppliermanager/invoices/'.$supplierId;
        
        if (!is_dir($dir)) {
            mkdir($dir, 0777, true);
        }
        
        $path = $dir.'/'.time().'_'.Tools::str2url(pathinfo($filename, PATHINFO_FILENAME)).'.pdf';
        
        if (file_put_contents($path, $content)) {
            return $path;
        }
        
        return false;
    }

    private function extractInvoiceData($pdfPath)
    {
        // Cette fonction simule l'extraction de données d'une facture PDF
        // Dans une implémentation réelle, il faudrait utiliser une bibliothèque OCR
        // comme Tesseract ou un service d'extraction de données comme Google Document AI
        
        // Simulation de données extraites
        return [
            'invoice_number' => 'INV'.rand(10000, 99999),
            'invoice_date' => date('Y-m-d'),
            'amount' => rand(100, 1000)
        ];
    }

    private function findMatchingOrder($supplierId, $invoiceNumber, $amount)
    {
        // Rechercher une commande correspondante basée sur le fournisseur et le montant
        $sql = 'SELECT `id_order` 
                FROM `'._DB_PREFIX_.'supplier_orders` 
                WHERE `id_supplier` = '.(int)$supplierId.' 
                AND `total_amount` = '.(float)$amount.' 
                AND `status` = "'.pSQL(SupplierOrder::STATUS_SENT).'"
                ORDER BY `order_date` DESC';
        
        return Db::getInstance()->getValue($sql);
    }

    public function closeMailbox()
    {
        if ($this->mailbox) {
            imap_close($this->mailbox);
            $this->mailbox = null;
            return true;
        }
        
        return false;
    }
}