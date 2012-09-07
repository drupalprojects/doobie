@wip
Feature: Verify Write to VCS permission
  In order to commit or push to the repository
  As a project maintainer
  I should have the permission to Write to VCS

  Scenario: Create a new project
    Given I am logged in as "git vetted user"
    And I am at "/node/add/project-project"
    When I create a "module"
    Then I should see the project title

  @dependent
  Scenario: Add a maintainer: Valid maintainer name
    Given I am logged in as "git vetted user"
    And I am on the Maintainers tab
    When I enter "git user" for field "Maintainer user name"
    And I press "Update"
    And I see "added and permissions updated"
    And I assign "Write to VCS" to the maintainer "git user"
    And I press "Update"
    Then I should see "Maintainer permissions updated"

  @gitrepo @dependent
  Scenario: Git user does a push a commit to the repository
    Given I am logged in as "git user"
    And I am on the Version control tab
    And I initialize the repository
    Then I should be able to push a commit to the repository
