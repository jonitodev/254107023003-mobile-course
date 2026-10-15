import '../../../../core/failures.dart';
import '../../domain/entities/announcement.dart';
import '../../domain/repositories/announcement_repository.dart';
import '../models/announcement_model.dart';

class AnnouncementRepositoryImpl implements AnnouncementRepository {
  const AnnouncementRepositoryImpl();

  @override
  Future<({List<Announcement> items, Failure? failure})>
  fetchAnnouncements() async {
    try {
      final raw = <Map<String, Object?>>[
        {
          'id': '3',
          'title': 'Jadwal kuliah berubah',
          'summary':
              'Kelas Pemrograman Mobile TI-3F pindah ke Ruang A2 jam 13.00.',
          'published_at': '2026-09-27T08:00:00.000Z',
        },
        {
          'id': '7',
          'title': 'Review Clean Architecture Minggu 7',
          'summary':
              'Pastikan presentation dan domain steril sesuai dependency rule.',
          'published_at': '2026-09-28T08:00:00.000Z',
        },
      ];
      final items = raw
          .map((item) => AnnouncementModel.fromMap(item).toEntity())
          .toList();
      return (items: items, failure: null);
    } catch (e) {
      return (
        items: const <Announcement>[],
        failure: NetworkFailure('Gagal memuat pengumuman: $e'),
      );
    }
  }
}
