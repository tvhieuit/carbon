---
name: new-bloc
description: Generate a new BLoC with events and states. Use when creating new feature screens or state management.
---

Create a new BLoC following the project conventions.

Template structure:

IMPORTANT: Always use custom annotations from app_core!

```dart
import 'package:app_core/app_core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

// Events - use @eventFreezed (NOT @freezed)
@eventFreezed
class YourEvent with _$YourEvent {
  const factory YourEvent.started() = _Started;
  const factory YourEvent.actionRequested(String param) = _ActionRequested;
}

// States - use @stateFreezed (NOT @freezed)
@stateFreezed
class YourState with _$YourState {
  const factory YourState.initial() = _Initial;
  const factory YourState.loading() = _Loading;
  const factory YourState.success(DataType data) = _Success;
  const factory YourState.error(String message) = _Error;
}

// BLoC
@injectable
class YourBloc extends Bloc<YourEvent, YourState> {
  final YourUseCase _yourUseCase;

  YourBloc(this._yourUseCase) : super(const YourState.initial()) {
    on<_Started>(_onStarted);
    on<_ActionRequested>(_onActionRequested);
  }

  Future<void> _onStarted(_Started event, Emitter<YourState> emit) async {
    // Implementation
  }

  Future<void> _onActionRequested(
    _ActionRequested event,
    Emitter<YourState> emit,
  ) async {
    emit(const YourState.loading());

    final result = await _yourUseCase(params);

    result.when(
      success: (data) => emit(YourState.success(data)),
      failure: (error) => emit(YourState.error(error.message)),
    );
  }
}
```

Steps:
1. Ask for: BLoC name, feature package, events needed, states needed
2. Create the BLoC file with events and states
3. Ensure proper imports and annotations
4. Run build_runner
5. Show example of how to use it in a widget
