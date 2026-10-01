# AI Challenge — Minggu 5

Sumber: [Codelab penyimpanan lokal](https://jti-polinema.github.io/flutter-codelab/05-minggu-5-local-storage-offline-first/index.html).

## Rancangan prompt

Bandingkan SharedPreferences, Hive, SQLite melalui sqflite, dan Drift untuk preferensi tema serta koleksi catatan. Nilai query, relasi, reaktivitas, type safety, boilerplate, dan cara menguji. Jelaskan pilihan penyimpanan dan batas sinkronisasi demo.

## Perbandingan penyimpanan

| Pilihan | Query dan relasi | Reaktivitas/type safety | Boilerplate dan tes | Peran |
| --- | --- | --- | --- | --- |
| SharedPreferences | Key-value kecil, tanpa SQL | Nilai primitif; notifier untuk UI | Kecil, mock preference tersedia | Tema dan waktu dibuka |
| Hive | Penyimpanan objek/key-value, filter di Dart | Watch box; adapter untuk model | Adapter serta setup box uji | Alternatif cache objek |
| sqflite | SQL, indeks, join, transaksi | Map dikonversi ke model; invalidasi Riverpod | Skema/mapping ditulis sendiri, repository bisa diganti | Pilihan catatan dan cache post |
| Drift | SQL/query builder dan relasi | Query stream dan model bertipe | Code generation dan database uji | Alternatif ketika query reaktif lebih kompleks |

SQLite dipilih karena catatan memerlukan pengurutan tanggal, filter dirty, dan update baris. Preferensi kecil tetap di SharedPreferences. Tidak ada kebutuhan stream query yang cukup kuat untuk menambah code generation pada contoh ini.

## Skema yang diterapkan

`notes`: ID integer, title, body, updated_at (ISO-8601), dirty (0/1). Indeks `idx_notes_updated_at` dan `idx_notes_dirty` dibuat pada versi database 2; migrasi dari versi 1 menambahkan indeks. `cached_posts` menyimpan ID, payload JSON, dan waktu cache.

## Audit dan batas demo

Audit dengan bantuan AI pada 14 Oktober 2026 menambahkan edit catatan, menghubungkan halaman cache ke UI, menambahkan SQLite web, dan menjaga snapshot dirty saat simulasi sinkronisasi. Output AI awal tidak tersedia; dokumen ini tidak mengarang riwayat prompt/output sebelumnya.

- Android/iOS menggunakan sqflite. Web menggunakan SQLite/WASM dan IndexedDB melalui `sqflite_common_ffi_web`; aset worker/WASM disertakan.
- `syncNotes` hanya simulasi pengakuan server. Tidak ada upload catatan, backend, maupun penyelesaian konflik dua perangkat yang berjalan.
- Setelah delay simulasi, hanya baris dengan ID dan `updated_at` sama seperti snapshot awal yang dibersihkan. Edit atau catatan baru selama sync tetap dirty.
- Kebijakan konflik untuk backend lanjutan: Last-Write-Wins memakai timestamp server yang tepercaya; perlu aturan seri saat timestamp sama dan penanganan clock skew. Kebijakan ini belum diimplementasikan sebagai protokol remote.
- Penghapusan saat ini lokal; backend nyata memerlukan tombstone/outbox supaya delete dapat dikirim.
- Simulasi Mode Pesawat menahan refresh cache dan sync dalam aplikasi. Ini bukan bukti tombol mode pesawat perangkat OS diaktifkan.
- Cache post pertama perlu dibuka saat online; setelah tersimpan, halaman dapat membaca SQLite saat simulasi offline. UI mempertahankan cache bila refresh jaringan gagal.

## Verifikasi aktual

14 Oktober 2026: `flutter analyze` bersih dan 7 tes lulus: mapping, serialisasi dirty, provider sukses/gagal, sync online, sync offline, dan edit selama sync. Output lengkap dan hasil build: [validation.txt](validation.txt). Tes repository palsu tidak mengakses SQLite native; screenshot browser adalah bukti UI web, bukan hasil uji Android fisik.
