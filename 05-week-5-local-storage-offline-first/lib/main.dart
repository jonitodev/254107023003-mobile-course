import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'pages/note_detail_page.dart';
import 'pages/notes_page.dart';
import 'pages/settings_page.dart';
import 'pages/cached_posts_page.dart';

void main() => runApp(const ProviderScope(child: MyApp()));

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/cache',
      builder: (context, state) => const CachedPostsPage(),
    ),
    GoRoute(path: '/', builder: (context, state) => const NotesPage()),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsPage(),
    ),
    GoRoute(
      path: '/note/:id',
      builder: (context, state) {
        final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
        return NoteDetailPage(id: id);
      },
    ),
  ],
);

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(darkModeProvider).value ?? false;
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Week 5 - Offline Notes',
      routerConfig: appRouter,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
    );
  }
}
