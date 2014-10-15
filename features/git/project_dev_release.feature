@slow @releases @project
Feature: Manage development releases
  In order to make development releases available to users
  As a project owner
  I should be able to create a branch and development release

  @javascript @failing
  Scenario: Add git vetted user as maintainer
    Given users:
      | name                | pass     | mail                                    | roles         |
      | Administrative User | password | qa+administrator@association.drupal.org | administrator |
    And I am logged in as "Administrative User"
    When I visit "/project/git_deploy"
    And I follow "Maintainers"
    And I wait until the page loads
    Then I should see "git vetted user" as a maintainer

  @dependent @failing
  Scenario: Create a new branch
    Given users:
      | name            | pass     | mail                                | roles           |
      | Git Vetted User | password | qa+gitvetted@association.drupal.org | Git vetted user |
    And I am logged in as "Git Vetted User"
    And I visit "/project/git_deploy"
    And I see project data
    And I follow "Version control"
    And I clone the repo
    When I create a new branch for "9.x" version
    And I visit "/project/git_deploy"
    And I follow "Version control"
    Then I should see the branch in the dropdown "Version to work from"

  @dependent @git_branch @failing
  Scenario: Create a release for the above branch
    Given users:
      | name            | pass     | mail                                | roles           |
      | Git Vetted User | password | qa+gitvetted@association.drupal.org | Git vetted user |
    And I am logged in as "Git Vetted User"
    And I visit "/project/git_deploy"
    When I follow "Add new release"
    And I select a branch from "Git release tag or branch"
    And I press "Next"
    And I check the box "New features"
    And I fill in "Release notes" with random text
    And I press "Save"
    Then I should see "has been created"
    And the release should not be published
