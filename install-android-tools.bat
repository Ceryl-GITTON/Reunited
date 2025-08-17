@echo off
echo ===================================
echo   INSTALLATION ANDROID TOOLS
echo ===================================
echo.

echo 📥 Étape 1: Télécharger Android Command Line Tools
echo Allez sur: https://developer.android.com/studio#command-line-tools-only
echo Téléchargez: commandlinetools-win-11076708_latest.zip
echo.

echo 📂 Étape 2: Créer le dossier cmdline-tools
mkdir "C:\Users\cgitton\AppData\Local\Android\sdk\cmdline-tools\latest" 2>nul

echo.
echo 📋 Étape 3: Extraire dans:
echo C:\Users\cgitton\AppData\Local\Android\sdk\cmdline-tools\latest\
echo.

echo 🔧 Étape 4: Une fois extrait, exécutez:
echo C:\flutter\bin\flutter doctor --android-licenses
echo.

echo ⚠️  Si le dossier n'existe pas, créez-le manuellement:
echo mkdir "C:\Users\cgitton\AppData\Local\Android\sdk\cmdline-tools\latest"
echo.

pause
