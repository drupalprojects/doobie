@ci @git
Feature: Promote a project from a sandbox to a full project
  In order to make a project official
  As a git vetted user
  I should be able to promote a sandbox

  @gitrepo @cleanup
  Scenario: Git user creates a project and tries to promote it
    Given I am logged in as the "git user"
    And I am on "/node/add/project-theme"
    When I create a "sandbox" project
    And I follow "Edit"
    Then I should not see the link "Promote"
    And I should not see the link "Promote this project"
    And I should see that the project short name is read-only

  @cleanup
  Scenario: Git vetted user create a project and tries to promote it
    Given a promoted sandbox
    Given I am logged in as the "git vetted user"
    When I follow "Edit"
    Then I should not see the link "Promote"
    And I should not see the link "Promote this project"
    And I should see that the project short name is read-only

  @gitrepo @cleanup
  Scenario: Git vetted user initializes the repo and tries to promote project
    Given a promoted sandbox    
    When I follow "Edit"
    Then I should not see the link "Promote"
    And I should not see the link "Promote this project"
    And I should see that the project short name is read-only
