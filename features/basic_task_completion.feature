Feature: Basic Task Completion
  As a user
  I want to mark tasks as complete
  So that I can reset their status bars and track my progress

  @javascript
  Scenario: User marks a task complete and sees it reset
    Given I have a task "Water plants" that was completed 5 days ago
    When I visit the tasks page
    And I click "Complete" next to "Water plants"
    Then I should be redirected to the tasks page
    And I should see "Water plants" with a green status
    And the task should have an updated completion timestamp
