# Claude Code Skills Guide

## 🎯 What Are Skills?

Skills are custom commands you can invoke with `/skill-name` to automate common tasks in your Flutter monorepo. Think of them as **intelligent macros** that understand your project structure.

## 📋 Available Skills

### 🔨 Development Skills

#### `/run-app [flavor] [mode]`
Run the Flutter app with different configurations.
```bash
/run-app              # Run in dev mode (default)
/run-app dev          # Run in development
/run-app staging      # Run in staging
/run-app prod release # Run production release build
```

#### `/build [package]`
Run build_runner to generate code.
```bash
/build domain
/build feature/auth
/build  # Will ask which package
```

#### `/l10n [package]`
Generate localization files from ARB files.
```bash
/l10n feature/feuling_detail
/l10n  # Will ask which package
```

#### `/new-usecase`
Generate a new use case following Single Responsibility pattern.
```bash
/new-usecase
# Then follow prompts for name, package, etc.
```

#### `/new-bloc`
Generate a new BLoC with events and states.
```bash
/new-bloc
# Creates proper event/state/bloc structure
```

#### `/new-feature [name]`
Scaffold a complete feature package.
```bash
/new-feature orders
# Creates full package structure with DI, BLoC, screens
```

### 🔍 Analysis Skills

#### `/analyze [package]`
Check code quality and find issues.
```bash
/analyze data
/analyze  # Will ask which package
```

#### `/review`
Review code for architecture compliance.
```bash
/review
# Checks layer boundaries, DI, imports, etc.
```

#### `/deps`
Show package dependency tree.
```bash
/deps
# Visual diagram of package relationships
```

### 🐛 Debugging Skills

#### `/debug`
Help debug common Flutter/Dart issues.
```bash
/debug
# Interactive debugging assistant
```

#### `/fix-imports [file]`
Fix and organize imports.
```bash
/fix-imports packages/feature/auth/lib/auth_bloc.dart
/fix-imports domain  # Fix imports in whole package
```

#### `/fix-annotations`
Check and fix Freezed annotation usage.
```bash
/fix-annotations
# Ensures @modelFreezed, @eventFreezed, @stateFreezed usage
```

### 🧪 Testing Skills

#### `/test [package]`
Run tests for a package.
```bash
/test domain
/test feature/auth --coverage
/test  # Will ask which package
```

### 🧹 Maintenance Skills

#### `/clean [package|all]`
Clean build artifacts and regenerate.
```bash
/clean domain
/clean all  # Clean entire monorepo
```

### 📚 Documentation Skills

#### `/docs [target]`
Generate documentation.
```bash
/docs usecase LoginUseCase
/docs package domain
```

#### `/explain-code [topic]`
Explain code with diagrams and analogies.
```bash
/explain-code package
/explain-code BLoC pattern
```

### 🔧 Refactoring Skills

#### `/refactor`
Guide architectural refactoring.
```bash
/refactor
# Interactive refactoring assistant
```

## 🚀 Quick Start

### Example Workflow: Running the App

```bash
# 1. Build all packages
/build all

# 2. Run the app in development
/run-app dev

# 3. Or run in profile mode for performance testing
/run-app dev profile
```

### Example Workflow: Adding a New Feature

```bash
# 1. Create the feature package
/new-feature notifications

# 2. Create a use case
/new-usecase
# Name: GetNotificationsUseCase
# Package: domain
# Return: List<Notification>

# 3. Create a BLoC
/new-bloc
# Name: NotificationsBloc
# Package: feature/notifications

# 4. Run build_runner
/build feature/notifications

# 5. Review your code
/review

# 6. Run tests
/test feature/notifications

# 7. Analyze for issues
/analyze feature/notifications

# 8. Run the app to test
/run-app dev
```

### Example Workflow: Debugging an Error

```bash
# 1. Encounter build error
/debug
# Follow interactive prompts

# 2. Fix imports if needed
/fix-imports packages/feature/auth/lib/bloc/auth_bloc.dart

# 3. Clean and rebuild
/clean feature/auth
/build feature/auth

# 4. Verify no issues
/analyze feature/auth
```

## 💡 Tips and Tricks

### 1. Chain Skills
Skills work great together:
```bash
/new-usecase  # Create use case
# Then immediately:
/build domain  # Generate code
/review  # Check compliance
/test domain  # Run tests
```

### 2. Use Arguments
Most skills accept arguments to skip prompts:
```bash
/build domain  # Direct
vs
/build  # Will prompt
```

### 3. Layer-Specific Workflows

**When working on domain:**
```bash
/new-usecase → /build domain → /analyze domain → /test domain
```

**When working on features:**
```bash
/new-bloc → /build feature/X → /test feature/X → /review
```

**When debugging:**
```bash
/debug → /fix-imports → /clean → /build
```

### 4. Regular Maintenance
Run these regularly:
```bash
/deps  # Check architecture health
/review  # Verify code quality
/analyze all  # Find issues early
```

## 🏗️ Architecture Compliance

Skills enforce these rules:

### ✅ Always Allowed
- app_core depends on nothing
- domain depends on app_core only
- data depends on domain + app_core
- features depend on domain + app_core + utilities

### ❌ Never Allowed
- domain depending on data
- domain using Dio/SharedPreferences
- BLoCs using repositories directly
- Circular dependencies

Skills will warn you if you violate these rules!

## 🎨 Customizing Skills

Skills are just markdown files in `.claude/skills/`. To customize:

1. Navigate to `.claude/skills/[skill-name]/`
2. Edit `skill.md`
3. Reload Claude Code

### Skill Template
```markdown
---
name: your-skill-name
description: What this skill does. Used for autocomplete and help.
---

Instructions for Claude Code when this skill is invoked.

You can include:
- Steps to follow
- Code templates
- Commands to run
- Validation rules
- Examples
```

## 📖 Learning More

- `/explain-code` - Great for learning how things work
- `/docs` - Generate docs for your own reference
- `/deps` - Understand the architecture visually

## 🔗 Quick Reference Card

```
Development         Analysis           Debugging
───────────────    ───────────────    ───────────────
/build             /analyze           /debug
/new-usecase       /review            /fix-imports
/new-bloc          /deps              /clean
/new-feature       /test

Documentation      Refactoring
───────────────    ───────────────
/docs              /refactor
/explain-code
```

## 🎯 Common Use Cases

### "I need to add new business logic"
→ `/new-usecase`

### "I need a new screen with state management"
→ `/new-bloc`

### "I have import errors"
→ `/fix-imports`

### "Build is broken"
→ `/clean` then `/build`

### "Is my architecture correct?"
→ `/review` and `/deps`

### "I don't understand how this works"
→ `/explain-code`

### "I want to add a major feature"
→ `/new-feature`

### "My tests are failing"
→ `/test` then `/debug`

---

**Pro Tip**: Skills get better as you use them. They learn your project patterns and provide more relevant suggestions over time!
