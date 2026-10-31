@echo off
chcp 65001 >nul
cd /d "%~dp0"
where yt-dlp >nul 2>nul
if errorlevel 1 (
  echo yt-dlp bulunamadi. Once kur.bat dosyasini calistir, sonra pencereyi kapatip tekrar dene.
  pause
  exit /b 1
)
if exist _gecici rmdir /s /q _gecici
if exist hatalar.txt del hatalar.txt
yt-dlp --encoding utf-8 -i -x --audio-format mp3 --audio-quality 0 --embed-metadata --no-playlist --trim-filenames 120 --sleep-interval 3 --max-sleep-interval 8 -a linkler.txt -P "home:UZUN" -P "temp:%~dp0_gecici" -o "%%(title)s.%%(ext)s" 2>>hatalar.txt
set KOD=%errorlevel%
if exist _gecici rmdir /s /q _gecici
echo.
if %KOD% gtr 0 (
  echo DIKKAT: Bazi videolar inmemis olabilir.
  echo Bu dosyayi bir kez daha calistir. Ayrintilar hatalar.txt dosyasinda.
) else (
  del hatalar.txt
  echo Bitti. Dosyalar bu klasordeki UZUN klasorunde.
)
pause
