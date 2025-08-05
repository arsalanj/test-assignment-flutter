import 'package:equatable/equatable.dart';

class ProjectModel extends Equatable {
  final String id;
  final String name;

  const ProjectModel({required this.id, required this.name});

  ProjectModel copyWith({String? id, String? name}) {
    return ProjectModel(id: id ?? this.id, name: name ?? this.name);
  }

  // JSON serialization
  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(id: json['id'] as String, name: json['name'] as String);
  }

  @override
  List<Object> get props => [id, name];
}
