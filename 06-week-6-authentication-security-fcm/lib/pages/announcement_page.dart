import 'package:flutter/material.dart';

class AnnouncementPage extends StatelessWidget {
  const AnnouncementPage({required this.id, super.key});

  final String id;

  @override
  Widget build(BuildContext context) {
    final details = switch (id) {
      '3' => (
        title: 'Jadwal kuliah berubah',
        body:
            'Kelas Pemrograman Mobile TI-3F pindah ke Ruang A2 jam 13.00 WIB.',
      ),
      '7' => (
        title: 'Pengumpulan Portfolio Minggu 8',
        body: 'Pastikan seluruh progres Minggu 1–8 telah diuji dengan flutter analyze & flutter test.',
      ),
      _ => (
        title: 'Pengumuman Kampus #$id',
        body:
            'Halaman ini dibuka melalui deep link notifikasi /pengumuman/$id.',
      ),
    };

    return Scaffold(
      appBar: AppBar(title: Text('Pengumuman #$id')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  details.title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text('Rute Deep Link: /pengumuman/$id'),
                const Divider(height: 24),
                Text(details.body),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
