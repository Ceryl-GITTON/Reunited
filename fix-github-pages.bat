@echo off
echo 🔧 Fix rapide GitHub Pages
echo.

echo 📂 Navigation vers le dossier du projet...
cd /d "c:\Dedou\Reunited"

echo 🌐 Construction de l'application web...
flutter build web --base-href="/Reunited/" --web-renderer canvaskit

echo 📋 Ajout des fichiers...
git add .

echo 💾 Commit...
git commit -m "🌐 Quick fix GitHub Pages deployment"

echo 📤 Push...
git push origin main

echo ✅ Fait ! L'application devrait être disponible dans quelques minutes à :
echo https://ceryl-gitton.github.io/Reunited/
pause
