@echo off
echo Reconstruction simple...
cd /d "c:\Dedou\Reunited"

echo Nettoyage...
if exist build rmdir /s /q build

echo Construction web...
flutter build web --base-href="/Reunited/"

echo Copie des fichiers...
PowerShell -Command "Copy-Item 'build\web\*' 'web\' -Recurse -Force"

echo Terminé !
pause
