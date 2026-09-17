# AI Challenge — Minggu 3

Sumber: [Codelab navigasi dan state](https://jti-polinema.github.io/flutter-codelab/03-minggu-3-navigation-state-management/index.html).

## Rancangan prompt

Buat halaman statistik tugas dengan Riverpod, tiga keadaan UI (memuat, gagal dengan retry, berhasil), simulasi delay 2 detik dan peluang gagal 30%. Hitung statistik dari daftar ToDo dan sediakan tes deterministik untuk hasil sukses serta error.

## Catatan asal-usul

Audit ini dilakukan dengan bantuan AI pada 14 Oktober 2026 terhadap kode yang sudah tersedia di workspace. Arsip percakapan dan output AI awal tidak tersedia; dokumen ini tidak mengklaim sebagai rekaman output awal atau bukti pengerjaan manual mahasiswa. Pemilik tugas perlu memahami dan mendemokan kode sesuai kebijakan codelab.

## Hasil audit dan perbaikan

- `TodoListNotifier` membuat list baru pada mutasi dan menggunakan ID stabil untuk aksi pada hasil filter.
- `StatsSimulationConfig` mengatur delay dan peluang gagal; runtime memakai 2 detik/30%, tes mengatur nol delay serta peluang 0 atau 1.
- Ketergantungan ToDo diamati di `build`; callback refresh memakai `read` sehingga statistik mengikuti data tugas.
- Retry halaman statistik memanggil `refresh`, mempertahankan urutan percobaan simulasi. Auto-retry Riverpod dinonaktifkan agar error dapat diperiksa pengguna.
- `TodoTile`, filter turunan, GoRouter dan NavigationBar terpisah sesuai refactoring challenge.

## Verifikasi aktual

14 Oktober 2026: `flutter analyze` bersih; 4 tes lulus (tambah tugas melalui widget, mutasi/filter, statistik sukses, statistik gagal); build web berhasil. Output: [validation.txt](validation.txt). Tes tidak membuktikan pengujian pada Android fisik. Screenshot web aktual tercantum dalam README.
