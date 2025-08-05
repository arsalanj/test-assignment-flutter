import 'dart:async';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import '../models/timer_model.dart';
import '../data/mock_data.dart';
import '../../../core/config/app_config.dart';
import 'timer_event.dart';
import 'timer_state.dart';

class TimerBloc extends HydratedBloc<TimerEvent, TimerState> {
  Timer? _ticker;
  final Map<String, Timer> _activeTimers = {};

  TimerBloc() : super(const TimerInitial()) {
    on<LoadTimers>(_onLoadTimers);
    on<CreateTimer>(_onCreateTimer);
    on<StartTimer>(_onStartTimer);
    on<PauseTimer>(_onPauseTimer);
    on<StopTimer>(_onStopTimer);
    on<ToggleFavorite>(_onToggleFavorite);
    on<UpdateTimerElapsed>(_onUpdateTimerElapsed);
  }

  void _onLoadTimers(LoadTimers event, Emitter<TimerState> emit) {
    try {
      if (AppConfig.useMockData) {
        // Always use mock data when flag is true
        emit(const TimerLoading());
        emit(
          TimerLoaded(
            timers: List.from(mockTimers),
            projects: mockProjects,
            tasks: mockTasks,
          ),
        );
      } else {
        // Check if we already have persisted data (restored by HydratedBloc)
        if (state is TimerLoaded) {
          // Data was already restored from HydratedBloc, don't override it
          // Just ensure we have projects and tasks for creating new timers
          final currentState = state as TimerLoaded;
          if (currentState.projects.isEmpty || currentState.tasks.isEmpty) {
            emit(
              currentState.copyWith(projects: mockProjects, tasks: mockTasks),
            );
          }
        } else {
          // No persisted data, start with empty state but include projects/tasks for creating new timers
          emit(const TimerLoading());
          emit(
            TimerLoaded(timers: [], projects: mockProjects, tasks: mockTasks),
          );
        }
      }

      // Start tickers for running timers
      if (state is TimerLoaded) {
        final loadedState = state as TimerLoaded;
        for (final timer in loadedState.runningTimers) {
          _startTimerTicker(timer.id);
        }
      }
    } catch (e) {
      emit(TimerError('Failed to load timers: $e'));
    }
  }

  void _onCreateTimer(CreateTimer event, Emitter<TimerState> emit) {
    if (state is TimerLoaded) {
      final currentState = state as TimerLoaded;

      final newTimer = TimerModel(
        id: 'timer_${DateTime.now().millisecondsSinceEpoch}',
        description: event.description,
        projectId: event.projectId,
        taskId: event.taskId,
        isRunning: true,
        isFavorite: event.isFavorite,
        isCompleted: false,
        startTime: DateTime.now(),
        elapsed: Duration.zero,
      );

      final updatedTimers = List<TimerModel>.from(currentState.timers)
        ..add(newTimer);

      emit(currentState.copyWith(timers: updatedTimers));

      // Start ticker for the new timer
      _startTimerTicker(newTimer.id);
    }
  }

  void _onStartTimer(StartTimer event, Emitter<TimerState> emit) {
    if (state is TimerLoaded) {
      final currentState = state as TimerLoaded;
      final timerIndex = currentState.timers.indexWhere(
        (t) => t.id == event.timerId,
      );

      if (timerIndex != -1) {
        final timer = currentState.timers[timerIndex];
        if (!timer.isCompleted) {
          final updatedTimer = timer.copyWith(
            isRunning: true,
            startTime: DateTime.now(),
            pausedAt: null,
          );

          final updatedTimers = List<TimerModel>.from(currentState.timers);
          updatedTimers[timerIndex] = updatedTimer;

          emit(currentState.copyWith(timers: updatedTimers));
          _startTimerTicker(event.timerId);
        }
      }
    }
  }

  void _onPauseTimer(PauseTimer event, Emitter<TimerState> emit) {
    if (state is TimerLoaded) {
      final currentState = state as TimerLoaded;
      final timerIndex = currentState.timers.indexWhere(
        (t) => t.id == event.timerId,
      );

      if (timerIndex != -1) {
        final timer = currentState.timers[timerIndex];
        final updatedTimer = timer.copyWith(
          isRunning: false,
          pausedAt: DateTime.now(),
        );

        final updatedTimers = List<TimerModel>.from(currentState.timers);
        updatedTimers[timerIndex] = updatedTimer;

        emit(currentState.copyWith(timers: updatedTimers));
        _stopTimerTicker(event.timerId);
      }
    }
  }

  void _onStopTimer(StopTimer event, Emitter<TimerState> emit) {
    if (state is TimerLoaded) {
      final currentState = state as TimerLoaded;
      final timerIndex = currentState.timers.indexWhere(
        (t) => t.id == event.timerId,
      );

      if (timerIndex != -1) {
        final timer = currentState.timers[timerIndex];
        final updatedTimer = timer.copyWith(
          isRunning: false,
          isCompleted: true,
          pausedAt: DateTime.now(),
        );

        final updatedTimers = List<TimerModel>.from(currentState.timers);
        updatedTimers[timerIndex] = updatedTimer;

        emit(currentState.copyWith(timers: updatedTimers));
        _stopTimerTicker(event.timerId);
      }
    }
  }

  void _onToggleFavorite(ToggleFavorite event, Emitter<TimerState> emit) {
    if (state is TimerLoaded) {
      final currentState = state as TimerLoaded;
      final timerIndex = currentState.timers.indexWhere(
        (t) => t.id == event.timerId,
      );

      if (timerIndex != -1) {
        final timer = currentState.timers[timerIndex];
        final updatedTimer = timer.copyWith(isFavorite: !timer.isFavorite);

        final updatedTimers = List<TimerModel>.from(currentState.timers);
        updatedTimers[timerIndex] = updatedTimer;

        emit(currentState.copyWith(timers: updatedTimers));
      }
    }
  }

  void _onUpdateTimerElapsed(
    UpdateTimerElapsed event,
    Emitter<TimerState> emit,
  ) {
    if (state is TimerLoaded) {
      final currentState = state as TimerLoaded;
      final timerIndex = currentState.timers.indexWhere(
        (t) => t.id == event.timerId,
      );

      if (timerIndex != -1) {
        final timer = currentState.timers[timerIndex];
        if (timer.isRunning && !timer.isCompleted) {
          final updatedTimer = timer.copyWith(elapsed: event.elapsed);

          final updatedTimers = List<TimerModel>.from(currentState.timers);
          updatedTimers[timerIndex] = updatedTimer;

          emit(currentState.copyWith(timers: updatedTimers));
        }
      }
    }
  }

  void _startTimerTicker(String timerId) {
    _stopTimerTicker(timerId); // Stop existing ticker if any

    _activeTimers[timerId] = Timer.periodic(const Duration(seconds: 1), (
      timer,
    ) {
      if (state is TimerLoaded) {
        final currentState = state as TimerLoaded;
        final timerModel = currentState.timers.firstWhere(
          (t) => t.id == timerId,
          orElse: () => throw Exception('Timer not found'),
        );

        if (timerModel.isRunning && !timerModel.isCompleted) {
          final now = DateTime.now();
          final newElapsed = timerModel.elapsed + const Duration(seconds: 1);

          add(UpdateTimerElapsed(timerId: timerId, elapsed: newElapsed));
        } else {
          _stopTimerTicker(timerId);
        }
      }
    });
  }

  void _stopTimerTicker(String timerId) {
    _activeTimers[timerId]?.cancel();
    _activeTimers.remove(timerId);
  }

  @override
  Future<void> close() {
    _ticker?.cancel();
    for (final timer in _activeTimers.values) {
      timer.cancel();
    }
    _activeTimers.clear();
    return super.close();
  }

  // HydratedBloc implementation
  @override
  TimerState? fromJson(Map<String, dynamic> json) {
    try {
      if (json['type'] == 'TimerLoaded') {
        return TimerLoaded.fromJson(json['data'] as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      // If there's an error deserializing, return null to use initial state
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(TimerState state) {
    if (state is TimerLoaded) {
      return {'type': 'TimerLoaded', 'data': state.toJson()};
    }
    return null;
  }
}
