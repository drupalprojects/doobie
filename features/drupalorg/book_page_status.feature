Feature: Check the background color of the book page status
  In order to know the current status of a book page
  As a site user
  I should edit the book page and view the status

  Background:
    Given I am logged in as "site user"
    And I follow "Documentation"
    And I follow "Understanding Drupal"

  Scenario: Create a book page
    When I follow "Add child page"
    And I create a book page
    Then I should see "has been created"

  @javascript
  Scenario Outline: Edit a book page and set status
    When I follow a random book page
    And I wait "1" second
    And I follow "Edit"
    And I wait "1" second
    And I select "<status>" from "Page status:"
    And I fill in "Log message:" with random text
    And I press "Save"
    Then I see "has been updated"
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
