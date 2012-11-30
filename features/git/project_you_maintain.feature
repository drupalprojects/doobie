@ci
Feature: Promote a project from a sandbox to a full project
  In order to make a project official
  As a git vetted user
  I should be able to promote a sandbox

  Scenario: Git user creates a project and tries to promote it
    Given I am logged in as "git user"
    When I create a sandbox project
    And I see project data
    And I follow "Edit"
    Then I should not see the link "Promote"
    And I should not see the link "Promote this project"
    And I should see that the project short name is readonly

  @gitrepo @dependent @clean_data
  Scenario: Git user initializes the repo and tries to promote project
    Given I am logged in as "git user"
    And I am on the Version control tab
    When I initialize the repository
    And I follow "Edit"
    Then I should not see the link "Promote"
    And I should not see the link "Promote this project"
    And I should see that the project short name is readonly

  @clean_data
  Scenario: Git vetted user create a project and tries to promote it
    Given I am logged in as "git vetted user"
    And I created a sandbox project
    When I promote the project
    And I see "has been promoted to a full project"
    And I follow "Edit"
    Then I should not see the link "Promote"
    And I should not see the link "Promote this project"
    And I should see that the project short name is readonly

  @gitrepo @clean_data
  Scenario: Git vetted user initializes the repo and tries to promote project
    Given I am logged in as "git vetted user"
    And I created a sandbox project
    And I follow "Version control"
    And I initialize the repository
    When I promote the project
    And I see "has been promoted to a full project"
    And I follow "Edit"
    Then I should not see the link "Promote"
    And I should not see the link "Promote this project"
    And I should see that the project short name is readonly
