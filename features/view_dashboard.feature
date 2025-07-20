Feature: View Dashboard
  As a user
  I want to see list of my created tasks
  So that I can view all my tasks in one place

  Background:
    Given I have created a task "Water plants" with "weekly" interval
    And I have created a task "Clean bathroom" with "daily" interval

  Scenario: User can see list of their created tasks
    Given I visit the tasks dashboard
    Then I should see "Water plants" in my task list
    And I should see "Clean bathroom" in my task list
    And I should see the creation date for each task
    And I should see "Create New Task" link

  Scenario: User can navigate from homepage to task dashboard
    Given I visit the homepage
    When I click "View Tasks"
    Then I should be on the tasks dashboard
    And I should see my task list

  Scenario: User can navigate to create new task from dashboard
    Given I visit the tasks dashboard
    When I click "Create New Task"
    Then I should be on the new task page
