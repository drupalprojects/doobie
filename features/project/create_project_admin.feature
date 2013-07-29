@wip @project
Feature: Manage all project types
  In order to assist users and the project
  As an administrator
  I need to be able to create and promote all project types

  Scenario Outline: Create a sandbox for each type
    Given I am logged in as "admin test"
    And I am on "<url>"
    And I create a "sandbox" project
    Then I should see "has been created"
    And the URL should match "/sandbox/*"

    Examples:
    | url                            |
    | /node/add/project-module       |
    | /node/add/project-theme-engine |
    | /node/add/project-distribution |
    | /node/add/project-core         |
    | /node/add/project-drupalorg    |
    | /node/add/project-theme        |

    
  Scenario Outline: Promote sandboxes
    Given I am logged in as "admin test"     
    And I am on "<url>"
    And I create a "sandbox" project
    When I promote the project 
    Then the URL should match "/project/*"

    Examples:                        
    | url                            |
    | /node/add/project-module       |
    | /node/add/project-theme-engine |
    | /node/add/project-distribution |
    | /node/add/project-core         |
    | /node/add/project-drupalorg    |

  Scenario Outline: Create a full project for each type 
    Given I am logged in as "admin test/*"
    And I am on "<url>"
    And I create a "full" project
    Then I should see "has been created"
    And the URL should match "/project/*"

    Examples:
    | url                            |
    | /node/add/project-module       |
    | /node/add/project-theme-engine |
    | /node/add/project-distribution |
    | /node/add/project-core         |
    | /node/add/project-drupalorg    |
    | /node/add/project-theme        |
