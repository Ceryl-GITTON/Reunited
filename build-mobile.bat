@echo off
echo ======================================
echo    REUNITED COUNTDOWN MOBILE DEPLOY
echo ======================================
echo.

REM Configuration
set PROJECT_DIR=%~dp0
set FLUTTER_BIN=C:\flutter\bin\flutter
set BUILD_DIR=%PROJECT_DIR%build\mobile
set WEB_DIR=%PROJECT_DIR%web

echo 📱 Nettoyage des builds précédents...
if exist "%BUILD_DIR%" (
    rmdir /s /q "%BUILD_DIR%"
)

echo 📦 Installation des dépendances Flutter...
cd /d "%PROJECT_DIR%"
%FLUTTER_BIN% pub get

if %ERRORLEVEL% neq 0 (
    echo ❌ Erreur lors de l'installation des dépendances
    pause
    exit /b 1
)

echo 🌐 Génération des localisations...
%FLUTTER_BIN% gen-l10n

if %ERRORLEVEL% neq 0 (
    echo ❌ Erreur lors de la génération des localisations
    pause
    exit /b 1
)

echo 🔨 Construction de l'application mobile...
%FLUTTER_BIN% build web --target lib/simple_mobile_app.dart --base-href /Reunited/mobile/ --release

if %ERRORLEVEL% neq 0 (
    echo ❌ Erreur lors de la construction
    pause
    exit /b 1
)

echo 📂 Copie des fichiers personnalisés...

REM Copier le fichier HTML mobile personnalisé
copy "%WEB_DIR%\mobile.html" "%BUILD_DIR%\mobile.html"

REM Copier le manifest mobile
copy "%WEB_DIR%\mobile-manifest.json" "%BUILD_DIR%\manifest.json"

REM Copier les assets
xcopy "%PROJECT_DIR%assets" "%BUILD_DIR%\assets\" /E /I /Y

REM Créer le fichier .nojekyll pour GitHub Pages
echo. > "%BUILD_DIR%\.nojekyll"

REM Créer une redirection d'index
echo ^<!DOCTYPE html^> > "%BUILD_DIR%\index.html"
echo ^<html^> >> "%BUILD_DIR%\index.html"
echo ^<head^> >> "%BUILD_DIR%\index.html"
echo   ^<meta charset="utf-8"^> >> "%BUILD_DIR%\index.html"
echo   ^<meta http-equiv="refresh" content="0; url=mobile.html"^> >> "%BUILD_DIR%\index.html"
echo   ^<title^>Redirecting to Reunited Countdown Mobile...^</title^> >> "%BUILD_DIR%\index.html"
echo ^</head^> >> "%BUILD_DIR%\index.html"
echo ^<body^> >> "%BUILD_DIR%\index.html"
echo   ^<p^>Redirecting to ^<a href="mobile.html"^>Reunited Countdown Mobile^</a^>...^</p^> >> "%BUILD_DIR%\index.html"
echo ^</body^> >> "%BUILD_DIR%\index.html"
echo ^</html^> >> "%BUILD_DIR%\index.html"

echo.
echo ✅ Build mobile terminé avec succès !
echo.
echo 📱 Application mobile prête dans : %BUILD_DIR%
echo 🌐 Pour déployer sur GitHub Pages :
echo    1. Copiez le contenu de build/mobile/ vers la branche gh-pages/mobile/
echo    2. Ou utilisez : git subtree push --prefix build/mobile origin gh-pages
echo.
echo 🚀 Pour tester localement :
echo    - Servez le dossier build/mobile/ avec un serveur HTTP
echo    - Ou ouvrez mobile.html dans un navigateur
echo.

REM Demander si l'utilisateur veut démarrer un serveur local
echo Voulez-vous démarrer un serveur local pour tester ? (o/n)
set /p choice=
if /i "%choice%"=="o" (
    echo 🌐 Démarrage du serveur local...
    cd /d "%BUILD_DIR%"
    start http://localhost:8080/mobile.html
    python -m http.server 8080 2>nul || (
        echo Python non trouvé, tentative avec PHP...
        php -S localhost:8080 2>nul || (
            echo Aucun serveur trouvé. Ouvrez manuellement mobile.html dans un navigateur.
        )
    )
) else (
    echo 👋 Build terminé ! Vous pouvez maintenant déployer l'application.
)

pause
