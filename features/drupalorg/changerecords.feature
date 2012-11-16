Feature: Add change record
  In order to see and add change records
  As an authenticated user
  I should be able to click on the respective link and submit the page

  Background:
    Given I am logged in as "site user"
    And I am on "/project/drupal"
    And I follow "View change records"
    
  Scenario: Search records
    When I fill in "mail" for "Keywords"
    And I fill in "7.x" for "Introduced in branch"
    And I press "Apply"
    Then I should see at least "2" records

  Scenario: Add new change record
    When I follow "Add new change record"
    And I fill in "Title" with random text
    And I fill in the following:
    | Project               | Drupal core        |
    | Introduced in branch  | 8.x                |
    | Introduced in version | 8.x                |
    | Description           | Test change record |
    And I check "Themers"
    And I check "Module developers"
    And I check "Theming guide done"
    And I enter "#1507: printable drupal documentation" for field "Issues"
    And I press "Save"
    Then I should see "has been created"

  Scenario: Add new change record as anonymous user
    Given I am on "/list-changes/drupal"
    When I follow "Add new change record"
    Then I should see "You are not authorized to access this page"
    And I should see the heading "Access denied"
    But I should not see "Create Change record"
   
