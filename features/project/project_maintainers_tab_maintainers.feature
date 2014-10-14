@project @maintainers
Feature: 'Administer maintainers' permission check
  In order to get help maintaining my project
  As a project owner
  I need to be able to add people to my project with appropriate permissions

  @failing
 Scenario: Create a new project
    Given users:
      | name            | pass     | mail                                | roles           |
      | Git Vetted User | password | qa+gitvetted@association.drupal.org | Git vetted user |
    And I am logged in as "Git Vetted User"
    And I am at "/node/add/project-distribution"
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
 Scenario: Assign Administer maintainers permission to a maintainer
    Given users:
      | name            | pass     | mail                                | roles           |
      | Git Vetted User | password | qa+gitvetted@association.drupal.org | Git vetted user |
    And I am logged in as "Git Vetted User"
    And I am on the Maintainers tab
    When I assign "Administer maintainers" to the maintainer "git user"
    And I press "Update"
    Then I should see "Maintainer permissions updated"

  @dependent @failing
 Scenario: Log in as maintainer and see that if you can add a maintainer
    Given users:
      | name     | pass     | mail                              | roles    |
      | Git User | password | qa+gituser@association.drupal.org | Git user |
    And I am logged in as "Git User"
    And I am on the Maintainers tab
    When I enter "site user" for field "Maintainer user name"
    And I press "Update"
    Then I should see "added and permissions updated"

  @dependent @failing
 Scenario: Unassign Administer maintainers permission from a maintainer
    Given users:
      | name            | pass     | mail                                | roles           |
      | Git Vetted User | password | qa+gitvetted@association.drupal.org | Git vetted user |
    And I am logged in as "Git Vetted User"
    And I am on the Maintainers tab
    When I unassign "Administer maintainers" from the maintainer "git user"
    And I press "Update"
    Then I should see "Maintainer permissions updated"

  @dependent @clean_data @failing
 Scenario: Log in as maintainer and see that maintainers tab is accessible
    Given users:
      | name     | pass     | mail                              | roles    |
      | Git User | password | qa+gituser@association.drupal.org | Git user |
    And I am logged in as "Git User"
    When I am on the Maintainers tab
    Then I should not see the link "Maintainers"
