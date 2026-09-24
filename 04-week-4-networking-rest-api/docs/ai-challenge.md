# AI Challenge — Minggu 4

Sumber: [Codelab networking](https://jti-polinema.github.io/flutter-codelab/04-minggu-4-networking-rest-api/index.html).

## Rancangan prompt

Rancang repository komentar JSONPlaceholder dengan model aman untuk field null/hilang, klien Dio terpusat, provider asinkron, pemetaan error ke pesan Indonesia, dan tes tanpa jaringan. Audit juga pagination dan kasus retry.

## Catatan asal-usul

Audit dengan bantuan AI dilakukan pada 14 Oktober 2026 terhadap kode yang tersedia. Arsip output AI awal tidak tersedia; daftar berikut merupakan temuan kode saat audit, bukan riwayat percakapan yang direkonstruksi.

## Hasil audit dan perbaikan

- Semua request UI melalui repository. `Dio` dan timeout terpusat; komentar memakai instance klien yang sama.
- Model memberi nilai default untuk field hilang/null. Cast numerik menerima `num`, termasuk double; tipe nonnumerik yang melanggar kontrak API tetap dapat memunculkan error.
- `friendlyErrorMessage` dibagikan oleh halaman daftar, detail, dan pagination.
- Komentar memakai `FutureProvider.autoDispose.family` untuk data per post yang hanya dibaca; ini pilihan implementasi berbeda dari contoh prompt `AsyncNotifierProvider`. Reload dilakukan dengan invalidasi provider.
- Perbaikan audit: request halaman pertama kini memiliki guard; request berikut tidak dimulai sebelum halaman pertama selesai. Kegagalan halaman berikut mempertahankan data dan menampilkan tombol retry.
- Tombol `Muat berikutnya` mendukung layar tinggi ketika 10 item belum cukup untuk menghasilkan scroll.

## Verifikasi aktual

14 Oktober 2026: `flutter analyze` bersih; 7 tes lulus; build web berhasil. Tes mencakup model, pemetaan error, provider sukses/gagal, request ganda, serta retry pagination tanpa kehilangan halaman lama. Output: [validation.txt](validation.txt). Screenshot UI memakai API publik; tes unit memakai repository palsu.
