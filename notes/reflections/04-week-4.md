# Refleksi — Minggu 4

Repository membuat UI dapat diuji tanpa jaringan. Pagination server membatasi jumlah data setiap request, tetapi guard harus berlaku sejak request halaman pertama. Error halaman lanjut harus mempertahankan data lama dan memberi retry pada halaman yang sama. AsyncNotifier menangkap exception build menjadi AsyncError; aksi manual menangani error secara eksplisit. Audit AI 14 Oktober 2026 menambahkan guard serta tes retry; arsip output AI awal tidak tersedia.
