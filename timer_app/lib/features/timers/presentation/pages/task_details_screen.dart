import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../bloc/timer_bloc.dart';
import '../../bloc/timer_state.dart';
import '../../bloc/timer_event.dart';
import '../../models/task_model.dart';
import '../../models/project_model.dart';
import '../../models/timer_model.dart';
import '../widgets/timer_card.dart';

class TaskDetailsScreen extends StatefulWidget {
  final String taskId;
  final String initialTab;

  const TaskDetailsScreen({
    super.key,
    required this.taskId,
    this.initialTab = 'details',
  });

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTab == 'timesheets' ? 1 : 0,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      builder: (context, state) {
        if (state is! TimerLoaded) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final task = state.getTask(widget.taskId);
        final project = task != null ? state.getProject(task.projectId) : null;

        if (task == null) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Task Not Found'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.go('/timers'),
              ),
            ),
            body: const Center(child: Text('Task not found')),
          );
        }

        final taskTimers =
            state.timers
                .where((timer) => timer.taskId == widget.taskId)
                .toList();

        return Scaffold(
          appBar: AppBar(
            title: Text(task.name),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.go('/timers'),
            ),
            bottom: TabBar(
              controller: _tabController,
              tabs: const [Tab(text: 'Details'), Tab(text: 'Timesheets')],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildDetailsTab(task, project),
              _buildTimesheetsTab(taskTimers, state),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailsTab(TaskModel task, ProjectModel? project) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Task Information',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildDetailRow('Task Name', task.name),
                  const SizedBox(height: 8),
                  _buildDetailRow('Project', project?.name ?? 'Unknown'),
                  const SizedBox(height: 8),
                  _buildDetailRow(
                    'Deadline',
                    task.deadline != null
                        ? _formatDate(task.deadline!)
                        : 'No deadline set',
                  ),
                  const SizedBox(height: 8),
                  _buildDetailRow(
                    'Assigned to',
                    task.assignedTo ?? 'Unassigned',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimesheetsTab(List<TimerModel> timers, TimerLoaded state) {
    if (timers.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.timer_off, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No timers for this task',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    final activeTimers = timers.where((t) => !t.isCompleted).toList();
    final completedTimers = timers.where((t) => t.isCompleted).toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (activeTimers.isNotEmpty) ...[
          Text(
            'Active Timers',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...activeTimers.map((timer) {
            final project = state.getProject(timer.projectId);
            final task = state.getTask(timer.taskId);
            return TimerCard(timer: timer, project: project, task: task);
          }),
          const SizedBox(height: 16),
        ],
        if (completedTimers.isNotEmpty) ...[
          Text(
            'Completed Timers',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...completedTimers.map((timer) {
            final project = state.getProject(timer.projectId);
            final task = state.getTask(timer.taskId);
            return TimerCard(timer: timer, project: project, task: task);
          }),
        ],
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            '$label:',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(child: Text(value)),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
