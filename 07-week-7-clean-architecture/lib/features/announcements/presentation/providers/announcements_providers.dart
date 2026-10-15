import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../dependencies.dart';
import '../../domain/entities/announcement.dart';
import '../../domain/usecases/get_announcements.dart';

final getAnnouncementsProvider = Provider<GetAnnouncements>((ref) {
  return GetAnnouncements(ref.watch(announcementRepositoryProvider));
});

final announcementsProvider = FutureProvider<List<Announcement>>((ref) async {
  final result = await ref.watch(getAnnouncementsProvider).call();
  if (result.failure != null) {
    throw Exception(result.failure!.message);
  }
  return result.items;
}, retry: (retryCount, error) => null);
