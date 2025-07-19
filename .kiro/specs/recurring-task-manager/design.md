# Design Document

## Overview

The Recurring Task Manager is a single-user Rails 7+ application that provides a gamified approach to managing recurring tasks through visual "needs bars" similar to The Sims. The application uses a modern Rails stack with Turbo/Stimulus for interactivity, PlanetScale for database hosting, and follows BDD practices with Cucumber and RSpec.

## Architecture

### Technology Stack
- **Framework**: Ruby on Rails 8.0.2 (latest with Turbo/Stimulus)
- **Database**: MySQL 8.0 via PlanetScale (free tier)
- **Frontend**: Rails views with Turbo Drive/Frames and Stimulus controllers
- **CSS**: Tailwind CSS for styling and responsive design
- **Testing**: Cucumber for BDD feature specs, RSpec for unit/integration tests
- **Deployment**: Railway (free tier)

### Application Structure
```
app/
├── controllers/
│   ├── application_controller.rb
│   └── tasks_controller.rb
├── models/
│   └── task.rb
├── views/
│   ├── layouts/
│   │   └── application.html.erb
│   └── tasks/
│       ├── index.html.erb
│       ├── new.html.erb
│       ├── edit.html.erb
│       └── _task.html.erb
├── javascript/
│   └── controllers/
│       └── task_bar_controller.js
└── assets/
    └── stylesheets/
        └── application.tailwind.css
```

## Components and Interfaces

### Task Model
The core domain model representing a recurring task.

**Attributes:**
- `id`: Primary key (integer)
- `name`: Task name (string, required, max 255 chars)
- `interval_type`: Type of interval (enum: daily, weekly, monthly, custom)
- `interval_value`: Numeric value for custom intervals (integer, days)
- `last_completed_at`: Timestamp of last completion (datetime)
- `created_at`: Record creation timestamp (datetime)
- `updated_at`: Record update timestamp (datetime)

**Methods:**
- `next_due_date`: Calculates when task should next be completed
- `completion_percentage`: Returns 0-100+ based on time elapsed since last completion
- `status_color`: Returns CSS class for bar color (green, yellow, red)
- `overdue?`: Boolean indicating if task is past due date

### TasksController
RESTful controller handling all task operations.

**Actions:**
- `index`: Display dashboard with all tasks and their status bars
- `new`: Show task creation form
- `create`: Process new task creation
- `edit`: Show task editing form
- `update`: Process task updates
- `destroy`: Delete a task
- `complete`: Mark a task as completed (custom action)

### Task Status Bar Component
A reusable component for displaying task status visually.

**Responsibilities:**
- Calculate current completion percentage
- Render appropriate color gradient
- Update via Stimulus when needed
- Handle completion button interaction

## Data Models

### Task Schema
```sql
CREATE TABLE tasks (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  interval_type VARCHAR(20) NOT NULL DEFAULT 'weekly',
  interval_value INT DEFAULT NULL,
  last_completed_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

### Task Completion Log Schema
```sql
CREATE TABLE task_completions (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  task_id BIGINT NOT NULL,
  completed_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (task_id) REFERENCES tasks(id) ON DELETE CASCADE,
  INDEX idx_task_completions_task_id (task_id),
  INDEX idx_task_completions_completed_at (completed_at)
);
```

### Enum Implementation for PlanetScale
Since PlanetScale doesn't support MySQL ENUMs (they cause issues with schema branching), we'll use:
- **Database**: VARCHAR field with validation constraints
- **Rails Model**: ActiveRecord enum with string values
- **Validation**: Rails-level validation to ensure only valid interval types

```ruby
# In Task model
enum interval_type: {
  daily: 'daily',
  weekly: 'weekly',
  monthly: 'monthly',
  custom: 'custom'
}
```

### Validation Rules
- Task name: required, maximum 255 characters
- Interval type: must be one of the defined enum values (daily, weekly, monthly, custom)
- Interval value: required when interval_type is 'custom', must be positive integer
- Last completed at: defaults to creation time for new tasks

### Business Logic
- Daily tasks: due every 1 day
- Weekly tasks: due every 7 days
- Monthly tasks: due every 30 days
- Custom tasks: due every N days (where N is interval_value)
- Task completions are logged for future analytics and history tracking

### Data Consistency Requirements
**Task Completion Transaction**:
When a task is marked complete, both operations must succeed atomically:
1. Create new TaskCompletion record with current timestamp
2. Update Task.last_completed_at to match the TaskCompletion.completed_at

**Implementation**:
```ruby
# In Task model
def mark_completed!
  ActiveRecord::Base.transaction do
    completion = task_completions.create!(completed_at: Time.current)
    update!(last_completed_at: completion.completed_at)
  end
end
```

**PlanetScale Transaction Support**:
- PlanetScale fully supports MySQL transactions
- ACID compliance ensures data consistency
- Rollback on failure prevents partial updates

## User Interface Design

### Dashboard Layout
- Header with application title
- Main content area with task list
- Each task displayed as a card with:
  - Task name
  - Visual status bar (CSS gradient)
  - Completion percentage text
  - "Complete" button
  - "Edit" and "Delete" links

### Status Bar Visual Design
- Width: 100% of container
- Height: 20px
- Border radius: 10px
- Color gradient based on completion percentage:
  - 0-50%: Green (#10B981) to Yellow-Green (#84CC16)
  - 50-80%: Yellow-Green (#84CC16) to Orange (#F59E0B)
  - 80-100%: Orange (#F59E0B) to Red (#EF4444)
  - 100%+: Solid Red (#EF4444)

### Responsive Design
- Mobile-first approach using Tailwind CSS
- Task cards stack vertically on mobile
- Larger screens show grid layout (2-3 columns)
- Touch-friendly button sizes (minimum 44px)

## Error Handling

### Validation Errors
- Display inline validation messages using Rails flash system
- Highlight invalid form fields with red borders
- Preserve user input on validation failure

### Database Errors
- Graceful handling of connection issues
- User-friendly error messages for constraint violations
- Logging of technical errors for debugging

### User Experience Errors
- 404 pages for non-existent tasks
- Confirmation dialogs for destructive actions (delete)
- Success messages for completed actions

## Testing Strategy

### BDD with Cucumber
Feature files covering main user journeys:
- `features/manage_tasks.feature`: Creating, editing, deleting tasks
- `features/complete_tasks.feature`: Marking tasks complete and bar reset
- `features/view_dashboard.feature`: Dashboard display and status calculations

### Unit Testing with RSpec
- `spec/models/task_spec.rb`: Task model validations and business logic
- `spec/controllers/tasks_controller_spec.rb`: Controller action behavior
- `spec/helpers/`: View helper methods for status calculations

### Integration Testing
- Request specs for full HTTP request/response cycles
- System specs for JavaScript interactions (Stimulus controllers)
- Database integration tests for PlanetScale compatibility

### Test Data Management
- Factory Bot for test data creation
- Rails built-in transactional fixtures for test isolation (Database Cleaner not needed for standard RSpec)
- Cucumber may require Database Cleaner for feature specs if using JavaScript drivers
- Fixtures for consistent test scenarios

## Performance Considerations

### Database Optimization
- Index on `last_completed_at` for status calculations
- Consider caching completion percentages for large datasets (future optimization)
- Use database-level date calculations where possible

### Frontend Performance
- Turbo Drive for fast page navigation
- Stimulus controllers for minimal JavaScript footprint
- CSS-only animations for status bar transitions
- Lazy loading for large task lists (future consideration)

## Security Considerations

### Data Protection
- No user authentication required (single-user app)
- CSRF protection enabled by default in Rails
- SQL injection prevention through ActiveRecord
- XSS protection through Rails HTML escaping

### Input Validation
- Server-side validation for all user inputs
- Sanitization of task names and descriptions
- Protection against mass assignment vulnerabilities

## Deployment and Infrastructure

### Continuous Deployment Strategy
**Philosophy**: Ship working software every hour or sooner with a "walking skeleton" approach.

**Workflow**:
- Feature branches for each task implementation
- Pull Request (PR) based workflow
- Merge to `main` branch triggers automatic deployment
- No long-running branches - each task goes straight to production

### CI/CD Pipeline (GitHub Actions)
**Pre-merge Checks** (`.github/workflows/ci.yml`):
- Run full Cucumber feature suite
- Run RSpec unit and integration tests
- Code quality checks (Rubocop, security scanning)
- Database migration validation
- Asset compilation verification

**Deployment Pipeline** (`.github/workflows/deploy.yml`):
- Triggered on merge to `main` branch
- Deploy to production hosting platform
- Run database migrations
- Health check verification
- Rollback capability on failure

### Hosting Platform: Railway
**Selected for**:
- Free tier available for MVP development
- Automatic deployments from GitHub
- Built-in environment variable management
- Database migration support
- SSL/HTTPS by default
- Modern platform with good Rails support
- Cost-effective scaling path

### PlanetScale Configuration
**Branch Strategy**:
- `development`: Local development and feature branch testing
- `main`: Production database, mirrors GitHub main branch
- Schema changes deployed via PlanetScale deploy requests

**Connection Management**:
- Environment-specific connection strings
- Connection pooling through Rails database.yml
- Secure credential management via hosting platform

### Environment Setup
- **Development**: Local Rails server + PlanetScale development branch
- **CI/CD**: GitHub Actions runners + SQLite for fast test execution (no PlanetScale needed for tests)
- **Production**: Railway + PlanetScale main branch

### Walking Skeleton Implementation Strategy
**Phase 1 - Minimal Deployable App**:
- Basic Rails app with single "Hello World" page
- Database connection to PlanetScale
- CI/CD pipeline fully functional
- Deployed to production with HTTPS

**Phase 2 - Core Domain**:
- Task model with basic CRUD
- Simple list view (no status bars yet)
- Each feature deployed immediately upon completion

**Phase 3 - Enhanced Features**:
- Status bar calculations and display
- Task completion functionality
- UI polish and responsive design

This approach ensures we have a production-ready system from day one and can validate our deployment pipeline before building complex features.

## Development Workflow

### Task Implementation Process
1. Create feature branch from `main`
2. Write Cucumber feature (BDD)
3. Implement minimal code to make feature pass
4. Write RSpec tests for implementation details
5. Ensure all tests pass locally
6. Create Pull Request
7. CI pipeline validates all tests
8. Merge to `main` triggers automatic deployment
9. Verify feature works in production

### Quality Gates
- All Cucumber features must pass
- All RSpec tests must pass
- Code coverage threshold (90%+)
- No security vulnerabilities detected
- Successful deployment health check

This design provides a solid foundation for implementing the recurring task manager while maintaining modern Rails practices, continuous deployment, and preparing for future enhancements.
