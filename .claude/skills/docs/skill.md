---
name: docs
description: Generate documentation for code, architecture, or packages. Use when you need to document features or explain code.
---

Generate documentation following the project's standards.

Documentation types:

1. **Package README**: Overview of what the package does
2. **Architecture Doc**: How components work together
3. **API Documentation**: Endpoint and repository docs
4. **Use Case Doc**: Business logic documentation
5. **BLoC Flow**: State management flows

Template for package README:
```markdown
# Package Name

## Overview
Brief description of what this package does.

## Architecture Layer
Which layer this belongs to (core/domain/data/feature).

## Dependencies
- List of dependencies
- Why each is needed

## Key Components

### Component 1
Description and usage example.

### Component 2
Description and usage example.

## Usage Example
\`\`\`dart
// Code example
\`\`\`

## DI Registration
How this package registers with GetIt.

## Related Packages
Links to related packages.
```

Template for use case documentation:
```markdown
# Use Case Name

## Purpose
What business rule this implements.

## Input
- Parameter 1: Description
- Parameter 2: Description

## Output
`Result<ReturnType>` where:
- Success: Description of success case
- Failure: Possible failure reasons

## Flow
1. Step 1
2. Step 2
3. Step 3

## Dependencies
- Repository: What it's used for
- Service: What it's used for

## Example
\`\`\`dart
final result = await useCase(params);
result.when(
  success: (data) => // Handle success,
  failure: (error) => // Handle error,
);
\`\`\`

## Edge Cases
- Edge case 1
- Edge case 2
```

Steps:
1. Ask what to document
2. Read the relevant code
3. Generate documentation following templates
4. Include diagrams where helpful
5. Add code examples
6. Save to appropriate location
