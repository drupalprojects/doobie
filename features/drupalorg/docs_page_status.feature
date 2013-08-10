@docs
Feature: Page status block on documentation pages
  In order to quickly communicate the status of a book page to site visitors
  As someone editing a page
  I need to change the status

  Background:
    Given I am logged in as the "site user"
    And I follow "Documentation"
    And I follow "Understanding Drupal"

  Scenario: Create a book page
    When I follow "Add child page"
    And I create a book page
    Then I should see "has been created"

  @javascript @flaky
  Scenario Outline: Edit a book page and set status
    When I follow a random book page
    And I wait until the page loads
    And I follow "Edit"
    And I wait until the page loads
    And I select "<status>" from "Page status"
    And I fill in revision log message with random text
    And I press "Save"
    And I wait until the page loads
    Then I should see "has been updated"
    And the page status should be "<status>"
    And the background color of the status should be "<color>"
    Examples:
    | status                  | color  |
    | No known problems       | green  |
    | Incomplete              | yellow |
    | Insecure code           | red    |
    | Needs copy/style review | yellow |
    | Needs dividing          | yellow |
    | Needs technical review  | yellow |
    | Needs updating          | yellow |
    | Deprecated              | red    |
