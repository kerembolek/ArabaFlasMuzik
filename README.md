# Araba Flaş Müzik

Eski araba teypleri için müzik flaşı hazırlayan küçük bir Windows aracı. Şarkı ya da sanatçı adından MP3 indirir, tekrar edenleri eler, karıştırır ve teyplerin sorunsuz okuyacağı adlarla kopyalar.

Araç, [yt-dlp](https://github.com/yt-dlp/yt-dlp) ve [FFmpeg](https://ffmpeg.org/) üzerine yazılmış bir kullanım ve güvenlik katmanıdır. Bu programlar repoya dahil değildir, `kur.bat` onları resmi winget deposundan kurar.

## Kurulum

1. Bu sayfada yeşil **Code** butonuna, sonra **Download ZIP** seçeneğine tıkla.
2. Zip'i bir klasöre çıkar. Yedeklenen klasörlere, örneğin OneDrive'a koymamak iyi olur.
3. `kur.bat` dosyasına çift tıkla. Bitince pencereyi kapat.

Windows "bilinmeyen dosya" uyarısı verirse **Ek bilgi**, sonra **Yine de çalıştır** seçeneğini kullan. Her `.bat` dosyasını Not Defteri ile açıp ne yaptığını okuyabilirsin.

## Kullanım

| Ne istiyorsun | Dosyayı doldur | Çift tıkla | Sonuç |
|---|---|---|---|
| Belirli şarkılar | `sarkilar.txt` (`Sanatçı - Şarkı adı`) | `sarki-indir.bat` | `MP3` klasörü |
| Sanatçı başına 20 şarkı | `sanatcilar.txt` (sadece sanatçı adı) | `sanatci-indir.bat` | `MP3` klasörü |
| Uzun video veya tek link | `linkler.txt` | `link-indir.bat` | `UZUN` klasörü |
| Flaşa hazır karışık liste | Bir şey doldurmana gerek yok | `flas-hazirla.bat` | `KARISIK` klasörü |

Son olarak `KARISIK` içindeki dosyaları seçip flaşın ana dizinine kopyala.

Sanatçı başına şarkı sayısını değiştirmek için `sanatci-indir.bat` içindeki `SARKI_SAYISI=20` satırını düzenle.

## Neler yapıyor

- **Yarım dosya bırakmaz:** Şarkılar önce geçici klasörde hazırlanır, bitince taşınır. Pencere kapansa bile `MP3` klasörüne bozuk dosya düşmez.
- **Kaldığı yerden devam eder:** Tekrar çalıştırınca inmiş dosyaları atlar.
- **Hataları gizlemez:** Sorun olursa `Bitti` yerine uyarı verir, ayrıntıları `hatalar.txt` dosyasına yazar.
- **Sanatçı aramasını temiz tutar:** YouTube Music'in şarkı aramasını kullanır, 10 dakikadan uzun videoları eler.
- **Tekrarları eler:** `V2`, `Remix`, `Akustik` gibi sürümlerde normal olan kalır. `MP3` klasöründeki asıl dosyalar silinmez.
- **Dengeli karıştırır:** Aynı sanatçı mümkün olduğunca art arda gelmez.
- **Eski teyplere uygun ad verir:** `0001 - Baris Manco - Gulpembe.mp3` gibi numaralı ve düz harfli adlar kullanır.
- **Flaşı kontrol eder:** Dosya sistemini, boş yeri ve dosya sayısını raporlar.

## Eski teyp notları

- Flaş genelde FAT32 olmalı.
- Bazı teypler 32 GB'tan büyük flaşları ya da bir klasörde 255 dosyadan fazlasını görmez.
- Tamamını kopyalamadan önce birkaç şarkıyla deneyin.

## Sorumlu kullanım

Bu aracı yalnızca kullanım hakkına sahip olduğun içerikler için kullan. Telifli içeriği indirmek veya paylaşmak yasalara ve YouTube'un kullanım şartlarına aykırı olabilir, sorumluluk kullanıcıya aittir. Repoda müzik dosyası bulunmaz.

## Lisans

[MIT](LICENSE)
