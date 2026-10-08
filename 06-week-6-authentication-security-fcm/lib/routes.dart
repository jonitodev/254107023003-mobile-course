class AppRoutes {
  static const String home = '/';
  static const String login = '/login';
  static const String announcementPattern = '/pengumuman/:id';

  static String announcement(String id) => '/pengumuman/$id';
}

/// Fungsi murni untuk memetakan data payload FCM menjadi rute GoRouter.
String routeFromMessage(Map<String, dynamic> data) {
  final value = data['route'];
  final raw = value is String ? value.trim() : '';
  if (raw.isEmpty) return AppRoutes.home;
  final route = raw.startsWith('/') ? raw : '/$raw';
  return RegExp(r'^/pengumuman/[0-9]+$').hasMatch(route)
      ? route
      : AppRoutes.home;
}
