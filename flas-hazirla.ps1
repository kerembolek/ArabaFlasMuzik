# MP3 klasorunu eski arac teypleri icin hazirlar.
# Sira: dosya kontrolu, tekrar eleme, dengeli karistirma, numarali ve duz harfli kopya.
# Bu dosya ASCII kalmali: Windows PowerShell 5.1, BOM'suz UTF-8'i yanlis okur.
param(
  [string]$Kaynak = (Join-Path $PSScriptRoot 'MP3'),
  [string]$Hedef = (Join-Path $PSScriptRoot 'KARISIK')
)
$ErrorActionPreference = 'Stop'
[Console]::OutputEncoding = [Text.Encoding]::UTF8

# Turkce harfleri duz harfe cevirir. Regex'te -creplace sart: Turkce Windows'ta
# -replace buyuk I harfini kucuk dotless i sayar ve [A-Z] disinda birakir.
function ConvertTo-Duz([string]$Metin) {
  $s = $Metin.Replace([string][char]0x131, 'i').Normalize([Text.NormalizationForm]::FormD)
  -join ($s.ToCharArray() | Where-Object {
    [Globalization.CharUnicodeInfo]::GetUnicodeCategory($_) -ne 'NonSpacingMark' -and [int]$_ -ge 32 -and [int]$_ -lt 127
  })
}

function Get-DosyaAdi([string]$Metin) {
  $s = (ConvertTo-Duz $Metin) -creplace '[^A-Za-z0-9 ''().,&-]', ' ' -creplace '\s+', ' '
  $s = $s.Trim(' ', '-', '.', ',')
  if ($s.Length -gt 80) { $s = $s.Substring(0, 80).Trim(' ', '-', '.', ',') }
  $s
}

# Ayni sarkinin V2, Remix, Akustik gibi surumleri ayni anahtari alir.
function Get-SarkiAnahtari([string]$Baslik) {
  $s = (ConvertTo-Duz $Baslik).ToLowerInvariant()
  $s = $s -creplace '[\(\[\{].*?[\)\]\}]', ' '
  $s = $s -creplace '\b(v\d|versiyon\s*\d*|version\s*\d*|remix|live|canli|akustik|acoustic|enstrumantal|instrumental|remastered|remaster|official|audio|video|klip|lyrics)\b', ' '
  $s -creplace '[^a-z0-9]', ''
}

if (-not (Test-Path -LiteralPath $Kaynak)) { Write-Output "Kaynak klasor yok: $Kaynak"; exit 1 }
if (Test-Path -LiteralPath $Hedef) { Write-Output 'KARISIK klasoru zaten var. Yeniden olusturmak icin once onu sil.'; exit 1 }

$sarkilar = @()
$bozuk = @()
foreach ($f in (Get-ChildItem -LiteralPath $Kaynak -Filter *.mp3)) {
  $bilgi = ffprobe -v error -select_streams a:0 -show_entries stream=codec_name:format=duration -of csv=p=0 "$($f.FullName)" 2>$null
  $codec = ''; $sure = 0.0
  foreach ($satir in @($bilgi)) {
    $x = "$satir".Trim().TrimEnd(',')
    if ($x -cmatch '^[0-9.]+$') { $sure = [double]::Parse($x, [Globalization.CultureInfo]::InvariantCulture) }
    elseif ($x) { $codec = $x }
  }
  if ($codec -cne 'mp3' -or $sure -lt 30) { $bozuk += $f.Name; continue }
  $parca = $f.BaseName -split ' - ', 2
  if ($parca.Count -lt 2) { $parca = @('Bilinmiyor', $f.BaseName) }
  $sanatci = (ConvertTo-Duz (($parca[0] -split ',')[0].Trim())).ToLowerInvariant()
  $sarkilar += [pscustomobject]@{
    Dosya = $f; Sanatci = $sanatci; Uzunluk = $parca[1].Length
    Anahtar = "$sanatci|$(Get-SarkiAnahtari $parca[1])"
  }
}
Write-Output "Kontrol edilen: $($sarkilar.Count + $bozuk.Count)  bozuk: $($bozuk.Count)"
$bozuk | ForEach-Object { Write-Output "  BOZUK: $_" }
if (-not $sarkilar) { Write-Output 'Hazirlanacak sarki yok.'; exit 1 }

# Tekrarlarda en kisa adli, yani normal surum kalir.
$kalan = @()
$atilan = @()
foreach ($grup in ($sarkilar | Group-Object Anahtar)) {
  $sira = @($grup.Group | Sort-Object Uzunluk, { $_.Dosya.Name })
  $kalan += $sira[0]
  if ($sira.Count -gt 1) { $atilan += $sira[1..($sira.Count - 1)] }
}
Write-Output "Kalan: $($kalan.Count)  tekrar: $($atilan.Count)"
$atilan | ForEach-Object { Write-Output "  ELENDI: $($_.Dosya.Name)" }

# Her sanatcinin sarkilari listeye esit aralikla dagitilir.
$rastgele = New-Object Random
$konumlu = @()
foreach ($grup in ($kalan | Group-Object Sanatci)) {
  $sira = @($grup.Group | Sort-Object { $rastgele.Next() })
  $ofset = $rastgele.NextDouble()
  for ($i = 0; $i -lt $sira.Count; $i++) {
    $konumlu += [pscustomobject]@{ Sarki = $sira[$i]; Konum = ($i + $ofset + $rastgele.NextDouble() * 0.3) / $sira.Count }
  }
}
$liste = @($konumlu | Sort-Object Konum | ForEach-Object { $_.Sarki })
for ($i = 1; $i -lt $liste.Count - 1; $i++) {
  if ($liste[$i].Sanatci -ceq $liste[$i - 1].Sanatci) {
    for ($j = $i + 1; $j -lt $liste.Count; $j++) {
      if ($liste[$j].Sanatci -cne $liste[$i - 1].Sanatci) {
        $gecici = $liste[$i]; $liste[$i] = $liste[$j]; $liste[$j] = $gecici
        break
      }
    }
  }
}

# Teyp kopyalanma sirasina bakabilir, bu yuzden numara sirasiyla kopyalanir.
New-Item -ItemType Directory -Path $Hedef | Out-Null
$no = 0
foreach ($s in $liste) {
  $no++
  $ad = '{0:D4} - {1}.mp3' -f $no, (Get-DosyaAdi $s.Dosya.BaseName)
  Copy-Item -LiteralPath $s.Dosya.FullName -Destination (Join-Path $Hedef $ad)
}
$boyut = (Get-ChildItem -LiteralPath $Hedef -Filter *.mp3 | Measure-Object Length -Sum).Sum
Write-Output ("KARISIK hazir: {0} sarki, {1:N2} GB" -f $no, ($boyut / 1GB))
if ($no -gt 255) { Write-Output 'Not: Bazi eski teypler bir klasorde 255 dosyadan fazlasini gormez. Once arabada deneyin.' }

$flaslar = @(Get-Volume | Where-Object { $_.DriveType -eq 'Removable' -and $_.DriveLetter })
foreach ($v in $flaslar) {
  Write-Output ("Flas {0}: {1}, bos {2:N1} GB" -f $v.DriveLetter, $v.FileSystem, ($v.SizeRemaining / 1GB))
  if ($v.FileSystem -cne 'FAT32') { Write-Output '  DIKKAT: Eski teypler genelde sadece FAT32 okur.' }
  if ($v.SizeRemaining -lt $boyut) { Write-Output '  DIKKAT: Flasta yeterli bos yer yok.' }
}
if (-not $flaslar) { Write-Output 'Flas takili degil. Takinca KARISIK icindeki dosyalari flasin ana dizinine kopyala.' }
