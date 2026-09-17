import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'todo_provider.dart';

class StatItem {
  const StatItem({
    required this.label,
    required this.value,
    required this.subtitle,
  });

  final String label;
  final String value;
  final String subtitle;
}

/// Konfigurasi simulasi jaringan untuk StatsNotifier agar deterministik saat diuji.
class StatsSimulationConfig {
  const StatsSimulationConfig({
    this.delay = const Duration(seconds: 2),
    this.failureRate = 0.3,
    this.randomSeed = 42,
  });

  final Duration delay;
  final double failureRate;
  final int randomSeed;
}

final statsSimulationConfigProvider = Provider<StatsSimulationConfig>(
  (ref) => const StatsSimulationConfig(),
);

/// Notifier asinkron yang mensimulasikan pengambilan data statistik tugas.
class StatsNotifier extends AsyncNotifier<List<StatItem>> {
  int _attempt = 0;

  @override
  Future<List<StatItem>> build() async {
    return _fetchStats(ref.watch(todoListProvider));
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _fetchStats(ref.read(todoListProvider)),
    );
  }

  Future<List<StatItem>> _fetchStats(List<Todo> todos) async {
    final config = ref.read(statsSimulationConfigProvider);
    _attempt++;

    if (config.delay > Duration.zero) {
      await Future<void>.delayed(config.delay);
    }

    final rng = Random(config.randomSeed + _attempt);
    if (config.failureRate > 0 && rng.nextDouble() < config.failureRate) {
      throw Exception('Gagal memuat statistik dari server (simulasi 30%)');
    }

    final total = todos.length;
    final completed = todos.where((t) => t.done).length;
    final pending = total - completed;

    return [
      StatItem(
        label: 'Total Tugas',
        value: '$total',
        subtitle: 'Seluruh tugas terdaftar pada state Riverpod',
      ),
      StatItem(
        label: 'Tugas Selesai',
        value: '$completed',
        subtitle: 'Tugas yang sudah ditandai selesai',
      ),
      StatItem(
        label: 'Belum Selesai',
        value: '$pending',
        subtitle: 'Tugas aktif yang masih perlu dikerjakan',
      ),
    ];
  }
}

final statsProvider = AsyncNotifierProvider<StatsNotifier, List<StatItem>>(
  StatsNotifier.new,
  retry: (retryCount, error) => null,
);
