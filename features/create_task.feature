Feature: Create Task
  As a user
  I want to create a basic task
  So that I can track my recurring responsibilities

  Scenario: User creates a task with name and weekly interval
    Given I visit the homepage
    When I click "Create Task"
    And I fill in "Task Name" with "Take out trash"
    And I select "Weekly" from "Interval"
    And I click "Create Task"
    Then I should see "Take out trash" in my task list
    And I should see "Task created successfully"
