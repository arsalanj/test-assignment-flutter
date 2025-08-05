import 'package:equatable/equatable.dart';
import '../models/timer_model.dart';
import '../models/project_model.dart';
import '../models/task_model.dart';

abstract class TimerState extends Equatable {
  const TimerState();

  @override
  List<Object?> get props => [];
}

class TimerInitial extends TimerState {
  const TimerInitial();
}

class TimerLoading extends TimerState {
  const TimerLoading();
}

class TimerLoaded extends TimerState {
  final List<TimerModel> timers;
  final List<ProjectModel> projects;
  final List<TaskModel> tasks;

  const TimerLoaded({
    required this.timers,
    required this.projects,
    required this.tasks,
  });

  TimerLoaded copyWith({
    List<TimerModel>? timers,
    List<ProjectModel>? projects,
    List<TaskModel>? tasks,
  }) {
    return TimerLoaded(
      timers: timers ?? this.timers,
      projects: projects ?? this.projects,
      tasks: tasks ?? this.tasks,
    );
  }

  List<TimerModel> get activeTimers =>
      timers.where((timer) => !timer.isCompleted).toList();

  List<TimerModel> get completedTimers =>
      timers.where((timer) => timer.isCompleted).toList();

  List<TimerModel> get runningTimers =>
      timers.where((timer) => timer.isRunning && !timer.isCompleted).toList();

  ProjectModel? getProject(String projectId) {
    try {
      return projects.firstWhere((project) => project.id == projectId);
    } catch (e) {
      return null;
    }
  }

  TaskModel? getTask(String taskId) {
    try {
      return tasks.firstWhere((task) => task.id == taskId);
    } catch (e) {
      return null;
    }
  }

  List<TaskModel> getTasksForProject(String projectId) {
    return tasks.where((task) => task.projectId == projectId).toList();
  }

  // JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'timers': timers.map((timer) => timer.toJson()).toList(),
      'projects': projects.map((project) => project.toJson()).toList(),
      'tasks': tasks.map((task) => task.toJson()).toList(),
    };
  }

  factory TimerLoaded.fromJson(Map<String, dynamic> json) {
    return TimerLoaded(
      timers:
          (json['timers'] as List<dynamic>)
              .map(
                (timerJson) =>
                    TimerModel.fromJson(timerJson as Map<String, dynamic>),
              )
              .toList(),
      projects:
          (json['projects'] as List<dynamic>)
              .map(
                (projectJson) =>
                    ProjectModel.fromJson(projectJson as Map<String, dynamic>),
              )
              .toList(),
      tasks:
          (json['tasks'] as List<dynamic>)
              .map(
                (taskJson) =>
                    TaskModel.fromJson(taskJson as Map<String, dynamic>),
              )
              .toList(),
    );
  }

  @override
  List<Object> get props => [timers, projects, tasks];
}

class TimerError extends TimerState {
  final String message;

  const TimerError(this.message);

  @override
  List<Object> get props => [message];
}
