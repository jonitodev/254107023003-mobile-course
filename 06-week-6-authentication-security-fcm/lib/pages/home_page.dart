import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_provider.dart';
import '../routes.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final maskedTokenAsync = ref.watch(maskedAccessTokenProvider);
    final subscribed = ref.watch(topicSubscriptionProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Notify — TI-3F'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Keluar',
            onPressed: () => ref.read(authStateProvider.notifier).logout(),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Card(
            child: ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('Mode demo • Firebase belum dikonfigurasi'),
              subtitle: Text(
                'Login, refresh 401, topik, dan rute memakai data '
                'simulasi. Pengujian notifikasi FCM belum dilakukan.',
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.verified_user)),
              title: const Text('Joni Yoga Kusuma · NIM 254107023003 · TI-3F'),
              subtitle: Text(
                'Access Token (masked): ${maskedTokenAsync.value ?? "..."}',
              ),
              trailing: TextButton(
                onPressed: () async {
                  try {
                    await ref
                        .read(authStateProvider.notifier)
                        .rotateAccessToken();
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Simulasi 401 → refresh sekali → 200 OK'),
                      ),
                    );
                  } catch (_) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Sesi tidak valid, silakan masuk lagi.'),
                      ),
                    );
                  }
                },
                child: const Text('Simulasi 401 Refresh'),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: SwitchListTile(
              title: const Text('Simulasi topik: pengumuman-kampus'),
              subtitle: const Text(
                'Hanya status lokal; belum terhubung ke Firebase',
              ),
              value: subscribed,
              onChanged: (_) =>
                  ref.read(topicSubscriptionProvider.notifier).toggle(),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Contoh Pengumuman Kampus (Simulasi Deep Link)',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.campaign_outlined),
              title: const Text('Pengumuman #3: Jadwal kuliah berubah'),
              subtitle: const Text(
                'Payload FCM: {"route": "/pengumuman/3", "id": "3"}',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push(
                routeFromMessage(const {'route': '/pengumuman/3', 'id': '3'}),
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.school_outlined),
              title: const Text(
                'Pengumuman #7: Pengumpulan Portfolio Minggu 8',
              ),
              subtitle: const Text(
                'Payload FCM: {"route": "/pengumuman/7", "id": "7"}',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push(
                routeFromMessage(const {'route': 'pengumuman/7', 'id': '7'}),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
