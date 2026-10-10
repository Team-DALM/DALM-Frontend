import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'router/app_router.dart';
import 'theme/dalm_theme.dart';

class DalmApp extends ConsumerWidget {
  const DalmApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'DALM',
      debugShowCheckedModeBanner: false,
      theme: DalmTheme.light,
      routerConfig: router,
    );
  }
}
