# Catatan bantuan AI — Minggu 6

Audit implementasi dan validasi otomatis: **14 Oktober 2026**.

## Konteks yang dapat dibuktikan

Implementasi awal yang tersedia pada sesi ini sudah berisi login mock, TokenStore, Dio, router, dan scaffold FCM. Tugas sesi ini adalah memeriksa kesesuaian dengan codelab, memperbaiki bug, menjalankan validasi, dan menyiapkan screenshot aplikasi. Pengguna menyetujui mode demo serta pencatatan bahwa pengujian Firebase belum dilakukan.

Tidak tersedia rekaman prompt/output AI historis maupun bukti perbaikan manual mahasiswa. Dokumen ini mencatat perubahan oleh asisten pada sesi ini; evaluasi pribadi dan demonstrasi perangkat oleh mahasiswa masih perlu dilakukan.

## Temuan yang diperbaiki

1. Interceptor awal mengulang setiap 401 tanpa penanda sehingga retry dapat berulang tanpa batas. `authRetried` sekarang membatasi retry; kegagalan autentikasi membersihkan token dan memberitahu state sesi.
2. Tombol refresh awal langsung mengganti token. Sekarang tombol melewati interceptor dengan `DemoApiAdapter` yang menghasilkan 401 dan respons sukses secara lokal. Unit test memeriksa jumlah request dan header token baru.
3. Router sebelumnya dibuat ulang saat state auth berubah. Router kini tetap hidup dan me-refresh redirect; tujuan pengumuman dipertahankan saat login.
4. Parsing route sebelumnya menerima sembarang string dan dapat melempar pada nilai non-string. Sekarang hanya rute pengumuman numerik yang diterima.
5. Background handler sebelumnya menulis variabel global seolah dapat membagikannya dengan UI isolate. Penulisan itu dihapus; navigasi perlu ditangani lewat event klik/initial message.
6. README awal menyatakan tiga state push berhasil tanpa bukti. Klaim tersebut diganti **belum diuji**, dan UI menandai seluruh demo secara eksplisit.

## Bukti dan pekerjaan lanjutan

- Analyzer bersih; 11 test lulus, output di `validation.txt`.
- Screenshot browser membuktikan login mock, sesi, dan halaman pengumuman.
- Firebase Console, token perangkat, subscription topik nyata, registrasi `POST /devices`, dan banner pada tiga app state **belum diuji**.
- Sebelum demo perangkat: inisialisasikan Firebase, panggil scaffold setelah router siap, kelola listener dan lifecycle, pasang konfigurasi platform, lalu isi matriks hasil dari pengamatan nyata.
