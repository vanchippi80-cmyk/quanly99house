@echo off
cd /d "%~dp0"
echo === Deploy quanly99house ===
git add index.html
git commit -m "Update app"
git push origin main
echo.
echo === Hoan thanh! GitHub Pages se cap nhat trong 1-2 phut ===
pause
