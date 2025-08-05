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

  // JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'projectId': projectId,
      'taskId': taskId,
      'isRunning': isRunning,
      'isFavorite': isFavorite,
      'isCompleted': isCompleted,
      'startTime': startTime.millisecondsSinceEpoch,
      'elapsed': elapsed.inMilliseconds,
      'pausedAt': pausedAt?.millisecondsSinceEpoch,
    };
  }

  factory TimerModel.fromJson(Map<String, dynamic> json) {
    return TimerModel(
      id: json['id'] as String,
      description: json['description'] as String,
      projectId: json['projectId'] as String,
      taskId: json['taskId'] as String,
      isRunning: json['isRunning'] as bool,
      isFavorite: json['isFavorite'] as bool,
      isCompleted: json['isCompleted'] as bool,
      startTime: DateTime.fromMillisecondsSinceEpoch(json['startTime'] as int),
      elapsed: Duration(milliseconds: json['elapsed'] as int),
      pausedAt:
          json['pausedAt'] != null
              ? DateTime.fromMillisecondsSinceEpoch(json['pausedAt'] as int)
              : null,
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
