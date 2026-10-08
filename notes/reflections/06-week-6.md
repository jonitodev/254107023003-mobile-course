# Refleksi Minggu 6

Catatan teknis disusun dengan bantuan AI; bukan klaim pengujian manual mahasiswa.

- Refresh token berumur panjang disimpan lewat secure storage, dengan perlindungan yang bergantung pada platform. Token contoh pada aplikasi ini bukan kredensial nyata.
- Mengabaikan rotasi token FCM dapat membuat backend mengirim ke token lama.
- Topik sesuai untuk broadcast publik; pesan sensitif memerlukan tujuan perangkat dan otorisasi backend.
- Background isolate tidak berbagi variabel global dengan UI. Navigasi dilakukan saat klik notifikasi atau saat aplikasi menerima initial message.
- Login mock dan unit test sudah dapat dijalankan. Verifikasi Firebase pada foreground, background, terminated, serta pembaruan token backend tetap belum dilakukan.
