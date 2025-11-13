---
name: Git Merge Branches
description: This skill should be used when integrating multiple feature branches into the main branch. It automates the process of merging branches, checking for conflicts, running tests after merging, pushing synchronized changes to the remote repository, and closing merged branches. This is ideal for projects with a Claude-based workflow where multiple feature branches need to be consolidated into the main branch and synchronized with the team.
---

# Git Merge Branches

This skill automates the process of merging multiple feature branches into the main branch while ensuring quality control through conflict detection and test validation. It also handles synchronization of changes with the remote repository and automatically closes merged branches to keep the repository clean and prevent accidental re-merges.

## When to Use This Skill

Use this skill when you need to:
- Merge multiple feature branches (typically named `claude/description-<id>`) into the main branch
- Check for merge conflicts before completing merges
- Run tests after merging to ensure code quality
- Fix any errors that arise from the merge
- Push synchronized changes to the remote repository
- Close merged feature branches to keep the repository clean
- Maintain code synchronization across team members

## How to Use This Skill

### Step 1: Identify Branches to Merge

To begin the merge process, list all remote branches and identify which ones need to be merged into main:

```bash
git branch -a
```

Look for branches following the naming pattern `origin/claude/feature-description-<id>`.

### Step 2: Execute Merges

For each branch to merge:

1. **Merge the branch** into main using:
   ```bash
   git merge origin/<branch-name> --no-edit
   ```

2. **Check for conflicts**. If conflicts appear, resolve them manually in the affected files.

3. **Commit the merge** if conflicts were resolved.

### Step 3: Run Tests

After all branches are merged:

1. **Identify the test framework** used by the project (e.g., `flutter test`, `npm test`, `pytest`)

2. **Run tests** using the appropriate command for your project

3. **Fix any errors** that tests reveal:
   - Read error messages carefully
   - Identify affected files
   - Make corrections
   - Re-run tests to verify fixes

### Step 4: Push Changes to Remote Repository

After successful merges and tests, synchronize your changes with the remote:

1. **Review all staged changes**:
   ```bash
   git status
   ```

2. **Create a merge commit** if not already created:
   ```bash
   git add -A
   git commit -m "Merge feature branches into main"
   ```

3. **Push to remote**:
   ```bash
   git push origin main
   ```

4. **Verify push was successful**:
   ```bash
   git log --oneline -5
   git status
   ```

### Step 6: Close Merged Feature Branches

After successful merge and push, delete the remote branches to keep the repository clean:

1. **Delete remote branches** that have been merged:
   ```bash
   git push origin --delete <branch-name>
   ```

   Or delete multiple branches:
   ```bash
   git push origin --delete branch1 branch2 branch3
   ```

2. **Verify branches are deleted**:
   ```bash
   git branch -a
   ```

3. **Clean up local branch references** (optional):
   ```bash
   git remote prune origin
   ```

### Step 7: Verify Final Integration

After all branches are deleted, verify the final state:

```bash
git status
git log --oneline -5
git branch -a
```

This ensures a clean repository and prevents accidentally re-merging already-integrated branches.

## Common Branch Naming Patterns

- `claude/fix-<feature>-<id>` - Bug fixes
- `claude/add-<feature>-<id>` - New features
- `claude/<description>-<id>` - General changes

## Conflict Resolution

If merge conflicts occur:

1. Open the affected files
2. Look for conflict markers: `<<<<<<<`, `=======`, `>>>>>>>`
3. Choose the correct version or combine both
4. Remove conflict markers
5. Save and stage the file: `git add <file>`
6. Complete the merge

## Error Handling During Tests

If tests fail after merging:

1. Read the test output carefully to identify the failing test
2. Locate the affected code
3. Analyze what changed in the merge that caused the failure
4. Make targeted fixes
5. Re-run tests to verify the fix

## Project-Specific Configuration

This skill is configured for projects with:
- A `main` branch as the integration target
- Remote branches following the `claude/*` naming convention
- Automated testing via Flutter, npm, or similar frameworks
