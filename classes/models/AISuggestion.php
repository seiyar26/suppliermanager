<?php
if (!defined('_PS_VERSION_')) {
    exit;
}

class AISuggestion extends ObjectModel
{
    public $id_suggestion;
    public $id_product;
    public $id_shop;
    public $suggested_quantity;
    public $reason;
    public $confidence_score;
    public $created_date;
    public $applied;

    public static $definition = [
        'table' => 'ai_suggestions',
        'primary' => 'id_suggestion',
        'fields' => [
            'id_product' => ['type' => self::TYPE_INT, 'validate' => 'isUnsignedId', 'required' => true],
            'id_shop' => ['type' => self::TYPE_INT, 'validate' => 'isUnsignedId', 'required' => true],
            'suggested_quantity' => ['type' => self::TYPE_INT, 'validate' => 'isUnsignedInt', 'required' => true],
            'reason' => ['type' => self::TYPE_STRING, 'validate' => 'isCleanHtml'],
            'confidence_score' => ['type' => self::TYPE_FLOAT, 'validate' => 'isFloat'],
            'created_date' => ['type' => self::TYPE_DATE, 'validate' => 'isDate', 'required' => true],
            'applied' => ['type' => self::TYPE_BOOL, 'validate' => 'isBool'],
        ],
    ];

    public static function getActiveSuggestions($id_shop, $limit = null)
    {
        $id_shop = (int)$id_shop;
        $limitClause = $limit ? ' LIMIT '.(int)$limit : '';
        
        $sql = 'SELECT ais.*, pl.name as product_name, p.reference
                FROM `'._DB_PREFIX_.'ai_suggestions` ais
                JOIN `'._DB_PREFIX_.'product` p ON (ais.id_product = p.id_product)
                JOIN `'._DB_PREFIX_.'product_lang` pl ON (p.id_product = pl.id_product)
                WHERE ais.id_shop = '.$id_shop.'
                AND ais.applied = 0
                AND pl.id_lang = '.(int)Context::getContext()->language->id.'
                ORDER BY ais.confidence_score DESC, ais.created_date DESC'.$limitClause;
        
        return Db::getInstance()->executeS($sql);
    }

    public static function getSuggestionsByProduct($id_product, $id_shop)
    {
        $id_product = (int)$id_product;
        $id_shop = (int)$id_shop;
        
        $sql = 'SELECT * FROM `'._DB_PREFIX_.'ai_suggestions` 
                WHERE `id_product` = '.$id_product.' 
                AND `id_shop` = '.$id_shop.' 
                ORDER BY `created_date` DESC';
        
        return Db::getInstance()->executeS($sql);
    }

    public static function markAsApplied($id_suggestion)
    {
        $id_suggestion = (int)$id_suggestion;
        
        $sql = 'UPDATE `'._DB_PREFIX_.'ai_suggestions` 
                SET `applied` = 1 
                WHERE `id_suggestion` = '.$id_suggestion;
        
        return Db::getInstance()->execute($sql);
    }

    public static function cleanOldSuggestions($days = 30)
    {
        $days = (int)$days;
        
        $sql = 'DELETE FROM `'._DB_PREFIX_.'ai_suggestions` 
                WHERE `created_date` < DATE_SUB(NOW(), INTERVAL '.$days.' DAY)';
        
        return Db::getInstance()->execute($sql);
    }
}