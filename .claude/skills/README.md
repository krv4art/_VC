# Claude Skills for ACS Project

This directory contains custom skills for Claude Code to help with common development tasks in the ACS (AI Cosmetic Scanner) project.

## Available Skills

### 🔧 Refactoring & Code Quality

#### `refactor-complexity.md`
Analyzes files for high cyclomatic complexity and proposes modularization strategies.

**Use when**:
- File exceeds 500-1000 lines
- Methods have complexity > 10
- Code duplication detected
- Need to improve testability

**Example usage**:
```
Please analyze lib/screens/my_screen.dart for cyclomatic complexity and propose refactoring
```

**Key features**:
- Calculates cyclomatic complexity metrics
- Proposes service/widget extraction
- Creates refactoring plan in phases
- Provides implementation guidelines
- Based on real successful refactoring (scanning_screen: 1,593 → 363 lines)

**Output**:
- Initial analysis with metrics
- Detailed refactoring plan
- Code examples
- Expected improvements
- Documentation updates

---

### 🌍 Localization

#### `localization-add-language.json`
Adds a new language to the application with all required translations and configurations.

**Example usage**:
```
Add French (fr) language support
```

#### `localization-check.json`
Checks the integrity of localization files and identifies issues.

**Example usage**:
```
Check localization files for issues
```

#### `localization-find-missing.json`
Finds missing translations across all language files.

**Example usage**:
```
Find missing translations in Ukrainian
```

#### `localization-regenerate.json`
Regenerates localization files after adding new keys.

**Example usage**:
```
Regenerate localization files
```

---

## How to Use Skills

Skills are automatically available in Claude Code. Simply describe what you want to do, and Claude will invoke the appropriate skill.

### Natural Language Examples

**For Refactoring**:
- "Check this screen for cyclomatic complexity"
- "Refactor this file to reduce complexity"
- "Modularize this large file"
- "Extract services from this screen"

**For Localization**:
- "Add German language support"
- "Check for missing translations"
- "Find untranslated keys in Spanish"
- "Regenerate l10n files"

### Direct Skill Invocation

You can also directly invoke skills by mentioning them:
```
Use the refactor-complexity skill on lib/screens/profile_screen.dart
```

---

## Creating New Skills

To create a new skill:

1. Create a new file in this directory:
   - `.md` for text-based skills (like refactor-complexity.md)
   - `.json` for structured skills (like localization skills)

2. Follow the skill template structure:
```markdown
# Skill Name

## Purpose
Clear description of what the skill does

## When to Use
Specific scenarios when this skill is helpful

## Process
Step-by-step process

## Expected Outcomes
What to expect after using the skill

## Examples
Real-world examples from the project
```

3. Document the skill in this README.md

---

## Skill Best Practices

### For Text Skills (.md)
- Be specific and actionable
- Include real examples from the project
- Provide metrics and measurements
- Include code samples
- Reference existing documentation

### For JSON Skills (.json)
- Use clear, descriptive names
- Include helpful prompts
- Provide examples in descriptions
- Test with real scenarios

---

## Skills Directory Structure

```
.claude/skills/
├── README.md (this file)
│
├── 🔧 Code Quality
│   └── refactor-complexity.md
│
└── 🌍 Localization
    ├── localization-add-language.json
    ├── localization-check.json
    ├── localization-find-missing.json
    └── localization-regenerate.json
```

---

## Skill Versions

| Skill | Version | Last Updated | Status |
|-------|---------|--------------|--------|
| refactor-complexity | 1.0 | Jan 2025 | ✅ Active |
| localization-add-language | 1.0 | Nov 2024 | ✅ Active |
| localization-check | 1.0 | Nov 2024 | ✅ Active |
| localization-find-missing | 1.0 | Nov 2024 | ✅ Active |
| localization-regenerate | 1.0 | Nov 2024 | ✅ Active |

---

## Contributing

When adding new skills:
1. Follow the existing patterns
2. Test thoroughly with real scenarios
3. Document in this README
4. Update the skills table
5. Add examples from actual project usage

---

## References

- [Claude Code Skills Documentation](https://docs.claude.com/claude-code/skills)
- [ACS Project Documentation](../docs/README.md)
- [Architecture Guide](../docs/ARCHITECTURE.md)
- [Scanning Screen Refactoring Example](../docs/SCANNING_SCREEN_REFACTORING.md)

---

**Last Updated**: January 2025
**Maintained by**: ACS Development Team
