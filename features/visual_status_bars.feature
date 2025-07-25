Feature: Visual Task Status Bars

  As a user
  I want to see the status of my tasks as a visual bar
  So that I can quickly gauge how close they are to their due date.

  Background:
    Given I have created the following tasks:
      | name          | interval | last_completed_at |
      | New Task      | 1 week   | 3 days ago        |
      | Overdue Task  | 2 weeks  | 15 days ago       |
      | Completed Task| 1 day    | 1 hour ago        |

  Scenario: Viewing tasks with visual status bars
    When I visit the dashboard
    Then I should see a visual status bar for each task
    And the "New Task" status bar should reflect a partial completion percentage
    And the "Overdue Task" status bar should reflect an overdue state
    And the "Completed Task" status bar should reflect a recently completed state
