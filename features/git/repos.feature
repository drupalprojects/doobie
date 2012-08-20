Feature: Users want to share code
  In order to share and improve code
  As a user
  I need to create sandboxes and projects

  Background:
    Given I am logged in as "git user"
#    And I have identified myself to git

  Scenario: Git User creates a project
    Given I am at "/node/add/project-project"
    When I create a "module"
    Then I should see the project title

  @gitrepo
  Scenario: Git user inits the repo
    Given I am on the Version control tab
    And I should see "Empty Sandbox repository"
    When I initialize the repository
    And I am on the Version control tab
    Then I should see "Routinely"
    And I should see "Switching to a different branch" 

