@echo off
echo Suppression des icônes PNG en double...

REM Suppression des fichiers PNG d'icônes dans tous les dossiers mipmap
del /q "android\app\src\main\res\mipmap-hdpi\ic_launcher.png" 2>nul
del /q "android\app\src\main\res\mipmap-mdpi\ic_launcher.png" 2>nul
del /q "android\app\src\main\res\mipmap-xhdpi\ic_launcher.png" 2>nul
del /q "android\app\src\main\res\mipmap-xxhdpi\ic_launcher.png" 2>nul
del /q "android\app\src\main\res\mipmap-xxxhdpi\ic_launcher.png" 2>nul

REM Suppression des fichiers foreground PNG aussi
del /q "android\app\src\main\res\mipmap-hdpi\ic_launcher_foreground.png" 2>nul
del /q "android\app\src\main\res\mipmap-mdpi\ic_launcher_foreground.png" 2>nul
del /q "android\app\src\main\res\mipmap-xhdpi\ic_launcher_foreground.png" 2>nul
del /q "android\app\src\main\res\mipmap-xxhdpi\ic_launcher_foreground.png" 2>nul
del /q "android\app\src\main\res\mipmap-xxxhdpi\ic_launcher_foreground.png" 2>nul

echo Icônes PNG supprimées ! Seuls les fichiers XML sont conservés.
echo Tentative de build APK...

C:\flutter\bin\flutter clean
C:\flutter\bin\flutter pub get
C:\flutter\bin\flutter build apk --release
