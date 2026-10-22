# Bukti awal audit Minggu 8

Audit dilakukan pada 14 Oktober 2026 (Asia/Jakarta), sebelum perubahan audit ini disimpan dalam commit. Ini adalah snapshot awal; riwayat dapat bertambah setelah proses publikasi.

## Riwayat dan branch yang diamati

Perintah: `git log --oneline -15`, `git branch -a`, dan `git status --short`.

HEAD awal: `4ad80e4f26d86e1d9b810b7efe60392be4373455`.

```text
4ad80e4 Remove accidental Colab notebook from the mobile course repo.
a3915ef Merge branch 'main' of https://github.com/jonitodev/254107023003-mobile-course
e409056 progress
a66befa Created using Colab
ebf0464 coming soon
0f4739c feat: week 1 Flutter profile app
b6c91a9 Initial commit
```

```text
* main
  remotes/origin/HEAD -> origin/main
  remotes/origin/main
```

Working tree memuat perubahan dan file belum terlacak dari pengerjaan tugas Minggu 1–8. Daftar lengkapnya berubah selama pengerjaan paralel, sehingga audit ini tidak mengklaim working tree bersih.

Tidak terlihat branch `develop` pada daftar branch lokal/remote-tracking di snapshot awal. Hasil ini tidak membuktikan konfigurasi protection di GitHub, identitas reviewer, atau adanya persetujuan. Tidak ada URL PR dan bukti review yang disertakan draf awal.

## Bukti masalah pada workflow awal

Isi relevan workflow sebelum perbaikan:

```yaml
defaults:
  run:
    working-directory: 07-week-7-clean-architecture
steps:
  - uses: subosito/flutter-action@v2
    with:
      channel: stable
```

Tidak ada matrix tujuh aplikasi dan tidak ada `flutter-version`. Karena itu, workflow awal hanya menjalankan perintah di Minggu 7 dan SDK dapat berubah mengikuti kanal stable.

## Bukti klaim yang tidak dapat dipertahankan

Draf awal README dan checklist menyatakan `#12` dan `#15` telah merged/approved serta reviewer telah memberi approve. Tidak ada URL issue, PR, review, atau run CI yang menyertai klaim tersebut. Angka `#12` juga dipakai sebagai contoh di codelab. Audit menghapus klaim ini, bukan menyimpulkan bahwa review sudah pernah dilakukan.

Draf awal juga memberi status analyze/test tersendiri untuk Minggu 8 meskipun folder ini tidak memiliki `pubspec.yaml`. Pemeriksaan mesin dijalankan terhadap tujuh aplikasi Minggu 1–7.

## SDK lokal

Output relevan `flutter --version --machine` pada awal audit:

```json
{
  "frameworkVersion": "3.47.2",
  "channel": "stable",
  "frameworkRevision": "d3b14c876900e553bc736ca19295fc09e3853e8e",
  "dartSdkVersion": "3.13.2"
}
```

Workflow yang diperbaiki menggunakan Flutter 3.47.2. `flutter pub get --enforce-lockfile` mencegah pemulihan dependency secara diam-diam mengubah versi dari lockfile yang disimpan.

## Batas bukti

Bukti ini berasal dari inspeksi file dan Git lokal. Pemeriksaan GitHub API tidak dijadikan bukti approval/merge. Log analyze/test terbaru disimpan terpisah di `docs/validation.txt` tiap aplikasi; status mesin tidak diturunkan dari teks README lama.
