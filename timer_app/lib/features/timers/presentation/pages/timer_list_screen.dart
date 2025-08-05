import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../bloc/timer_bloc.dart';
import '../../bloc/timer_state.dart';
import '../widgets/timer_card.dart';
import '../../../../core/theme/app_colors.dart';

class TimerListScreen extends StatelessWidget {
  const TimerListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.gradientStart, AppColors.gradientEnd],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Timesheets',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // Upload button (placeholder)
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.cardBackground,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.upload,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Add button
                    GestureDetector(
                      onTap: () => context.go('/timers/create'),
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.cardBackground,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.add,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Tab Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    _buildTab('Favorites', true),
                    const SizedBox(width: 32),
                    _buildTab('Odoo', false),
                    const SizedBox(width: 32),
                    _buildTab('Local', false),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Timer count
              BlocBuilder<TimerBloc, TimerState>(
                builder: (context, state) {
                  if (state is TimerLoaded) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'You have ${state.timers.length} Timers',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),

              const SizedBox(height: 16),

              // Timer List
              Expanded(
                child: BlocBuilder<TimerBloc, TimerState>(
                  builder: (context, state) {
                    if (state is TimerLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.textPrimary,
                        ),
                      );
                    }

                    if (state is TimerError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error,
                              size: 64,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Error: ${state.message}',
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    }

                    if (state is TimerLoaded) {
                      final activeTimers = state.activeTimers;
                      final completedTimers = state.completedTimers;

                      if (activeTimers.isEmpty && completedTimers.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.timer,
                                size: 64,
                                color: AppColors.textSecondary,
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'No timers yet',
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Tap the + button to create your first timer',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        children: [
                          ...activeTimers.map((timer) {
                            final project = state.getProject(timer.projectId);
                            final task = state.getTask(timer.taskId);
                            return GestureDetector(
                              onTap: () {
                                context.go('/task/${timer.taskId}/timesheets');
                              },
                              child: TimerCard(
                                timer: timer,
                                project: project,
                                task: task,
                              ),
                            );
                          }),
                          if (completedTimers.isNotEmpty) ...[
                            const SizedBox(height: 24),
                            const Text(
                              'Completed Records',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ...completedTimers.map((timer) {
                              final project = state.getProject(timer.projectId);
                              final task = state.getTask(timer.taskId);
                              return GestureDetector(
                                onTap: () {
                                  context.go(
                                    '/task/${timer.taskId}/timesheets',
                                  );
                                },
                                child: TimerCard(
                                  timer: timer,
                                  project: project,
                                  task: task,
                                ),
                              );
                            }),
                          ],
                          const SizedBox(
                            height: 100,
                          ), // Space for bottom navigation
                        ],
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTab(String title, bool isSelected) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
            fontSize: 16,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 2,
          width: 40,
          color: isSelected ? AppColors.textPrimary : Colors.transparent,
        ),
      ],
    );
  }
}
