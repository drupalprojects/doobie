@project @maintainers
Feature: 'Edit project' permission check
  In order to provide information about a project
  As a project maintainer
  I should be able to edit the project

  @failing
  Scenario: Create a new project
    Given users:
      | name            | pass     | mail                                | roles           |
      | Git Vetted User | password | qa+gitvetted@association.drupal.org | Git vetted user |
    And I am logged in as "Git Vetted User"
    And I am at "/node/add/project-core"
    When I create a "sandbox" project
    Then I should see project data

  @dependent @failing
  Scenario: Add a maintainer: Valid maintainer name
    Given users:
      | name            | pass     | mail                                | roles           |
      | Git Vetted User | password | qa+gitvetted@association.drupal.org | Git vetted user |
    And I am logged in as "Git Vetted User"
    And I am on the Maintainers tab
    When I enter "git user" for field "Maintainer user name"
    And I press "Update"
    Then I should see "added and permissions updated"

  @dependent @failing
  Scenario: Assign Edit project permission to a maintainer
    Given users:
      | name            | pass     | mail                                | roles           |
      | Git Vetted User | password | qa+gitvetted@association.drupal.org | Git vetted user |
    And I am logged in as "Git Vetted User"
    And I am on the Maintainers tab
    When I assign "Edit project" to the maintainer "git user"
    And I press "Update"
    Then I should see "Maintainer permissions updated"

  @dependent @failing
  Scenario: Log in as maintainer and edit the project
    Given users:
      | name     | pass     | mail                              | roles    |
      | Git User | password | qa+gituser@association.drupal.org | Git user |
    And I am logged in as "Git User"
    And I am on the project page
    And I follow "Edit"
    And I press "Save"
    Then I should see "has been updated"

  @dependent @failing
  Scenario: Unassign Edit project permission from a maintainer
    Given users:
      | name            | pass     | mail                                | roles           |
      | Git Vetted User | password | qa+gitvetted@association.drupal.org | Git vetted user |
    And I am logged in as "Git Vetted User"
    And I am on the Maintainers tab
    When I unassign "Edit project" from the maintainer "git user"
    And I press "Update"
    Then I should see "Maintainer permissions updated"

  @dependent @clean_data @failing
  Scenario: Log in as maintainer and look for edit link
    Given users:
      | name     | pass     | mail                              | roles    |
      | Git User | password | qa+gituser@association.drupal.org | Git user |
    And I am logged in as "Git User"
    And I am on the project page
    Then I should not see the link "Edit"
