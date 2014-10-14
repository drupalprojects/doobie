@slow @project @releases
Feature: Manage stable releases
  In order to make stable releases available to users
  As a project owner
  I should be able to create a tag and stable release

  @javascript @failing
 Scenario: Add git vetted user as maintainer
    Given users:
      | name                | pass     | mail                                    | roles         |
      | Administrative User | password | qa+administrator@association.drupal.org | administrator |
    And I am logged in as "Administrative User"
    And I am on "/project/git_deploy"
    When I follow "Maintainers"
    And I wait until the page loads
    Then I should see "git vetted user" as a maintainer

  @dependent @failing
  Scenario: Create a new tag
    Given users:
      | name            | pass     | mail                                | roles           |
      | Git Vetted User | password | qa+gitvetted@association.drupal.org | Git vetted user |
    And I am logged in as "Git Vetted User"
    And I visit "/project/git_deploy"
    And I see project data
    And I follow "Version control"
    And I clone the repo
    When I create a new tag for "7.x" version
    And I visit "/project/git_deploy"
    And I follow "Add new release"
    Then I should see the tag in the dropdown "Git release tag or branch"

  @dependent @failing
 Scenario: Create a release for the above tag
    Given users:
      | name            | pass     | mail                                | roles           |
      | Git Vetted User | password | qa+gitvetted@association.drupal.org | Git vetted user |
    And I am logged in as "Git Vetted User"
    And I visit "/project/git_deploy"
    When I follow "Add new release"
    And I select a tag from "Git release tag or branch"
    And I press "Next"
    And I check the box "New features"
    And I fill in "Release notes" with random text
    And I press "Save"
    Then I should see "has been created"
    And the release should not be published
