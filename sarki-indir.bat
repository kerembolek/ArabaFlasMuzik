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
yt-dlp --encoding utf-8 -i -x --audio-format mp3 --audio-quality 0 --embed-metadata --no-playlist --default-search ytsearch1 -a sarkilar.txt -P "home:MP3" -P "temp:%~dp0_gecici" -o "%%(title)s.%%(ext)s" 2>>hatalar.txt
set KOD=%errorlevel%
if exist _gecici rmdir /s /q _gecici
echo.
if %KOD% gtr 0 (
  echo DIKKAT: Bazi sarkilar inmemis olabilir.
  echo Bu dosyayi bir kez daha calistir. Ayrintilar hatalar.txt dosyasinda.
) else (
  del hatalar.txt
  echo Bitti. MP3 dosyalari bu klasordeki MP3 klasorunde.
)
pause
