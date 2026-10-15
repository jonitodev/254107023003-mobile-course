# Refleksi Minggu 7

Catatan teknis ini disusun dengan bantuan AI; bukan catatan penilaian manual mahasiswa.

- Interface repository di domain membatasi ketergantungan terhadap cara data disimpan.
- Entity Note dan Announcement tidak membutuhkan kode serialisasi; perubahan skema storage ditangani model pada layer data.
- AddNote dapat diuji dengan fake repository karena validasi tidak bergantung pada Flutter atau database.
- Adapter browser menunjukkan manfaat kontrak yang sama untuk storage berbeda. Biayanya adalah kode adapter dan pengujian tambahan.
- Riverpod sudah cukup untuk wiring implementasi ini. Menambah package DI atau banyak wrapper getter belum memberikan manfaat yang sepadan.
