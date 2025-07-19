# Recurring Task Manager

A gamified approach to managing recurring tasks with visual "needs bars" similar to The Sims. Track your regular responsibilities and see their status degrade over time until you complete them to reset the bars.

## 🎯 Features

- **Sims-style Status Bars**: Visual indicators that transition from green (recently completed) to red (overdue)
- **Custom Intervals**: Set tasks to repeat daily, weekly, monthly, or custom intervals
- **Simple Task Management**: Create, edit, and complete recurring tasks
- **Clean Interface**: Built with Tailwind CSS for a modern, responsive design

## 🚀 Getting Started

### Prerequisites

- Ruby 3.4.5
- Rails 8.0.2
- MySQL (for production) or SQLite (for testing)
- Node.js (for asset compilation)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/knightstick/lifebar.git
   cd lifebar
   ```

2. **Install dependencies**
   ```bash
   bundle install
   ```

3. **Set up the database**
   ```bash
   rails db:create
   rails db:migrate
   ```

4. **Start the development server**
   ```bash
   rails server
   ```

5. **Visit the application**
   Open http://localhost:3000 in your browser

## 🧪 Testing

This project follows Behavior-Driven Development (BDD) with Cucumber and RSpec.

### Run all tests
```bash
# Run Cucumber features (BDD scenarios)
bundle exec cucumber

# Run RSpec unit tests
bundle exec rspec
```

### Current test status
- ✅ Homepage feature: User can visit the homepage

## 🛠 Development

### Tech Stack
- **Framework**: Ruby on Rails 8.0.2
- **Database**: MySQL (production), SQLite (test)
- **Frontend**: Turbo + Stimulus + Tailwind CSS
- **Testing**: Cucumber (BDD) + RSpec (unit/integration)
- **Deployment**: Railway (planned)

### Development Approach
- **BDD (Behavior-Driven Development)**: Features are written as Cucumber scenarios first
- **Outside-in Development**: Start with user-facing behavior, then implement
- **Continuous Delivery**: Each feature is deployable immediately after completion

### Project Structure
```
├── features/                 # Cucumber BDD scenarios
├── spec/                    # RSpec unit/integration tests
├── app/
│   ├── controllers/         # Rails controllers
│   ├── models/             # Domain models
│   └── views/              # ERB templates with Tailwind
└── .kiro/specs/            # Feature specifications and implementation plan
```

## 📋 Implementation Status

This project is being built incrementally following a detailed implementation plan:

- ✅ **Task 1**: Walking skeleton with deployable homepage
- ⏳ **Task 2**: User can create a basic task (end-to-end slice)
- ⏳ **Task 3**: User can view their tasks on a dashboard
- ⏳ **Task 4**: User can create tasks with different intervals
- ⏳ **Task 5**: User can see basic task status
- ⏳ **Task 6**: User can mark tasks as complete
- ⏳ **Task 7**: User can see visual status bars (Sims-style)
- ⏳ **Task 8**: User can edit existing tasks
- ⏳ **Task 9**: User can delete tasks
- ⏳ **Task 10**: Polish user experience and handle edge cases

## 🚢 Deployment

The application is designed for deployment on Railway with PlanetScale database.

### Environment Variables
- `DATABASE_URL`: PlanetScale connection string (production)
- `RAILS_MASTER_KEY`: Rails credentials key

## 🤝 Contributing

This project follows a strict BDD workflow:

1. **Write Cucumber feature** describing user behavior
2. **Run feature** (it should fail)
3. **Implement minimal code** to make it pass
4. **Ensure all tests pass**
5. **Deploy immediately**

## 📝 License

This project is available as open source under the terms of the MIT License.
