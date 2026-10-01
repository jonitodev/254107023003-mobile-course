# Refleksi — Minggu 5

SharedPreferences tidak menyediakan query relasional dan update per baris yang dibutuhkan koleksi catatan; SQLite lebih sesuai. Cache-first memungkinkan membaca data tersimpan saat koneksi gagal. Dirty flag menunjukkan perubahan yang menunggu pengakuan; sinkronisasi perlu memakai snapshot agar perubahan yang dibuat selama request tetap tertunda.

Demo ini menggunakan pengakuan server simulasi, belum upload ataupun penyelesaian konflik lintas perangkat. Last-Write-Wins adalah rancangan lanjutan yang membutuhkan timestamp tepercaya. Penghapusan remote memerlukan tombstone/outbox, karena delete lokal tidak meninggalkan data untuk dikirim. Injeksi repository membuat tes provider dapat berjalan tanpa SQLite perangkat.
