@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion
cd /d "%~dp0"
where yt-dlp >nul 2>nul
if errorlevel 1 (
  echo yt-dlp bulunamadi. Once kur.bat dosyasini calistir, sonra pencereyi kapatip tekrar dene.
  pause
  exit /b 1
)
set SARKI_SAYISI=20
set HATA=0
if exist _gecici rmdir /s /q _gecici
if exist hatalar.txt del hatalar.txt
for /f "usebackq eol=# delims=" %%a in ("sanatcilar.txt") do (
  set "q=%%a"
  set "q=!q: =+!"
  echo.
  echo === %%a ===
  yt-dlp --encoding utf-8 -i -x --audio-format mp3 --audio-quality 0 --embed-metadata --playlist-end %SARKI_SAYISI% --match-filter "duration<600" --sleep-interval 3 --max-sleep-interval 8 -P "home:MP3" -P "temp:%~dp0_gecici" -o "%%(artist,channel)s - %%(title)s.%%(ext)s" "https://music.youtube.com/search?q=!q!#songs" 2>>hatalar.txt
  if errorlevel 1 set /a HATA+=1
)
if exist _gecici rmdir /s /q _gecici
echo.
if !HATA! gtr 0 (
  echo DIKKAT: !HATA! sanatcida sorun oldu, bazi sarkilar inmemis olabilir.
  echo Bu dosyayi bir kez daha calistir. Ayrintilar hatalar.txt dosyasinda.
) else (
  del hatalar.txt
  echo Bitti. MP3 dosyalari bu klasordeki MP3 klasorunde.
)
pause
