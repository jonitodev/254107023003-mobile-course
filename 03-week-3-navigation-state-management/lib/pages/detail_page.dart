import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/todo_provider.dart';

class DetailPage extends ConsumerWidget {
  const DetailPage({required this.id, super.key});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todoListProvider);
    final todo = todos.where((item) => item.id == id).firstOrNull;

    return Scaffold(
      appBar: AppBar(title: Text('Detail $id')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Anda membuka item dengan id: $id',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            if (todo != null) ...[
              Card(
                child: ListTile(
                  leading: Icon(
                    todo.done
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                  ),
                  title: Text(todo.title),
                  subtitle: Text(
                    todo.done ? 'Status: Selesai' : 'Status: Belum selesai',
                  ),
                  trailing: FilledButton.tonal(
                    onPressed: () =>
                        ref.read(todoListProvider.notifier).toggleById(todo.id),
                    child: Text(todo.done ? 'Buka lagi' : 'Tandai selesai'),
                  ),
                ),
              ),
            ] else
              const Text('Item tidak ditemukan di daftar saat ini.'),
          ],
        ),
      ),
    );
  }
}
