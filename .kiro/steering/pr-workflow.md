# PR Workflow with GitHub CLI

## Creating Pull Requests

Always use the GitHub CLI (`gh`) to create pull requests instead of directing users to GitHub URLs.

### Standard PR Creation Command
```bash
gh pr create --title "Task Title" --body "PR Description"
```

### PR Title Format
Use the exact task name from the tasks.md file:
- Example: `User can create a basic task (end-to-end slice)`
- Example: `User can view their tasks on a dashboard`

### PR Description Template
```markdown
Implements task X from the recurring task manager spec.

## What's included:
- ✅ [Feature 1 description]
- ✅ [Feature 2 description]
- ✅ [Feature 3 description]

## Testing:
- All Cucumber features pass (X/X)
- [Specific test results]

## Next steps:
Ready for task X+1: [Next task description]
```

### Workflow Steps
1. Ensure all tests pass: `bundle exec cucumber && bundle exec rspec`
2. Push branch: `git push origin feature-branch-name`
3. Create PR: `gh pr create --title "Task Title" --body "Description"`
4. **STOP** - Let user review and merge the PR

### Important Notes
- **NEVER merge PRs automatically** - only the user should merge PRs
- After creating PR, inform user it's ready for review
- Wait for user to merge before proceeding to next task

## Branch Management

### Branch Naming Convention
- `feature/task-description` (kebab-case)
- Example: `feature/create-basic-task`
- Example: `feature/visual-status-bars`

### After User Merges PR
Only after user confirms the PR has been merged, clean up by:
1. Return to main branch and pull latest changes:
```bash
git checkout main
git pull origin main
```
2. Delete the local feature branch (if it still exists):
```bash
git branch -d feature/branch-name
```

### Cleanup Instructions
- Wait for user to explicitly tell you "it's merged" or similar confirmation
- Only then perform the cleanup steps above
- This ensures we're always working from the latest main branch for the next task
