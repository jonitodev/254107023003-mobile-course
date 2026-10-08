# Learning Journal — Minggu 6

Tanggal validasi: 14 Oktober 2026. Tanggal penugasan: Kamis, 8 Oktober 2026.

- Implementasi menggunakan login dan token simulasi sesuai model mock codelab.
- Interceptor diuji menggunakan transport lokal: 401 memperbarui token sekali; 401 kedua atau refresh gagal menghapus sesi. Kegagalan server setelah retry tidak menghapus sesi yang valid.
- Route guard mempertahankan tujuan pengumuman setelah login. Payload asing ditolak.
- FCM masih berupa scaffold. Izin, token perangkat, token refresh ke backend, dan tiga state notifikasi belum diuji; screenshot browser tidak membuktikan pengiriman push.
