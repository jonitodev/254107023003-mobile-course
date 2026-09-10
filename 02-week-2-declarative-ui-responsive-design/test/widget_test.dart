import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_first_app/main.dart';

void main() {
  testWidgets('Dashboard satu kolom di layar sempit', (tester) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const DashboardApp());
    await tester.pumpAndSettle();

    final firstCard = tester.getRect(find.byType(Card).at(0));
    final secondCard = tester.getRect(find.byType(Card).at(1));

    expect(firstCard.width, lessThan(kWideBreakpoint));
    expect(secondCard.top, greaterThan(firstCard.bottom - 1));
  });

  testWidgets('Dashboard dua kolom di layar lebar', (tester) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const DashboardApp());
    await tester.pumpAndSettle();

    final firstCard = tester.getRect(find.byType(Card).at(0));
    final secondCard = tester.getRect(find.byType(Card).at(1));

    expect(firstCard.width, greaterThan(500));
    expect(secondCard.left, greaterThan(firstCard.right - 1));
  });

  testWidgets('menampilkan header profil dan empat kartu', (tester) async {
    await tester.pumpWidget(const DashboardApp());
    await tester.pumpAndSettle();

    expect(find.text('Academic Overview'), findsOneWidget);
    expect(find.text('Joni Yoga Kusuma'), findsOneWidget);
    expect(find.text('NIM 254107023003 · TI-3F'), findsOneWidget);
    expect(find.byType(InfoCard), findsNWidgets(4));
    expect(find.byType(ProfileHeader), findsOneWidget);
  });

  testWidgets('CupertinoSwitch mengganti tema terang dan gelap', (
    tester,
  ) async {
    await tester.pumpWidget(const DashboardApp());
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.light_mode), findsOneWidget);

    await tester.tap(find.byType(CupertinoSwitch));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.dark_mode), findsOneWidget);

    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(materialApp.themeMode, ThemeMode.dark);
  });
}
