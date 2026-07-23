@echo off
cd /d "C:\Users\anhtv\OneDrive\Documents\GitHub\quanly99house"

:: Tim git tu GitHub Desktop
set GIT=""
for /f "delims=" %%i in ('where git 2^>nul') do set GIT="%%i" & goto :found
for /f "delims=" %%i in ('dir /b /s "C:\Users\anhtv\AppData\Local\GitHubDesktop\app-*\resources\app\git\cmd\git.exe" 2^>nul') do set GIT="%%i" & goto :found
for /f "delims=" %%i in ('dir /b /s "C:\Program Files\Git\cmd\git.exe" 2^>nul') do set GIT="%%i" & goto :found

:found
if %GIT%=="" (
  echo KHONG TIM THAY GIT. Vui long cai Git hoac dung GitHub Desktop.
  pause
  exit /b 1
)

echo Tim thay git: %GIT%
echo.
%GIT% add index.html
%GIT% commit -m "Update app"
%GIT% push origin main
echo.
echo === Hoan thanh! GitHub Pages cap nhat sau 1-2 phut ===
pause
