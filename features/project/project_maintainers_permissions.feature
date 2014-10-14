@project @maintainers
Feature: To check maintainers permissions
  In order to delegate project maintenance
  As a project owner
  I should make sure that proper permissions have been assigned to the maintainers

  Scenario: Follow Maintainers page and view maintainer's permissions
    Given users:
      | name                | pass     | mail                                    | roles         |
      | Administrative User | password | qa+administrator@association.drupal.org | administrator |
    And I am logged in as "Administrative User"
    And I am at "/node/1765126/maintainers"
    When I follow "Maintainers"
    Then I should see the <users> with the following <permissions>
      | users          | permissions            |
      | ksbalajisundar | Write to VCS           |
      | pradeeprkara   | Edit project           |
      | ksbalajisundar | Maintain issues        |
      | eliza411       | Edit project           |
      | eliza411       | Administer maintainers |
    And I should see the <users> without the following <permissions>
      | users          | permissions            |
      | ksbalajisundar | Administer maintainers |
      | pradeeprkara   | Write to VCS           |
