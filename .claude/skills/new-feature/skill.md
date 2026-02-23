---
name: new-feature
description: Scaffold a new feature package with proper structure. Use when adding a new major feature to the app.
---

Create a complete feature package following the project architecture.

Structure to create:
```
packages/feature/your_feature/
├── lib/
│   ├── src/
│   │   ├── bloc/
│   │   │   ├── your_feature_bloc.dart
│   │   │   ├── your_feature_event.dart
│   │   │   └── your_feature_state.dart
│   │   ├── screen/
│   │   │   └── your_feature_screen.dart
│   │   ├── widget/
│   │   │   └── (feature-specific widgets)
│   │   └── injection.dart
│   └── feature_your_feature.dart (barrel file)
├── pubspec.yaml
└── analysis_options.yaml
```

Steps:
1. Ask for the feature name
2. Create the package structure
3. Set up pubspec.yaml with proper dependencies:
   - app_core
   - domain
   - app_utility
   - app_widget
   - flutter_bloc
   - injectable
   - freezed_annotation
   - auto_route
4. Create injection.dart with @InjectableInit
5. Create a sample BLoC and screen
6. Add the package to melos.yaml
7. Update apps/flutter_app to initialize the feature package
8. Run build_runner and show next steps
