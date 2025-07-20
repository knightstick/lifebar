# Implementation Plan

- [x] 1. Create walking skeleton with deployable homepage
  - Generate new Rails 8.0.2 application with essential gems (Cucumber, RSpec, Tailwind)
  - Configure PlanetScale database connection
  - Set up basic CI/CD pipeline with GitHub Actions
  - Create simple homepage with "Recurring Task Manager" title
  - Deploy to Railway and verify end-to-end pipeline works
  - Write passing Cucumber feature: "User can visit homepage"
  - _Requirements: Foundation for all subsequent features_

- [x] 2. User can create a basic task (end-to-end slice)
  - Write Cucumber feature: "User can create a task with name and weekly interval"
  - Create Task model, migration, and validations (driven by failing feature)
  - Create TasksController with new/create actions
  - Create task creation form and success page
  - Implement basic task storage with default weekly interval
  - Make Cucumber feature pass with working create task flow
  - _Requirements: 1.1, 1.2, 1.5_

- [ ] 3. Verify deployment and database connectivity (manual verification)
  - Run application locally in development mode and verify task creation works
  - Run database migrations in development: `rails db:migrate`
  - Test full task creation flow manually in browser
  - Deploy current state to Railway with PlanetScale database
  - Verify Railway deployment is accessible and functional
  - Test task creation in production environment
  - Confirm database connectivity and data persistence in production
  - _Requirements: Deployment verification before continuing with features_

- [ ] 4. User can view their tasks on a dashboard
  - Write Cucumber feature: "User can see list of their created tasks"
  - Create tasks index view showing task names and creation dates
  - Add navigation from homepage to task dashboard
  - Add "Create New Task" link on dashboard
  - Style with basic Tailwind CSS for clean presentation
  - Make Cucumber feature pass with working task list display
  - _Requirements: 2.1, 2.6_

- [ ] 5. User can create tasks with different intervals
  - Write Cucumber feature: "User can create daily, weekly, monthly, and custom interval tasks"
  - Add interval_type enum to Task model (daily, weekly, monthly, custom)
  - Add interval_value field for custom intervals
  - Update task creation form with interval selection
  - Add form validation and conditional custom interval field
  - Make Cucumber feature pass with all interval types working
  - _Requirements: 1.1, 1.2, 1.3, 1.4_

- [ ] 6. User can see basic task status (without visual bars yet)
  - Write Cucumber feature: "User can see if tasks are due, overdue, or recently completed"
  - Add last_completed_at field to Task model
  - Implement next_due_date and overdue? methods on Task model
  - Display text status (e.g., "Due in 3 days", "Overdue by 1 day") on dashboard
  - Add basic status styling (green/yellow/red text colors)
  - Make Cucumber feature pass with working status display
  - _Requirements: 6.1, 6.6_

- [ ] 7. User can mark tasks as complete
  - Write Cucumber feature: "User can mark a task complete and see it reset"
  - Create TaskCompletion model and migration
  - Add complete action to TasksController
  - Implement transactional mark_completed! method
  - Add "Complete" button to each task on dashboard
  - Update task status after completion and redirect to dashboard
  - Make Cucumber feature pass with working task completion
  - _Requirements: 3.1, 3.2, 3.3, 3.4, 3.5_

- [ ] 8. User can see visual status bars (Sims-style)
  - Write Cucumber feature: "User sees green-to-red status bars that change over time"
  - Implement completion_percentage and status_color methods on Task model
  - Create CSS classes for status bar gradients (green/yellow/red)
  - Replace text status with visual progress bars on dashboard
  - Add percentage text alongside visual bars
  - Make Cucumber feature pass with working visual status bars
  - _Requirements: 2.2, 2.3, 2.4, 2.5, 6.2, 6.3, 6.4, 6.5_

- [ ] 9. User can edit existing tasks
  - Write Cucumber feature: "User can edit task name and interval"
  - Add edit/update actions to TasksController
  - Create task edit form with pre-populated values
  - Handle interval changes and due date recalculation
  - Add "Edit" link to each task on dashboard
  - Make Cucumber feature pass with working task editing
  - _Requirements: 4.1, 4.2, 4.3, 4.4, 4.5_

- [ ] 10. User can delete tasks they no longer need
  - Write Cucumber feature: "User can delete a task with confirmation"
  - Add destroy action to TasksController with confirmation
  - Add "Delete" link with JavaScript confirmation dialog
  - Handle cascade deletion of TaskCompletion records
  - Show success message after deletion
  - Make Cucumber feature pass with working task deletion
  - _Requirements: 5.1, 5.2, 5.3, 5.4_

- [ ] 11. Polish user experience and handle edge cases
  - Write Cucumber features for error scenarios and validation
  - Add comprehensive form validation with user-friendly error messages
  - Implement 404 handling for non-existent tasks
  - Add loading states and smooth transitions
  - Ensure mobile-responsive design across all views
  - Make all Cucumber features pass with polished user experience
  - _Requirements: 1.4, 4.4, 5.4 - validation and error handling aspects_
