import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/timers/presentation/pages/timer_list_screen.dart';
import '../../features/timers/presentation/pages/create_timer_screen.dart';
import '../../features/timers/presentation/pages/task_details_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/timers',
    routes: [
      GoRoute(
        path: '/timers',
        builder: (context, state) => const TimerListScreen(),
      ),
      GoRoute(
        path: '/timers/create',
        builder: (context, state) => const CreateTimerScreen(),
      ),
      GoRoute(
        path: '/task/:taskId/details',
        builder: (context, state) {
          final taskId = state.pathParameters['taskId']!;
          return TaskDetailsScreen(taskId: taskId, tab: 'details');
        },
      ),
      GoRoute(
        path: '/task/:taskId/timesheets',
        builder: (context, state) {
          final taskId = state.pathParameters['taskId']!;
          return TaskDetailsScreen(taskId: taskId, tab: 'timesheets');
        },
      ),
    ],
  );
}
