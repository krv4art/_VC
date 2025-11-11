# Documentation Index

Welcome to the documentation for the AI Apps Monorepo!

## 📚 Table of Contents

### Monorepo Documentation
Learn about the overall structure and architecture of this monorepo.

- **[Architecture Overview](./monorepo/ARCHITECTURE.md)**  
  Comprehensive guide to the shared architecture, technology stack, and design patterns used across all applications.

- **[Development Guidelines](./monorepo/DEVELOPMENT.md)**  
  Coding standards, development workflow, testing guidelines, and best practices for contributing to the projects.

- **[Contributing Guide](./monorepo/CONTRIBUTING.md)**  
  How to contribute to the projects, code of conduct, pull request process, and issue reporting.

- **[Shared Components](./monorepo/SHARED_COMPONENTS.md)**  
  Common components, patterns, and code shared across multiple applications in the monorepo.

---

### Tools & Utilities
Documentation for tools and scripts that help with development and deployment.

#### Google Play Console Uploader
Automation tool for uploading app descriptions in multiple languages to Google Play Console.

- **[Google Play Uploader Overview](./tools/google-play-uploader/README.md)**  
  Introduction to the tool and quick start guide.

- **[Quick Start Guide](./tools/google-play-uploader/QUICK_START.md)**  
  Get started in 5 minutes with step-by-step instructions.

- **[Cheat Sheet](./tools/google-play-uploader/CHEATSHEET.md)**  
  Quick reference for common commands and operations.

- **[Complete Upload Guide](./tools/google-play-uploader/UPLOAD_GUIDE.md)**  
  Comprehensive guide with all details, troubleshooting, and advanced usage.

- **[Full Index](./tools/google-play-uploader/INDEX.md)**  
  Complete navigation through all uploader features and documentation.

#### Localization Analysis
Tools and reports for analyzing localization structure across apps.

- **[Localization Overview](./tools/localization/README.md)**  
  Analysis of localization structure, supported languages, and usage guidelines.

---

### Application-Specific Documentation
Each application has its own detailed documentation.

- **[ACS (AI Cosmetic Scanner)](../acs/README.md)**
  - [Architecture](../acs/docs/ARCHITECTURE.md)
  - [API Integration](../acs/docs/API_INTEGRATION.md)
  - [Design System](../acs/docs/DESIGN_SYSTEM.md)
  - [More docs...](../acs/docs/)

- **[Bug Identifier](../bug_identifier/README.md)**
  - [Architecture](../bug_identifier/docs/ARCHITECTURE.md)
  - [Design System](../bug_identifier/docs/DESIGN_SYSTEM.md)
  - [More docs...](../bug_identifier/docs/)

- **[Plant Identifier](../plant_identifier/README.md)**
  - App-specific documentation

- **[MAS (Math AI Solver)](../MAS/README.md)**
  - [Getting Started](../MAS/GETTING_STARTED.md)
  - [Fixes Summary](../MAS/MAS_FIXES_SUMMARY.md)

- **[Unseen](../unseen/README.md)**
  - [Verification Report](../unseen/VERIFICATION_REPORT.md)

---

## 🚀 Quick Links

### For New Developers
1. Read the [Architecture Overview](./monorepo/ARCHITECTURE.md)
2. Follow the [Development Guidelines](./monorepo/DEVELOPMENT.md)
3. Check [Contributing Guide](./monorepo/CONTRIBUTING.md)
4. Choose an app and read its specific README

### For Contributors
1. Review [Contributing Guide](./monorepo/CONTRIBUTING.md)
2. Check [Coding Standards](./monorepo/DEVELOPMENT.md#coding-standards)
3. Look for open issues in the app you want to work on
4. Follow the pull request process

### For Tool Users
1. **Google Play Upload:** Start with [Quick Start](./tools/google-play-uploader/QUICK_START.md)
2. **Localization:** Check [Localization Overview](./tools/localization/README.md)

---

## 📁 Documentation Structure

```
docs/
├── README.md                                    # This file
├── monorepo/                                    # Monorepo-wide documentation
│   ├── ARCHITECTURE.md                         # Architecture overview
│   ├── DEVELOPMENT.md                          # Development guidelines
│   ├── CONTRIBUTING.md                         # How to contribute
│   └── SHARED_COMPONENTS.md                    # Shared components guide
└── tools/                                       # Tool-specific documentation
    ├── google-play-uploader/                   # Google Play upload tool
    │   ├── README.md                           # Tool overview
    │   ├── QUICK_START.md                      # Quick start guide
    │   ├── CHEATSHEET.md                       # Command reference
    │   ├── UPLOAD_GUIDE.md                     # Complete guide
    │   ├── INDEX.md                            # Full navigation
    │   ├── FILES_SUMMARY.txt                   # Created files summary
    │   └── SETUP_COMPLETE.txt                  # Setup report
    └── localization/                            # Localization analysis
        ├── README.md                            # Analysis overview
        ├── LOCALIZATION_FULL_REPORT.txt        # Full report
        └── localization_analysis.txt            # Analysis summary
```

---

## 💡 Tips

- **Search**: Use your IDE's search function to find specific topics across all documentation
- **Links**: All internal links are relative and should work in GitHub and locally
- **Updates**: Documentation is kept up-to-date with code changes
- **Feedback**: If something is unclear, please open an issue or submit a PR

---

## 📞 Getting Help

- **General Questions**: Check [Development Guidelines](./monorepo/DEVELOPMENT.md)
- **Contributing**: See [Contributing Guide](./monorepo/CONTRIBUTING.md)
- **App-Specific**: Check the app's own documentation
- **Tools**: See specific tool documentation under `tools/`

---

**Last Updated:** 2025-01-11  
**Maintained By:** Development Team
