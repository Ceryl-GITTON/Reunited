@echo off
echo ===================================
echo   AJOUTER FLUTTER AU PATH
echo ===================================
echo.

echo 🔧 MÉTHODE MANUELLE (Recommandée):
echo.
echo 1️⃣ Appuyer sur Win + R, taper: sysdm.cpl
echo 2️⃣ Cliquer: "Variables d'environnement..."
echo 3️⃣ Dans "Variables système", sélectionner "Path"
echo 4️⃣ Cliquer: "Modifier..."
echo 5️⃣ Cliquer: "Nouveau"
echo 6️⃣ Ajouter: C:\flutter\bin
echo 7️⃣ Cliquer: OK, OK, OK
echo 8️⃣ REDÉMARRER le terminal !
echo.

echo 🚀 MÉTHODE AUTOMATIQUE:
echo.
echo Ouvrir PowerShell en tant qu'administrateur et exécuter:
echo [Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\flutter\bin", "Machine")
echo.

echo 💡 APRÈS modification, ouvrir un NOUVEAU terminal et taper:
echo flutter doctor
echo (sans C:\flutter\bin\ devant)
echo.

pause
start sysdm.cpl
