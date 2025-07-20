Feature: Create Tasks with Different Intervals
  As a user
  I want to create daily, weekly, monthly, and custom interval tasks
  So that I can track tasks with different recurring schedules

  Scenario: User creates a daily task
    Given I visit the homepage
    When I click "Create Task"
    And I fill in "Task Name" with "Take vitamins"
    And I select "Daily" from "Interval"
    And I click "Create Task"
    Then I should see "Take vitamins" in my task list
    And I should see "Daily" as the interval for "Take vitamins"

  Scenario: User creates a weekly task
    Given I visit the homepage
    When I click "Create Task"
    And I fill in "Task Name" with "Grocery shopping"
    And I select "Weekly" from "Interval"
    And I click "Create Task"
    Then I should see "Grocery shopping" in my task list
    And I should see "Weekly" as the interval for "Grocery shopping"

  Scenario: User creates a monthly task
    Given I visit the homepage
    When I click "Create Task"
    And I fill in "Task Name" with "Pay rent"
    And I select "Monthly" from "Interval"
    And I click "Create Task"
    Then I should see "Pay rent" in my task list
    And I should see "Monthly" as the interval for "Pay rent"

  Scenario: User creates a custom interval task
    Given I visit the homepage
    When I click "Create Task"
    And I fill in "Task Name" with "Water garden"
    And I select "Custom" from "Interval"
    And I fill in "Custom Days" with "3"
    And I click "Create Task"
    Then I should see "Water garden" in my task list
    And I should see "Every 3 days" as the interval for "Water garden"

  Scenario: User cannot create custom task without specifying days
    Given I visit the homepage
    When I click "Create Task"
    And I fill in "Task Name" with "Invalid task"
    And I select "Custom" from "Interval"
    And I click "Create Task"
    Then I should see "Interval value can't be blank"
