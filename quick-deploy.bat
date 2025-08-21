@echo off
echo === Test Rapide GitHub Pages ===
echo.

echo Copie de l'HTML temporaire vers index.html...
copy "web\temp-index.html" "web\index.html" /Y > nul

echo Commit et push...
git add web\index.html
git commit -m "✅ Deploy working HTML countdown - temporary fix"
git push origin main

echo.
echo ✅ Page temporaire déployée !
echo 🔗 https://ceryl-gitton.github.io/Reunited/
echo.
echo Cette version fonctionne avec JavaScript natif pendant
echo que nous résolvons les problèmes Flutter Web.

pause
