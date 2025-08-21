@echo off
echo === Test Build Web avec pubspec web ===
cd /d c:\Dedou\Reunited

echo Sauvegarde pubspec.yaml...
copy pubspec.yaml pubspec_mobile_backup.yaml

echo Utilisation pubspec_web.yaml...
copy pubspec_web.yaml pubspec.yaml

echo Nettoyage...
flutter clean

echo Recuperation dependances web...
flutter pub get

echo Build web...
flutter build web --web-renderer html --release

echo Restauration pubspec mobile...
copy pubspec_mobile_backup.yaml pubspec.yaml

echo Build termine !
pause
