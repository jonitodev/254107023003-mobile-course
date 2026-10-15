import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'routes.dart';

void main() => runApp(const ProviderScope(child: CleanArchApp()));

class CleanArchApp extends StatelessWidget {
  const CleanArchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Week 7 - Clean Architecture',
      routerConfig: appRouter,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
    );
  }
}
