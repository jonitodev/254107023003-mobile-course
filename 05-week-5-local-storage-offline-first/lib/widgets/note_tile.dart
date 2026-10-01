import 'package:flutter/material.dart';

import '../data/local/note.dart';

class NoteTile extends StatelessWidget {
  const NoteTile({
    required this.note,
    required this.onTap,
    required this.onDelete,
    super.key,
  });

  final Note note;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        onTap: onTap,
        title: Text(note.title),
        subtitle: Text(
          note.body.isEmpty ? '(Tanpa isi)' : note.body,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (note.dirty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Belum tersinkron',
                  style: TextStyle(
                    fontSize: 11,
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
                ),
              )
            else
              const Icon(Icons.cloud_done_outlined, size: 18),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Hapus catatan',
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
