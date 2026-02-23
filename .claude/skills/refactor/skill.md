---
name: refactor
description: Guide architectural refactoring following Clean Architecture principles. Use when restructuring code or moving logic between layers.
---

Help refactor code following the project's Clean Architecture patterns.

Common refactoring scenarios:

1. **Extract Use Case**: Move logic from BLoC to a use case
2. **Split Repository**: Separate remote/local repository concerns
3. **Extract Entity**: Move data models from feature to domain
4. **Create DTO**: Add DTOs in data layer to separate from entities
5. **Move to Utility**: Extract reusable logic to app_utility

Refactoring checklist:
- [ ] Identify which layer the code belongs to
- [ ] Check for dependency rule violations
- [ ] Create new files in correct package
- [ ] Update imports
- [ ] Run build_runner
- [ ] Update DI registration
- [ ] Run tests
- [ ] Update documentation

Layer rules to enforce:
- **app_core**: No dependencies (foundation)
- **domain**: No Dio, SharedPreferences, or implementation details
- **data**: Implements domain interfaces
- **features**: Use cases, not repositories
- **apps/flutter_app**: Composition only

Example refactoring:
```dart
// BEFORE: BLoC with business logic
class AuthBloc {
  final AuthRepository _repository;

  on<LoginRequested>((event, emit) async {
    // Complex validation logic here
    if (event.email.isEmpty) { ... }
    if (!event.email.contains('@')) { ... }

    final result = await _repository.login(event.email, event.password);
    // ...
  });
}

// AFTER: Logic moved to use case
class LoginUseCase extends UseCaseWithParams<User, LoginParams> {
  final AuthRepository _repository;

  Future<Result<User>> call(LoginParams params) async {
    // Validation logic here (business rule)
    if (params.email.isEmpty) {
      return const Failure('Email is required');
    }
    if (!params.email.contains('@')) {
      return const Failure('Invalid email');
    }

    return _repository.login(params.email, params.password);
  }
}

class AuthBloc {
  final LoginUseCase _loginUseCase; // BLoC is now thin

  on<LoginRequested>((event, emit) async {
    final result = await _loginUseCase(
      LoginParams(email: event.email, password: event.password)
    );
    // Just handle result
  });
}
```
