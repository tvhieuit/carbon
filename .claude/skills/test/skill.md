---
name: test
description: Run tests for a package. Use when you want to verify functionality or run unit/widget tests.
---

Run `fvm flutter test` for the specified package.

Steps:
1. Ask which package to test (or use the argument if provided)
2. Navigate to the package directory
3. Check if test directory exists
4. Run the appropriate test command:
   - `fvm flutter test` for Flutter packages
   - `fvm dart test` for pure Dart packages
5. Show test results with pass/fail summary
6. If tests fail, offer to help debug

Options to support:
- Run all tests (default)
- Run specific test file
- Run with coverage
- Run in watch mode

Valid packages:
- app_core
- domain
- data
- feature/auth
- feature/app_settings
- app_utility
- app_widget
- apps/flutter_app
