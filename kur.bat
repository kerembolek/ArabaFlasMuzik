@echo off
chcp 65001 >nul
echo Araba Flas Muzik kurulumu basliyor.
echo yt-dlp, FFmpeg ve Deno resmi winget deposundan kurulacak.
echo.
where winget >nul 2>nul
if errorlevel 1 (
  echo winget bulunamadi. Windows 10 veya 11 gerekir.
  echo Microsoft Store'dan App Installer uygulamasini kurup bu dosyayi tekrar calistir.
  pause
  exit /b 1
)
winget install --id yt-dlp.yt-dlp --exact --source winget --accept-package-agreements --accept-source-agreements
echo.
where yt-dlp >nul 2>nul
if not errorlevel 1 (
  echo Kurulum tamam. Artik indirme dosyalarini calistirabilirsin.
  pause
  exit /b 0
)
if exist "%LOCALAPPDATA%\Microsoft\WinGet\Links\yt-dlp.exe" (
  echo Kurulum tamam. Bu pencereyi kapat, sonra indirme dosyalarini calistir.
  pause
  exit /b 0
)
echo Kurulum tamamlanamadi. Yukaridaki hatayi kontrol et, sonra tekrar dene.
pause
exit /b 1
