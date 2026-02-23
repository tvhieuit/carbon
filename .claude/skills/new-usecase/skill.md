---
name: new-usecase
description: Generate a new use case following the Single Responsibility pattern. Use when adding new business logic.
---

Create a new use case with proper structure.

Template to follow:

```dart
import 'package:app_core/app_core.dart';
import 'package:injectable/injectable.dart';

// For use cases without parameters
@lazySingleton
class YourUseCase extends UseCase<ReturnType> {
  final YourRepository _repository;

  YourUseCase(this._repository);

  @override
  Future<Result<ReturnType>> call() async {
    // Implementation
  }
}

// OR for use cases with parameters
@freezed
class YourUseCaseParams with _$YourUseCaseParams {
  const factory YourUseCaseParams({
    required String param1,
    required int param2,
  }) = _YourUseCaseParams;
}

@lazySingleton
class YourUseCase extends UseCaseWithParams<ReturnType, YourUseCaseParams> {
  final YourRepository _repository;

  YourUseCase(this._repository);

  @override
  Future<Result<ReturnType>> call(YourUseCaseParams params) async {
    // Implementation
  }
}
```

Steps:
1. Ask for: use case name, package location, return type, parameters (if any)
2. Create the file in the appropriate package
3. Add the import to the package's barrel file
4. Run build_runner if using @freezed for params
5. Show the user where to inject it in their BLoC
