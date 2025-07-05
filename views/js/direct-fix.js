/**
 * Solution d'urgence pour le problème d'affichage des onglets
 * Ce script s'exécute immédiatement et force l'affichage des contenus
 */

// Fonction d'initialisation immédiate
(function() {
    // Fonction pour forcer l'affichage des contenus
    function forceDisplay() {
        console.log('🔄 Force Display: Applying emergency CSS fixes');
        
        // 1. Cibler tous les contenus d'onglets
        var allTabContents = document.querySelectorAll('.tab-content');
        var tabButtons = document.querySelectorAll('.tab-button');
        
        // 2. Si aucun contenu n'est visible, forcer l'affichage du premier
        var visibleContent = document.querySelector('.tab-content.active');
        if (!visibleContent && allTabContents.length > 0) {
            console.log('⚠️ No active tab content found. Forcing first tab to display.');
            
            // Activer le premier onglet
            if (tabButtons.length > 0) {
                tabButtons[0].classList.add('active');
                console.log('▶️ First tab button activated');
            }
            
            // Activer le premier contenu
            allTabContents[0].classList.add('active');
            console.log('▶️ First tab content activated');
        }
        
        // 3. Appliquer un style forcé à tous les contenus d'onglets actifs
        var activeContents = document.querySelectorAll('.tab-content.active');
        activeContents.forEach(function(content) {
            // Style en ligne pour contourner tout CSS existant
            content.setAttribute('style', 'display: block !important; visibility: visible !important; opacity: 1 !important; position: relative !important; z-index: 999 !important;');
            console.log('🔧 Forced display style applied to tab content:', content.id);
        });
        
        // 4. Appliquer un style forcé à la colonne centrale
        var mainColumns = document.querySelectorAll('.main-column, .content-column, .center-column, .page-content, #content');
        mainColumns.forEach(function(column) {
            column.setAttribute('style', 'display: block !important; visibility: visible !important; opacity: 1 !important;');
            console.log('🔧 Forced display style applied to main column');
        });
    }
    
    // Exécuter immédiatement
    forceDisplay();
    
    // Exécuter à nouveau après le chargement complet
    if (document.readyState === 'complete' || document.readyState === 'interactive') {
        forceDisplay();
    } else {
        document.addEventListener('DOMContentLoaded', forceDisplay);
    }
    
    // Exécuter encore après un court délai pour s'assurer que tout est chargé
    setTimeout(forceDisplay, 100);
    setTimeout(forceDisplay, 500);
    setTimeout(forceDisplay, 1000);
    
    // Observer les changements DOM pour réappliquer les correctifs si nécessaire
    var observer = new MutationObserver(function(mutations) {
        forceDisplay();
    });
    
    // Démarrer l'observation dès que possible
    if (document.body) {
        observer.observe(document.body, {
            childList: true,
            subtree: true
        });
    } else {
        window.addEventListener('load', function() {
            observer.observe(document.body, {
                childList: true,
                subtree: true
            });
        });
    }
    
    // Surcharger la fonction switchTab pour s'assurer que les onglets s'affichent correctement
    if (typeof SupplierManager !== 'undefined' && SupplierManager.prototype.switchTab) {
        var originalSwitchTab = SupplierManager.prototype.switchTab;
        
        SupplierManager.prototype.switchTab = function(tabId, button) {
            // Appeler la fonction originale
            originalSwitchTab.call(this, tabId, button);
            
            // Forcer l'affichage après le changement d'onglet
            var selectedTab = document.getElementById(tabId);
            if (selectedTab) {
                selectedTab.setAttribute('style', 'display: block !important; visibility: visible !important; opacity: 1 !important;');
                console.log('▶️ Tab content forced visible after switch:', tabId);
            }
        };
        
        console.log('🔄 SwitchTab function overridden');
    }
    
    console.log('✅ Emergency tab display fix applied');
})();
