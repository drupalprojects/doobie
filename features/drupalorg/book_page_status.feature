Feature: Check the status background color of a book page
  In order to verify the status of a book page
  As a site user
  I should edit a book page

  Background:
    Given I am logged in as "site user"
    And I follow "Documentation"
    And I follow "Understanding Drupal"
    And I click on a book page

  Scenario Outline: Edit a book page and set status
    When I follow "Edit"
    And I select "<status>" from "Page status:"
    And I fill in "Log message:" with random text
    And I press "Save"
    Then I see "has been updated"
    And the page status should be "<status>"
    And the background of the status should be "<color>"
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
