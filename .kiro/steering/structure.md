# Project Structure & Organization

## Rails Application Structure

### Core Application Files
```
app/
├── controllers/
│   ├── application_controller.rb
│   └── tasks_controller.rb          # RESTful CRUD + complete action
├── models/
│   ├── task.rb                      # Core domain model
│   └── task_completion.rb           # Completion history tracking
├── views/
│   ├── layouts/
│   │   └── application.html.erb     # Main layout with Tailwind
│   └── tasks/
│       ├── index.html.erb           # Dashboard with status bars
│       ├── new.html.erb             # Task creation form
│       ├── edit.html.erb            # Task editing form
│       └── _task.html.erb           # Task card partial
├── javascript/
│   └── controllers/
│       └── task_bar_controller.js   # Stimulus for status bar updates
└── assets/
    └── stylesheets/
        └── application.tailwind.css # Custom Tailwind styles
```

### Database Schema
```
db/
├── migrate/
│   ├── 001_create_tasks.rb          # Main task table
│   └── 002_create_task_completions.rb # Completion history
└── schema.rb                        # Generated schema file
```

### Testing Structure
```
features/                            # Cucumber BDD features
├── manage_tasks.feature             # Create, edit, delete tasks
├── complete_tasks.feature           # Mark tasks complete
├── view_dashboard.feature           # Dashboard display
└── step_definitions/
    └── task_steps.rb                # Step implementations

spec/                                # RSpec unit/integration tests
├── models/
│   ├── task_spec.rb                 # Task model validations & logic
│   └── task_completion_spec.rb      # Completion model tests
├── controllers/
│   └── tasks_controller_spec.rb     # Controller action behavior
├── factories/
│   ├── tasks.rb                     # Task test data factory
│   └── task_completions.rb          # Completion test data factory
└── rails_helper.rb                  # RSpec configuration
```

## Key Models & Relationships

### Task Model
- **Primary Entity**: Represents a recurring task
- **Key Methods**: `next_due_date`, `completion_percentage`, `status_color`, `overdue?`, `mark_completed!`
- **Validations**: Name required (max 255 chars), valid interval types
- **Enums**: `interval_type` (daily, weekly, monthly, custom)

### TaskCompletion Model
- **Purpose**: Track completion history for analytics
- **Relationship**: `belongs_to :task`
- **Constraint**: Foreign key with cascade delete

### Data Consistency Pattern
```ruby
# Transactional completion to ensure data integrity
def mark_completed!
  ActiveRecord::Base.transaction do
    completion = task_completions.create!(completed_at: Time.current)
    update!(last_completed_at: completion.completed_at)
  end
end
```

## Controller Patterns

### TasksController Actions
- **Standard REST**: `index`, `new`, `create`, `edit`, `update`, `destroy`
- **Custom Action**: `complete` for marking tasks done
- **Redirects**: Always redirect to dashboard after mutations
- **Error Handling**: Flash messages for validation errors

## View Organization

### Layout Strategy
- **Single Layout**: `application.html.erb` with Tailwind CSS
- **Responsive Design**: Mobile-first approach
- **Navigation**: Simple header with dashboard link

### Component Approach
- **Task Cards**: Reusable `_task.html.erb` partial
- **Status Bars**: CSS-only gradients (green → yellow → red)
- **Forms**: Standard Rails form helpers with Tailwind styling

## Configuration Files

### Essential Config
```
config/
├── database.yml                     # PlanetScale connection
├── routes.rb                        # RESTful routes + complete action
├── application.rb                   # Rails app configuration
└── environments/
    ├── development.rb               # Local development settings
    ├── test.rb                      # Test environment config
    └── production.rb                # Railway deployment config
```

### Deployment Config
```
.github/
└── workflows/
    ├── ci.yml                       # Test pipeline
    └── deploy.yml                   # Deployment pipeline
```

## Naming Conventions

### Files & Classes
- **Models**: Singular (`Task`, `TaskCompletion`)
- **Controllers**: Plural (`TasksController`)
- **Views**: Match controller actions (`tasks/index.html.erb`)
- **Features**: Descriptive (`manage_tasks.feature`)

### Database
- **Tables**: Plural (`tasks`, `task_completions`)
- **Columns**: Snake_case (`last_completed_at`, `interval_type`)
- **Foreign Keys**: `model_id` pattern (`task_id`)

### CSS Classes
- **Status Colors**: `.status-green`, `.status-yellow`, `.status-red`
- **Components**: `.task-card`, `.status-bar`, `.completion-button`
- **Tailwind**: Use utility classes for layout and spacing

## Development Principles

### Code Organization
- **Fat Models, Skinny Controllers**: Business logic in models
- **Single Responsibility**: Each class has one clear purpose
- **RESTful Design**: Follow Rails conventions for routes and actions
- **DRY Principle**: Extract common functionality into partials and helpers

### File Placement Rules
- **Business Logic**: Models (`app/models/`)
- **HTTP Handling**: Controllers (`app/controllers/`)
- **Presentation**: Views (`app/views/`)
- **Client Interaction**: Stimulus controllers (`app/javascript/controllers/`)
- **Styling**: Tailwind utilities in views, custom CSS in `application.tailwind.css`
