---
name: run-app
description: Run the Flutter app with different flavors and configurations. Use when you want to launch the app in dev, staging, or production mode.
---

Run the Flutter app using the project's launch configurations.

## Available Flavors

1. **dev** - Development environment
2. **staging** - Staging environment (if configured)
3. **prod** - Production environment (if configured)

## Launch Configuration

Based on `.vscode/launch.json`:
```json
{
  "name": "Flutter App - Development",
  "type": "dart",
  "flutterMode": "debug",
  "cwd": "apps/flutter_app",
  "program": "lib/main.dart",
  "args": [
    "--flavor", "dev",
    "--dart-define-from-file=configs/dev.json"
  ]
}
```

## Steps

1. Ask which flavor to run (or use argument if provided):
   - `dev` (default)
   - `staging`
   - `prod`

2. Ask which mode (optional):
   - `debug` (default) - with hot reload
   - `profile` - performance profiling
   - `release` - optimized build

3. Check if config file exists:
   - `apps/flutter_app/configs/{flavor}.json`

4. Run the appropriate command:
   ```bash
   cd apps/flutter_app
   fvm flutter run \
     --flavor {flavor} \
     --dart-define-from-file=configs/{flavor}.json \
     [--profile|--release]
   ```

## Additional Options

- **Device selection**: If multiple devices available, ask which one
- **Hot reload**: In debug mode, hot reload is available with `r`
- **Hot restart**: In debug mode, hot restart is available with `R`
- **Quit**: Press `q` to quit

## Examples

### Run in development mode (default)
```bash
/run-app
# or
/run-app dev
```

### Run in staging mode
```bash
/run-app staging
```

### Run in profile mode for performance testing
```bash
/run-app dev profile
```

### Run in release mode
```bash
/run-app prod release
```

## Pre-flight Checks

Before running, verify:
1. ✅ All packages are built (run `/build all` if needed)
2. ✅ No analysis errors (run `/analyze apps/flutter_app` if needed)
3. ✅ Config file exists for the selected flavor
4. ✅ At least one device is available (emulator/simulator/physical device)

## Troubleshooting

If the app fails to start:
1. Run `/clean apps/flutter_app` then `/build apps/flutter_app`
2. Check if the device is connected: `fvm flutter devices`
3. Verify the config file exists and is valid JSON
4. Check for any missing dependencies: `cd apps/flutter_app && fvm flutter pub get`

## Notes

- The app runs from `apps/flutter_app` directory
- Config files are in `apps/flutter_app/configs/`
- Flavors are defined in `android/app/build.gradle` and `ios/Runner/Info.plist`
- The app will launch in the currently selected device
