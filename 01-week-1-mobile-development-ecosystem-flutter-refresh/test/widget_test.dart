import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_first_app/main.dart';

void main() {
  testWidgets('menampilkan profil mahasiswa minggu 1', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byIcon(Icons.school), findsOneWidget);
    expect(find.text('Profil Mahasiswa'), findsOneWidget);
    expect(find.text('Joni Yoga Kusuma'), findsOneWidget);
    expect(find.text('NIM 254107023003'), findsOneWidget);
    expect(find.text('Kelas TI-3F'), findsOneWidget);
    expect(find.text('Pemrograman Mobile — Minggu 1'), findsOneWidget);
  });
}
