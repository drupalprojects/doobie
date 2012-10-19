@project @wip
Feature: Create projects
  In order to share my code with the community
  As a contributor
  I need to create a project

  Background: 
    Given I am logged in as "git vetted user"
    And I am on "/node/add"
  
  @javascript @clean_data
  Scenario: Create a module
    When I follow "Module project"
    And I fill in "Name" with random text
    And I select "Actively maintained" from "Maintenance status"
    And I select "Full project" from "Project type"
    And I select "Under active development" from "Development status"
    And I fill in "Short name" with random text
    And I select "Administration" from "Projects"
    And I upload the following <files> for "File attachments"
    | files           | description     |
    | desert.jpg      | Desert pic      |
    | hydrangeas.jpg  | Hydrangeas pic  |
    | koala.jpg       | Koala pic       |
    And I press "Save"
    Then I should see the random "Name" text
    And I should see that the project was created

  @javascript @clean_data
  Scenario Outline: Create other projects
    When I follow "<project>"
    And I wait until the page is loaded
    And I fill in "Name" with random text
    And I select "Actively maintained" from "Maintenance status" 
    And I select "Full project" from "Project type"
    And I select "Under active development" from "Development status"
    And I fill in "Short name" with random text
    And I press "Save"
    Then I should see the random "Name" text
    And I should see that the project was created

    Examples:
    | project              |
    | Distribution project |
    | Drupal core          |
    | Drupal.org project   |
    | Theme Engine project |
    | Theme project        |
    | Translation project  |  