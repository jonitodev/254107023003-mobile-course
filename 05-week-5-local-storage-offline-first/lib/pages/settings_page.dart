import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/prefs.dart';
import '../data/repositories/note_repository.dart';

final prefsRepositoryProvider = Provider<PrefsRepository>(
  (ref) => PrefsRepository(),
);

final darkModeProvider = AsyncNotifierProvider<DarkModeNotifier, bool>(
  DarkModeNotifier.new,
  retry: (retryCount, error) => null,
);

class DarkModeNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() => ref.watch(prefsRepositoryProvider).getDarkMode();

  Future<void> toggle() async {
    final next = !(state.value ?? false);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(prefsRepositoryProvider).setDarkMode(next);
      return next;
    });
  }
}

final lastOpenedProvider = FutureProvider<String?>((ref) async {
  final repo = ref.watch(prefsRepositoryProvider);
  final prev = await repo.getLastOpened();
  await repo.markOpenedNow();
  return prev;
});

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final darkAsync = ref.watch(darkModeProvider);
    final lastOpenedAsync = ref.watch(lastOpenedProvider);
    final forceOffline = ref.watch(forceOfflineProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan Preferensi')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: SwitchListTile(
              title: const Text('Mode Gelap (SharedPreferences)'),
              subtitle: const Text('Tersimpan lokal di perangkat'),
              value: darkAsync.value ?? false,
              onChanged: (_) => ref.read(darkModeProvider.notifier).toggle(),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: SwitchListTile(
              title: const Text('Simulasi Mode Pesawat'),
              subtitle: const Text(
                'Menahan sinkronisasi untuk menguji antrean dirty flag',
              ),
              value: forceOffline,
              onChanged: (val) =>
                  ref.read(forceOfflineProvider.notifier).setOffline(val),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.access_time),
              title: const Text('Terakhir dibuka'),
              subtitle: Text(lastOpenedAsync.value ?? 'Kunjungan pertama'),
            ),
          ),
        ],
      ),
    );
  }
}
