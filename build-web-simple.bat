@echo off
echo === Build Web Simple ===
cd /d c:\Dedou\Reunited

echo 1. Sauvegarde des fichiers actuels...
copy pubspec.yaml pubspec_backup.yaml
copy lib\main.dart lib\main_backup.dart

echo 2. Utilisation de la version web simple...
copy pubspec_minimal_web.yaml pubspec.yaml
copy lib\simple_web_main.dart lib\main.dart

echo 3. Nettoyage...
flutter clean

echo 4. Installation des dependances...
flutter pub get

echo 5. Build web...
flutter build web --web-renderer html --release

echo 6. Restauration des fichiers originaux...
copy pubspec_backup.yaml pubspec.yaml
copy lib\main_backup.dart lib\main.dart

echo 7. Verification du resultat...
if exist build\web\index.html (
    echo ✅ Build web reussi !
    echo 📁 Fichiers generes dans build\web\
) else (
    echo ❌ Echec du build web
)

echo === Termine ===
pause
