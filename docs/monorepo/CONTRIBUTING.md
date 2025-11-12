# Contributing to AI Apps Monorepo

Thank you for your interest in contributing! This document provides guidelines for contributing to the projects in this monorepo.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [How to Contribute](#how-to-contribute)
- [Development Workflow](#development-workflow)
- [Coding Standards](#coding-standards)
- [Testing Guidelines](#testing-guidelines)
- [Documentation](#documentation)
- [Pull Request Process](#pull-request-process)
- [Issue Reporting](#issue-reporting)

## Code of Conduct

### Our Pledge

We are committed to providing a welcoming and inclusive environment for all contributors, regardless of background, identity, or experience level.

### Expected Behavior

- Be respectful and considerate
- Welcome newcomers and help them get started
- Accept constructive criticism gracefully
- Focus on what's best for the community
- Show empathy towards others

### Unacceptable Behavior

- Harassment, discrimination, or offensive comments
- Personal attacks or trolling
- Publishing others' private information
- Any conduct that could reasonably be considered inappropriate

## Getting Started

### Prerequisites

1. **Install Flutter**
   ```bash
   # Download from https://flutter.dev/docs/get-started/install
   flutter --version  # Should be 3.x or higher
   ```

2. **Install Dart**
   ```bash
   dart --version  # Should be 3.x or higher
   ```

3. **Setup IDE**
   - VS Code with Flutter extension
   - Android Studio with Flutter plugin
   - IntelliJ IDEA with Flutter plugin

4. **Fork and Clone**
   ```bash
   # Fork the repository on GitHub
   git clone https://github.com/YOUR_USERNAME/repository-name.git
   cd repository-name
   ```

5. **Install Dependencies**
   ```bash
   cd app_name  # Choose app to work on
   flutter pub get
   ```

## How to Contribute

### Types of Contributions

1. **Bug Fixes** - Fix existing issues
2. **New Features** - Add new functionality
3. **Documentation** - Improve or add documentation
4. **Tests** - Add or improve test coverage
5. **Performance** - Optimize code performance
6. **Refactoring** - Improve code quality
7. **Localization** - Add or improve translations

### Finding Issues to Work On

- Check the [Issues](https://github.com/organization/repository/issues) page
- Look for issues labeled `good first issue` or `help wanted`
- Comment on an issue to express interest before starting work
- Wait for maintainer confirmation before proceeding

## Development Workflow

### 1. Create a Branch

```bash
# Update main branch
git checkout main
git pull origin main

# Create feature branch
git checkout -b feature/your-feature-name
# or
git checkout -b fix/bug-description
```

### 2. Make Changes

- Write clean, readable code
- Follow the coding standards (see below)
- Add tests for new functionality
- Update documentation as needed

### 3. Test Your Changes

```bash
# Run tests
flutter test

# Check formatting
dart format .

# Analyze code
flutter analyze

# Run the app
flutter run
```

### 4. Commit Changes

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```bash
git add .
git commit -m "feat: add new feature description"
```

**Commit Types:**
- `feat:` - New feature
- `fix:` - Bug fix
- `docs:` - Documentation changes
- `style:` - Code style changes (formatting, etc.)
- `refactor:` - Code refactoring
- `test:` - Adding or updating tests
- `chore:` - Maintenance tasks

**Examples:**
```bash
git commit -m "feat: add dark mode support"
git commit -m "fix: resolve crash on startup"
git commit -m "docs: update installation instructions"
git commit -m "test: add unit tests for DatabaseService"
```

### 5. Push Changes

```bash
git push origin feature/your-feature-name
```

### 6. Create Pull Request

1. Go to GitHub repository
2. Click "New Pull Request"
3. Select your branch
4. Fill in PR template (see below)
5. Submit for review

## Coding Standards

### Dart Style Guide

Follow the [official Dart style guide](https://dart.dev/guides/language/effective-dart):

#### Naming Conventions
```dart
// Classes, enums, typedefs - UpperCamelCase
class ScanResult { }
enum ThemeMode { }

// Variables, functions, parameters - lowerCamelCase
String userName;
void fetchData() { }

// Constants - lowerCamelCase
const double maxScore = 10.0;

// Files - snake_case
// scan_result.dart
// database_service.dart
```

#### Formatting
```dart
// Use trailing commas for better formatting
Widget build(BuildContext context) {
  return Container(
    padding: EdgeInsets.all(16),
    child: Text('Hello'),  // <- trailing comma
  );
}

// Format code before committing
dart format .
```

#### Code Organization
```dart
// Order: constants, fields, constructor, methods
class MyClass {
  // 1. Static constants
  static const String defaultValue = 'default';
  
  // 2. Instance fields
  final String name;
  final int age;
  
  // 3. Constructor
  MyClass({
    required this.name,
    required this.age,
  });
  
  // 4. Public methods
  void publicMethod() { }
  
  // 5. Private methods
  void _privateMethod() { }
}
```

### Widget Guidelines

#### Use const constructors when possible
```dart
// Good
const Text('Hello')
const SizedBox(height: 16)

// Bad
Text('Hello')
SizedBox(height: 16)
```

#### Extract reusable widgets
```dart
// Good - extracted widget
class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});
  
  @override
  Widget build(BuildContext context) {
    return Text(title, style: Theme.of(context).textTheme.headlineSmall);
  }
}

// Usage
_SectionHeader(title: 'My Section')
```

#### Keep build methods small
```dart
// Good - compose smaller widgets
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: _buildAppBar(),
    body: _buildBody(),
    bottomNavigationBar: _buildBottomBar(),
  );
}

Widget _buildAppBar() => AppBar(title: Text('Title'));
Widget _buildBody() => ListView(children: [...]);
Widget _buildBottomBar() => BottomNavigationBar(items: [...]);
```

## Testing Guidelines

### Test Coverage

Aim for:
- **Unit tests:** 80%+ coverage
- **Widget tests:** Cover critical UI components
- **Integration tests:** Cover main user flows

### Writing Tests

#### Unit Tests
```dart
// test/services/api_service_test.dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ApiService', () {
    late ApiService service;
    
    setUp(() {
      service = ApiService();
    });
    
    test('should fetch data successfully', () async {
      final result = await service.fetchData();
      expect(result, isNotNull);
    });
    
    test('should throw exception on error', () {
      expect(
        () => service.fetchInvalidData(),
        throwsA(isA<ApiException>()),
      );
    });
  });
}
```

#### Widget Tests
```dart
// test/widgets/scan_card_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('ScanCard displays score', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ScanCard(
            scan: ScanResult(score: 8.5),
          ),
        ),
      ),
    );
    
    expect(find.text('8.5'), findsOneWidget);
  });
}
```

### Running Tests
```bash
# All tests
flutter test

# Specific file
flutter test test/services/api_service_test.dart

# With coverage
flutter test --coverage

# Watch mode (re-run on changes)
flutter test --watch
```

## Documentation

### Code Comments

```dart
// Use doc comments for public APIs
/// Fetches scan results from the database.
///
/// Returns a list of [ScanResult] objects ordered by date.
/// Throws [DatabaseException] if the database is unavailable.
Future<List<ScanResult>> getScans() async {
  // Implementation comments for complex logic
  final db = await database;
  return db.query('scans');
}
```

### README Updates

When adding a new feature:
1. Update app-specific README
2. Update monorepo README if it affects multiple apps
3. Add usage examples
4. Document any new configuration

### Changelog

Update CHANGELOG.md (if exists):
```markdown
## [Unreleased]

### Added
- Dark mode support for all screens

### Fixed
- Crash on startup when database is unavailable

### Changed
- Updated minimum SDK version to 3.0.0
```

## Pull Request Process

### PR Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
- [ ] Unit tests pass
- [ ] Widget tests pass
- [ ] Manual testing completed
- [ ] No new warnings

## Screenshots (if applicable)
[Add screenshots here]

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Comments added for complex code
- [ ] Documentation updated
- [ ] No breaking changes (or documented)
```

### Review Process

1. **Automatic Checks**
   - Tests must pass
   - Code analysis must pass
   - Formatting must be correct

2. **Manual Review**
   - Code quality
   - Test coverage
   - Documentation
   - Performance implications

3. **Feedback**
   - Address all comments
   - Push updates to same branch
   - Request re-review when ready

4. **Merge**
   - Approved by maintainer
   - All checks passed
   - Conflicts resolved

## Issue Reporting

### Bug Reports

Use this template:

```markdown
**Describe the bug**
Clear and concise description

**To Reproduce**
Steps to reproduce:
1. Go to '...'
2. Click on '...'
3. See error

**Expected behavior**
What you expected to happen

**Screenshots**
If applicable, add screenshots

**Environment:**
- Device: [e.g. iPhone 12, Pixel 5]
- OS: [e.g. iOS 15, Android 12]
- App Version: [e.g. 1.2.3]
- Flutter Version: [e.g. 3.10.0]

**Additional context**
Any other information
```

### Feature Requests

Use this template:

```markdown
**Is your feature request related to a problem?**
Clear description of the problem

**Describe the solution you'd like**
Clear description of desired feature

**Describe alternatives you've considered**
Other solutions you've thought about

**Additional context**
Mockups, examples, etc.
```

## Questions?

- Check existing [documentation](../README.md)
- Search [existing issues](https://github.com/organization/repository/issues)
- Ask in [discussions](https://github.com/organization/repository/discussions)
- Contact maintainers

## Recognition

Contributors will be recognized in:
- CONTRIBUTORS.md file
- Release notes
- GitHub contributors page

## License

By contributing, you agree that your contributions will be licensed under the same license as the project (MIT License).

---

Thank you for contributing! 🎉

**Last Updated:** 2025-01-11  
**Maintained By:** Development Team
