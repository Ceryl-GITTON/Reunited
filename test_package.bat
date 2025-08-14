@echo off
echo.
echo ========================================
echo    REUNITED COUNTDOWN PACKAGE TEST
echo ========================================
echo.

echo 1. Testing package dependencies...
cd /d "C:\Dedou\Reunited"
C:\flutter\bin\flutter pub get

echo.
echo 2. Running package tests...
C:\flutter\bin\flutter test

echo.
echo 3. Building test app...
C:\flutter\bin\flutter build web --dart-define=FLUTTER_WEB_USE_SKIA=true

echo.
echo 4. Running test app on web...
echo Starting Flutter web server...
start "" C:\flutter\bin\flutter run -d web-server --web-port=8080 lib/test_package_app.dart

echo.
echo ========================================
echo Tests completed! Check the web browser
echo at http://localhost:8080
echo ========================================
echo.
pause
