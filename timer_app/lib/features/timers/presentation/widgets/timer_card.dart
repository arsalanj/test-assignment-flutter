import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/timer_model.dart';
import '../../models/project_model.dart';
import '../../models/task_model.dart';
import '../../bloc/timer_bloc.dart';
import '../../bloc/timer_event.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class TimerCard extends StatelessWidget {
  final TimerModel timer;
  final ProjectModel? project;
  final TaskModel? task;

  const TimerCard({super.key, required this.timer, this.project, this.task});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            // Yellow accent line
            Container(
              width: 4,
              decoration: const BoxDecoration(
                color: AppColors.yellowAccent,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
            ),
            // Card content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header row with favorite icon
                    Row(
                      children: [
                        // Favorite icon
                        Icon(
                          timer.isFavorite ? Icons.star : Icons.star_outline,
                          color:
                              timer.isFavorite
                                  ? AppColors.favoriteColor
                                  : AppColors.textSecondary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        // Task title
                        Expanded(
                          child: Text(
                            task?.name ?? 'Unknown Task',
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        // Timer display and controls
                        _buildTimerControls(context),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Project info row
                    Row(
                      children: [
                        const Icon(
                          Icons.folder_outlined,
                          color: AppColors.textSecondary,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          project?.name ?? 'Unknown Project',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    // Deadline row
                    Row(
                      children: [
                        const Icon(
                          Icons.schedule,
                          color: AppColors.textSecondary,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Deadline ${_formatDate(DateTime.now().add(const Duration(days: 30)))}',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimerControls(BuildContext context) {
    if (timer.isCompleted) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.completedColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          'Completed',
          style: TextStyle(
            color: AppColors.completedColor,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Timer display
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.timerBackground,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            _formatDuration(timer.elapsed),
            style: const TextStyle(
              color: AppColors.timerText,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'monospace',
            ),
          ),
        ),
        const SizedBox(width: 8),
        // Play/Pause button
        GestureDetector(
          onTap: () {
            if (timer.isRunning) {
              context.read<TimerBloc>().add(PauseTimer(timer.id));
            } else {
              context.read<TimerBloc>().add(StartTimer(timer.id));
            }
          },
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.timerBackground,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              timer.isRunning ? Icons.pause : Icons.play_arrow,
              color: AppColors.timerText,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    return '$hours:$minutes';
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
