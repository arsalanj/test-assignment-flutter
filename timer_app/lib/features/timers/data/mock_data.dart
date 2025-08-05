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
    description:
        'Create reusable UI components for the mobile application including buttons, cards, and navigation elements.',
  ),
  TaskModel(
    id: 't2',
    name: 'Setup Backend API',
    projectId: 'p1',
    deadline: DateTime.now().add(const Duration(days: 5)),
    assignedTo: 'Jane Smith',
    description:
        'Implement REST API endpoints for user authentication, data management, and real-time synchronization.',
  ),
  TaskModel(
    id: 't3',
    name: 'Write Documentation',
    projectId: 'p2',
    deadline: DateTime.now().add(const Duration(days: 3)),
    assignedTo: 'Bob Johnson',
    description:
        'As a user, I would like to be able to buy a subscription, this would allow me to get a discount on the products and on the second stage of diagnosis',
  ),
  TaskModel(
    id: 't4',
    name: 'Create Landing Page',
    projectId: 'p2',
    deadline: DateTime.now().add(const Duration(days: 10)),
    assignedTo: 'Alice Brown',
    description:
        'Design and develop a responsive landing page that showcases the product features and drives conversions.',
  ),
  TaskModel(
    id: 't5',
    name: 'Social Media Strategy',
    projectId: 'p3',
    deadline: DateTime.now().add(const Duration(days: 14)),
    assignedTo: 'Charlie Wilson',
    description:
        'Develop a comprehensive social media marketing strategy to increase brand awareness and engagement.',
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
