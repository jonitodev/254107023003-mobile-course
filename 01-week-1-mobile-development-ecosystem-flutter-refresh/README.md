# Minggu 1 — Mobile Development Ecosystem & Flutter Refresh

Sumber: [Codelab Minggu 1](https://jti-polinema.github.io/flutter-codelab/01-minggu-1-mobile-development-ecosystem-flutter-refresh/index.html)

Tanggal commit portofolio: **Kamis, 3 September 2026**. Tanggal ini merupakan metadata jadwal mingguan, bukan bukti waktu push ke GitHub.

| | |
| --- | --- |
| Nama | Joni Yoga Kusuma |
| NIM | 254107023003 |
| Kelas | TI-3F |

## Tujuan

Menyiapkan environment Flutter, menjalankan aplikasi pertama, dan mengganti UI default menjadi **Profil Mahasiswa** sesuai praktikum Minggu 1.

## Fitur utama

- Halaman profil dengan ikon sekolah
- Nama, NIM, kelas TI-3F, dan label mata kuliah
- Widget dasar: `MaterialApp`, `Scaffold`, `AppBar`, `Center`, `Column`, `Icon`, `Text`

## Stack teknologi

- Flutter 3.47.2 (stable)
- Dart 3.13.2
- Material Design

## Cara menjalankan

```powershell
cd 01-week-1-mobile-development-ecosystem-flutter-refresh
flutter pub get
flutter test
flutter run
```

Pilih emulator Android atau perangkat fisik jika diminta. Untuk target web: `flutter run -d chrome`.

Tekan `r` untuk hot reload dan `R` untuk hot restart.

## Hasil

- Bukti setup yang sudah tersedia: [Flutter doctor](screenshots/ss.jpeg)
- Aplikasi profil mahasiswa berjalan
- Widget test lulus
- Screenshot browser dari aplikasi yang dijalankan ulang pada 14 Oktober 2026:

![Hasil aplikasi Profil Mahasiswa](screenshots/profil-mahasiswa.png)

![Bukti setup Flutter yang sudah tersedia](screenshots/ss.jpeg)

Log pemeriksaan aktual: [docs/validation.txt](docs/validation.txt).

## Kendala setup

Perintah `flutter` belum dikenali karena SDK belum terpasang, dan Android cmdline-tools belum ada sehingga lisensi SDK tidak bisa dicek. Flutter kemudian di-clone ke `C:\src\flutter`, PATH di-set, cmdline-tools dipasang, lalu `flutter doctor --android-licenses` dijalankan. Setelah itu Flutter dan Android toolchain sudah hijau.

Visual Studio (C++) tidak dipasang; itu hanya untuk target Windows desktop, bukan syarat target Android.

## Refleksi

- Native lebih tepat jika aplikasi membutuhkan akses API perangkat yang sangat spesifik, performa ketat, atau hanya menarget satu platform.
- UI Flutter bersifat deklaratif: widget tree menggambarkan state saat ini. Jika state berubah, Flutter membangun ulang bagian tree yang terkait.
- Commit kecil dengan pesan jelas memudahkan review, rollback, dan dokumentasi portfolio tiap minggu.

## Latihan Dart mandiri

Latihan `hitungLuasPersegiPanjang` dan class `Profil` merupakan bagian latihan mandiri pada codelab. Source latihan tersebut belum tersedia di repository; dokumentasi ini tidak mengklaim latihan mandiri sudah diverifikasi. Penyempurnaan repository dan verifikasi aplikasi dibantu AI.
