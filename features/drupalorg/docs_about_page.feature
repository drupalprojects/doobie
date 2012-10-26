@docs @wip
Feature: About this page block on documentation pages
  In order to make sure that the documentation contents are displayed correctly
  As a document manager
  I want to fill various field in the form and save the same

  Background:
   Given I am logged in as "docs manager"
   And I am on "/documentation/administer"

  Scenario: Dropdown values
    When I follow "Edit"
    Then I should see the following <values> in the dropdown "Drupal version"
    | values                |
    | - None -              |
    | Drupal 4.5.x or older |
    | Drupal 4.6.x          |
    | Drupal 4.7.x          |
    | Drupal 5.x            |
    | Drupal 6.x            |
    | Drupal 7.x            |
    | Drupal 8.x            |
    And I should see the following <values> in the dropdown "Level"
    | values       |
    | - None -     |
    | Beginner     |
    | Intermediate |
    | Advanced     |
    And I should see the following <values> in the dropdown "Audience"
    | values              |
    | - None -            |
    | Contributors        |
    | Designers/themers   |
    | Programmers         |
    | Site administrators |
    | Site builders       |
    | Site users          |
    And I should see the following <values> in the dropdown "Page status"
    | values                  |
    | - None -       |
    | No known problems       |
    | Incomplete              |
    | Insecure code           |
    | Needs copy/style review |
    | Needs dividing          |
    | Needs technical review  |
    | Needs updating          |
    | Deprecated              |

  Scenario: Change the drupal version
    When I follow "Edit"
    And I select "Drupal 6.x" from "Drupal version"
    And I fill in revision log message with random text
    And I press "Save"
    Then I should see "Drupal 6.x"

  Scenario: Change the level
    When I follow "Edit"
    And I select "Beginner" from "Level"
    And I fill in revision log message with random text
    And I press "Save"
    Then I should see "Beginner"

  Scenario: Change the audience
    When I follow "Edit"
    And I select "Programmers" from "Audience"
    And I fill in revision log message with random text
    And I press "Save"
    Then I should see "Programmers"

  Scenario: Change the page status
    When I follow "Edit"
    And I select "Needs updating" from "Page status"
    And I fill in revision log message with random text
    And I press "Save"
    Then I should see "Needs updating"

  Scenario: Add keyword
    When I follow "Edit"
    And I fill in "Keywords" with random text
    And I fill in revision log message with random text
    And I press "Save"
    Then I should see the random "Keywords" text

  Scenario: Reset to defaults
    When I follow "Edit"
    And I select "- None -" from "Drupal version"
    And I select "- None -" from "Level"
    And I select "Site administrators" from "Audience"
    And I fill in "" for "Keywords"
    And I select "- None -" from "Page status"
    And I fill in revision log message with random text
    And I press "Save"
    Then I should see "has been updated"
    And I should see "Site administrators"
