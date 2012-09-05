Feature: To check maintainers permissions
  In order to maintain a project
  As a project owner
  I should make sure that proper permissions have been assigned to the maintainers

  Scenario: Check maintainers permissions
    Given I am logged in as "git vetted user"
    And I am at "/node/1724323/maintainers"
    When I follow "Maintainers"
    Then I should see the <users> with the following <permissions>
    | users          | permissions               |
    | ksbalajisundar | Write to VCS              |
    | pradeeprkara   | Edit project              |
    | ksbalajisundar | Maintain issues           |
    | eliza411       | Edit project              |
    | eliza411       | Administer maintainers    |
    And I should see the <users> without the following <permissions>
    | users          | permissions               |
    | ksbalajisundar | Administer maintainers    |
    | pradeeprkara   | Write to VCS              |