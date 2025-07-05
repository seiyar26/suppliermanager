<!DOCTYPE html>
<html>
<head>
    <title>Debug Supplier Manager</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background: #f5f5f5;
        }
        .debug-container {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        .success {
            background: #d4edda;
            color: #155724;
            padding: 10px;
            border-radius: 5px;
            border: 1px solid #c3e6cb;
        }
        .error {
            background: #f8d7da;
            color: #721c24;
            padding: 10px;
            border-radius: 5px;
            border: 1px solid #f5c6cb;
        }
        .info {
            background: #d1ecf1;
            color: #0c5460;
            padding: 10px;
            border-radius: 5px;
            border: 1px solid #bee5eb;
        }
        .test-button {
            background: #007bff;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            margin: 5px;
        }
        .test-button:hover {
            background: #0056b3;
        }
    </style>
</head>
<body>
    <div class="debug-container">
        <h1>🔧 Debug Supplier Manager</h1>
        <div class="success">
            ✅ Template debug.tpl chargé avec succès !
        </div>
    </div>

    <div class="debug-container">
        <h2>Tests de fonctionnement</h2>
        
        <div class="info">
            <strong>Template :</strong> debug.tpl<br>
            <strong>Contrôleur :</strong> {if isset($smarty.server.REQUEST_URI)}{$smarty.server.REQUEST_URI}{else}Non défini{/if}<br>
            <strong>Module :</strong> suppliermanager
        </div>
        
        <h3>Test JavaScript</h3>
        <button class="test-button" onclick="testJS()">Test JavaScript</button>
        <button class="test-button" onclick="testNotification()">Test Notification</button>
        
        <h3>Test CSS</h3>
        <div style="background: linear-gradient(45deg, #ff6b6b, #4ecdc4); color: white; padding: 15px; border-radius: 10px; margin: 10px 0;">
            🎨 CSS Inline fonctionne !
        </div>
        
        <h3>Test Variables Smarty</h3>
        <div class="info">
            {if isset($link)}
                ✅ Variable $link disponible<br>
            {else}
                ❌ Variable $link non disponible<br>
            {/if}
            
            {if isset($token)}
                ✅ Variable $token disponible: {$token}<br>
            {else}
                ❌ Variable $token non disponible<br>
            {/if}
            
            {if isset($table)}
                ✅ Variable $table disponible: {$table}<br>
            {else}
                ❌ Variable $table non disponible<br>
            {/if}
        </div>
    </div>

    <div class="debug-container">
        <h2>Test du CSS externe</h2>
        <div class="bootstrap">
            <div class="panel">
                <div class="panel-heading">
                    Test Panel avec CSS externe
                </div>
                <div class="panel-body">
                    Si ce panel a un style moderne, le CSS externe fonctionne.
                </div>
            </div>
        </div>
        
        <div class="stat-card">
            <div class="stat-icon">
                <i class="icon-check"></i>
            </div>
            <div class="stat-content">
                <h3>Test</h3>
                <p>CSS Card</p>
            </div>
        </div>
    </div>

    <script>
        function testJS() {
            alert('✅ JavaScript fonctionne parfaitement !');
        }
        
        function testNotification() {
            var notification = document.createElement('div');
            notification.style.cssText = `
                position: fixed;
                top: 20px;
                right: 20px;
                background: #28a745;
                color: white;
                padding: 15px 20px;
                border-radius: 5px;
                box-shadow: 0 4px 6px rgba(0,0,0,0.1);
                z-index: 9999;
                font-weight: bold;
            `;
            notification.textContent = '✅ Notification test réussie !';
            document.body.appendChild(notification);
            
            setTimeout(function() {
                document.body.removeChild(notification);
            }, 3000);
        }
        
        // Test du CSS externe
        document.addEventListener('DOMContentLoaded', function() {
            var testElement = document.querySelector('.bootstrap');
            if (testElement) {
                var styles = window.getComputedStyle(testElement);
                var bgColor = styles.backgroundColor;
                var padding = styles.padding;
                
                console.log('CSS externe détecté:', {
                    backgroundColor: bgColor,
                    padding: padding
                });
                
                if (bgColor !== 'rgba(0, 0, 0, 0)' && bgColor !== 'transparent') {
                    console.log('✅ CSS externe fonctionne !');
                } else {
                    console.log('❌ CSS externe ne fonctionne pas');
                }
            }
        });
    </script>
</body>
</html>