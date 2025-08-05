import 'package:equatable/equatable.dart';

class TaskModel extends Equatable {
  final String id;
  final String name;
  final String projectId;
  final DateTime? deadline;
  final String? assignedTo;
  final String? description;

  const TaskModel({
    required this.id,
    required this.name,
    required this.projectId,
    this.deadline,
    this.assignedTo,
    this.description,
  });

  TaskModel copyWith({
    String? id,
    String? name,
    String? projectId,
    DateTime? deadline,
    String? assignedTo,
    String? description,
  }) {
    return TaskModel(
      id: id ?? this.id,
      name: name ?? this.name,
      projectId: projectId ?? this.projectId,
      deadline: deadline ?? this.deadline,
      assignedTo: assignedTo ?? this.assignedTo,
      description: description ?? this.description,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    projectId,
    deadline,
    assignedTo,
    description,
  ];
}
