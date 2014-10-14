@ci @maintainers @git
Feature: Verify Write to VCS permission
  In order to commit or push to the repository
  As a project maintainer
  I should have the permission to Write to VCS

  @gitrepo @failing
 Scenario: Create a new project and initialize repo
    Given users:
      | name            | pass     | mail                                | roles           |
      | Git Vetted User | password | qa+gitvetted@association.drupal.org | Git vetted user |
    And I am logged in as "Git Vetted User"
    And I am at "/node/add/project-module"
    When I create a "sandbox" project
    And I see project data
    And I follow "Version control"
    And I initialize the repository
    And I reload the page
    Then I should see "Setting up repository for the first time"

  @dependent @failing
 Scenario: Add a maintainer: Valid maintainer name
    Given users:
      | name            | pass     | mail                                | roles           |
      | Git Vetted User | password | qa+gitvetted@association.drupal.org | Git vetted user |
    And I am logged in as "Git Vetted User"
    And I am on the Maintainers tab
    When I enter "git user" for field "Maintainer user name"
    And I press "Update"
    And I see "added and permissions updated"
    And I assign "Write to VCS" to the maintainer "git user"
    And I assign "Maintain issues" to the maintainer "git user"
    And I press "Update"
    Then I should see "Maintainer permissions updated"

  @dependent @gitrepo @clean_data @failing
 Scenario: Git user does a push a commit to the repository
    Given users:
      | name     | pass     | mail                              | roles    |
      | Git User | password | qa+gituser@association.drupal.org | Git user |
    And I am logged in as "Git User"
    And I visit the recent sandbox
    And I follow "Version control"
    When I clone the repo
    And I push "2" commits to the repository
    And I follow "Logged in as git user"
    And I follow "Your Commits"
    Then I should see the project link


