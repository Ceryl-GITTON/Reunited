@echo off
echo ======================================
echo    REUNITED MOBILE - DEPLOY TO GITHUB
echo ======================================
echo.

REM Configuration
set PROJECT_DIR=%~dp0
set MOBILE_DIR=%PROJECT_DIR%build\mobile

echo 📱 Vérification du build mobile...
if not exist "%MOBILE_DIR%" (
    echo ❌ Dossier mobile introuvable. Lancez d'abord build-mobile.bat
    pause
    exit /b 1
)

echo 🌐 Préparation du déploiement GitHub Pages...
cd /d "%PROJECT_DIR%"

echo 📦 Ajout des fichiers au Git...
git add .
git status

echo.
echo 📝 Commit des changements...
set /p commit_msg="Message de commit (appuyez sur Entrée pour utiliser le message par défaut): "
if "%commit_msg%"=="" set commit_msg=🚀 Mobile app deployment - %date% %time%

git commit -m "%commit_msg%"

echo.
echo 🚀 Push vers GitHub...
git push origin main

echo.
echo ✅ Déploiement initié !
echo.
echo 📱 L'application mobile sera disponible à :
echo 🌐 https://ceryl-gitton.github.io/Reunited/mobile/
echo.
echo ⏰ Le déploiement GitHub Actions prendra quelques minutes...
echo 📊 Vérifiez le statut sur : https://github.com/Ceryl-GITTON/Reunited/actions
echo.

pause
