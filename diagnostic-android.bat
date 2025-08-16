@echo off
echo ===================================
echo   DIAGNOSTIC FLUTTER ANDROID
echo ===================================
echo.

echo 🔍 Version Flutter:
C:\flutter\bin\flutter --version
echo.

echo 🔍 Doctor Flutter:
C:\flutter\bin\flutter doctor -v
echo.

echo 🔍 Configuration Android:
dir android\app\src\main\ /s /b
echo.

echo 📋 Analyse terminée. Vérifiez les erreurs ci-dessus.
pause
