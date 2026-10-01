# Learning Journal — Minggu 5

- SharedPreferences menyimpan tema serta waktu kunjungan pengaturan terakhir melalui PrefsRepository.
- SQLite menyimpan catatan dan cache post; repository menangani tambah, baca, edit, hapus, dan snapshot dirty.
- Cache halaman bacaan ditampilkan lebih dahulu kemudian diperbarui saat online; mode offline simulasi menahan refresh.
- Simulasi sync tidak mengirim data ke backend. Hanya ID/timestamp yang sesuai snapshot yang boleh ditandai bersih, agar edit baru tidak hilang dari antrean.
- SQLite web memakai WASM/IndexedDB, native mobile memakai sqflite. Database versi 2 menambahkan indeks dan migrasi.
- Verifikasi 14 Oktober 2026: 7 tes lulus dan analyze bersih; log pada folder docs minggu ini.
