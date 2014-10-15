@project
Feature: Create specific project types
  In order to prevent end user from accidentally downloading experimental code
  As a git user
  I should only be allowed to create sandbox projects

  @failing
  Scenario Outline: Full project options should not available for git user
    Given users:
      | name     | pass     | mail                              | roles    |
      | Git User | password | qa+gituser@association.drupal.org | Git user |
    And I am logged in as "Git User"
    When I visit "<url>"
    Then I should not see "Project type"
    And I should not see "Short name"
    And I should not see "Version"
    And I should not see "Releases"

  Examples:
    | url                            |
    | /node/add/project-module       |
    | /node/add/project-theme-engine |
    | /node/add/project-distribution |
    | /node/add/project-core         |
    | /node/add/project-drupalorg    |
    | /node/add/project-theme        |

  @failing
  Scenario Outline: Create each project type as a sandbox
    Given users:
      | name     | pass     | mail                              | roles    |
      | Git User | password | qa+gituser@association.drupal.org | Git user |
    And I am logged in as "Git User"
    And I am on "<url>"
    And I create a "sandbox" project
    Then I should see "has been created"

  Examples:
    | url                            |
    | /node/add/project-module       |
    | /node/add/project-theme-engine |
    | /node/add/project-distribution |
    | /node/add/project-core         |
    | /node/add/project-drupalorg    |
    | /node/add/project-theme        |
