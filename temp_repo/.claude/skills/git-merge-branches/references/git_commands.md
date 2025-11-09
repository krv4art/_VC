# Git Commands Reference

## Basic Merge Operations

### List all branches
```bash
git branch -a
```

Shows all local and remote branches. Remote branches are prefixed with `origin/`.

### Check current branch and status
```bash
git status
git branch
```

### Switch to main branch
```bash
git checkout main
```

### Merge a specific branch
```bash
git merge origin/<branch-name> --no-edit
```

The `--no-edit` flag automatically creates a merge commit without prompting for a message.

### Merge with auto-strategy (recommended for fast-forward)
```bash
git merge origin/<branch-name> -ff-only
```

This only works if the merge can be done as a fast-forward (no new commits on main).

## Conflict Handling

### Check merge status
```bash
git status
```

Shows files with conflicts marked as "both modified".

### View conflicts in a file
```bash
git diff <file>
```

Shows the specific conflict regions with `<<<<<<<`, `=======`, and `>>>>>>>` markers.

### Resolve conflicts and complete merge
```bash
# After editing conflicted files
git add <file>
git commit -m "Merge <branch-name>"
```

### Abort a merge
```bash
git merge --abort
```

Cancels the current merge operation and returns to the previous state.

## Testing and Validation

### Run Flutter tests
```bash
flutter test
```

For Flutter projects, runs all tests in the `test/` directory.

### Run NPM tests
```bash
npm test
```

For Node.js projects, runs tests defined in package.json.

### Run Python tests
```bash
pytest
```

For Python projects, discovers and runs all test files.

## History and Verification

### View recent commits
```bash
git log --oneline -10
```

Shows last 10 commits with shortened commit hashes.

### View full commit details
```bash
git log -p -1
```

Shows full details of the last commit, including changes.

### View what changed in a merge
```bash
git diff HEAD~1..HEAD
```

Shows all changes introduced by the most recent commit.

## Remote Updates

### Fetch updates from remote
```bash
git fetch origin
```

Downloads all remote branch information without making local changes.

### Update main from remote
```bash
git pull origin main
```

Fetches and merges latest main branch from remote.

## Pushing Changes to Remote

### Push single branch
```bash
git push origin main
```

Uploads commits from local branch to remote repository.

### Push with tracking
```bash
git push -u origin main
```

The `-u` flag sets up tracking, making future push/pull operations use the default branch.

### Check push status
```bash
git status
```

Shows if your branch is ahead of the remote and if changes are ready to push.

## Deleting Branches

### Delete single remote branch
```bash
git push origin --delete branch-name
```

Removes a branch from the remote repository after it has been merged.

### Delete multiple remote branches
```bash
git push origin --delete branch1 branch2 branch3
```

Deletes multiple branches in one command.

### Delete local branch
```bash
git branch -d branch-name
```

Removes a local branch. Use `-D` to force delete.

### Clean up local branch references
```bash
git remote prune origin
```

Removes local references to deleted remote branches. Useful after deleting branches on the remote.

## Common Merge Workflows

### Standard merge with conflict handling and push
```bash
# 1. Update local main
git checkout main
git pull origin main

# 2. Merge feature branch
git merge origin/feature-branch --no-edit

# 3. If conflicts, resolve them
# Edit conflicted files...
git add <resolved-file>

# 4. Complete the merge
git commit -m "Merge feature-branch"

# 5. Push to remote
git push origin main
```

### Merge multiple branches sequentially
```bash
git checkout main
git pull origin main

for branch in branch1 branch2 branch3; do
  git merge origin/$branch --no-edit || {
    echo "Merge conflict in $branch"
    exit 1
  }
done

# Run tests (example: flutter test)
flutter test || {
  echo "Tests failed"
  exit 1
}

# Push all merges to remote
git push origin main
```

This workflow:
1. Ensures you have the latest main branch
2. Merges multiple feature branches sequentially
3. Runs tests to validate the merged code
4. Pushes all changes to remote repository to synchronize with the team

## Troubleshooting

### Merge was accidentally started
```bash
git merge --abort
```

### Need to undo a completed merge
```bash
git revert -m 1 <merge-commit-hash>
```

Creates a new commit that undoes the merge.

### Check if branch is fully merged
```bash
git branch --merged main
```

Shows which branches have been merged into main.

### See commits ahead of main
```bash
git log main..<branch>
```

Shows commits in `<branch>` that are not in main.
