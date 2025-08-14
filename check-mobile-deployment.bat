@echo off
echo ======================================
echo    VERIFICATION DEPLOIEMENT MOBILE
echo ======================================
echo.

echo 🔍 Vérification du déploiement GitHub Pages...
echo.

echo 🌐 Test de l'URL de l'application mobile...
echo https://ceryl-gitton.github.io/Reunited/mobile/
echo.

echo 📊 Vérification du statut GitHub Actions...
echo https://github.com/Ceryl-GITTON/Reunited/actions
echo.

echo ⏰ Le déploiement peut prendre 2-5 minutes...
echo.

REM Tentative d'ouverture de l'URL dans le navigateur par défaut
start https://ceryl-gitton.github.io/Reunited/mobile/

echo 📱 Si l'application ne s'ouvre pas encore :
echo    1. Attendez quelques minutes pour le déploiement
echo    2. Vérifiez GitHub Actions pour le statut
echo    3. Actualisez la page une fois déployée
echo.

echo 🎯 Une fois déployée, l'application sera accessible à :
echo 📱 Mobile : https://ceryl-gitton.github.io/Reunited/mobile/
echo 🖥️  Desktop : https://ceryl-gitton.github.io/Reunited/
echo.

pause
