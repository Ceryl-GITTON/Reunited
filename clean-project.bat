@echo off
echo Nettoyage du projet Reunited - Suppression des fichiers non essentiels...

REM Suppression des fichiers d'applications alternatives
del /q "lib\mobile_app.dart" 2>nul
del /q "lib\widget_app.dart" 2>nul
del /q "lib\simple_main.dart" 2>nul
del /q "lib\simple_mobile_app.dart" 2>nul
del /q "lib\simple_test_app.dart" 2>nul
del /q "lib\main_backup.dart" 2>nul
del /q "lib\main_github.dart" 2>nul

REM Suppression des fichiers de test et démonstration
del /q "lib\package_test_screen.dart" 2>nul
del /q "lib\test_package_app.dart" 2>nul
del /q "package_demo.dart" 2>nul

REM Suppression du dossier test_app complet
rmdir /s /q "test_app" 2>nul

REM Nettoyage des caches de build
rmdir /s /q "android\.gradle" 2>nul
rmdir /s /q "android\.kotlin" 2>nul
rmdir /s /q "android\build" 2>nul
rmdir /s /q "build" 2>nul

REM Suppression des fichiers de log et temporaires
del /q "flutter_01.log" 2>nul
del /q "*.log" 2>nul

echo.
echo Nettoyage terminé !
echo Fichiers conservés :
echo - lib\main.dart (application principale)
echo - lib\widget_service.dart (service de widget)
echo - packages\reunited_countdown\ (package principal)
echo - Configuration Android et assets
echo.
echo Vous pouvez maintenant lancer : flutter clean && flutter pub get
pause
