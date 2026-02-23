---
name: analyze
description: Run dart analyze on a package to check for issues. Use when you want to check code quality or find potential bugs.
---

Run `fvm dart analyze lib` for the specified package.

Steps:
1. Ask which package to analyze (or use the argument if provided)
2. Navigate to the package directory
3. Run the analyze command
4. Parse and explain any errors or warnings
5. Suggest fixes if issues are found

Valid packages:
- app_core
- domain
- data
- feature/auth
- feature/app_settings
- app_utility
- app_widget
- apps/flutter_app

If no package is specified, ask the user which one to analyze.

After showing results, offer to fix any issues found.
