import 'package:equatable/equatable.dart';

class TimerModel extends Equatable {
  final String id;
  final String description;
  final String projectId;
  final String taskId;
  final bool isRunning;
  final bool isFavorite;
  final bool isCompleted;
  final DateTime startTime;
  final Duration elapsed;
  final DateTime? pausedAt;

  const TimerModel({
    required this.id,
    required this.description,
    required this.projectId,
    required this.taskId,
    required this.isRunning,
    required this.isFavorite,
    required this.isCompleted,
    required this.startTime,
    required this.elapsed,
    this.pausedAt,
  });

  TimerModel copyWith({
    String? id,
    String? description,
    String? projectId,
    String? taskId,
    bool? isRunning,
    bool? isFavorite,
    bool? isCompleted,
    DateTime? startTime,
    Duration? elapsed,
    DateTime? pausedAt,
  }) {
    return TimerModel(
      id: id ?? this.id,
      description: description ?? this.description,
      projectId: projectId ?? this.projectId,
      taskId: taskId ?? this.taskId,
      isRunning: isRunning ?? this.isRunning,
      isFavorite: isFavorite ?? this.isFavorite,
      isCompleted: isCompleted ?? this.isCompleted,
      startTime: startTime ?? this.startTime,
      elapsed: elapsed ?? this.elapsed,
      pausedAt: pausedAt ?? this.pausedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    description,
    projectId,
    taskId,
    isRunning,
    isFavorite,
    isCompleted,
    startTime,
    elapsed,
    pausedAt,
  ];
}
