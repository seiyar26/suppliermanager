{* Page de diagnostic pour problèmes d'affichage *}
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Diagnostic d'affichage - Supplier Manager</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            line-height: 1.6;
        }
        h1 {
            color: #333;
            border-bottom: 1px solid #ddd;
            padding-bottom: 10px;
        }
        .diagnostic-panel {
            margin-bottom: 20px;
            padding: 15px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        .control-panel {
            background: #f8f8f8;
            padding: 15px;
            margin-bottom: 20px;
            border: 1px solid #ddd;
        }
        button {
            padding: 8px 15px;
            background: #0073aa;
            color: white;
            border: none;
            border-radius: 3px;
            cursor: pointer;
            margin-right: 5px;
        }
        button:hover {
            background: #005177;
        }
        .test-area {
            border: 1px dashed #ccc;
            padding: 20px;
            margin-top: 20px;
        }
        pre {
            background: #f5f5f5;
            padding: 10px;
            overflow: auto;
            border: 1px solid #ddd;
        }
        .test-tabs {
            margin-top: 30px;
        }
        .test-tab-nav {
            display: flex;
            border-bottom: 1px solid #ddd;
        }
        .test-tab-button {
            padding: 10px 15px;
            background: #f5f5f5;
            border: 1px solid #ddd;
            border-bottom: none;
            cursor: pointer;
            margin-right: 5px;
        }
        .test-tab-button.active {
            background: white;
            border-bottom-color: white;
            position: relative;
            bottom: -1px;
        }
        .test-tab-content {
            display: none;
            padding: 15px;
            border: 1px solid #ddd;
            border-top: none;
        }
        .test-tab-content.active {
            display: block;
        }
        .error {
            color: red;
            font-weight: bold;
        }
        .success {
            color: green;
            font-weight: bold;
        }
        #css-inspector {
            margin-top: 20px;
        }
        .css-rule {
            margin-bottom: 8px;
            font-family: monospace;
        }
    </style>
</head>
<body>
    <h1>Outil de diagnostic - Problèmes d'affichage des onglets</h1>
    
    <div class="control-panel">
        <h2>Panneau de contrôle</h2>
        <button id="analyze-tabs">Analyser les onglets</button>
        <button id="force-display">Forcer l'affichage</button>
        <button id="rebuild-tabs">Reconstruire les onglets</button>
        <button id="inspect-css">Inspecter CSS</button>
        <button id="clear-cache">Simuler clear cache</button>
    </div>
    
    <div class="diagnostic-panel">
        <h2>Résultats de diagnostic</h2>
        <div id="diagnostic-results">
            Cliquez sur "Analyser les onglets" pour commencer le diagnostic...
        </div>
    </div>
    
    <div class="test-area">
        <h2>Zone de test</h2>
        <p>Cette zone contient une implémentation minimale des onglets pour tester leur fonctionnement.</p>
        
        <div class="test-tabs">
            <div class="test-tab-nav">
                <button class="test-tab-button active" data-tab="test-tab-1">Onglet 1</button>
                <button class="test-tab-button" data-tab="test-tab-2">Onglet 2</button>
                <button class="test-tab-button" data-tab="test-tab-3">Onglet 3</button>
            </div>
            
            <div id="test-tab-1" class="test-tab-content active">
                <h3>Contenu de l'onglet 1</h3>
                <p>Si vous pouvez voir ce texte, cela signifie que l'affichage des onglets fonctionne correctement dans cette zone de test.</p>
            </div>
            
            <div id="test-tab-2" class="test-tab-content">
                <h3>Contenu de l'onglet 2</h3>
                <p>Contenu du deuxième onglet. Ce contenu devrait être masqué par défaut et s'afficher uniquement lorsqu'on clique sur l'onglet 2.</p>
            </div>
            
            <div id="test-tab-3" class="test-tab-content">
                <h3>Contenu de l'onglet 3</h3>
                <p>Contenu du troisième onglet. Ce contenu devrait être masqué par défaut et s'afficher uniquement lorsqu'on clique sur l'onglet 3.</p>
            </div>
        </div>
        
        <div id="css-inspector"></div>
    </div>
    
    <script>
        // Fonctions de diagnostic
        document.addEventListener('DOMContentLoaded', function() {
            const diagnosticResults = document.getElementById('diagnostic-results');
            
            // Fonction pour afficher un message dans la zone de résultats
            function log(message, isError = false, isSuccess = false) {
                const p = document.createElement('p');
                if (isError) p.classList.add('error');
                if (isSuccess) p.classList.add('success');
                p.textContent = message;
                diagnosticResults.appendChild(p);
            }
            
            // Analyser les onglets
            document.getElementById('analyze-tabs').addEventListener('click', function() {
                diagnosticResults.innerHTML = '';
                log('Analyse des onglets en cours...', false);
                
                // 1. Vérifier si les sélecteurs d'onglets existent dans la page
                const tabContainers = document.querySelectorAll('.tab-container');
                log(`Nombre de conteneurs d'onglets trouvés: ${tabContainers.length}`, false);
                
                if (tabContainers.length === 0) {
                    log('PROBLÈME: Aucun conteneur d\'onglets trouvé dans la page!', true);
                } else {
                    tabContainers.forEach((container, i) => {
                        log(`Conteneur d'onglets #${i+1}:`, false);
                        
                        const tabButtons = container.querySelectorAll('.tab-button');
                        log(`  - Boutons d'onglets: ${tabButtons.length}`, false);
                        
                        const tabContents = container.querySelectorAll('.tab-content');
                        log(`  - Contenus d'onglets: ${tabContents.length}`, false);
                        
                        if (tabButtons.length === 0) {
                            log('  - PROBLÈME: Aucun bouton d\'onglet trouvé!', true);
                        }
                        
                        if (tabContents.length === 0) {
                            log('  - PROBLÈME: Aucun contenu d\'onglet trouvé!', true);
                        }
                        
                        // Vérifier si un onglet est actif
                        const activeButtons = container.querySelectorAll('.tab-button.active');
                        log(`  - Boutons actifs: ${activeButtons.length}`, false);
                        
                        const activeContents = container.querySelectorAll('.tab-content.active');
                        log(`  - Contenus actifs: ${activeContents.length}`, false);
                        
                        if (activeButtons.length === 0) {
                            log('  - PROBLÈME: Aucun bouton d\'onglet actif!', true);
                        }
                        
                        if (activeContents.length === 0) {
                            log('  - PROBLÈME: Aucun contenu d\'onglet actif!', true);
                        }
                        
                        // Vérifier les styles CSS appliqués
                        if (activeContents.length > 0) {
                            const firstActiveContent = activeContents[0];
                            const computedStyle = window.getComputedStyle(firstActiveContent);
                            
                            log(`  - Style 'display': ${computedStyle.display}`, computedStyle.display === 'none');
                            log(`  - Style 'visibility': ${computedStyle.visibility}`, computedStyle.visibility === 'hidden');
                            log(`  - Style 'opacity': ${computedStyle.opacity}`, computedStyle.opacity === '0');
                        }
                    });
                }
                
                // 2. Vérifier les scripts chargés
                log('\nVérification des scripts chargés:', false);
                const scripts = document.querySelectorAll('script');
                let hasAdminJs = false;
                
                scripts.forEach(script => {
                    if (script.src.includes('admin.js')) {
                        hasAdminJs = true;
                        log(`  - admin.js trouvé: ${script.src}`, false, true);
                    }
                });
                
                if (!hasAdminJs) {
                    log('  - PROBLÈME: admin.js non trouvé!', true);
                }
                
                // 3. Vérifier le navigateur
                log('\nInformations sur le navigateur:', false);
                log(`  - User Agent: ${navigator.userAgent}`, false);
                
                // 4. Tester l'affichage de base
                log('\nTest d\'affichage de base:', false);
                const testContent = document.getElementById('test-tab-1');
                if (testContent) {
                    const testStyle = window.getComputedStyle(testContent);
                    log(`  - Test onglet display: ${testStyle.display}`, testStyle.display === 'none');
                }
                
                log('\nDiagnostic terminé.', false, true);
            });
            
            // Forcer l'affichage des onglets
            document.getElementById('force-display').addEventListener('click', function() {
                log('Application de l\'affichage forcé...', false);
                
                // Cibler tous les contenus d'onglets
                const tabContents = document.querySelectorAll('.tab-content');
                
                tabContents.forEach(content => {
                    // Appliquer des styles inline très agressifs
                    content.setAttribute('style', 'display: block !important; visibility: visible !important; opacity: 1 !important; position: static !important; z-index: 999 !important;');
                });
                
                // Activer le premier onglet si aucun n'est actif
                const tabContainers = document.querySelectorAll('.tab-container');
                
                tabContainers.forEach(container => {
                    const activeContents = container.querySelectorAll('.tab-content.active');
                    const allContents = container.querySelectorAll('.tab-content');
                    
                    if (activeContents.length === 0 && allContents.length > 0) {
                        allContents[0].classList.add('active');
                    }
                });
                
                log('Styles d\'affichage forcé appliqués!', false, true);
            });
            
            // Reconstruire les onglets
            document.getElementById('rebuild-tabs').addEventListener('click', function() {
                log('Reconstruction des onglets...', false);
                
                const tabContainers = document.querySelectorAll('.tab-container');
                
                if (tabContainers.length === 0) {
                    log('Aucun conteneur d\'onglets trouvé!', true);
                    return;
                }
                
                tabContainers.forEach((container, index) => {
                    const tabButtons = container.querySelectorAll('.tab-button');
                    const tabContents = container.querySelectorAll('.tab-content');
                    
                    // Créer un nouveau conteneur
                    const newContainer = document.createElement('div');
                    newContainer.className = 'new-tab-container';
                    newContainer.style.cssText = 'width: 100%; margin-bottom: 20px;';
                    
                    // Créer la nouvelle navigation
                    const newNav = document.createElement('div');
                    newNav.className = 'new-tab-nav';
                    newNav.style.cssText = 'display: flex; border-bottom: 1px solid #ddd; margin-bottom: 10px;';
                    
                    // Ajouter les boutons
                    tabButtons.forEach((button, buttonIndex) => {
                        const newButton = document.createElement('button');
                        newButton.textContent = button.textContent || `Onglet ${buttonIndex + 1}`;
                        newButton.className = buttonIndex === 0 ? 'new-tab-button active' : 'new-tab-button';
                        newButton.setAttribute('data-tab-index', buttonIndex);
                        newButton.style.cssText = buttonIndex === 0 ? 
                            'padding: 10px 15px; border: 1px solid #ddd; background: white; cursor: pointer; border-bottom: none; margin-right: 5px;' :
                            'padding: 10px 15px; border: 1px solid #ddd; background: #f5f5f5; cursor: pointer; border-bottom: none; margin-right: 5px;';
                        
                        newButton.addEventListener('click', function() {
                            // Désactiver tous les boutons
                            newNav.querySelectorAll('.new-tab-button').forEach(btn => {
                                btn.className = 'new-tab-button';
                                btn.style.background = '#f5f5f5';
                            });
                            
                            // Activer ce bouton
                            this.className = 'new-tab-button active';
                            this.style.background = 'white';
                            
                            // Masquer tous les contenus
                            newContainer.querySelectorAll('.new-tab-content').forEach(content => {
                                content.style.display = 'none';
                            });
                            
                            // Afficher le contenu correspondant
                            const tabIndex = this.getAttribute('data-tab-index');
                            const targetContent = newContainer.querySelector(`.new-tab-content[data-tab-index="${tabIndex}"]`);
                            if (targetContent) {
                                targetContent.style.display = 'block';
                            }
                        });
                        
                        newNav.appendChild(newButton);
                    });
                    
                    // Ajouter la navigation au nouveau conteneur
                    newContainer.appendChild(newNav);
                    
                    // Ajouter les contenus
                    tabContents.forEach((content, contentIndex) => {
                        const newContent = document.createElement('div');
                        newContent.className = contentIndex === 0 ? 'new-tab-content active' : 'new-tab-content';
                        newContent.setAttribute('data-tab-index', contentIndex);
                        newContent.innerHTML = content.innerHTML;
                        newContent.style.cssText = contentIndex === 0 ?
                            'display: block; padding: 15px; border: 1px solid #ddd; border-top: none;' :
                            'display: none; padding: 15px; border: 1px solid #ddd; border-top: none;';
                        
                        newContainer.appendChild(newContent);
                    });
                    
                    // Remplacer l'ancien conteneur par le nouveau
                    container.parentNode.insertBefore(newContainer, container);
                    container.style.display = 'none';
                    
                    log(`Conteneur d'onglets #${index+1} reconstruit avec succès!`, false, true);
                });
            });
            
            // Inspecter les CSS appliqués
            document.getElementById('inspect-css').addEventListener('click', function() {
                log('Inspection des CSS appliqués aux onglets...', false);
                
                const cssInspector = document.getElementById('css-inspector');
                cssInspector.innerHTML = '<h3>Règles CSS applicables aux onglets</h3>';
                
                // Récupérer toutes les feuilles de style
                const allSheets = [...document.styleSheets];
                
                try {
                    allSheets.forEach((sheet, sheetIndex) => {
                        try {
                            const rules = [...sheet.cssRules];
                            rules.forEach(rule => {
                                if (rule.selectorText && (
                                    rule.selectorText.includes('tab-content') ||
                                    rule.selectorText.includes('tab-pane') ||
                                    rule.selectorText.includes('active')
                                )) {
                                    const div = document.createElement('div');
                                    div.className = 'css-rule';
                                    div.textContent = `${rule.selectorText} { ${rule.style.cssText} }`;
                                    cssInspector.appendChild(div);
                                }
                            });
                        } catch (e) {
                            // Certaines feuilles de style externes peuvent générer des erreurs CORS
                            const div = document.createElement('div');
                            div.className = 'css-rule error';
                            div.textContent = `Impossible d'accéder à la feuille de style #${sheetIndex} (Erreur CORS)`;
                            cssInspector.appendChild(div);
                        }
                    });
                } catch (e) {
                    const div = document.createElement('div');
                    div.className = 'css-rule error';
                    div.textContent = `Erreur lors de l'inspection CSS: ${e.message}`;
                    cssInspector.appendChild(div);
                }
                
                log('Inspection CSS terminée.', false, true);
            });
            
            // Simuler clear cache
            document.getElementById('clear-cache').addEventListener('click', function() {
                log('Simulation du vidage de cache...', false);
                
                // Ajout d'un paramètre unique à l'URL pour forcer le rechargement
                const timestamp = new Date().getTime();
                const url = new URL(window.location.href);
                url.searchParams.set('cache_buster', timestamp);
                
                log('La page va être rechargée dans 3 secondes...', false);
                setTimeout(() => {
                    window.location.href = url.toString();
                }, 3000);
            });
            
            // Initialiser les onglets de test
            const testButtons = document.querySelectorAll('.test-tab-button');
            testButtons.forEach(button => {
                button.addEventListener('click', function() {
                    // Désactiver tous les boutons et contenus
                    document.querySelectorAll('.test-tab-button').forEach(btn => btn.classList.remove('active'));
                    document.querySelectorAll('.test-tab-content').forEach(content => content.classList.remove('active'));
                    
                    // Activer ce bouton
                    this.classList.add('active');
                    
                    // Activer le contenu correspondant
                    const tabId = this.getAttribute('data-tab');
                    const tabContent = document.getElementById(tabId);
                    if (tabContent) {
                        tabContent.classList.add('active');
                    }
                });
            });
            
            log('Outil de diagnostic chargé. Cliquez sur "Analyser les onglets" pour commencer.', false, true);
        });
    </script>
</body>
</html>
