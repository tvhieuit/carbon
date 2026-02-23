---
name: debug
description: Help debug common Flutter/Dart issues. Use when you encounter errors, build failures, or runtime issues.
---

Debug common issues in the Flutter monorepo.

Common issue categories:

1. **Build Runner Issues**
   - Missing generated files (*.freezed.dart, *.g.dart)
   - Conflicting builders
   - Annotation errors

2. **DI Issues**
   - Missing @injectable/@lazySingleton
   - Wrong initialization order
   - Unregistered dependencies

3. **Import Issues**
   - Circular dependencies
   - Missing package dependencies
   - Relative vs absolute imports

4. **BLoC Issues**
   - Events not firing
   - State not updating
   - Missing event handlers

5. **Architecture Violations**
   - Domain depending on data
   - BLoC using repository directly
   - Entities in wrong layer

Debugging steps:
1. Identify the error category
2. Check recent changes
3. Verify dependencies and imports
4. Check DI registration
5. Run build_runner if needed
6. Verify layer boundaries
7. Test the fix

For each error type, provide:
- **Root cause**: Why this happened
- **Quick fix**: Immediate solution
- **Prevention**: How to avoid in future

Example debug session:
```
Error: MissingPluginException (GetIt)
├─ Symptom: "Object/factory with type X is not registered"
├─ Root cause: Missing @injectable or wrong init order
├─ Check: Is @injectable on the class?
├─ Check: Is package initialized in main.dart?
├─ Check: Is initialization order correct?
└─ Fix: Add annotation and run build_runner
```
