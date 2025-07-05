<?php
if (!defined('_PS_VERSION_')) {
    exit;
}

class SupplierEmailConfig extends ObjectModel
{
    public $id_config;
    public $id_supplier;
    public $id_shop;
    public $commercial_email;
    public $email_subject_template;
    public $bcc_emails;
    public $is_active;
    public $created_date;

    public static $definition = [
        'table' => 'supplier_email_configs',
        'primary' => 'id_config',
        'fields' => [
            'id_supplier' => ['type' => self::TYPE_INT, 'validate' => 'isUnsignedId', 'required' => true],
            'id_shop' => ['type' => self::TYPE_INT, 'validate' => 'isUnsignedId'],
            'commercial_email' => ['type' => self::TYPE_STRING, 'validate' => 'isEmail', 'required' => true, 'size' => 255],
            'email_subject_template' => ['type' => self::TYPE_STRING, 'validate' => 'isGenericName', 'size' => 255],
            'bcc_emails' => ['type' => self::TYPE_STRING, 'validate' => 'isGenericName'],
            'is_active' => ['type' => self::TYPE_BOOL, 'validate' => 'isBool'],
            'created_date' => ['type' => self::TYPE_DATE, 'validate' => 'isDate', 'required' => true],
        ],
    ];

    public function add($autoDate = true, $nullValues = false)
    {
        $this->created_date = date('Y-m-d H:i:s');
        return parent::add($autoDate, $nullValues);
    }
}
