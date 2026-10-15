# Learning Journal — Minggu 7

Tanggal validasi: 14 Oktober 2026. Tanggal penugasan: Kamis, 15 Oktober 2026.

- Entity dan kontrak repository berada di domain; serialisasi serta detail storage berada di data.
- Composition root memilih SQLite pada mobile atau SharedPreferences pada browser tanpa mengubah use case.
- AddNote menyimpan aturan judul tidak kosong. Domain memakai hasil Dart Record dengan Failure eksplisit.
- Analyzer bersih, 7 test lulus, dan pemindaian dependensi tidak menemukan akses data langsung di presentation atau plugin di domain/core. Bukti berada di docs/validation.txt.
- Pengujian native SQLite dan evaluasi pribadi mahasiswa masih perlu dilakukan. Data pengumuman adalah fixture lokal.
