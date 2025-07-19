# Technology Stack & Build System

## Core Technologies
- **Framework**: Ruby on Rails 8.0.2 (latest with Turbo/Stimulus)
- **Database**: MySQL 8.0 via PlanetScale (free tier)
- **Frontend**: Rails views with Turbo Drive/Frames and Stimulus controllers
- **CSS**: Tailwind CSS for styling and responsive design
- **Deployment**: Railway (free tier)

## Testing Framework
- **BDD**: Cucumber for feature specs (behavior-driven development)
- **Unit/Integration**: RSpec for model and controller tests
- **Test Data**: Factory Bot for test data creation
- **Approach**: Write Cucumber features first, then implement minimal code to pass

## Database Considerations
- **PlanetScale Compatibility**: No MySQL ENUMs (use VARCHAR with Rails enum)
- **Transactions**: Full ACID support for task completion operations
- **Schema Branching**: Use PlanetScale branches for development/production

## Development Workflow
- **Walking Skeleton**: Deploy working software every hour or sooner
- **Feature Branches**: Each task gets its own branch, merged to main immediately
- **CI/CD**: GitHub Actions for testing and automatic deployment
- **Quality Gates**: All Cucumber + RSpec tests must pass before merge

## Common Commands

### Setup
```bash
# Generate new Rails app with essential gems
rails new recurring_task_manager --database=mysql --css=tailwind

# Add testing gems to Gemfile
bundle add cucumber-rails rspec-rails factory_bot_rails

# Setup test frameworks
rails generate cucumber:install
rails generate rspec:install
```

### Development
```bash
# Run development server
rails server

# Run all tests
bundle exec cucumber
bundle exec rspec

# Database operations
rails db:create
rails db:migrate
rails db:seed
```

### Testing
```bash
# Run BDD features (primary testing approach)
bundle exec cucumber

# Run specific feature
bundle exec cucumber features/manage_tasks.feature

# Run unit tests
bundle exec rspec spec/models/
bundle exec rspec spec/controllers/
```

### Deployment
```bash
# Deploy happens automatically on merge to main
# Manual deployment check
git push origin main

# Database migrations (handled by Railway)
rails db:migrate RAILS_ENV=production
```

## Code Quality Standards
- Follow Rails conventions and RESTful patterns
- Write Cucumber features before implementation
- Maintain 90%+ test coverage
- Use ActiveRecord validations and strong parameters
- Implement transactional operations for data consistency
