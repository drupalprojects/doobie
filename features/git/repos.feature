Feature: Users want to share code
  In order to share and improve code
  As a user
  I need to create sandboxes and projects

  Background:
    Given I am logged in as "git user"

  Scenario: Git User creates a project
    Given I am at "/node/add/project-project"
    When I create a "module"
    Then I should see the project title

  Scenario: Git user inits the repo
    Given I am on the Version control tab
    And I should see "Empty Sandbox repository"
    When I initialize the repository
#TODO determine some visible indicator of success on the site

