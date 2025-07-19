Feature: Homepage
  As a user
  I want to visit the homepage
  So that I can access the Recurring Task Manager

  Scenario: User visits homepage
    Given I visit the homepage
    Then I should see "Recurring Task Manager"
    And I should see "Manage your recurring tasks with Sims-style status bars"
