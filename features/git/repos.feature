@ci @git
Feature: Users create git repository
  In order to share and improve code
  As a git user
  I need to initialize a git repository for my project

  Background:
    Given users:
      | name     | pass     | mail                              | roles    |
      | Git User | password | qa+gituser@association.drupal.org | Git user |
    And I am logged in as "Git User"

  @smoke @clean_data @gitrepo @failing
 Scenario: Git User creates a project
    Given I am at "/node/add/project-module"
    When I create a "sandbox" project
    And I see project data
    And I follow "Version control"
    And I see "Empty Sandbox Repository"
    And I initialize the repository
    And I reload the page
    Then I should see "Routinely"
    And I should see "Switching to a different branch"

