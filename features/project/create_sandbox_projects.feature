@project @wip
Feature: Create projects
  In order to share my code with the community
  As a contributor
  I need to create a project

  Background: 
  Given I am logged in as "git user"
  And I am on "/node/add"

  Scenario: Create a module
    When I follow "Module project"
    And I fill in "Name" with random text
    And I select "Actively maintained" from "Maintenance status"
    And I select "Sandbox project" from "Project type"
    And I select "Under active development" from "Development status"
    And I select "Administration" from "Projects"
    And I press "Save"
    Then I should see the random "Name" text

  Scenario Outline: Create other projects
    When I follow "<project>"
    Then I should not see "Full project" in the dropdown "Project type"
    And I should not see "Project short name"
 
    Examples:
    | project              |
    | Distribution project |
    | Drupal core          |
    | Drupal.org project   |
    | Module project       |
    | Theme Engine project |
    | Theme project        |
    | Translation project  |


