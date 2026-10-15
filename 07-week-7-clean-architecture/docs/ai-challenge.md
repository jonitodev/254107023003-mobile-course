# Catatan bantuan AI — Minggu 7

Audit dan validasi otomatis: **14 Oktober 2026**.

## Konteks dan batas bukti

Implementasi awal pada sesi ini sudah mempunyai fitur notes dan announcements dalam tiga layer. Asisten diminta memeriksa implementasi terhadap codelab, memperbaiki celah, menjalankan validasi, dan menyiapkan hasil yang dapat difoto dari aplikasi berjalan.

Tidak ada rekaman prompt/output AI historis atau bukti evaluasi manual mahasiswa yang dapat diverifikasi. Catatan ini menjelaskan keputusan implementasi sesi ini. Bagian refleksi pribadi dan penilaian trade-off oleh mahasiswa belum diklaim selesai.

## Temuan dan perubahan sesi ini

- SQLite tidak memiliki konfigurasi web, sehingga halaman catatan tidak dapat dipakai untuk screenshot browser. `BrowserNoteRepository` ditambahkan sebagai adapter persisten lewat SharedPreferences, dengan interface domain yang sama. Implementasi SQLite tetap tersedia untuk Android/iOS.
- Provider presentation sebelumnya mengimpor implementasi data. Wiring konkret dipindahkan ke `dependencies.dart`, sedangkan provider state hanya memanggil use case.
- Dialog penambahan sekarang mencegah klik simpan ganda saat operasi berjalan dan melepas controller setelah dialog selesai.
- Dua test adapter membuktikan data dapat dibaca melalui instance repository baru serta data rusak tidak diam-diam ditimpa.

## Keputusan arsitektur

| Keputusan | Alasan dan biaya |
| --- | --- |
| Feature-first untuk notes dan announcements | Batas fitur mudah dibaca; jumlah folder bertambah |
| Interface repository dalam domain | Domain tidak mengetahui plugin storage dan mudah diuji dengan fake |
| `AddNote` sebagai use case | Validasi judul menjadi aturan bersama semua adapter |
| `GetNotes` dan `GetAnnouncements` tetap sederhana | Menunjukkan arah dependensi; belum perlu use case tambahan untuk setiap getter |
| Riverpod sebagai DI | Memakai dependensi yang sudah ada; tidak menambah generator/package DI |
| Adapter browser terpisah | Mendukung demo persisten tanpa memaksakan SQLite web; tidak ditujukan untuk data sensitif atau sinkronisasi multi-client |

## Bukti

Analyzer bersih dan 7 test lulus. Pemindaian presentation terhadap akses data mentah/import data dan domain/core terhadap framework menghasilkan 0 temuan; rincian ada di `validation.txt`. Build web berhasil. Screenshot berasal dari aplikasi browser. Pengujian SQLite pada Android/iOS dan kesetaraan seluruh fitur Minggu 5/6 tidak diklaim telah dilakukan.
