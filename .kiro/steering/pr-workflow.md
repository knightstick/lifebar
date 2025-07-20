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

## Reading and Addressing PR Review Feedback

### When User Says "I left a comment on the PR"

1. **Read PR Reviews and Comments** using GitHub CLI:
```bash
# Check for review comments (inline code comments)
gh api repos/OWNER/REPO/pulls/PR_NUMBER/comments

# Check for general PR reviews
gh api repos/OWNER/REPO/pulls/PR_NUMBER/reviews
```

2. **Parse the Feedback**: Look for the `body` field in the JSON response which contains the actual comment text

3. **Address Each Comment**:
   - Make the requested code changes
   - Improve code quality, naming, or approach as suggested
   - Add tests if requested
   - Update documentation if needed

4. **Commit and Push Changes**:
```bash
git add .
git commit -m "Address PR review feedback: [brief description of changes]"
git push origin feature-branch-name
```

5. **Verify Changes**: Ensure all tests still pass after addressing feedback:
```bash
bundle exec cucumber && bundle exec rspec
```

### Example Review Comment Scenarios

**Code Quality Issues**:
- Improve variable/method naming
- Refactor complex logic
- Add missing validations
- Fix linting issues

**Test-Related Feedback**:
- Improve test selectors (e.g., use semantic data attributes instead of CSS classes)
- Add missing test scenarios
- Make tests more reliable or maintainable

**Architecture/Design Feedback**:
- Refactor to follow better patterns
- Improve separation of concerns
- Enhance error handling

### Best Practices for Addressing Feedback

1. **Be Responsive**: Address feedback promptly and thoroughly
2. **Ask for Clarification**: If feedback is unclear, ask specific questions
3. **Test Thoroughly**: Always run full test suite after making changes
4. **Document Changes**: Use clear commit messages explaining what was addressed
5. **Maintain Functionality**: Ensure changes don't break existing features

### Communication Pattern

When user says they left feedback:
1. Use `gh api` commands to read the actual comments
2. Acknowledge what you found: "I see your comment about [specific issue]"
3. Explain your planned approach to address it
4. Make the changes and commit with descriptive messages
5. Confirm the feedback has been addressed
