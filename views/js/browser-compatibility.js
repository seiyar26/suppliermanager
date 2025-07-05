/**
 * Script de compatibilité entre navigateurs pour le module Supplier Manager
 * Ce script s'assure que les contenus des onglets s'affichent correctement sur tous les navigateurs
 */
document.addEventListener('DOMContentLoaded', function() {
    // 1. Injecter les styles de correction CSS
    const injectCSS = () => {
        const style = document.createElement('style');
        style.textContent = `
            /* Correction principale pour l'affichage des contenus */
            .tab-content.active {
                display: block !important;
                opacity: 1 !important;
                visibility: visible !important;
            }
            
            /* Fixes pour Webkit (Chrome, Safari) */
            .tab-content.active {
                -webkit-transform: translateZ(0);
                transform: translateZ(0);
            }
            
            .bootstrap .tab-container {
                -webkit-transform: translateZ(0);
                transform: translateZ(0);
            }
            
            /* Correctif de visibilité forcée */
            .visible-all-browsers {
                display: block !important;
                opacity: 1 !important;
                visibility: visible !important;
            }
            
            /* Fix pour le problème de colonne centrale */
            .page-content,
            .content-wrap,
            .main-content {
                display: block !important;
                visibility: visible !important;
                opacity: 1 !important;
            }
        `;
        document.head.appendChild(style);
    };
    
    // 2. Forcer l'affichage des onglets
    const fixTabDisplay = () => {
        // Sélectionner tous les boutons d'onglet
        const tabButtons = document.querySelectorAll('.tab-button');
        
        // Si aucun onglet n'est actif, activer le premier
        let hasActiveTab = false;
        
        tabButtons.forEach(button => {
            if (button.classList.contains('active')) {
                hasActiveTab = true;
                
                // S'assurer que le contenu correspondant est bien visible
                const tabId = button.dataset.tab;
                const tabContent = document.getElementById(tabId);
                
                if (tabContent) {
                    tabContent.classList.add('active', 'visible-all-browsers');
                    console.log('Tab content activated:', tabId);
                }
            }
        });
        
        // Si aucun onglet n'est actif, activer le premier
        if (!hasActiveTab && tabButtons.length > 0) {
            const firstButton = tabButtons[0];
            firstButton.classList.add('active');
            
            const tabId = firstButton.dataset.tab;
            const tabContent = document.getElementById(tabId);
            
            if (tabContent) {
                tabContent.classList.add('active', 'visible-all-browsers');
                console.log('First tab activated:', tabId);
            }
        }
    };
    
    // 3. Observer les changements DOM pour réappliquer les correctifs si nécessaire
    const observeDOM = () => {
        const observer = new MutationObserver(function(mutations) {
            mutations.forEach(function(mutation) {
                if (mutation.addedNodes.length > 0) {
                    fixTabDisplay();
                }
            });
        });
        
        observer.observe(document.body, {
            childList: true,
            subtree: true
        });
    };
    
    // Exécuter les correctifs
    injectCSS();
    
    // Appliquer les correctifs après un court délai pour s'assurer que le DOM est complètement chargé
    setTimeout(fixTabDisplay, 100);
    
    // Observer les changements DOM
    observeDOM();
    
    // Réappliquer périodiquement pour s'assurer que tout est visible
    setInterval(fixTabDisplay, 1000);
    
    console.log('Browser compatibility fixes applied');
});
