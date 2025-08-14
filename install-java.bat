@echo off
echo ======================================
echo    INSTALLATION JAVA JDK 17
echo ======================================
echo.

REM Créer le dossier Java
if not exist "C:\Java" mkdir "C:\Java"

echo Téléchargement d'OpenJDK 17...
echo Veuillez télécharger OpenJDK 17 depuis:
echo https://download.java.net/java/GA/jdk17.0.2/dfd4a8d0985749f896bed50d7138ee7f/8/GPL/openjdk-17.0.2_windows-x64_bin.zip
echo.
echo Puis extraire dans C:\Java\jdk-17.0.2
echo.

echo Configuration des variables d'environnement...
setx JAVA_HOME "C:\Java\jdk-17.0.2"
setx PATH "%PATH%;C:\Java\jdk-17.0.2\bin"

echo.
echo Redémarrez votre terminal pour que les changements prennent effet.
echo.
pause
