@echo off
echo ===================================
echo   INSTALLATION COMMAND LINE TOOLS
echo ===================================
echo.

echo 📂 Création des dossiers nécessaires...
mkdir "C:\Users\cgitton\AppData\Local\Android\Sdk\cmdline-tools\latest" 2>nul

echo.
echo 📥 TÉLÉCHARGEMENT REQUIS:
echo 1. Aller sur: https://developer.android.com/studio#command-line-tools-only
echo 2. Télécharger: commandlinetools-win-11076708_latest.zip
echo 3. Extraire TOUT le contenu dans:
echo    C:\Users\cgitton\AppData\Local\Android\Sdk\cmdline-tools\latest\
echo.

echo 📋 STRUCTURE ATTENDUE:
echo C:\Users\cgitton\AppData\Local\Android\Sdk\cmdline-tools\latest\bin\
echo C:\Users\cgitton\AppData\Local\Android\Sdk\cmdline-tools\latest\lib\
echo etc...
echo.

echo 🚀 APRÈS EXTRACTION, exécuter:
echo set ANDROID_HOME=C:\Users\cgitton\AppData\Local\Android\Sdk
echo C:\flutter\bin\flutter doctor --android-licenses
echo.

start https://developer.android.com/studio#command-line-tools-only
pause
