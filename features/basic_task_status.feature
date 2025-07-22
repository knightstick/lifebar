Feature: Basic Task Status
  As a user
  I want to see if tasks are due, overdue, or recently completed
  So that I can prioritize which tasks need attention

  Background:
    Given the current time is "2025-01-15 12:00:00"

  Scenario: User sees recently completed task status
    Given I have a task "Water plants" with "weekly" interval completed "1 day ago"
    When I visit the tasks dashboard
    Then I should see "Water plants" with status "Due in 6 days"
    And I should see green status color for "Water plants"

  Scenario: User sees task due soon
    Given I have a task "Take vitamins" with "daily" interval completed "20 hours ago"
    When I visit the tasks dashboard
    Then I should see "Take vitamins" with status "Due in 4 hours"
    And I should see yellow status color for "Take vitamins"

  Scenario: User sees overdue task
    Given I have a task "Clean bathroom" with "weekly" interval completed "10 days ago"
    When I visit the tasks dashboard
    Then I should see "Clean bathroom" with status "Overdue by 3 days"
    And I should see red status color for "Clean bathroom"

  Scenario: User sees newly created task (never completed)
    Given I have a task "New task" with "daily" interval that was never completed
    When I visit the tasks dashboard
    Then I should see "New task" with status "Due in 1 day"
    And I should see green status color for "New task"

  Scenario: User sees task due today
    Given I have a task "Daily routine" with "daily" interval completed "24 hours ago"
    When I visit the tasks dashboard
    Then I should see "Daily routine" with status "Due now"
    And I should see yellow status color for "Daily routine"
