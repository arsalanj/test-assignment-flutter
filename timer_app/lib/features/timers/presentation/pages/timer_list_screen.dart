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
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Timesheets',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Inter',
                      ),
                    ),
                    Row(
                      children: [
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
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 8),
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
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Tab Bar
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Row(
                  children: [
                    Expanded(child: _buildTab('Favorites', false)),
                    Expanded(child: _buildTab('Odoo', true)),
                    Expanded(child: _buildTab('Local', false)),
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
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color:
                isSelected
                    ? AppColors.textPrimary
                    : AppColors.textPrimary.withValues(alpha: 0.16),
            width: isSelected ? 2.0 : 1.0,
          ),
        ),
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.1,
            fontFamily: 'Inter',
          ),
        ),
      ),
    );
  }
}
