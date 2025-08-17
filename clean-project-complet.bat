@echo off
echo =======================================================
echo NETTOYAGE COMPLET DU PROJET REUNITED
echo Suppression de tous les fichiers non essentiels...
echo =======================================================

REM Suppression des fichiers de build et scripts non essentiels
del /q "build-android-apk.bat" 2>nul
del /q "build-mobile.bat" 2>nul
del /q "build-widget-apk.bat" 2>nul
del /q "check-mobile-deployment.bat" 2>nul
del /q "deploy-github-mobile.bat" 2>nul
del /q "deploy-mobile.sh" 2>nul
del /q "deploy-widget-v1.1.bat" 2>nul
del /q "diagnostic-android.bat" 2>nul
del /q "install-android-studio.bat" 2>nul
del /q "install-android-tools.bat" 2>nul
del /q "install-cmdline-tools.bat" 2>nul
del /q "install-java.bat" 2>nul
del /q "test-after-android-studio.bat" 2>nul
del /q "test_package.bat" 2>nul
del /q "add-flutter-to-path.bat" 2>nul
del /q "create-release.bat" 2>nul

REM Suppression des fichiers de documentation non essentiels
del /q "DEPLOY_GITHUB.md" 2>nul
del /q "DEPLOY_MOBILE_SUCCESS.md" 2>nul
del /q "DEPLOY_PRIVATE.md" 2>nul
del /q "INSTALLATION_MOBILE.md" 2>nul
del /q "MOBILE_GUIDE.md" 2>nul
del /q "RELEASE_GUIDE.md" 2>nul
del /q "TEST_GUIDE.md" 2>nul

REM Suppression des fichiers volumineux inutiles
del /q "flutter_windows_stable.zip" 2>nul
del /q "reunited-countdown-widget-v1.0.apk" 2>nul

REM Suppression des fichiers iml (IntelliJ)
del /q "*.iml" 2>nul

REM Suppression des dossiers de test et web (non utilisés pour l'APK)
rmdir /s /q "test" 2>nul
rmdir /s /q "web" 2>nul
rmdir /s /q "ios" 2>nul

REM Nettoyage des caches et builds
rmdir /s /q "build" 2>nul
rmdir /s /q "android\.gradle" 2>nul
rmdir /s /q "android\.kotlin" 2>nul
rmdir /s /q "android\build" 2>nul
rmdir /s /q ".dart_tool" 2>nul

REM Suppression des dossiers IDE
rmdir /s /q ".idea" 2>nul
rmdir /s /q ".vscode" 2>nul

echo.
echo =======================================================
echo NETTOYAGE TERMINÉ !
echo.
echo FICHIERS CONSERVÉS :
echo ✓ lib\main.dart - Application principale
echo ✓ lib\widget_service.dart - Service de widget  
echo ✓ packages\reunited_countdown\ - Package de countdown
echo ✓ android\ - Configuration Android
echo ✓ assets\ - Ressources de l'app
echo ✓ pubspec.yaml - Configuration du projet
echo ✓ analysis_options.yaml - Options d'analyse
echo ✓ l10n.yaml - Configuration des localisations
echo ✓ README.md - Documentation
echo.
echo ÉTAPES SUIVANTES :
echo 1. flutter clean
echo 2. flutter pub get  
echo 3. flutter build apk --release
echo =======================================================
pause
