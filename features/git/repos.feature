@ci
Feature: Users create git repository
  In order to share and improve code
  As a git user
  I need to initialize a git repository for my project

  Background:
    Given I am logged in as "git user"

  @smoke
  Scenario: Git User creates a project
    Given I am at "/node/add/project-project"
    When I create a "module"
    And I see the project title
    And I am on the Version control tab
    And I see "Empty Sandbox repository"
    And I initialize the repository
    And I am on the Version control tab
    Then I should see "Routinely"
    And I should see "Switching to a different branch"

