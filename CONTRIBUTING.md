Contributing to Flowery Rider
To ensure consistent code quality and avoid issues in Pull Requests, follow these guidelines:
Code Formatting

Branch Naming Conventions
To ensure branches are organized and the GitHub Actions workflow passes, follow these rules:

Feature Branches: Start with feature/ followed by a descriptive name (e.g., feature/login-screen, feature/add-payment).
Bugfix Branches: Start with bugfix/ followed by a descriptive name (e.g., bugfix/fix-crash-on-login, bugfix/ui-alignment).
Hotfix Branches: Start with hotfix/ followed by a descriptive name (e.g., hotfix/patch-security-issue, hotfix/fix-api-error).

Commands to Run Before Committing
Run these commands locally to ensure the GitHub Actions workflow passes:

dart format . - Formats code and fixes spacing/blank lines.
flutter analyze - Checks for linting issues (must pass with no errors).
flutter test - Runs all tests (must pass with no failures).

Example:
dart format .
flutter analyze
flutter test

Notes

If flutter analyze fails, fix the reported issues (e.g., empty statements, unused imports).
If flutter test fails, ensure all tests pass (check test/widget_test.dart or other test files).
If the branch name does not follow the conventions (e.g., does not start with feature/, bugfix/, or hotfix/), the workflow will fail.
The workflow will fail if linting or tests fail, so running these commands locally saves time.

