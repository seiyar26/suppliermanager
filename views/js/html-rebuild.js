/**
 * Script de reconstruction d'urgence HTML
 * Ce script va reconstruire complètement les onglets pour contourner tout problème CSS/JS
 */
document.addEventListener('DOMContentLoaded', function() {
    console.log('🔄 HTML Rebuild: Starting emergency tab reconstruction');
    
    // Fonction d'exécution différée pour s'assurer que tout le DOM est chargé
    function executeRebuild() {
        try {
            // 1. Identifier tous les conteneurs d'onglets
            const tabContainers = document.querySelectorAll('.tab-container');
            
            if (tabContainers.length === 0) {
                console.log('⚠️ No tab containers found. Nothing to rebuild.');
                return;
            }
            
            console.log(`🔍 Found ${tabContainers.length} tab container(s) to rebuild`);
            
            // 2. Traiter chaque conteneur d'onglets
            tabContainers.forEach((container, containerIndex) => {
                // Trouver la navigation et les contenus
                const tabNav = container.querySelector('.tab-nav');
                const allTabButtons = container.querySelectorAll('.tab-button');
                const allTabContents = container.querySelectorAll('.tab-content');
                
                console.log(`📋 Container #${containerIndex}: Found ${allTabButtons.length} buttons and ${allTabContents.length} content panels`);
                
                if (allTabButtons.length === 0 || allTabContents.length === 0) {
                    console.log(`⚠️ Container #${containerIndex}: Missing buttons or content panels. Skipping.`);
                    return;
                }
                
                // 3. Créer un nouveau conteneur avec une structure optimisée
                const newContainer = document.createElement('div');
                newContainer.className = 'rebuilt-tab-container';
                newContainer.style.cssText = 'width: 100%; display: block; visibility: visible; opacity: 1;';
                
                // 4. Créer une nouvelle navigation
                const newNav = document.createElement('div');
                newNav.className = 'rebuilt-tab-nav';
                newNav.style.cssText = 'display: flex; border-bottom: 1px solid #ddd; margin-bottom: 20px;';
                
                // 5. Ajouter les boutons d'onglets
                const buttonMap = [];
                
                allTabButtons.forEach((button, index) => {
                    const newButton = document.createElement('button');
                    newButton.textContent = button.textContent;
                    newButton.className = 'rebuilt-tab-button';
                    newButton.setAttribute('data-tab-index', index);
                    newButton.style.cssText = 'padding: 10px 15px; margin-right: 5px; border: none; background: #f4f4f4; cursor: pointer; border-radius: 4px 4px 0 0;';
                    
                    if (index === 0) {
                        newButton.style.background = '#007bff';
                        newButton.style.color = 'white';
                    }
                    
                    // Stocker la correspondance entre les boutons et leur contenu
                    const originalTabId = button.getAttribute('data-tab');
                    if (originalTabId) {
                        buttonMap.push({
                            buttonIndex: index,
                            contentId: originalTabId
                        });
                    }
                    
                    // Ajouter un événement clic
                    newButton.addEventListener('click', function() {
                        // Désactiver tous les boutons
                        const allNewButtons = newNav.querySelectorAll('.rebuilt-tab-button');
                        allNewButtons.forEach(btn => {
                            btn.style.background = '#f4f4f4';
                            btn.style.color = '#333';
                        });
                        
                        // Activer ce bouton
                        this.style.background = '#007bff';
                        this.style.color = 'white';
                        
                        // Masquer tous les contenus
                        const allNewContents = newContainer.querySelectorAll('.rebuilt-tab-content');
                        allNewContents.forEach(content => {
                            content.style.display = 'none';
                        });
                        
                        // Afficher le contenu correspondant
                        const targetIndex = parseInt(this.getAttribute('data-tab-index'));
                        const targetContent = newContainer.querySelector(`.rebuilt-tab-content[data-tab-index="${targetIndex}"]`);
                        if (targetContent) {
                            targetContent.style.display = 'block';
                        }
                    });
                    
                    newNav.appendChild(newButton);
                });
                
                // 6. Ajouter la navigation au nouveau conteneur
                newContainer.appendChild(newNav);
                
                // 7. Ajouter les contenus
                allTabContents.forEach((content, index) => {
                    const newContent = document.createElement('div');
                    newContent.className = 'rebuilt-tab-content';
                    newContent.setAttribute('data-tab-index', index);
                    newContent.style.cssText = 'padding: 15px; border: 1px solid #ddd; border-top: none; border-radius: 0 0 4px 4px;';
                    
                    // Masquer tous les contenus sauf le premier
                    if (index !== 0) {
                        newContent.style.display = 'none';
                    } else {
                        newContent.style.display = 'block';
                    }
                    
                    // Copier le contenu original
                    newContent.innerHTML = content.innerHTML;
                    
                    newContainer.appendChild(newContent);
                });
                
                // 8. Remplacer le conteneur original par notre version reconstruite
                container.parentNode.insertBefore(newContainer, container);
                container.style.display = 'none'; // Cacher l'original au lieu de le supprimer
                
                console.log(`✅ Container #${containerIndex}: Successfully rebuilt with ${allTabButtons.length} tabs`);
            });
            
            console.log('🎉 Tab HTML reconstruction complete!');
            
        } catch (error) {
            console.error('❌ Error during tab reconstruction:', error);
        }
    }
    
    // Exécuter maintenant et après un court délai pour s'assurer que tout est chargé
    executeRebuild();
    setTimeout(executeRebuild, 500);
});
