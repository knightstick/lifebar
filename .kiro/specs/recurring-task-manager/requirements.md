# Requirements Document

## Introduction

A single-user web application for managing recurring tasks with visual "needs bar" indicators that degrade over time, similar to The Sims game mechanics. Users can create tasks with custom intervals, view their current status through color-coded bars (green to red), and mark tasks as complete to reset the bars. The application will be built using Ruby on Rails with a BDD approach using Cucumber and RSpec, and will use PlanetScale as the database backend.

## Future Features (Not for Initial Implementation)
- Multi-user support (families, roommates)
- Task categories (cleaning, maintenance, personal care)
- Notifications and reminders
- Real-time bar updates
- Gamification elements (points, streaks, achievements)

These features should be recorded, but considered as in the "icebox" and not implemented at this time.

## Requirements

### Requirement 1

**User Story:** As a user, I want to create recurring tasks with custom intervals, so that I can track all my regular responsibilities.

#### Acceptance Criteria

1. WHEN I access the task creation form THEN the system SHALL display fields for task name and interval
2. WHEN I enter a task name and select an interval THEN the system SHALL save the task with a full green bar
3. WHEN I specify a custom interval THEN the system SHALL accept daily, weekly, monthly, or custom day values
4. IF I submit an empty task name THEN the system SHALL display a validation error
5. WHEN a task is created THEN the system SHALL set the initial completion date to the current timestamp

### Requirement 2

**User Story:** As a user, I want to view all my tasks with visual status bars, so that I can quickly see which tasks need attention.

#### Acceptance Criteria

1. WHEN I visit the main dashboard THEN the system SHALL display all my tasks with their current status bars
2. WHEN a task bar is displayed THEN the system SHALL show a color gradient from green (recently completed) to red (overdue)
3. WHEN a task is newly created or just completed THEN the system SHALL display a full green bar
4. WHEN a task approaches its due date THEN the system SHALL display the bar transitioning from green to yellow to red
5. WHEN a task is overdue THEN the system SHALL display a full red bar
6. WHEN I view the dashboard THEN the system SHALL show the task name and current bar status for each task

### Requirement 3

**User Story:** As a user, I want to mark tasks as complete, so that I can reset their status bars and track my progress.

#### Acceptance Criteria

1. WHEN I click a "Complete" button next to a task THEN the system SHALL mark the task as completed
2. WHEN a task is marked complete THEN the system SHALL reset the bar to full green
3. WHEN a task is completed THEN the system SHALL update the last completion timestamp
4. WHEN a task is completed THEN the system SHALL calculate the next due date based on the task's interval
5. WHEN I complete a task THEN the system SHALL redirect me back to the dashboard with updated status

### Requirement 4

**User Story:** As a user, I want to edit existing tasks, so that I can adjust intervals or names as my needs change.

#### Acceptance Criteria

1. WHEN I click an "Edit" link next to a task THEN the system SHALL display an edit form with current values
2. WHEN I update a task name or interval THEN the system SHALL save the changes
3. WHEN I change a task's interval THEN the system SHALL recalculate the next due date from the last completion
4. IF I submit invalid data THEN the system SHALL display validation errors
5. WHEN I save changes THEN the system SHALL redirect me to the dashboard with updated task information

### Requirement 5

**User Story:** As a user, I want to delete tasks I no longer need, so that I can keep my dashboard clean and relevant.

#### Acceptance Criteria

1. WHEN I click a "Delete" link next to a task THEN the system SHALL prompt for confirmation
2. WHEN I confirm deletion THEN the system SHALL permanently remove the task
3. WHEN I cancel deletion THEN the system SHALL return me to the dashboard without changes
4. WHEN a task is deleted THEN the system SHALL redirect me to the dashboard with the task removed

### Requirement 6

**User Story:** As a user, I want the status bars to accurately reflect time passage, so that I can see which tasks are becoming urgent.

#### Acceptance Criteria

1. WHEN I view the dashboard THEN the system SHALL calculate bar status based on time elapsed since last completion
2. WHEN 0% of the interval has passed THEN the system SHALL display a full green bar
3. WHEN 50% of the interval has passed THEN the system SHALL display a yellow-green bar
4. WHEN 80% of the interval has passed THEN the system SHALL display a yellow-red bar
5. WHEN 100% or more of the interval has passed THEN the system SHALL display a full red bar
6. WHEN the page is refreshed THEN the system SHALL recalculate all bar statuses based on current time
