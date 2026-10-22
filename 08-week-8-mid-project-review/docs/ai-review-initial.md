# Prompt dan output awal audit AI

Tanggal audit: 14 Oktober 2026. Pelaksana audit awal: Codex (AI). Objek review adalah working tree dan dokumentasi, bukan PR yang telah direview pasangan.

## Ruang lingkup prompt audit sesi ini

```text
Audit dokumentasi Minggu 8 terhadap codelab Mid Project Review & Code Review.
Periksa klaim issue, PR, merge, approval, hasil mesin, dan implementasi yang dirujuk.
Periksa cakupan CI terhadap tujuh aplikasi Flutter dan kesesuaian SDK/lockfile.
Jangan membuat klaim peer approval atau PR eksternal yang tidak memiliki bukti.
Pisahkan fakta yang diamati, usulan, dan pekerjaan kolaborasi yang masih terbuka.
```

Ini mencatat ruang lingkup audit yang dikerjakan pada sesi ini, bukan mengaku menjalankan ulang percakapan review historis.

## Lima kandidat pemeriksaan

1. **Blocker dokumentasi — status review tanpa bukti.** Draf mengklaim issue `#12`/`#15` merged dan approved, tetapi tidak menyertakan URL/bukti reviewer. Usul: hapus status tersebut dan tulis tahapan peer review sebagai belum dibuktikan.
2. **Blocker cakupan CI — hanya Minggu 7 diuji.** `working-directory` bersifat tetap. Usul: matrix terpisah untuk tujuh aplikasi agar kegagalan satu aplikasi tidak menutupi hasil aplikasi lain.
3. **Saran reproduktibilitas — SDK bergerak.** `channel: stable` tanpa versi membolehkan SDK runner berubah. Usul: pin Flutter sesuai SDK penghasil lockfile dan gunakan pemulihan dependency yang memeriksa lockfile.
4. **Verifikasi ulang klaim lama tentang validasi judul.** Draf sebelumnya menyebut `AddNote` belum men-trim spasi. Jangan menambahkan patch hanya karena klaim ini; baca use case dan test terlebih dahulu. Jika `trim()` sudah ada, tolak diagnosis bug tersebut untuk versi saat ini.
5. **Saran bukti pengujian — klaim hijau perlu log.** README lama mengisi seluruh status lulus, termasuk Minggu 8 yang bukan aplikasi. Usul: tautkan output pemeriksaan nyata per aplikasi dan hilangkan status mesin untuk Minggu 8.

## Batas peran

Temuan ini adalah audit AI awal. Tidak ada keputusan reviewer sejawat, tanda tangan mahasiswa, hasil demo, atau approval manusia yang dibuat oleh AI. Evaluasi teknis dan tautan bukti ada di [verifikasi saran](ai-review-vs-keputusan.md).
