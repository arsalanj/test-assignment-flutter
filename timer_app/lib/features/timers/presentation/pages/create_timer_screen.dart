import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../bloc/timer_bloc.dart';
import '../../bloc/timer_state.dart';
import '../../bloc/timer_event.dart';
import '../../models/project_model.dart';
import '../../models/task_model.dart';
import '../../../../core/theme/app_colors.dart';

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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.gradientStart, AppColors.gradientEnd],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => context.go('/timers'),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.cardBackground,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text(
                        'Create Timer',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Form Content
              Expanded(
                child: BlocBuilder<TimerBloc, TimerState>(
                  builder: (context, state) {
                    if (state is! TimerLoaded) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.textPrimary,
                        ),
                      );
                    }

                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 24),

                            // Project Dropdown
                            _buildDropdownField(
                              label: 'Project',
                              value: _selectedProject?.name,
                              onTap:
                                  () => _showProjectPicker(
                                    context,
                                    state.projects,
                                  ),
                              validator:
                                  _selectedProject == null
                                      ? 'Please select a project'
                                      : null,
                            ),

                            const SizedBox(height: 20),

                            // Task Dropdown
                            _buildDropdownField(
                              label: 'Task',
                              value: _selectedTask?.name,
                              onTap:
                                  _selectedProject == null
                                      ? null
                                      : () => _showTaskPicker(
                                        context,
                                        _availableTasks,
                                      ),
                              validator:
                                  _selectedTask == null
                                      ? 'Please select a task'
                                      : null,
                            ),

                            const SizedBox(height: 20),

                            // Description Field
                            _buildTextField(
                              label: 'Description',
                              controller: _descriptionController,
                              maxLines: 4,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter a description';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 24),

                            // Make Favorite Checkbox
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.cardBackground,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Checkbox(
                                    value: _isFavorite,
                                    onChanged: (value) {
                                      setState(() {
                                        _isFavorite = value ?? false;
                                      });
                                    },
                                    activeColor: AppColors.buttonBackground,
                                    checkColor: AppColors.buttonText,
                                    side: const BorderSide(
                                      color: AppColors.textSecondary,
                                      width: 2,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Text(
                                    'Mark as Favorite',
                                    style: TextStyle(
                                      color: AppColors.textPrimary,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Create Timer Button fixed at the bottom
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 24,
                ),
                child: Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.buttonBackground,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ElevatedButton(
                    onPressed: _createTimer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Create Timer',
                      style: TextStyle(
                        color: AppColors.buttonText,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    String? value,
    VoidCallback? onTap,
    String? validator,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
          border:
              validator != null
                  ? Border.all(color: Colors.red, width: 1)
                  : null,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value ?? label,
                style: TextStyle(
                  color:
                      value != null
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                  fontSize: 16,
                ),
              ),
            ),
            Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(color: AppColors.textPrimary, fontSize: 16),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: AppColors.textSecondary),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: const EdgeInsets.all(16),
        ),
        validator: validator,
      ),
    );
  }

  void _showProjectPicker(BuildContext context, List<ProjectModel> projects) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.gradientEnd,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Select Project',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                ...projects.map(
                  (project) => ListTile(
                    title: Text(
                      project.name,
                      style: const TextStyle(color: AppColors.textPrimary),
                    ),
                    onTap: () {
                      _onProjectChanged(project);
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
    );
  }

  void _showTaskPicker(BuildContext context, List<TaskModel> tasks) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.gradientEnd,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Select Task',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                ...tasks.map(
                  (task) => ListTile(
                    title: Text(
                      task.name,
                      style: const TextStyle(color: AppColors.textPrimary),
                    ),
                    onTap: () {
                      setState(() {
                        _selectedTask = task;
                      });
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
    );
  }
}
