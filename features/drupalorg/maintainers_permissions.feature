Feature: To check maintainers permissions
  In order to maintain a project
  As a project owner
  I should make sure proper permissions have been assigned to the maintainers

  Background:
    Given I am logged in as "admin test"
    And I follow "Your Projects"
    And I follow a post

  Scenario: Check maintainers permissions
    When I follow "Maintainers"
    Then I should see the <users> with the following <permissions>
    | users          | permissions     |
    | ksbalajisundar | Write to VCS    |
    | pradeeprkara   | Write to VCS    |
    | sachin2dhoni   | Edit project    |
    | sachin2dhoni   | Write to VCS    |
    | ksbalajisundar | Maintain issues |
    | pradeeprkara   | Write to VCS    |