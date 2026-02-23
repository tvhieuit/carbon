---
name: clean
description: Clean build artifacts and regenerate code. Use when you have build errors or want a fresh start.
---

Clean and rebuild the project.

Steps:
1. Ask which package to clean (or "all" for entire monorepo)
2. Run cleanup commands:
   - `fvm flutter clean` (for Flutter packages)
   - Delete `.dart_tool`, `build`, `.flutter-plugins*` directories
   - Run `fvm flutter pub get` or `fvm dart pub get`
3. Optionally run build_runner:
   - Ask if user wants to regenerate code
   - Run `fvm dart run build_runner build -d`
4. Show completion message

For "all" option:
- Clean all packages in order
- Run `fvm dart run melos clean`
- Run `fvm dart run melos bootstrap`
- Offer to rebuild all generated code

Safety checks:
- Confirm before deleting if there are uncommitted changes
- Show what will be deleted
- Offer to create a backup of generated files
