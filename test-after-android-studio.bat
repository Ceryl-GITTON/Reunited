@echo off
echo ===================================
echo   TEST APRÈS ANDROID STUDIO
echo ===================================
echo.

echo 🔍 Test 1: Flutter Doctor
C:\flutter\bin\flutter doctor
echo.

echo 🔍 Test 2: Licences Android
C:\flutter\bin\flutter doctor --android-licenses
echo.

echo 🔍 Test 3: Build APK Debug
cd "c:\Dedou\Reunited"
C:\flutter\bin\flutter build apk --debug
echo.

echo ✅ Si tout passe, votre environnement est prêt !
pause
