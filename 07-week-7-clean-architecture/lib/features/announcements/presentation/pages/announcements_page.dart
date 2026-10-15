import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/format.dart';
import '../../../../routes.dart';
import '../providers/announcements_providers.dart';

class AnnouncementsPage extends ConsumerWidget {
  const AnnouncementsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(announcementsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Announcements — TI-3F')),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('$e', textAlign: TextAlign.center),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () => ref.invalidate(announcementsProvider),
                child: const Text('Coba lagi'),
              ),
            ],
          ),
        ),
        data: (items) => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return Card(
              child: ListTile(
                leading: CircleAvatar(child: Text('#${item.id}')),
                title: Text(item.title),
                subtitle: Text(
                  '${formatShortDate(item.publishedAt)} · ${item.summary}',
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 1,
        onDestinationSelected: (idx) {
          if (idx == 0) context.go(AppRoutes.notes);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.note_alt_outlined),
            label: 'Notes',
          ),
          NavigationDestination(
            icon: Icon(Icons.campaign_outlined),
            label: 'Announcements',
          ),
        ],
      ),
    );
  }
}
