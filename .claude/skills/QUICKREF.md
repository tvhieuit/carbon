# Skills Quick Reference

## One-Line Commands

```bash
# Run app
/run-app                         # Run in dev mode
/run-app dev                     # Run development
/run-app staging                 # Run staging
/run-app prod release            # Run production release

# Generate code
/build domain                    # Run build_runner
/new-usecase                     # Create new use case
/new-bloc                        # Create new BLoC
/new-feature notifications       # Scaffold feature package

# Check quality
/analyze domain                  # Lint and analyze
/review                          # Architecture review
/test domain                     # Run tests
/deps                            # Show dependency tree

# Fix issues
/debug                           # Debug assistant
/fix-imports                     # Organize imports
/clean all                       # Clean and rebuild

# Learn & document
/explain-code package            # Explain with diagrams
/docs                            # Generate documentation
/refactor                        # Refactoring guide
```

## Workflows

### Run App
```
/build all → /run-app dev
```

### New Feature
```
/new-feature → /new-usecase → /new-bloc → /build → /review → /test → /run-app
```

### Fix Build
```
/debug → /clean → /build → /analyze → /run-app
```

### Code Review
```
/review → /fix-imports → /analyze → /test → /run-app
```

### Architecture Check
```
/deps → /review → /explain-code
```

## Package Names
- `app_core`, `app_utility`, `app_widget`
- `domain`, `data`
- `feature/auth`, `feature/app_settings`
- `apps/flutter_app`

## Remember
- Skills enforce Clean Architecture
- Most accept arguments to skip prompts
- Chain skills for complete workflows
- `/explain-code` for learning
