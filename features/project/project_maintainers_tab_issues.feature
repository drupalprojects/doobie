@project @maintainers @issues
Feature: 'Maintain issues' permission check
  In order to get help maintaining my project issues
  As a project owner
  I need to be able to add people to my project with appropriate permissions

  @failing
 Scenario: Create a new project and an issue
    Given users:
      | name            | pass     | mail                                | roles           |
      | Git Vetted User | password | qa+gitvetted@association.drupal.org | Git vetted user |
    And I am logged in as "Git Vetted User"
    And I am at "/node/add/project-distribution"
    When I create a "sandbox" project
    Then I should see project data
    And I follow "open"
    And I follow "Create a new issue"
    And I create a new issue

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
 Scenario: Assign Maintain issues permission to a maintainer
    Given users:
      | name            | pass     | mail                                | roles           |
      | Git Vetted User | password | qa+gitvetted@association.drupal.org | Git vetted user |
    And I am logged in as "Git Vetted User"
    And I am on the Maintainers tab
    When I assign "Maintain issues" to the maintainer "git user"
    And I press "Update"
    Then I should see "Maintainer permissions updated"

  @dependent @failing
 Scenario: Log in as maintainer and see creator username in Assigned drop down : git user can assign an issue to maintainer
    Given users:
      | name     | pass     | mail                              | roles    |
      | Git User | password | qa+gituser@association.drupal.org | Git user |
    And I am logged in as "Git User"
    And I am on the project page
    And I follow "open"
    And I follow an issue of the project
    And I click "Edit"
    And I select "git vetted user" from "Assigned"
    And I press "Save"
    Then I should see "git vetted user" in the "Assigned" metadata

  @dependent @failing
 Scenario: Unassign Maintain issues permission from a maintainer
    Given users:
      | name            | pass     | mail                                | roles           |
      | Git Vetted User | password | qa+gitvetted@association.drupal.org | Git vetted user |
    And I am logged in as "Git Vetted User"
    And I am on the Maintainers tab
    When I unassign "Maintain issues" from the maintainer "git user"
    And I press "Update"
    Then I should see "Maintainer permissions updated"

  @dependent @clean_data @failing
 Scenario: Log in as maintainer and see creator username in Assigned drop down : git user can assign an issue to maintainer
    Given users:
      | name     | pass     | mail                              | roles    |
      | Git User | password | qa+gituser@association.drupal.org | Git user |
    And I am logged in as "Git User"
    And I am on the project page
    And I follow "open"
    And I follow an issue of the project
    And I click "Edit"
    Then the "Assigned" field should not contain "git vetted user"
