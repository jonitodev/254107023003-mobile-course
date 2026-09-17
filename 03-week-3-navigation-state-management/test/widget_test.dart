import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:week3_todo/main.dart';
import 'package:week3_todo/providers/stats_provider.dart';
import 'package:week3_todo/providers/todo_provider.dart';

void main() {
  testWidgets('menambah tugas baru', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));
    expect(find.text('Belum ada tugas'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Kerjakan PR minggu 3');
    await tester.tap(find.text('Tambah'));
    await tester.pump();

    expect(find.text('Kerjakan PR minggu 3'), findsOneWidget);
  });

  test('TodoListNotifier menambah, toggle, dan menghapus secara immutable', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final notifier = container.read(todoListProvider.notifier);
    notifier.add('Belajar GoRouter');
    notifier.add('Belajar Riverpod');

    expect(container.read(todoListProvider).length, 2);
    expect(container.read(filteredTodosProvider).length, 2);

    notifier.toggle(0);
    expect(container.read(todoListProvider).first.done, isTrue);

    container
        .read(todoFilterProvider.notifier)
        .setFilter(TodoFilter.pendingOnly);
    expect(container.read(filteredTodosProvider).length, 1);
    expect(
      container.read(filteredTodosProvider).first.title,
      'Belajar Riverpod',
    );

    notifier.remove(0);
    expect(container.read(todoListProvider).length, 1);
  });

  test(
    'StatsNotifier mengembalikan 3 item statistik pada state sukses',
    () async {
      final container = ProviderContainer(
        overrides: [
          statsSimulationConfigProvider.overrideWithValue(
            const StatsSimulationConfig(delay: Duration.zero, failureRate: 0.0),
          ),
        ],
      );
      addTearDown(container.dispose);

      container.read(todoListProvider.notifier).add('Tugas 1');
      final items = await container.read(statsProvider.future);

      expect(items.length, 3);
      expect(items.first.label, 'Total Tugas');
      expect(items.first.value, '1');
    },
  );

  test('StatsNotifier menghasilkan error saat simulasi gagal 100%', () async {
    final container = ProviderContainer(
      overrides: [
        statsSimulationConfigProvider.overrideWithValue(
          const StatsSimulationConfig(delay: Duration.zero, failureRate: 1.0),
        ),
      ],
    );
    addTearDown(container.dispose);

    await expectLater(
      container.read(statsProvider.future),
      throwsA(isA<Exception>()),
    );
  });
}
