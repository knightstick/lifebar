# BDD Workflow & Continuous Delivery

## Core Philosophy: Ship Working Software Every Hour

The primary development approach is **continuous delivery of small, working slices**. Every feature implementation should result in deployable software within 1 hour or less.

## BDD Cycle (Red-Green-Refactor)

### 1. Write Failing Cucumber Feature (Red)
```bash
# Write a single, focused Cucumber scenario
bundle exec cucumber features/new_feature.feature
# Should fail - no implementation exists yet
```

### 2. Implement Minimal Code (Green)
- Write the **absolute minimum** code to make the Cucumber feature pass
- Don't build extra functionality "just in case"
- Focus on the happy path first
- Ignore edge cases until they have their own scenarios

### 3. Commit & Deploy (Ship)
```bash
git add .
git commit -m "Implement [feature]: [brief description]"
git push origin feature-branch
# Create PR, merge to main, auto-deploy
```

### 4. Refactor (Clean)
- Only refactor if the code is working and deployed
- Keep refactoring commits separate and small
- Each refactor should also be deployable

## Walking Skeleton Approach

### Phase 1: Deployable Foundation (30 minutes)
- Generate Rails app with basic gems
- Create simple homepage with "Hello World"
- Set up CI/CD pipeline
- Deploy to production with working HTTPS
- **Result**: Fully functional deployment pipeline

### Phase 2: End-to-End Slice (45 minutes)
- Write Cucumber feature: "User can create a basic task"
- Implement Task model, controller, and views
- Make feature pass with working create/list flow
- Deploy and verify in production
- **Result**: Core domain working end-to-end

### Phase 3: Incrtal Features (30-45 minutes each)
Each subsequent feature follows the same pattern:
1. Write Cucumber scenario (5 minutes)
2. Implement minimal code (20-30 minutes)
3. Deploy and verify (5-10 minutes)

## Feature Slicing Strategy

### Vertical Slices (Good)
✅ "User can create a task with weekly interval"
- Touches all layers: UI → Controller → Model → Database
- Delivers working functionality
- Can be demonstrated to users

### Horizontal Slices (Avoid)
❌ "Implement all Task model methods"
- Only touches one layer
- No user-visible functionality
- Cannot be demonstrated

## Cucumber Feature Writing Guidelines

### One Scenario Per Slice
```gherkin
Feature: Task Creation
  Scenario: User creates a weekly task
    Given I am on the homepage
    When I click "Create Task"
    And I fill in "Task Name" with "Take out trash"
    And I select "Weekly" from "Interval"
    And I click "Create Task"
    Then I should see "Take out trash" in my task list
    And I should see a green status bar
```

### Focus on User Value
- Write scenarios from user perspective
- Describe behavior, not implementation
- Each scenario should deliver visible value
- Avoid technical implementation details

## Deployment Cadence

### Continuous Integration
- Every commit triggers full test suite
- All Cucumber features must pass
- All RSpec tests must pass
- No merge without green CI

### Continuous Deployment
- Merge to `main` triggers automatic deployment
- Database migrations run automatically
- Health checks verify deployment success
- Rollback capability for failures

### Feature Branch Lifecycle
```bash
# Start new feature (from main)
git checkout -b feature/user-can-edit-tasks

# Write failing Cucumber feature
# Implement minimal code
# Commit when feature passes

git add .
git commit -m "User can edit task name and interval"
git push origin feature/user-can-edit-tasks

# Create PR, get CI green, merge immediately
# Feature is live in production within minutes
```

## Quality Gates

### Before Merge
- [ ] Cucumber feature passes
- [ ] All existing features still pass
- [ ] RSpec tests pass
- [ ] Code follows Rails conventions
- [ ] Feature works in CI environment

### After Deployment
- [ ] Feature works in production
- [ ] No errors in production logs
- [ ] Database migrations completed successfully
- [ ] Health check endpoints respond

## Time Boxing

### Maximum Time Limits
- **Single feature slice**: 45 minutes max
- **Bug fix**: 30 minutes max
- **Refactoring**: 30 minutes max
- **If exceeded**: Stop, commit what works, deploy, then continue

### Minimum Viable Implementation
- Get the Cucumber scenario to pass
- Handle only the happy path
- Use hardcoded values if needed initially
- Add error handling in separate slices

## Example Feature Implementation Timeline

### "User can mark task complete" (40 minutes total)

**Minutes 0-5: Write Cucumber scenario**
```gherkin
Scenario: User completes a task
  Given I have a task "Water plants"
  When I click "Complete" next to "Water plants"
  Then I should see "Water plants" with a green status bar
```

**Minutes 5-25: Implement minimal code**
- Add `complete` action to TasksController
- Add "Complete" button to task list
- Update `last_completed_at` timestamp
- Make scenario pass

**Minutes 25-35: Test and commit**
- Run full Cucumber suite
- Fix any breaking changes
- Commit and push

**Minutes 35-40: Deploy and verify**
- Create PR and merge
- Verify deployment success
- Test feature in production

## Anti-Patterns to Avoid

### Over-Engineering
❌ Building complex status bar calculations before basic completion works
❌ Adding user authentication before core features exist
❌ Implementing all CRUD operations at once

### Batch Development
❌ Working on multiple features simultaneously
❌ Large commits with multiple changes
❌ Waiting days/weeks before deployment

### Perfect Code Syndrome
❌ Spending hours on "perfect" implementation
❌ Adding features not covered by Cucumber scenarios
❌ Extensive refactoring before deployment

## Success Metrics

### Development Velocity
- **Target**: Deploy working feature every 30-45 minutes
- **Measure**: Time from feature start to production deployment
- **Goal**: Consistent, predictable delivery rhythm

### Quality Indicators
- All Cucumber scenarios pass in production
- Zero production errors from new features
- Features work exactly as described in scenarios
- Users can immediately use new functionality

This workflow ensures rapid, reliable delivery of working software while maintaining quality through automated testing and continuous feedback.
