@echo off
chcp 65001 >nul
cd /d "%~dp0"
where ffprobe >nul 2>nul
if errorlevel 1 (
  echo ffprobe bulunamadi. Once kur.bat dosyasini calistir, sonra pencereyi kapatip tekrar dene.
  pause
  exit /b 1
)
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0flas-hazirla.ps1"
echo.
pause
