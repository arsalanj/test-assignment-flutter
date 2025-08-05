import 'package:equatable/equatable.dart';

abstract class TimerEvent extends Equatable {
  const TimerEvent();

  @override
  List<Object?> get props => [];
}

class LoadTimers extends TimerEvent {
  const LoadTimers();
}

class CreateTimer extends TimerEvent {
  final String description;
  final String projectId;
  final String taskId;
  final bool isFavorite;

  const CreateTimer({
    required this.description,
    required this.projectId,
    required this.taskId,
    required this.isFavorite,
  });

  @override
  List<Object> get props => [description, projectId, taskId, isFavorite];
}

class StartTimer extends TimerEvent {
  final String timerId;

  const StartTimer(this.timerId);

  @override
  List<Object> get props => [timerId];
}

class PauseTimer extends TimerEvent {
  final String timerId;

  const PauseTimer(this.timerId);

  @override
  List<Object> get props => [timerId];
}

class StopTimer extends TimerEvent {
  final String timerId;

  const StopTimer(this.timerId);

  @override
  List<Object> get props => [timerId];
}

class ToggleFavorite extends TimerEvent {
  final String timerId;

  const ToggleFavorite(this.timerId);

  @override
  List<Object> get props => [timerId];
}

class UpdateTimerElapsed extends TimerEvent {
  final String timerId;
  final Duration elapsed;

  const UpdateTimerElapsed({required this.timerId, required this.elapsed});

  @override
  List<Object> get props => [timerId, elapsed];
}
