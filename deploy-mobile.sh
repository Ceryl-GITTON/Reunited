#!/bin/bash

# Reunited Countdown Mobile Deployment Script
# Déploie l'application mobile sur GitHub Pages

echo "🚀 DEPLOYMENT - Reunited Countdown Mobile"
echo "=========================================="

# Configuration
REPO_URL="https://github.com/Ceryl-GITTON/Reunited.git"
BUILD_DIR="build/mobile"
BRANCH="gh-pages"

# Vérification des prérequis
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter n'est pas installé ou introuvable"
    exit 1
fi

if ! command -v git &> /dev/null; then
    echo "❌ Git n'est pas installé ou introuvable"  
    exit 1
fi

# Nettoyage et préparation
echo "🧹 Nettoyage des builds précédents..."
rm -rf $BUILD_DIR

# Build de l'application
echo "🔨 Construction de l'application mobile..."
flutter build web \
    --target lib/simple_mobile_app.dart \
    --base-href /Reunited/mobile/ \
    --release

if [ $? -ne 0 ]; then
    echo "❌ Erreur lors de la construction"
    exit 1
fi

# Copie des fichiers personnalisés
echo "📂 Copie des assets personnalisés..."

# Copier mobile.html et manifest
cp web/mobile.html $BUILD_DIR/mobile.html
cp web/mobile-manifest.json $BUILD_DIR/manifest.json

# Copier les assets
cp -r assets $BUILD_DIR/

# Créer .nojekyll pour GitHub Pages
touch $BUILD_DIR/.nojekyll

# Créer index.html de redirection
cat > $BUILD_DIR/index.html << 'EOF'
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta http-equiv="refresh" content="0; url=mobile.html">
  <title>Reunited Countdown Mobile</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      text-align: center;
      padding: 50px;
      background: linear-gradient(135deg, #ff6b9d, #e91e63);
      color: white;
      margin: 0;
      min-height: 100vh;
      display: flex;
      justify-content: center;
      align-items: center;
    }
    .container {
      max-width: 400px;
    }
    h1 { margin-bottom: 20px; }
    p { margin-bottom: 30px; opacity: 0.9; }
    .btn {
      display: inline-block;
      padding: 15px 30px;
      background: white;
      color: #e91e63;
      text-decoration: none;
      border-radius: 25px;
      font-weight: bold;
      transition: transform 0.3s ease;
    }
    .btn:hover { transform: translateY(-3px); }
    .spinner {
      margin: 20px auto;
      width: 40px;
      height: 40px;
      border: 4px solid rgba(255,255,255,0.3);
      border-left: 4px solid white;
      border-radius: 50%;
      animation: spin 1s linear infinite;
    }
    @keyframes spin {
      0% { transform: rotate(0deg); }
      100% { transform: rotate(360deg); }
    }
  </style>
</head>
<body>
  <div class="container">
    <h1>📱 Reunited Countdown Mobile</h1>
    <p>Redirection en cours vers l'application...</p>
    <div class="spinner"></div>
    <a href="mobile.html" class="btn">🚀 Accéder à l'app</a>
  </div>
  <script>
    setTimeout(() => {
      window.location.href = 'mobile.html';
    }, 2000);
  </script>
</body>
</html>
EOF

# Déploiement sur GitHub Pages
echo "🌐 Déploiement sur GitHub Pages..."

# Initialiser le déploiement git
cd $BUILD_DIR
git init
git add .
git commit -m "🚀 Mobile app deployment - $(date)"

# Push vers la branche gh-pages
git remote add origin $REPO_URL
git push -f origin HEAD:$BRANCH

cd ../..

echo ""
echo "✅ Déploiement mobile terminé avec succès !"
echo ""
echo "📱 Application mobile disponible à :"
echo "🌐 https://ceryl-gitton.github.io/Reunited/mobile/"
echo ""
echo "🎉 L'application peut maintenant être installée sur mobile via PWA !"
echo ""

# Instructions post-déploiement
cat << 'EOF'
📋 Instructions d'installation mobile :

🤖 Android :
1. Ouvrir l'URL dans Chrome
2. Menu → "Ajouter à l'écran d'accueil"

🍎 iOS :
1. Ouvrir l'URL dans Safari  
2. Bouton Partager → "Sur l'écran d'accueil"

💻 Desktop :
1. Ouvrir l'URL dans Chrome/Edge
2. Cliquer sur l'icône "Installer" dans la barre d'adresse

✨ Features disponibles :
- Support multilingue (FR/EN/ID)
- 4 thèmes personnalisables
- Installation PWA
- Fonctionnement hors ligne
- Animations fluides

EOF
