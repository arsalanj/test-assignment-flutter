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

  // JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'projectId': projectId,
      'deadline': deadline?.millisecondsSinceEpoch,
      'assignedTo': assignedTo,
      'description': description,
    };
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as String,
      name: json['name'] as String,
      projectId: json['projectId'] as String,
      deadline:
          json['deadline'] != null
              ? DateTime.fromMillisecondsSinceEpoch(json['deadline'] as int)
              : null,
      assignedTo: json['assignedTo'] as String?,
      description: json['description'] as String?,
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
