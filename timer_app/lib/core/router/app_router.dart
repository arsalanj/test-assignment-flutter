import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/timers/presentation/pages/timer_list_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/timers',
    routes: [
      GoRoute(
        path: '/timers',
        builder: (context, state) => const TimerListScreen(),
      ),
    ],
  );
}
