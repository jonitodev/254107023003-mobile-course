# Verifikasi alur browser

Dijalankan pada 14 Oktober 2026 (Asia/Jakarta), menggunakan build Flutter web release, Chrome headless, dan viewport 430 × 900. Dashboard juga diuji pada 1200 × 800. Screenshot diambil langsung dari halaman aplikasi yang berjalan.

- Week 1: profil menampilkan nama, NIM, kelas, dan label mata kuliah.
- Week 2: dashboard satu kolom dan dua kolom, masing-masing dalam tema terang dan gelap; sakelar tema diklik melalui UI.
- Week 3: menambahkan tiga tugas, menandai satu selesai, lalu membuka statistik. Statistik menampilkan total 3, selesai 1, dan belum selesai 2.
- Week 4: daftar post dimuat dari JSONPlaceholder sungguhan; tab pagination menampilkan batch pertama dan tombol muat berikutnya. Pemeriksaan ini tidak memakai mock jaringan.
- Week 5: menyimpan dua catatan pada SQLite web, memuat bacaan online, mengaktifkan simulasi mode pesawat melalui pengaturan, membuka cache ketika offline, lalu mematikan simulasi dan menjalankan simulasi sinkronisasi. Antrean dirty berubah dari 2 menjadi 0. Tidak ada server sinkronisasi sungguhan.
- Week 6: login dengan akun contoh bawaan, menekan tombol simulasi 401/refresh, lalu membuka pengumuman #3 melalui deep link. Firebase/FCM tidak dikonfigurasi dan tidak diuji.
- Week 7: membuat dua catatan, memuat ulang halaman, memastikan judul catatan masih tampil, lalu membuka halaman announcements dengan data contoh.
- Week 8: screenshot ringkasan laporan HTML yang dibentuk dari tujuh log analyzer/test aktual. Ini bukan screenshot CI GitHub.

Hasil screenshot tersedia di README masing-masing minggu. Pemeriksaan browser ini melengkapi 41 unit/widget test dan tidak menggantikan pengujian perangkat Android, peer review, atau pengiriman notifikasi FCM.
