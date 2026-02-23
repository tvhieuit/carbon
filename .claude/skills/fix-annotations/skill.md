---
name: fix-annotations
description: Check and fix Freezed annotation usage. Use when you need to ensure models use correct custom annotations (@modelFreezed, @eventFreezed, etc.) instead of @freezed.
---

Check and fix incorrect Freezed annotation usage across the codebase.

## Custom Annotations (from app_core)

The project uses custom annotations instead of plain `@freezed`:

| Annotation | Usage | Package |
|------------|-------|---------|
| `@modelFreezed` | Data models/DTOs | `data` |
| `@eventFreezed` | BLoC events | `feature/*` |
| `@stateFreezed` | BLoC states | `feature/*` |
| `@paramsFreezed` | Use case parameters | `domain`, `feature/*` |
| `@resultFreezed` | Result types | `app_core`, `domain` |

## Common Issues to Fix

### 1. Data Models Using `@freezed`
```dart
// ❌ WRONG
import 'package:freezed_annotation/freezed_annotation.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({ ... }) = _UserModel;
}

// ✅ CORRECT
import 'package:app_core/app_core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

@modelFreezed
class UserModel with _$UserModel {
  const UserModel._(); // If has custom methods like toEntity()

  const factory UserModel({ ... }) = _UserModel;

  UserEntity toEntity() { ... } // Custom methods need private constructor
}
```

### 2. BLoC Events/States Using `@freezed`
```dart
// ❌ WRONG
@freezed
class AuthEvent with _$AuthEvent { ... }

@freezed
class AuthState with _$AuthState { ... }

// ✅ CORRECT
import 'package:app_core/app_core.dart';

@eventFreezed
class AuthEvent with _$AuthEvent { ... }

@stateFreezed
class AuthState with _$AuthState { ... }
```

### 3. Use Case Params Using `@freezed`
```dart
// ❌ WRONG
@freezed
class LoginParams with _$LoginParams { ... }

// ✅ CORRECT
import 'package:app_core/app_core.dart';

@paramsFreezed
class LoginParams with _$LoginParams { ... }
```

### 4. Missing Private Constructor
```dart
// ❌ WRONG - will fail build if has custom methods
@modelFreezed
class UserModel with _$UserModel {
  const factory UserModel({ ... }) = _UserModel;

  UserEntity toEntity() { ... } // ERROR: Can't access properties
}

// ✅ CORRECT
@modelFreezed
class UserModel with _$UserModel {
  const UserModel._(); // Private constructor

  const factory UserModel({ ... }) = _UserModel;

  UserEntity toEntity() { ... } // Works!
}
```

## Steps to Fix

1. **Scan for incorrect usage:**
   ```bash
   # Find all @freezed usage (should be minimal)
   grep -r "@freezed" packages/data/lib/src/models --include="*.dart"
   grep -r "@freezed" packages/feature/*/lib/src --include="*.dart"
   ```

2. **Identify the type:**
   - In `packages/data/lib/src/models/` → Use `@modelFreezed`
   - In `packages/feature/*/lib/src/bloc/*_event.dart` → Use `@eventFreezed`
   - In `packages/feature/*/lib/src/bloc/*_state.dart` → Use `@stateFreezed`
   - Params classes → Use `@paramsFreezed`
   - Result types → Use `@resultFreezed`

3. **Apply fixes:**
   - Add `import 'package:app_core/app_core.dart';`
   - Change `@freezed` to appropriate custom annotation
   - If class has custom methods (toEntity, fromEntity, etc.), add private constructor:
     ```dart
     const ClassName._();
     ```

4. **Rebuild affected packages:**
   ```bash
   /build data
   /build domain
   /build feature/auth
   # etc.
   ```

5. **Verify:**
   ```bash
   /analyze {package}
   ```

## What to Check

- [ ] All data models in `packages/data/lib/src/models/` use `@modelFreezed`
- [ ] All BLoC events use `@eventFreezed`
- [ ] All BLoC states use `@stateFreezed`
- [ ] All use case params use `@paramsFreezed`
- [ ] All result types use `@resultFreezed`
- [ ] Classes with custom methods have private constructor
- [ ] All files import `package:app_core/app_core.dart`

## Quick Fix Script

For user to run manually if needed:
```bash
# Find all @freezed usage in data models
find packages/data/lib/src/models -name "*.dart" -type f ! -name "*.freezed.dart" ! -name "*.g.dart" -exec grep -l "@freezed" {} \;

# Find all @freezed usage in features
find packages/feature -name "*.dart" -type f ! -name "*.freezed.dart" ! -name "*.g.dart" -exec grep -l "@freezed" {} \;
```

## After Fixing

Always:
1. Run `/build {package}` to regenerate code
2. Run `/analyze {package}` to check for errors
3. Test that toEntity/fromEntity methods work correctly
4. Commit changes with message: "fix: use custom Freezed annotations"

## Why Custom Annotations?

- Consistent code generation across monorepo
- Clear semantic meaning (event vs state vs model)
- Centralized configuration in app_core
- Easier to enforce conventions
- Better IDE support with custom templates
