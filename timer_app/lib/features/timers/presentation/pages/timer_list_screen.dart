import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../bloc/timer_bloc.dart';
import '../../bloc/timer_state.dart';
import '../widgets/timer_card.dart';

class TimerListScreen extends StatelessWidget {
  const TimerListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timers'),
        actions: [
          IconButton(
            onPressed: () {
              context.go('/timers/create');
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: BlocBuilder<TimerBloc, TimerState>(
        builder: (context, state) {
          if (state is TimerLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TimerError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${state.message}',
                    style: Theme.of(context).textTheme.titleMedium,
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
                    const Icon(Icons.timer, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(
                      'No timers yet',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tap the + button to create your first timer',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            return ListView(
              children: [
                if (activeTimers.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Active Timers',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
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
                ],
                if (completedTimers.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Completed Timers',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ...completedTimers.map((timer) {
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
                ],
                const SizedBox(height: 16),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
