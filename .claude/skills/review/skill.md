---
name: review
description: Review code for architecture compliance and best practices. Use before committing or when you want feedback on your code.
---

Review code for compliance with the project's architecture and best practices.

Review checklist:

## Architecture Compliance
- [ ] Code is in the correct layer (core/domain/data/feature)
- [ ] Dependency direction is correct (domain ← data, not domain → data)
- [ ] Use cases follow Single Responsibility Principle
- [ ] BLoCs use use cases, not repositories
- [ ] No implementation details in domain layer

## Code Quality
- [ ] Proper error handling with Result<T>
- [ ] Use of proper custom annotations:
  - Data models use `@modelFreezed` (NOT `@freezed`)
  - BLoC events use `@eventFreezed`
  - BLoC states use `@stateFreezed`
  - Use case params use `@paramsFreezed`
  - Result types use `@resultFreezed`
- [ ] Freezed classes with custom methods have private constructor: `const ClassName._();`
- [ ] Data models import `package:app_core/app_core.dart` for custom annotations
- [ ] Consistent naming conventions
- [ ] No code duplication
- [ ] Comments only where necessary

## DI Registration
- [ ] All services have @injectable or @lazySingleton
- [ ] Repositories registered with `as` interface
- [ ] No missing dependencies

## Imports
- [ ] Using package imports, not relative imports
- [ ] No circular dependencies
- [ ] Proper use of barrel files
- [ ] `hide` clause used when needed

## Testing
- [ ] Use cases have unit tests
- [ ] BLoCs have bloc tests
- [ ] Repositories have tests with mocks

## Performance
- [ ] No unnecessary rebuilds
- [ ] Proper use of const constructors
- [ ] Lazy initialization where appropriate

Review output format:
```
Code Review Results
===================

✅ Architecture: PASS
✅ Code Quality: PASS
⚠️  DI Registration: WARNING
   - Missing @lazySingleton on UserService
❌ Imports: FAIL
   - Using relative import in auth_bloc.dart
   - Circular dependency: feature/auth ↔ domain

Recommendations:
1. Add @lazySingleton to UserService (packages/data/lib/services/user_service.dart:10)
2. Change import in auth_bloc.dart to package import
3. Extract shared models to domain to break circular dependency

Overall: NEEDS FIXES (2 issues)
```
