import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../bloc/timer_bloc.dart';
import '../../bloc/timer_state.dart';
import '../../bloc/timer_event.dart';
import '../../models/project_model.dart';
import '../../models/task_model.dart';

class CreateTimerScreen extends StatefulWidget {
  const CreateTimerScreen({super.key});

  @override
  State<CreateTimerScreen> createState() => _CreateTimerScreenState();
}

class _CreateTimerScreenState extends State<CreateTimerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();

  ProjectModel? _selectedProject;
  TaskModel? _selectedTask;
  bool _isFavorite = false;

  List<TaskModel> _availableTasks = [];

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _onProjectChanged(ProjectModel? project) {
    setState(() {
      _selectedProject = project;
      _selectedTask = null; // Reset task selection

      if (project != null) {
        final state = context.read<TimerBloc>().state;
        if (state is TimerLoaded) {
          _availableTasks = state.getTasksForProject(project.id);
        }
      } else {
        _availableTasks = [];
      }
    });
  }

  void _createTimer() {
    if (_formKey.currentState!.validate() &&
        _selectedProject != null &&
        _selectedTask != null) {
      context.read<TimerBloc>().add(
        CreateTimer(
          description: _descriptionController.text.trim(),
          projectId: _selectedProject!.id,
          taskId: _selectedTask!.id,
          isFavorite: _isFavorite,
        ),
      );

      // Navigate back to timer list
      context.go('/timers');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Timer'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/timers'),
        ),
      ),
      body: BlocBuilder<TimerBloc, TimerState>(
        builder: (context, state) {
          if (state is! TimerLoaded) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Project Dropdown
                  DropdownButtonFormField<ProjectModel>(
                    value: _selectedProject,
                    decoration: const InputDecoration(
                      labelText: 'Select Project',
                      border: OutlineInputBorder(),
                    ),
                    items:
                        state.projects.map((project) {
                          return DropdownMenuItem(
                            value: project,
                            child: Text(project.name),
                          );
                        }).toList(),
                    onChanged: _onProjectChanged,
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a project';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Task Dropdown
                  DropdownButtonFormField<TaskModel>(
                    value: _selectedTask,
                    decoration: const InputDecoration(
                      labelText: 'Select Task',
                      border: OutlineInputBorder(),
                    ),
                    items:
                        _availableTasks.map((task) {
                          return DropdownMenuItem(
                            value: task,
                            child: Text(task.name),
                          );
                        }).toList(),
                    onChanged: (task) {
                      setState(() {
                        _selectedTask = task;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a task';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Description Field
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Timer Description',
                      border: OutlineInputBorder(),
                      hintText: 'What are you working on?',
                    ),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Favorite Checkbox
                  CheckboxListTile(
                    title: const Text('Mark as Favorite'),
                    value: _isFavorite,
                    onChanged: (value) {
                      setState(() {
                        _isFavorite = value ?? false;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  ),

                  const SizedBox(height: 32),

                  // Create Button
                  ElevatedButton(
                    onPressed: _createTimer,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Create & Start Timer',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
