import 'package:go_router/go_router.dart';

import 'features/announcements/presentation/pages/announcements_page.dart';
import 'features/notes/presentation/pages/notes_page.dart';

class AppRoutes {
  static const String notes = '/';
  static const String announcements = '/announcements';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.notes,
  routes: [
    GoRoute(path: AppRoutes.notes, builder: (_, _) => const NotesPage()),
    GoRoute(
      path: AppRoutes.announcements,
      builder: (_, _) => const AnnouncementsPage(),
    ),
  ],
);
