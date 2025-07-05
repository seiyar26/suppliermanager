<?php
if (!defined('_PS_VERSION_')) {
    exit;
}

class GeminiAIService
{
    private $apiKey;
    private $apiEndpoint = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent';

    public function __construct()
    {
        $this->apiKey = Configuration::get('SUPPLIERMANAGER_GEMINI_API_KEY');
    }

    public function analyzeVentalData($productId, $shopId, $months = 3)
    {
        // Récupérer les données de vente
        $salesData = $this->getSalesData($productId, $shopId, $months);
        
        // Préparer les données pour l'API Gemini
        $prompt = $this->prepareSalesDataPrompt($salesData);
        
        // Appeler l'API Gemini
        $response = $this->callGeminiAPI($prompt);
        
        return $this->parseAnalysisResponse($response);
    }

    public function suggestOrderQuantities($productId, $shopId)
    {
        // Récupérer les données de stock et de vente
        $stockData = StockService::getProductStock($productId, $shopId);
        $salesData = $this->getSalesData($productId, $shopId, 6);
        
        // Préparer les données pour l'API Gemini
        $prompt = $this->prepareOrderSuggestionPrompt($productId, $stockData, $salesData);
        
        // Appeler l'API Gemini
        $response = $this->callGeminiAPI($prompt);
        
        return $this->parseSuggestionResponse($response);
    }

    public function predictDemand($productId, $shopId, $months = 3)
    {
        // Récupérer les données de vente historiques
        $salesData = $this->getSalesData($productId, $shopId, 12);
        
        // Préparer les données pour l'API Gemini
        $prompt = $this->prepareDemandPredictionPrompt($productId, $salesData, $months);
        
        // Appeler l'API Gemini
        $response = $this->callGeminiAPI($prompt);
        
        return $this->parsePredictionResponse($response);
    }

    public function detectAnomalies($shopId, $days = 30)
    {
        // Récupérer les données de vente pour tous les produits
        $salesData = $this->getShopSalesData($shopId, $days);
        
        // Préparer les données pour l'API Gemini
        $prompt = $this->prepareAnomalyDetectionPrompt($salesData);
        
        // Appeler l'API Gemini
        $response = $this->callGeminiAPI($prompt);
        
        return $this->parseAnomalyResponse($response);
    }

    public function generateSuggestionsForAllProducts($shopId, $supplierId = null)
    {
        // Récupérer tous les produits actifs
        $products = $this->getActiveProducts($shopId, $supplierId);
        $suggestions = [];
        
        foreach ($products as $product) {
            $suggestion = $this->suggestOrderQuantities($product['id_product'], $shopId);
            
            if ($suggestion['quantity'] > 0) {
                // Créer une nouvelle suggestion dans la base de données
                $aiSuggestion = new AISuggestion();
                $aiSuggestion->id_product = $product['id_product'];
                $aiSuggestion->id_shop = $shopId;
                $aiSuggestion->suggested_quantity = $suggestion['quantity'];
                $aiSuggestion->reason = $suggestion['explanation'];
                $aiSuggestion->confidence_score = $suggestion['confidence'] ?? 0.5;
                $aiSuggestion->created_date = date('Y-m-d H:i:s');
                $aiSuggestion->applied = 0;
                
                if ($aiSuggestion->save()) {
                    $suggestions[] = [
                        'id_suggestion' => $aiSuggestion->id,
                        'id_product' => $product['id_product'],
                        'product_name' => $product['name'],
                        'suggested_quantity' => $suggestion['quantity'],
                        'reason' => $suggestion['explanation'],
                        'confidence_score' => $suggestion['confidence'] ?? 0.5
                    ];
                }
            }
        }
        
        return $suggestions;
    }

    private function getSalesData($productId, $shopId, $months)
    {
        $productId = (int)$productId;
        $shopId = (int)$shopId;
        $months = (int)$months;
        
        $date = new DateTime();
        $date->modify('-'.$months.' months');
        $fromDate = $date->format('Y-m-d');
        
        $sql = 'SELECT o.date_add, od.product_quantity 
                FROM `'._DB_PREFIX_.'orders` o 
                JOIN `'._DB_PREFIX_.'order_detail` od ON (o.id_order = od.id_order) 
                WHERE od.product_id = '.$productId.' 
                AND o.id_shop = '.$shopId.' 
                AND o.date_add >= "'.$fromDate.'" 
                AND o.valid = 1 
                ORDER BY o.date_add ASC';
        
        return Db::getInstance()->executeS($sql);
    }

    private function getShopSalesData($shopId, $days)
    {
        $shopId = (int)$shopId;
        $days = (int)$days;
        
        $date = new DateTime();
        $date->modify('-'.$days.' days');
        $fromDate = $date->format('Y-m-d');
        
        $sql = 'SELECT o.date_add, od.product_id, od.product_quantity, pl.name as product_name
                FROM `'._DB_PREFIX_.'orders` o 
                JOIN `'._DB_PREFIX_.'order_detail` od ON (o.id_order = od.id_order) 
                JOIN `'._DB_PREFIX_.'product_lang` pl ON (od.product_id = pl.id_product)
                WHERE o.id_shop = '.$shopId.' 
                AND o.date_add >= "'.$fromDate.'" 
                AND o.valid = 1 
                AND pl.id_lang = '.(int)Context::getContext()->language->id.'
                ORDER BY o.date_add ASC';
        
        return Db::getInstance()->executeS($sql);
    }

    private function getActiveProducts($shopId, $supplierId = null)
    {
        $shopId = (int)$shopId;
        $supplierFilter = '';
        
        if ($supplierId) {
            $supplierId = (int)$supplierId;
            $supplierFilter = ' AND ps.id_supplier = '.$supplierId;
        }
        
        $sql = 'SELECT p.id_product, pl.name 
                FROM `'._DB_PREFIX_.'product` p 
                JOIN `'._DB_PREFIX_.'product_lang` pl ON (p.id_product = pl.id_product) 
                LEFT JOIN `'._DB_PREFIX_.'product_supplier` ps ON (p.id_product = ps.id_product)
                WHERE p.active = 1 
                AND pl.id_lang = '.(int)Context::getContext()->language->id.$supplierFilter;
        
        return Db::getInstance()->executeS($sql);
    }

    private function prepareSalesDataPrompt($salesData)
    {
        // Formater les données de vente pour l'API Gemini
        $formattedData = json_encode($salesData);
        
        return "Analyze the following sales data and provide insights on trends, seasonality, and recommendations for inventory management: " . $formattedData;
    }

    private function prepareOrderSuggestionPrompt($productId, $stockData, $salesData)
    {
        // Récupérer les informations du produit
        $product = new Product($productId, false, Context::getContext()->language->id);
        
        // Formater les données pour l'API Gemini
        $data = [
            'product_name' => $product->name,
            'current_stock' => $stockData,
            'sales_history' => $salesData
        ];
        
        $formattedData = json_encode($data);
        
        return "Based on the following product data, suggest an optimal order quantity for restocking. Consider current stock levels, sales history, and potential seasonality. Return a JSON object with 'quantity' (integer), 'explanation' (string), and 'confidence' (float between 0 and 1): " . $formattedData;
    }

    private function prepareDemandPredictionPrompt($productId, $salesData, $months)
    {
        // Récupérer les informations du produit
        $product = new Product($productId, false, Context::getContext()->language->id);
        
        // Formater les données pour l'API Gemini
        $data = [
            'product_name' => $product->name,
            'sales_history' => $salesData,
            'prediction_months' => $months
        ];
        
        $formattedData = json_encode($data);
        
        return "Based on the following product sales history, predict the demand for the next " . $months . " months. Return a JSON object with 'monthly_predictions' (array of integers, one per month), 'total_prediction' (integer), and 'explanation' (string): " . $formattedData;
    }

    private function prepareAnomalyDetectionPrompt($salesData)
    {
        // Formater les données pour l'API Gemini
        $formattedData = json_encode($salesData);
        
        return "Analyze the following sales data and detect any anomalies or unusual patterns. Return a JSON object with 'anomalies' (array of objects with 'product_id', 'product_name', 'anomaly_type', and 'description') and 'summary' (string): " . $formattedData;
    }

    private function callGeminiAPI($prompt)
    {
        if (empty($this->apiKey)) {
            return ['error' => 'API key not configured'];
        }
        
        $data = [
            'contents' => [
                [
                    'parts' => [
                        ['text' => $prompt]
                    ]
                ]
            ]
        ];
        
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $this->apiEndpoint . '?key=' . $this->apiKey);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($ch, CURLOPT_POST, 1);
        curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($data));
        curl_setopt($ch, CURLOPT_HTTPHEADER, ['Content-Type: application/json']);
        
        $response = curl_exec($ch);
        curl_close($ch);
        
        return json_decode($response, true);
    }

    private function parseAnalysisResponse($response)
    {
        // Extraire les informations pertinentes de la réponse de l'API
        if (isset($response['candidates'][0]['content']['parts'][0]['text'])) {
            return $response['candidates'][0]['content']['parts'][0]['text'];
        }
        
        return 'No analysis available';
    }

    private function parseSuggestionResponse($response)
    {
        // Extraire la suggestion de quantité de la réponse de l'API
        if (isset($response['candidates'][0]['content']['parts'][0]['text'])) {
            $text = $response['candidates'][0]['content']['parts'][0]['text'];
            
            // Essayer de parser le JSON dans la réponse
            preg_match('/\{.*\}/s', $text, $matches);
            
            if (isset($matches[0])) {
                $jsonData = json_decode($matches[0], true);
                
                if ($jsonData && isset($jsonData['quantity'])) {
                    return [
                        'quantity' => (int)$jsonData['quantity'],
                        'explanation' => $jsonData['explanation'] ?? 'No explanation provided',
                        'confidence' => $jsonData['confidence'] ?? 0.5
                    ];
                }
            }
            
            // Fallback: analyser le texte pour extraire la quantité suggérée
            preg_match('/suggested quantity[:\s]+(\d+)/i', $text, $matches);
            
            if (isset($matches[1])) {
                return [
                    'quantity' => (int)$matches[1],
                    'explanation' => $text,
                    'confidence' => 0.5
                ];
            }
        }
        
        return [
            'quantity' => 0,
            'explanation' => 'No suggestion available',
            'confidence' => 0
        ];
    }

    private function parsePredictionResponse($response)
    {
        // Extraire les prédictions de la réponse de l'API
        if (isset($response['candidates'][0]['content']['parts'][0]['text'])) {
            $text = $response['candidates'][0]['content']['parts'][0]['text'];
            
            // Essayer de parser le JSON dans la réponse
            preg_match('/\{.*\}/s', $text, $matches);
            
            if (isset($matches[0])) {
                $jsonData = json_decode($matches[0], true);
                
                if ($jsonData && isset($jsonData['monthly_predictions']) && isset($jsonData['total_prediction'])) {
                    return $jsonData;
                }
            }
        }
        
        return [
            'monthly_predictions' => [],
            'total_prediction' => 0,
            'explanation' => 'No prediction available'
        ];
    }

    private function parseAnomalyResponse($response)
    {
        // Extraire les anomalies de la réponse de l'API
        if (isset($response['candidates'][0]['content']['parts'][0]['text'])) {
            $text = $response['candidates'][0]['content']['parts'][0]['text'];
            
            // Essayer de parser le JSON dans la réponse
            preg_match('/\{.*\}/s', $text, $matches);
            
            if (isset($matches[0])) {
                $jsonData = json_decode($matches[0], true);
                
                if ($jsonData && isset($jsonData['anomalies'])) {
                    return $jsonData;
                }
            }
        }
        
        return [
            'anomalies' => [],
            'summary' => 'No anomalies detected'
        ];
    }
}