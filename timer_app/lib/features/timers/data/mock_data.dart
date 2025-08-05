import '../models/project_model.dart';
import '../models/task_model.dart';
import '../models/timer_model.dart';

final mockProjects = [
  const ProjectModel(id: 'p1', name: 'Mobile App Development'),
  const ProjectModel(id: 'p2', name: 'Website Redesign'),
  const ProjectModel(id: 'p3', name: 'Marketing Campaign'),
];

final mockTasks = [
  TaskModel(
    id: 't1',
    name: 'Design UI Components',
    projectId: 'p1',
    deadline: DateTime.now().add(const Duration(days: 7)),
    assignedTo: 'John Doe',
  ),
  TaskModel(
    id: 't2',
    name: 'Setup Backend API',
    projectId: 'p1',
    deadline: DateTime.now().add(const Duration(days: 5)),
    assignedTo: 'Jane Smith',
  ),
  TaskModel(
    id: 't3',
    name: 'Write Documentation',
    projectId: 'p2',
    deadline: DateTime.now().add(const Duration(days: 3)),
    assignedTo: 'Bob Johnson',
  ),
  TaskModel(
    id: 't4',
    name: 'Create Landing Page',
    projectId: 'p2',
    deadline: DateTime.now().add(const Duration(days: 10)),
    assignedTo: 'Alice Brown',
  ),
  TaskModel(
    id: 't5',
    name: 'Social Media Strategy',
    projectId: 'p3',
    deadline: DateTime.now().add(const Duration(days: 14)),
    assignedTo: 'Charlie Wilson',
  ),
];

final mockTimers = <TimerModel>[
  TimerModel(
    id: 'timer1',
    description: 'Working on mobile app wireframes',
    projectId: 'p1',
    taskId: 't1',
    isRunning: true,
    isFavorite: true,
    isCompleted: false,
    startTime: DateTime.now().subtract(const Duration(minutes: 25)),
    elapsed: const Duration(minutes: 25),
  ),
  TimerModel(
    id: 'timer2',
    description: 'API endpoint development',
    projectId: 'p1',
    taskId: 't2',
    isRunning: false,
    isFavorite: false,
    isCompleted: false,
    startTime: DateTime.now().subtract(const Duration(hours: 2)),
    elapsed: const Duration(hours: 1, minutes: 30),
    pausedAt: DateTime.now().subtract(const Duration(minutes: 30)),
  ),
  TimerModel(
    id: 'timer3',
    description: 'Documentation writing session',
    projectId: 'p2',
    taskId: 't3',
    isRunning: false,
    isFavorite: true,
    isCompleted: true,
    startTime: DateTime.now().subtract(const Duration(days: 1)),
    elapsed: const Duration(hours: 2, minutes: 45),
  ),
];
