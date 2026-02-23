---
name: l10n
description: Generate localization files from ARB files. Use when you add or modify .arb files for internationalization.
---

Generate localization files from ARB (Application Resource Bundle) files.

## Command

Use `ml l10n` to generate localization files (requires TTY for package selection).

**Non-interactive alternative:**
```bash
cd packages/feature/{feature_name}
fvm flutter gen-l10n
```

## When to Use

Run this skill when:
- Adding new translation keys to ARB files
- Creating new language support (new .arb files)
- Modifying existing translations
- Getting localization errors like "delegate not found"
- After creating new feature packages with localization

## ARB File Structure

Each package with localization should have:

```
packages/feature/your_feature/
├── l10n/
│   ├── feature_name_en.arb  # English (template)
│   ├── feature_name_ja.arb  # Japanese
│   └── feature_name_*.arb   # Other languages
├── l10n.yaml                # Configuration
└── lib/
    └── src/
        └── l10n/            # Generated files (auto)
```

## l10n.yaml Configuration

```yaml
arb-dir: l10n
template-arb-file: feature_name_en.arb  # English is template
output-localization-file: feature_name_localizations.dart
output-class: FeatureNameLocalizations
output-dir: lib/src/l10n
nullable-getter: false
```

## ARB File Format

### English Template (feature_name_en.arb)
```json
{
  "@@locale": "en",

  "hello_message": "Hello, {name}!",
  "@hello_message": {
    "description": "Greeting message",
    "placeholders": {
      "name": {
        "type": "String"
      }
    }
  },

  "item_count": "{count, plural, =0{no items} =1{one item} other{{count} items}}",
  "@item_count": {
    "description": "Number of items",
    "placeholders": {
      "count": {
        "type": "int"
      }
    }
  }
}
```

### Japanese Translation (feature_name_ja.arb)
```json
{
  "@@locale": "ja",

  "hello_message": "こんにちは、{name}さん！",
  "item_count": "{count}個のアイテム"
}
```

## Steps

1. **Create or modify ARB files:**
   - Always create English template first (`*_en.arb`)
   - Add translations for other languages (`*_ja.arb`, etc.)
   - Ensure all keys exist in all language files

2. **Update l10n.yaml:**
   - Set `template-arb-file` to English file
   - Set correct output class name

3. **Generate localization files:**
   ```bash
   # Interactive (requires TTY)
   ml l10n

   # OR non-interactive
   cd packages/feature/{feature_name}
   fvm flutter gen-l10n
   ```

4. **Verify generated files:**
   - Check `lib/src/l10n/` directory
   - Ensure `*_localizations.dart` and language-specific files are created

5. **Export from barrel file:**
   ```dart
   // lib/feature_name.dart
   export 'src/l10n/l10n.dart';
   ```

## Common Issues

### Missing locale error
```
A FeatureNameLocalizations delegate that supports the en locale was not found.
```

**Solution:**
1. Create missing ARB file (e.g., `feature_name_en.arb`)
2. Update `l10n.yaml` to use English as template
3. Run `ml l10n`
4. Rebuild the package: `/build feature/name`

### Keys mismatch between languages
```
Missing keys in ja.arb: key1, key2
```

**Solution:**
1. Ensure all keys from template exist in all translations
2. Add missing translations to language files
3. Run `ml l10n` again

### Wrong template language
If Japanese is set as template but app uses English:

```yaml
# ❌ WRONG
template-arb-file: feature_name_ja.arb

# ✅ CORRECT
template-arb-file: feature_name_en.arb
```

## Using Generated Localizations

```dart
import 'package:feature_name/feature_name.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = FeatureNameLocalizations.of(context)!;

    return Text(l10n.hello_message('John'));
  }
}
```

## Workflow

### Adding new translations
```bash
# 1. Edit ARB files
# 2. Generate localizations
ml l10n

# 3. Rebuild package if needed
/build feature/name
```

### Adding new language
```bash
# 1. Create new ARB file (e.g., feature_name_es.arb)
# 2. Copy all keys from template
# 3. Translate values
# 4. Generate
ml l10n

# 5. Update app's supported locales in main.dart
```

## Checklist

- [ ] English ARB file exists and is set as template
- [ ] All language files have the same keys
- [ ] l10n.yaml configured correctly
- [ ] Run `ml l10n` after changes
- [ ] Generated files in `lib/src/l10n/`
- [ ] Localizations exported in barrel file
- [ ] App's MaterialApp includes localizationsDelegates

## Related Commands

- `/build` - Rebuild package after l10n generation
- `/analyze` - Check for localization errors
- `/clean` - Clean before regenerating if issues persist
