import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/timer_model.dart';
import '../../models/project_model.dart';
import '../../models/task_model.dart';
import '../../bloc/timer_bloc.dart';
import '../../bloc/timer_event.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class TimerCard extends StatefulWidget {
  final TimerModel timer;
  final ProjectModel? project;
  final TaskModel? task;

  const TimerCard({super.key, required this.timer, this.project, this.task});

  @override
  State<TimerCard> createState() => _TimerCardState();
}

class _TimerCardState extends State<TimerCard> {
  OverlayEntry? _overlayEntry;
  Timer? _tooltipTimer;
  final GlobalKey _timerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            // Yellow accent line
            Container(
              width: 4,
              decoration: const BoxDecoration(
                color: AppColors.yellowAccent,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
            ),
            // Card content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header row with favorite icon
                    Row(
                      children: [
                        // Favorite icon
                        Icon(
                          widget.timer.isFavorite
                              ? Icons.star
                              : Icons.star_outline,
                          color:
                              widget.timer.isFavorite
                                  ? AppColors.favoriteColor
                                  : AppColors.textSecondary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        // Task title
                        Expanded(
                          child: Text(
                            widget.task?.name ?? 'Unknown Task',
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        // Timer display and controls
                        _buildTimerControls(context),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Project info row
                    Row(
                      children: [
                        const Icon(
                          Icons.folder_outlined,
                          color: AppColors.textSecondary,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          widget.project?.name ?? 'Unknown Project',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    // Deadline row
                    Row(
                      children: [
                        const Icon(
                          Icons.schedule,
                          color: AppColors.textSecondary,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Deadline ${_formatDate(DateTime.now().add(const Duration(days: 30)))}',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimerControls(BuildContext context) {
    if (widget.timer.isCompleted) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.completedColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          'Completed',
          style: TextStyle(
            color: AppColors.completedColor,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Timer display with long press tooltip
        GestureDetector(
          onLongPress: () {
            _showFullTimeTooltip(context, widget.timer.elapsed);
          },
          child: Container(
            key: _timerKey,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.timerBackground,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _formatDuration(widget.timer.elapsed),
              style: const TextStyle(
                color: AppColors.timerText,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'monospace',
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        // Play/Pause button
        GestureDetector(
          onTap: () {
            if (widget.timer.isRunning) {
              context.read<TimerBloc>().add(PauseTimer(widget.timer.id));
            } else {
              context.read<TimerBloc>().add(StartTimer(widget.timer.id));
            }
          },
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.timerBackground,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              widget.timer.isRunning ? Icons.pause : Icons.play_arrow,
              color: AppColors.timerText,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    return '$hours:$minutes';
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _formatFullDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

  void _showFullTimeTooltip(BuildContext context, Duration initialElapsed) {
    // Remove any existing tooltip
    _hideTooltip();

    final overlay = Overlay.of(context);
    final renderBox =
        _timerKey.currentContext?.findRenderObject() as RenderBox?;

    if (renderBox == null) return;

    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    // Create a stateful widget for the dynamic tooltip
    _overlayEntry = OverlayEntry(
      builder:
          (context) => _DynamicTooltip(
            position: position,
            size: size,
            timer: widget.timer,
            onDismiss: _hideTooltip,
          ),
    );

    overlay.insert(_overlayEntry!);

    // Auto-dismiss after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      _hideTooltip();
    });
  }

  void _hideTooltip() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _tooltipTimer?.cancel();
    _tooltipTimer = null;
  }

  @override
  void dispose() {
    _hideTooltip();
    super.dispose();
  }
}

class _DynamicTooltip extends StatefulWidget {
  final Offset position;
  final Size size;
  final TimerModel timer;
  final VoidCallback onDismiss;

  const _DynamicTooltip({
    required this.position,
    required this.size,
    required this.timer,
    required this.onDismiss,
  });

  @override
  State<_DynamicTooltip> createState() => _DynamicTooltipState();
}

class _DynamicTooltipState extends State<_DynamicTooltip> {
  late Timer _updateTimer;
  late Duration _currentElapsed;

  @override
  void initState() {
    super.initState();
    _currentElapsed = widget.timer.elapsed;

    // Update the tooltip every second if timer is running
    _updateTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (widget.timer.isRunning && !widget.timer.isCompleted) {
        setState(() {
          _currentElapsed = _currentElapsed + const Duration(seconds: 1);
        });
      }
    });
  }

  @override
  void dispose() {
    _updateTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Transparent background to capture taps
        GestureDetector(
          onTap: widget.onDismiss,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.transparent,
          ),
        ),
        // Tooltip positioned above the timer
        Positioned(
          left: widget.position.dx - 40,
          top: widget.position.dy - 80,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Full Timer Duration',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatFullDuration(_currentElapsed),
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _formatFullDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }
}
