#!/bin/bash

APP_NAME="timer_app"

echo "🚀 Creating new Flutter app: $APP_NAME"

# 1. Create a new Flutter app
flutter create $APP_NAME

cd $APP_NAME || exit

echo "📁 Entered directory: $(pwd)"

# 2. Clean up default lib
rm -rf lib/*

# 3. Create directory structure
mkdir -p lib/core/theme
mkdir -p lib/core/router
mkdir -p lib/features/timers/presentation/pages
mkdir -p lib/features/timers/presentation/widgets
mkdir -p lib/features/timers/bloc
mkdir -p lib/features/timers/models
mkdir -p lib/features/timers/data

# 4. main.dart
cat <<EOL > lib/main.dart
import 'package:flutter/material.dart';
import 'app.dart';

void main() {
  runApp(const MyApp());
}
EOL

# 5. app.dart
cat <<EOL > lib/app.dart
import 'package:flutter/material.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Timer App',
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.router,
    );
  }
}
EOL

# 6. Theme: app_colors.dart
cat <<EOL > lib/core/theme/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF6750A4);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFFEADDFF);
  static const Color onPrimaryContainer = Color(0xFF21005D);
  static const Color background = Color(0xFFFFFBFE);
  static const Color onBackground = Color(0xFF1C1B1F);
  static const Color surface = Color(0xFFFFFBFE);
  static const Color onSurface = Color(0xFF1C1B1F);
}
EOL

# 7. Theme: app_text_styles.dart
cat <<EOL > lib/core/theme/app_text_styles.dart
import 'package:flutter/material.dart';

class AppTextStyles {
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: 'Inter',
    fontSize: 32,
    height: 40 / 32,
    fontWeight: FontWeight.normal,
  );
}
EOL

# 8. Theme: app_theme.dart
cat <<EOL > lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Inter',
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        primaryContainer: AppColors.primaryContainer,
        onPrimaryContainer: AppColors.onPrimaryContainer,
        secondary: Colors.grey,
        onSecondary: Colors.white,
        secondaryContainer: Colors.grey,
        onSecondaryContainer: Colors.black,
        error: Colors.red,
        onError: Colors.white,
        errorContainer: Colors.redAccent,
        onErrorContainer: Colors.black,
        background: AppColors.background,
        onBackground: AppColors.onBackground,
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
      ),
      textTheme: const TextTheme(
        headlineLarge: AppTextStyles.headlineLarge,
      ),
    );
  }
}
EOL

# 9. Router
cat <<EOL > lib/core/router/app_router.dart
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
EOL

# 10. Models
cat <<EOL > lib/features/timers/models/timer_model.dart
class TimerModel {
  final String id;
  final String description;
  final bool isRunning;
  final bool isFavorite;
  final DateTime startTime;
  final Duration elapsed;

  TimerModel({
    required this.id,
    required this.description,
    required this.isRunning,
    required this.isFavorite,
    required this.startTime,
    required this.elapsed,
  });
}
EOL

cat <<EOL > lib/features/timers/models/project_model.dart
class ProjectModel {
  final String id;
  final String name;

  ProjectModel({required this.id, required this.name});
}
EOL

cat <<EOL > lib/features/timers/models/task_model.dart
class TaskModel {
  final String id;
  final String name;
  final String projectId;

  TaskModel({required this.id, required this.name, required this.projectId});
}
EOL

# 11. Mock data
cat <<EOL > lib/features/timers/data/mock_data.dart
import '../models/project_model.dart';
import '../models/task_model.dart';

final mockProjects = [
  ProjectModel(id: 'p1', name: 'Project A'),
  ProjectModel(id: 'p2', name: 'Project B'),
];

final mockTasks = [
  TaskModel(id: 't1', name: 'Design UI', projectId: 'p1'),
  TaskModel(id: 't2', name: 'Setup Backend', projectId: 'p1'),
  TaskModel(id: 't3', name: 'Write Docs', projectId: 'p2'),
];
EOL

# 12. Screens
cat <<EOL > lib/features/timers/presentation/pages/timer_list_screen.dart
import 'package:flutter/material.dart';

class TimerListScreen extends StatelessWidget {
  const TimerListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Timers')),
      body: const Center(child: Text('Timer list goes here')),
    );
  }
}
EOL

cat <<EOL > lib/features/timers/presentation/pages/create_timer_screen.dart
import 'package:flutter/material.dart';

class CreateTimerScreen extends StatelessWidget {
  const CreateTimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Timer')),
      body: const Center(child: Text('Form to create timer')),
    );
  }
}
EOL

cat <<EOL > lib/features/timers/presentation/pages/task_details_screen.dart
import 'package:flutter/material.dart';

class TaskDetailsScreen extends StatelessWidget {
  const TaskDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task Details')),
      body: const Center(child: Text('Task details go here')),
    );
  }
}
EOL

# 13. Pubspec Note
echo "📝 Don't forget to:"
echo "- Add go_router to pubspec.yaml: go_router: ^13.0.0"
echo "- Add Inter font if needed"
echo "- Run: flutter pub get"

echo "✅ Timer App project initialized!"