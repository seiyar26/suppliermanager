<?php

class SupplierContract extends ObjectModel
{
    public $id;
    public $id_supplier;
    public $name;
    public $reference;
    public $start_date;
    public $end_date;
    public $description;
    public $file_path;

    public static $definition = [
        'table' => 'supplier_contracts',
        'primary' => 'id_contract',
        'fields' => [
            'id_supplier' => ['type' => self::TYPE_INT, 'validate' => 'isUnsignedId', 'required' => true],
            'name' => ['type' => self::TYPE_STRING, 'validate' => 'isGenericName', 'required' => true],
            'reference' => ['type' => self::TYPE_STRING, 'validate' => 'isGenericName'],
            'start_date' => ['type' => self::TYPE_DATE, 'validate' => 'isDate', 'required' => true],
            'end_date' => ['type' => self::TYPE_DATE, 'validate' => 'isDate'],
            'description' => ['type' => self::TYPE_HTML, 'validate' => 'isCleanHtml'],
            'file_path' => ['type' => self::TYPE_STRING],
        ],
    ];
}