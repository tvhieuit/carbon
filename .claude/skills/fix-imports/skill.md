---
name: fix-imports
description: Fix import issues and organize imports. Use when you have import errors or want to clean up imports.
---

Fix and organize imports in Dart files.

Common issues to fix:
1. **Relative vs absolute imports**: Convert relative imports to package imports
2. **Unused imports**: Remove imports that aren't used
3. **Missing imports**: Add missing imports
4. **Circular dependencies**: Detect and help resolve
5. **Barrel file issues**: Fix re-export conflicts with `hide` keyword

Steps:
1. Ask which file or package to fix
2. Scan for import issues
3. Show what will be changed
4. Apply fixes:
   - Convert `import '../../foo.dart'` → `import 'package:name/foo.dart'`
   - Remove unused imports
   - Sort imports (dart imports, package imports, relative imports)
   - Add missing imports for undefined symbols
5. Run dart analyze to verify

Special cases for this project:
- feature/auth re-exports domain.dart - may need `hide` clauses
- Ensure domain never imports from data
- Check that BLoCs import use cases, not repositories

Example fix:
```dart
// Before
import '../../domain/entities/user.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';

// After
import 'package:flutter/material.dart';

import 'package:domain/domain.dart';
import 'package:feature_auth/models.dart' hide User;
```
