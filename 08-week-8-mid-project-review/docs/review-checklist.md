# Checklist mid project review

Nama: Joni Yoga Kusuma · NIM: 254107023003 · Kelas: TI-3F

Status: audit awal AI tersedia; review sejawat belum dibuktikan. Bukti awal ada di [audit-baseline.md](audit-baseline.md).

## 1. Audit Git dan model branch

Snapshot awal hanya menunjukkan `main` dan `origin/main`, sehingga alur `feature/* → develop → main` belum terbukti dijalankan. Beberapa pesan commit awal seperti `progress` dan `coming soon` tidak menjelaskan perubahan. Working tree masih berisi pekerjaan tugas yang belum dikomit ketika audit dimulai.

Model yang dituju sesuai codelab:

```text
main        : rilis stabil; proteksi branch perlu dikonfigurasi di GitHub
develop     : integrasi dan target PR tugas
feature/*   : satu fitur kecil dari develop
fix/*       : satu bug, reproduksi, dan test
```

Ini adalah rencana, bukan pernyataan bahwa branch/protection tersebut sudah aktif. Mengunggah seluruh portofolio dalam commit mingguan juga tidak otomatis membuktikan latihan satu PR kecil per pasangan.

## 2. Simulasi perbaikan tiga pesan commit

Riwayat asli tidak ditulis ulang oleh audit ini.

- `e409056 progress` → `chore(portfolio): simpan progres awal portofolio`. Scope menjadi jelas; nama fitur yang lebih rinci perlu ditentukan setelah memeriksa diff commit.
- `ebf0464 coming soon` → `docs(portfolio): tandai materi yang belum dikerjakan`. Contoh ini harus dipastikan sesuai diff sebelum benar-benar digunakan.
- `4ad80e4 Remove accidental Colab notebook from the mobile course repo.` → `chore(repo): hapus notebook Colab yang tidak terkait`. Menambahkan tipe dan scope tanpa mengubah makna pesan asli.

Dua pesan pertama sengaja diberi catatan verifikasi karena pesan commit saja tidak cukup untuk menyimpulkan isi perubahan.

## 3. Perbaikan audit yang tersedia

- [x] Hilangkan status PR merged/approved yang tidak memiliki bukti.
- [x] Bedakan hasil audit AI dari keputusan reviewer sejawat.
- [x] Sediakan [template PR](../../.github/PULL_REQUEST_TEMPLATE.md) dan [template issue](../../.github/ISSUE_TEMPLATE/task.md).
- [x] Cakup tujuh aplikasi dalam [CI](../../.github/workflows/ci.yml).
- [x] Pin Flutter 3.47.2 dan verifikasi dependency lockfile dalam workflow.
- [x] Sediakan [evaluasi saran AI](ai-review-vs-keputusan.md), termasuk diagnosis yang ditolak.

## 4. Verifikasi mesin

Hasil akhir harus dibaca dari `docs/validation.txt` tiap aplikasi, ditautkan pada [README Minggu 8](../README.md). Pemeriksaan yang dimaksud:

```powershell
flutter pub get --enforce-lockfile
dart format --output=none --set-exit-if-changed lib test
flutter analyze --fatal-infos
flutter test --reporter expanded
```

Pemeriksaan arsitektur Minggu 7 mengikuti bukti di [README Minggu 7](../../07-week-7-clean-architecture/README.md). Domain harus bebas import Flutter, Dio, SQLite, dan layer data/presentation; presentation boleh memakai domain melalui dependency injection. Tidak ada klaim hasil grep atau jumlah test yang ditulis tanpa hasil pemeriksaan terkait.

## 5. Lembar review sejawat — belum diisi reviewer

Pasangan harus checkout branch dan menjalankan aplikasi/test sebelum mengisi lembar ini.

- Reviewer / tanggal:
- URL issue:
- URL PR dan target branch:
- Commit yang diperiksa:
- URL run CI:
- Temuan kebenaran 1 (observasi → dampak → usulan):
- Temuan kebenaran 2 (observasi → dampak → usulan):
- Temuan arsitektur (observasi → dampak → usulan):
- Temuan test (observasi → dampak → usulan):
- Saran keterbacaan (observasi → dampak → usulan):
- Commit tindak lanjut dan hasil uji ulang:
- Keputusan reviewer melalui GitHub: belum ada.
- URL merge dan issue yang tertutup: belum ada.

Jangan mengisi nama reviewer, approve, atau merge sampai peristiwa tersebut terjadi. Ketika menemukan bug fungsional, pelanggaran layer, atau test gagal, gunakan request changes dan minta pemeriksaan ulang setelah perbaikan.

## 6. Syarat eksternal yang masih terbuka

- [ ] Minimal satu issue nyata dan satu PR kecil ke `develop`.
- [ ] Review pasangan dengan komentar bermakna dan bukti menjalankan aplikasi.
- [ ] Tindak lanjut, review ulang, dan approval manusia.
- [ ] Merge PR, tautan issue yang tertutup, serta bukti run GitHub Actions.
- [ ] Verifikasi perilaku aplikasi tetap sesuai akhir Minggu 7 melalui demo.
- [ ] Refleksi pribadi setelah review sejawat berdasarkan kejadian nyata.

File checklist ini tidak memberikan approval. Status akhir mid review tetap menunggu bukti kolaborasi di atas.
