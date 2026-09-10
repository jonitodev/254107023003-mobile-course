# Refleksi Minggu 2

- UI deklaratif menggambarkan state; `isDark` berubah, Flutter membangun ulang tema dan ikon tanpa edit widget satu per satu.
- `Expanded` aman hanya di dalam `Row`/`Column` yang lebarnya sudah terbatas; tanpa batas, teks panjang memicu overflow.
- Breakpoint 700 dan `ColorScheme` mengubah pola baca (1 vs 2 kolom) serta kontras light/dark secara konsisten.
- Rekomendasi AI (`LayoutBuilder` + tinggi intrinsik) dicek ulang: responsif di bawah 600px, `Semantics` tetap ada, widget semuanya stable.
