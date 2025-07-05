{* Tab Fixer - À inclure dans n'importe quelle page avec des problèmes d'onglets *}

<div id="tab-fixer-overlay" style="display: none; position: fixed; bottom: 20px; right: 20px; background: white; border: 1px solid #ccc; box-shadow: 0 0 10px rgba(0,0,0,0.2); padding: 15px; z-index: 9999; max-width: 300px; border-radius: 5px;">
    <h3 style="margin-top: 0; border-bottom: 1px solid #eee; padding-bottom: 8px;">Outil de réparation des onglets</h3>
    <div style="margin-bottom: 15px;">
        <button id="tab-fixer-analyze" style="background: #25b9d7; color: white; border: none; padding: 6px 10px; margin-right: 5px; border-radius: 3px; cursor: pointer;">Analyser</button>
        <button id="tab-fixer-fix" style="background: #72c279; color: white; border: none; padding: 6px 10px; margin-right: 5px; border-radius: 3px; cursor: pointer;">Réparer</button>
        <button id="tab-fixer-hide" style="background: #bbbbbb; color: white; border: none; padding: 6px 10px; border-radius: 3px; cursor: pointer;">Masquer</button>
    </div>
    <div id="tab-fixer-results" style="font-size: 12px; max-height: 150px; overflow-y: auto; padding: 5px; border: 1px solid #eee; background: #f9f9f9;">
        Cliquez sur "Analyser" pour commencer.
    </div>
</div>

<div style="position: fixed; bottom: 20px; left: 20px; z-index: 9998;">
    <button id="tab-fixer-show" style="background: #25b9d7; color: white; border: none; padding: 8px 15px; border-radius: 3px; cursor: pointer; box-shadow: 0 0 5px rgba(0,0,0,0.2);">
        🛠️ Réparer les onglets
    </button>
</div>

<script>
(function() {
    // Attendre que le DOM soit chargé
    document.addEventListener('DOMContentLoaded', function() {
        var overlay = document.getElementById('tab-fixer-overlay');
        var showButton = document.getElementById('tab-fixer-show');
        var hideButton = document.getElementById('tab-fixer-hide');
        var analyzeButton = document.getElementById('tab-fixer-analyze');
        var fixButton = document.getElementById('tab-fixer-fix');
        var resultsDiv = document.getElementById('tab-fixer-results');
        
        // Afficher le panneau
        showButton.addEventListener('click', function() {
            overlay.style.display = 'block';
            showButton.style.display = 'none';
        });
        
        // Masquer le panneau
        hideButton.addEventListener('click', function() {
            overlay.style.display = 'none';
            showButton.style.display = 'block';
        });
        
        // Fonction pour ajouter un message aux résultats
        function log(message, isError, isSuccess) {
            var p = document.createElement('p');
            p.style.margin = '3px 0';
            
            if (isError) {
                p.style.color = '#e74c3c';
                p.style.fontWeight = 'bold';
            } else if (isSuccess) {
                p.style.color = '#2ecc71';
                p.style.fontWeight = 'bold';
            }
            
            p.textContent = message;
            resultsDiv.appendChild(p);
            resultsDiv.scrollTop = resultsDiv.scrollHeight; // Auto-scroll vers le bas
        }
        
        // Analyser les onglets
        analyzeButton.addEventListener('click', function() {
            resultsDiv.innerHTML = '';
            log('Analyse des onglets en cours...', false, false);
            
            // Trouver tous les conteneurs d'onglets
            var tabContainers = document.querySelectorAll('.tab-container');
            log('Conteneurs trouvés: ' + tabContainers.length, false, false);
            
            if (tabContainers.length === 0) {
                log('⚠️ Aucun conteneur d\'onglets trouvé!', true, false);
            } else {
                tabContainers.forEach(function(container, index) {
                    log('Conteneur #' + (index + 1) + ':', false, false);
                    
                    var tabButtons = container.querySelectorAll('.tab-button');
                    log('- Boutons: ' + tabButtons.length, false, false);
                    
                    var tabContents = container.querySelectorAll('.tab-content');
                    log('- Contenus: ' + tabContents.length, false, false);
                    
                    var activeButtons = container.querySelectorAll('.tab-button.active');
                    log('- Boutons actifs: ' + activeButtons.length, false, false);
                    
                    var activeContents = container.querySelectorAll('.tab-content.active');
                    log('- Contenus actifs: ' + activeContents.length, false, false);
                    
                    if (activeContents.length > 0) {
                        var style = window.getComputedStyle(activeContents[0]);
                        log('- Style display: ' + style.display, style.display === 'none', false);
                        log('- Style visibility: ' + style.visibility, style.visibility === 'hidden', false);
                    }
                });
                
                log('Analyse terminée', false, true);
            }
        });
        
        // Réparer les onglets
        fixButton.addEventListener('click', function() {
            resultsDiv.innerHTML = '';
            log('Application des correctifs...', false, false);
            
            // 1. Forcer l'affichage de tous les contenus d'onglets actifs
            var activeContents = document.querySelectorAll('.tab-content.active');
            activeContents.forEach(function(content) {
                content.setAttribute('style', 'display: block !important; visibility: visible !important; opacity: 1 !important; position: relative !important; z-index: 999 !important;');
            });
            
            log('- Styles forcés sur les contenus actifs', false, true);
            
            // 2. Activer le premier onglet si aucun n'est actif
            var tabContainers = document.querySelectorAll('.tab-container');
            tabContainers.forEach(function(container) {
                var activeButtons = container.querySelectorAll('.tab-button.active');
                var activeContents = container.querySelectorAll('.tab-content.active');
                var allButtons = container.querySelectorAll('.tab-button');
                var allContents = container.querySelectorAll('.tab-content');
                
                if ((activeButtons.length === 0 || activeContents.length === 0) && allButtons.length > 0 && allContents.length > 0) {
                    // Activer le premier bouton
                    allButtons[0].classList.add('active');
                    
                    // Trouver et activer le contenu correspondant
                    var tabId = allButtons[0].getAttribute('data-tab');
                    if (tabId) {
                        var content = document.getElementById(tabId);
                        if (content) {
                            content.classList.add('active');
                            content.setAttribute('style', 'display: block !important; visibility: visible !important; opacity: 1 !important; position: relative !important; z-index: 999 !important;');
                        }
                    }
                    
                    log('- Premier onglet activé', false, true);
                }
            });
            
            // 3. Injecter du CSS d'urgence
            var style = document.createElement('style');
            style.textContent = `
                .tab-content.active {
                    display: block !important;
                    visibility: visible !important;
                    opacity: 1 !important;
                    position: relative !important;
                    z-index: 999 !important;
                }
                .bootstrap .tab-pane.active,
                .tab-pane.active {
                    display: block !important;
                    visibility: visible !important;
                    opacity: 1 !important;
                }
            `;
            document.head.appendChild(style);
            
            log('- CSS d\'urgence injecté', false, true);
            
            // 4. Reconfigurer les événements sur les boutons d'onglets
            var tabButtons = document.querySelectorAll('.tab-button');
            tabButtons.forEach(function(button) {
                button.addEventListener('click', function(e) {
                    // Éviter la propagation et le comportement par défaut
                    e.preventDefault();
                    e.stopPropagation();
                    
                    // Récupérer l'ID du contenu à afficher
                    var tabId = button.getAttribute('data-tab');
                    var tabContent = document.getElementById(tabId);
                    
                    // Trouver le conteneur parent
                    var container = button.closest('.tab-container');
                    
                    if (container) {
                        // Désactiver tous les boutons dans ce conteneur
                        container.querySelectorAll('.tab-button').forEach(function(btn) {
                            btn.classList.remove('active');
                        });
                        
                        // Désactiver tous les contenus dans ce conteneur
                        container.querySelectorAll('.tab-content').forEach(function(content) {
                            content.classList.remove('active');
                            content.style.display = 'none';
                        });
                    }
                    
                    // Activer le bouton cliqué
                    button.classList.add('active');
                    
                    // Activer et forcer l'affichage du contenu correspondant
                    if (tabContent) {
                        tabContent.classList.add('active');
                        tabContent.setAttribute('style', 'display: block !important; visibility: visible !important; opacity: 1 !important; position: relative !important; z-index: 999 !important;');
                    }
                    
                    return false;
                });
            });
            
            log('- Événements reconfigurés', false, true);
            log('✅ Correctifs appliqués avec succès!', false, true);
        });
    });
})();
</script>
