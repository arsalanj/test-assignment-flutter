import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/timer_model.dart';
import '../../models/project_model.dart';
import '../../models/task_model.dart';
import '../../bloc/timer_bloc.dart';
import '../../bloc/timer_event.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class TimerCard extends StatelessWidget {
  final TimerModel timer;
  final ProjectModel? project;
  final TaskModel? task;

  const TimerCard({super.key, required this.timer, this.project, this.task});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${project?.name ?? 'Unknown Project'} / ${task?.name ?? 'Unknown Task'}',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        timer.description,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    context.read<TimerBloc>().add(ToggleFavorite(timer.id));
                  },
                  icon: Icon(
                    timer.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: timer.isFavorite ? Colors.red : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _formatDuration(timer.elapsed),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
                if (!timer.isCompleted) ...[
                  IconButton(
                    onPressed: () {
                      if (timer.isRunning) {
                        context.read<TimerBloc>().add(PauseTimer(timer.id));
                      } else {
                        context.read<TimerBloc>().add(StartTimer(timer.id));
                      }
                    },
                    icon: Icon(
                      timer.isRunning ? Icons.pause : Icons.play_arrow,
                      size: 32,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      context.read<TimerBloc>().add(StopTimer(timer.id));
                    },
                    icon: const Icon(Icons.stop, size: 32),
                  ),
                ] else ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.green),
                    ),
                    child: const Text(
                      'Completed',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }
}
