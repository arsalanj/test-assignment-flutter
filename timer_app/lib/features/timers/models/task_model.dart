import 'package:equatable/equatable.dart';

class TaskModel extends Equatable {
  final String id;
  final String name;
  final String projectId;
  final DateTime? deadline;
  final String? assignedTo;

  const TaskModel({
    required this.id,
    required this.name,
    required this.projectId,
    this.deadline,
    this.assignedTo,
  });

  TaskModel copyWith({
    String? id,
    String? name,
    String? projectId,
    DateTime? deadline,
    String? assignedTo,
  }) {
    return TaskModel(
      id: id ?? this.id,
      name: name ?? this.name,
      projectId: projectId ?? this.projectId,
      deadline: deadline ?? this.deadline,
      assignedTo: assignedTo ?? this.assignedTo,
    );
  }

  @override
  List<Object?> get props => [id, name, projectId, deadline, assignedTo];
}
