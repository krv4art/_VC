#!/bin/bash

# Git Merge Branches Script
# Automates merging multiple feature branches into main
# Usage: ./merge_branches.sh [target_branch] [test_command]
# Example: ./merge_branches.sh main "flutter test"

set -e

# Default values
TARGET_BRANCH="${1:-main}"
TEST_COMMAND="${2:-flutter test}"
BRANCHES_MERGED=0
BRANCHES_FAILED=0
FAILED_BRANCHES=()

echo "==============================================="
echo "Git Merge Branches Automation"
echo "==============================================="
echo "Target branch: $TARGET_BRANCH"
echo "Test command: $TEST_COMMAND"
echo ""

# Ensure we're on the target branch
echo "Checking out $TARGET_BRANCH..."
git checkout "$TARGET_BRANCH" || {
    echo "ERROR: Could not checkout $TARGET_BRANCH"
    exit 1
}

# Update from remote
echo "Updating from remote..."
git pull origin "$TARGET_BRANCH" || {
    echo "WARNING: Could not pull latest from origin/$TARGET_BRANCH"
}

echo ""
echo "Finding branches to merge..."

# Get all remote branches matching the pattern
BRANCHES=$(git branch -r | grep -E "origin/(claude|feature)/" | sed 's/^\s*//' | grep -v "origin/$TARGET_BRANCH")

if [ -z "$BRANCHES" ]; then
    echo "No branches found to merge."
    exit 0
fi

echo "Found branches:"
echo "$BRANCHES"
echo ""

# Merge each branch
MERGED_BRANCHES=()
while IFS= read -r BRANCH; do
    BRANCH_NAME=$(echo "$BRANCH" | sed 's/^origin\///')
    echo "================================================"
    echo "Merging: $BRANCH_NAME"
    echo "================================================"

    if git merge "$BRANCH" --no-edit; then
        echo "✓ Successfully merged: $BRANCH_NAME"
        ((BRANCHES_MERGED++))
        MERGED_BRANCHES+=("$BRANCH_NAME")
    else
        echo "✗ Failed to merge: $BRANCH_NAME"
        FAILED_BRANCHES+=("$BRANCH_NAME")
        ((BRANCHES_FAILED++))

        # Try to abort the merge
        git merge --abort || true
    fi
    echo ""
done <<< "$BRANCHES"

# Summary
echo "================================================"
echo "Merge Summary"
echo "================================================"
echo "Branches merged: $BRANCHES_MERGED"
echo "Branches failed: $BRANCHES_FAILED"

if [ $BRANCHES_FAILED -gt 0 ]; then
    echo ""
    echo "Failed branches:"
    for branch in "${FAILED_BRANCHES[@]}"; do
        echo "  - $branch"
    done
    echo ""
    echo "Please resolve conflicts manually and retry."
    exit 1
fi

# Run tests if merge was successful
if [ $BRANCHES_MERGED -gt 0 ]; then
    echo ""
    echo "Running tests: $TEST_COMMAND"
    echo "================================================"

    if eval "$TEST_COMMAND"; then
        echo ""
        echo "✓ All tests passed!"

        # Push changes to remote
        echo ""
        echo "Pushing changes to remote..."
        echo "================================================"

        if git push origin "$TARGET_BRANCH"; then
            echo "✓ Changes pushed to remote successfully!"

            # Delete merged branches
            if [ ${#MERGED_BRANCHES[@]} -gt 0 ]; then
                echo ""
                echo "Deleting merged branches..."
                echo "================================================"

                for branch in "${MERGED_BRANCHES[@]}"; do
                    if git push origin --delete "$branch"; then
                        echo "✓ Deleted: $branch"
                    else
                        echo "✗ Failed to delete: $branch"
                    fi
                done

                echo ""
                echo "Cleaning up local branch references..."
                git remote prune origin

                echo "✓ Repository cleanup complete!"
            fi

            echo ""
            echo "✓ Merge completed, synchronized, and cleaned up!"
            exit 0
        else
            echo "✗ Failed to push to remote"
            echo "Please push manually: git push origin $TARGET_BRANCH"
            exit 1
        fi
    else
        echo ""
        echo "✗ Tests failed after merge"
        echo "Please fix the errors and retry."
        exit 1
    fi
else
    echo ""
    echo "No branches were merged. Nothing to test."
    exit 0
fi
