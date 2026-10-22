# Verifikasi saran AI dan keputusan teknis

Nama: Joni Yoga Kusuma · NIM: 254107023003 · Kelas: TI-3F

Lihat [prompt/output awal audit](ai-review-initial.md) dan [snapshot bukti sebelum perbaikan](audit-baseline.md). Keputusan di bawah adalah disposisi teknis audit AI pada working tree. Mahasiswa tetap perlu memahami dan mempertanggungjawabkan perubahan, dan reviewer sejawat tetap perlu memberi keputusan sendiri.

## 1. Klaim merged/approved — diterima untuk diperbaiki

**Observasi:** README lama mencantumkan `#12` dan `#15` sebagai merged/approved. Checklist menulis keputusan reviewer Approve tanpa tautan review.

**Bukti:** Isi awal tersebut dicatat di [audit-baseline.md](audit-baseline.md). Riwayat dan daftar branch lokal tidak menyediakan bukti review manusia untuk klaim itu.

**Dampak:** Pembaca dapat salah menganggap syarat kolaborasi sudah terpenuhi.

**Tindak lanjut:** Hapus klaim, jelaskan status yang belum dibuktikan, dan sediakan template issue/PR serta lembar review kosong. Jangan mengubah contoh codelab menjadi riwayat repository.

## 2. CI hanya mencakup Minggu 7 — diterima dan diperbaiki

**Observasi:** Workflow awal menggunakan `working-directory: 07-week-7-clean-architecture` tanpa matrix.

**Bukti:** Potongan workflow awal tersimpan dalam [audit-baseline.md](audit-baseline.md).

**Dampak:** Perubahan yang merusak Minggu 1–6 tidak dideteksi workflow tersebut.

**Tindak lanjut:** [Workflow saat ini](../../.github/workflows/ci.yml) memiliki tujuh direktori dalam matrix. Setiap job memulihkan dependency, memeriksa format, menjalankan analyzer dan test. `fail-fast: false` membuat hasil tiap aplikasi tetap terlihat.

## 3. Flutter stable tanpa versi — diterima dan diperbaiki

**Observasi:** Workflow awal hanya menentukan kanal stable.

**Bukti:** SDK lokal adalah Flutter 3.47.2 / Dart 3.13.2; lihat snapshot SDK. Pubspec dan lockfile aplikasi menggunakan Dart 3.13.2.

**Dampak:** Runner yang memilih versi stable lain dapat memberi hasil berbeda dari pengujian lokal.

**Tindak lanjut:** Pin Flutter `3.47.2`, simpan lockfile aplikasi, dan jalankan `flutter pub get --enforce-lockfile`. Ini membatasi perubahan dependency; tidak berarti semua faktor lingkungan identik.

## 4. Dugaan AddNote belum melakukan trim — ditolak untuk versi saat ini

**Observasi kandidat:** Draf lama menyebut bug spasi pada judul seolah belum ditangani sebelum review.

**Verifikasi:** [Use case AddNote](../../07-week-7-clean-architecture/lib/features/notes/domain/usecases/add_note.dart) sudah memiliki `final normalizedTitle = title.trim();`, pemeriksaan `normalizedTitle.isEmpty`, serta `body.trim()`. [Test validasi](../../07-week-7-clean-architecture/test/validate_note_test.dart) sudah memuat judul berisi spasi dan judul valid dengan spasi di tepi.

**Keputusan:** Tolak diagnosis bahwa bug itu masih ada pada snapshot yang direview. Tidak ada patch trim baru yang dapat diklaim sebagai hasil review sesi ini. Dokumen lama bukan bukti bahwa test pernah gagal.

**Alasan arsitektur:** Pesan UI tetap ditangani presentation. Memasukkan `BuildContext` atau `ScaffoldMessenger` ke use case tidak diperlukan dan akan merusak pemisahan domain. Ini alasan desain, bukan klaim bahwa reviewer manusia pernah memberi usulan tersebut.

## 5. Bukti hijau harus berasal dari output — diterima

**Observasi:** Draf lama menulis lulus untuk seluruh minggu dan menganggap Minggu 8 sebagai aplikasi.

**Tindak lanjut:** README Minggu 8 menautkan log `docs/validation.txt` dari setiap aplikasi dan screenshot ringkasan yang bersumber dari log tersebut. Minggu 8 hanya memuat hasil audit. Lihat log terbaru untuk status format/analyze/test; jangan menganggap adanya file workflow sebagai bukti run CI remote berhasil.

## Kesimpulan verifikasi

Dua masalah yang terbukti secara langsung adalah dokumentasi review tanpa bukti dan cakupan CI yang hanya memeriksa satu aplikasi. Satu diagnosis bug lama ditolak berdasarkan kode yang sudah ada. Bukti ini memenuhi latihan evaluasi kritis terhadap saran AI; proses review sejawat dan merge yang disyaratkan codelab masih harus dilakukan secara nyata.
