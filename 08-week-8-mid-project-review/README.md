# Minggu 8 — Mid Project Review & Code Review

Nama: Joni Yoga Kusuma · NIM: 254107023003 · Kelas: TI-3F

Jadwal Minggu 8: **Kamis, 22 Oktober 2026**. Tanggal ini adalah urutan jadwal mingguan; waktu push GitHub tidak diubah oleh tanggal commit.

Sumber tugas: [Codelab Minggu 8](https://jti-polinema.github.io/flutter-codelab/08-minggu-8-mid-project-review-code-review/index.html).

## Tujuan dan hasil

Minggu 8 mereview aplikasi Minggu 5–7, terutama Clean Architecture Minggu 7. Folder ini berisi dokumentasi audit, evaluasi saran AI, dan bukti pemeriksaan. Tidak ada aplikasi Flutter kedelapan.

Hasil yang tersedia adalah audit riwayat Git, perbaikan dokumentasi agar sesuai bukti, template issue dan PR, serta workflow CI untuk tujuh aplikasi. **Tahap review sejawat dan merge PR yang disetujui reviewer manusia belum dibuktikan.** Dokumen ini bukan bukti bahwa seluruh syarat kelulusan mid review sudah selesai.

## Status paruh semester

- Minggu 1 — profil Flutter: [README, screenshot, dan cara menjalankan](../01-week-1-mobile-development-ecosystem-flutter-refresh/README.md).
- Minggu 2 — UI deklaratif dan responsif: [README dan hasil tampilan](../02-week-2-declarative-ui-responsive-design/README.md).
- Minggu 3 — navigasi dan state: [README dan bukti](../03-week-3-navigation-state-management/README.md).
- Minggu 4 — REST API: [README dan bukti](../04-week-4-networking-rest-api/README.md).
- Minggu 5 — penyimpanan lokal dan offline: [README dan bukti](../05-week-5-local-storage-offline-first/README.md).
- Minggu 6 — autentikasi dan notifikasi: [README, mode demo, serta batas verifikasi Firebase](../06-week-6-authentication-security-fcm/README.md).
- Minggu 7 — Clean Architecture: [README dan bukti layer/test](../07-week-7-clean-architecture/README.md).
- Minggu 8 — artefak audit tersedia; issue, PR, dan keputusan reviewer manusia harus ditautkan setelah benar-benar ada.

## Screenshot hasil pemeriksaan

![Ringkasan pemeriksaan lokal tujuh aplikasi](screenshots/validation-summary.png)

Screenshot ini menampilkan ringkasan pemeriksaan lokal berdasarkan log, bukan halaman GitHub Actions atau bukti persetujuan reviewer. Tanggal pemeriksaan tercantum pada ringkasan/log dan terpisah dari jadwal Minggu 8.

Hasil log pada 14 Oktober 2026: **tujuh aplikasi tanpa issue analyzer, 41 test lulus** (Minggu 1–7: 1, 4, 4, 7, 7, 11, 7). [Laporan HTML](docs/validation-report.html) dan [metadata beserta hash log](docs/validation-report.json) tersedia untuk ditelusuri. Laporan dapat dibuat ulang dari root repository dengan `node 08-week-8-mid-project-review/docs/generate-validation-report.cjs`.

Log sumber: [Minggu 1](../01-week-1-mobile-development-ecosystem-flutter-refresh/docs/validation.txt), [Minggu 2](../02-week-2-declarative-ui-responsive-design/docs/validation.txt), [Minggu 3](../03-week-3-navigation-state-management/docs/validation.txt), [Minggu 4](../04-week-4-networking-rest-api/docs/validation.txt), [Minggu 5](../05-week-5-local-storage-offline-first/docs/validation.txt), [Minggu 6](../06-week-6-authentication-security-fcm/docs/validation.txt), [Minggu 7](../07-week-7-clean-architecture/docs/validation.txt).

Pemeriksaan tambahan: [format ketujuh aplikasi](docs/format-validation.txt) dan [hasil uji alur browser](docs/browser-validation.md). Formatter berhasil tanpa perubahan tersisa setelah normalisasi source.

## Peta issue dan PR

Belum ada URL issue/PR dan bukti review manusia yang dapat dicantumkan untuk latihan ini. Nomor contoh `#12` dari codelab bukan bukti issue milik repository ini. Klaim lama tentang issue `#12`/`#15`, merge, dan approval telah dihapus karena tidak didukung tautan atau riwayat review.

Gunakan [template issue](../.github/ISSUE_TEMPLATE/task.md) dan [template PR](../.github/PULL_REQUEST_TEMPLATE.md) saat melakukan latihan kolaborasi. Setelah dijalankan, isi peta ini dengan URL issue, branch, URL PR ke `develop`, reviewer, keputusan review, commit perbaikan, dan URL merge yang nyata.

## Artefak dan stack

- [Audit Git, checklist, serta lembar review sejawat](docs/review-checklist.md).
- [Prompt dan output awal audit AI](docs/ai-review-initial.md).
- [Verifikasi saran AI dan keputusan teknis](docs/ai-review-vs-keputusan.md).
- [Bukti awal audit](docs/audit-baseline.md).
- [CI tujuh aplikasi](../.github/workflows/ci.yml): GitHub Actions, Flutter **3.47.2**, Dart **3.13.2**, dependency lockfile, formatter, analyzer, dan test.

Stack aplikasi yang direview: Flutter, Riverpod, GoRouter, Dio, SQLite, serta pemisahan presentation/domain/data. Detail fitur mengikuti README Minggu 5–7. Workflow yang tersedia akan dijalankan GitHub ketika dipicu; keberadaan file workflow saja tidak membuktikan CI remote sudah hijau atau branch protection aktif.

## Cara menjalankan ulang

Gunakan Flutter 3.47.2, lalu dari root repository:

```powershell
cd 07-week-7-clean-architecture
flutter pub get --enforce-lockfile
dart format --output=none --set-exit-if-changed lib test
flutter analyze --fatal-infos
flutter test --reporter expanded
flutter run -d chrome
```

Ulangi tiga pemeriksaan di masing-masing direktori Minggu 1–7. Minggu 8 tidak memiliki `pubspec.yaml`, sehingga tidak diberi status `flutter analyze` atau `flutter test` tersendiri.

## Refleksi

Approve yang bertanggung jawab perlu bukti checkout, pemeriksaan, dan uji perilaku. `LGTM` tanpa verifikasi tidak cukup. Bug fungsional, pelanggaran layer, dan kegagalan test memerlukan request changes; preferensi penamaan bisa berupa saran.

Audit ini memperbaiki dua masalah yang dapat dibuktikan: CI sebelumnya hanya memeriksa Minggu 7, dan dokumentasi menyatakan review/merge yang tidak memiliki bukti. Dugaan bahwa `AddNote` belum men-trim judul ditolak setelah membaca implementasi dan test yang sudah ada. Ini adalah hasil audit AI, bukan pengganti review sejawat. Refleksi pasca-review sejawat baru dapat ditulis setelah proses tersebut benar-benar dilakukan.
