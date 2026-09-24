import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'pages/paged_post_page.dart';
import 'pages/post_detail_page.dart';
import 'pages/post_list_page.dart';

void main() => runApp(const ProviderScope(child: MyApp()));

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const PostListPage()),
    GoRoute(path: '/paged', builder: (context, state) => const PagedPostPage()),
    GoRoute(
      path: '/post/:id',
      builder: (context, state) {
        final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 1;
        return PostDetailPage(id: id);
      },
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    debugShowCheckedModeBanner: false,
    title: 'Week 4 - REST API',
    routerConfig: appRouter,
    theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
  );
}
