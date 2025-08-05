import 'package:equatable/equatable.dart';

class ProjectModel extends Equatable {
  final String id;
  final String name;

  const ProjectModel({required this.id, required this.name});

  ProjectModel copyWith({String? id, String? name}) {
    return ProjectModel(id: id ?? this.id, name: name ?? this.name);
  }

  @override
  List<Object> get props => [id, name];
}
