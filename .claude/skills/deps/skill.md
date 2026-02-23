---
name: deps
description: Show package dependencies and relationships. Use when you want to understand or verify the dependency structure.
---

Show the dependency tree for the Flutter monorepo.

Output:
1. ASCII diagram showing package relationships
2. List of each package's direct dependencies
3. Highlight any circular dependencies or issues
4. Show the DI initialization order

Example output format:
```
Package Dependency Tree:
========================

apps/flutter_app
├── feature/auth
├── feature/app_settings
├── app_widget
└── app_utility

feature/auth
├── domain
├── app_core
└── app_widget

domain
├── data
└── app_core

data
├── app_core
└── app_utility

DI Initialization Order:
========================
1. initCorePackage
2. initWidgetPackage
3. initDataPackage
4. initDomainPackage
5. initAuthPackage
6. initAppSettingsPackage
7. getIt.init()
```

Also check for common issues:
- Domain depending on data (violation!)
- Missing dependencies in pubspec.yaml
- Incorrect initialization order
