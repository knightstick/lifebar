Feature: User can see visual status bars
  As a user
  I want to see Sims-style visual status bars for my tasks
  So that I can quickly understand task status at a glance

  Background:
    Given I have a daily task called "Water plants"

  Scenario: Newly created task shows green status bar
    When I visit the tasks page
    Then I should see a status bar for "Water plants"
    And the status bar should be green
    And the status bar should be less than 25% filled

  Scenario: Task halfway to due date shows yellow status bar
    Given the task "Water plants" was completed 12 hours ago
    When I visit the tasks page
    Then I should see a status bar for "Water plants"
    And the status bar should be yellow
    And the status bar should be approximately 50% filled

  Scenario: Overdue task shows red status bar
    Given the task "Water plants" was completed 2 days ago
    When I visit the tasks page
    Then I should see a status bar for "Water plants"
    And the status bar should be red
    And the status bar should be 100% filled