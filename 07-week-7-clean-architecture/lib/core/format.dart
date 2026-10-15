/// Fungsi murni (pure Dart) untuk formatting tanggal dan parsing rute
/// agar dapat diuji tanpa ketergantungan pada widget Flutter.
String formatShortDate(DateTime date) {
  final y = date.year.toString().padLeft(4, '0');
  final m = date.month.toString().padLeft(2, '0');
  final d = date.day.toString().padLeft(2, '0');
  return '$y-$m-$d';
}

String normalizeRoute(String? rawRoute) {
  final trimmed = rawRoute?.trim() ?? '';
  if (trimmed.isEmpty) return '/';
  return trimmed.startsWith('/') ? trimmed : '/$trimmed';
}
