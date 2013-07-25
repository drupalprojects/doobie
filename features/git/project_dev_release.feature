@slow
Feature: Manage development releases
  In order to make development releases available to users
  As a project owner
  I should be able to create a branch and development release

  @javascript
  Scenario: Add git vetted user as maintainer
    Given I am logged in as "admin test"
    When I visit "/project/test_releases"
    And I follow "Maintainers"
    And I wait until the page loads
    Then I should see "git vetted user" as a maintainer

  @dependent
  Scenario: Create a new branch
  Given I am logged in as "git vetted user"
    And I visit "/project/test_releases"
    And I see project data
    And I am on the Version control tab
    And I clone the repo
    When I create a new branch for "6.x" version
    And I visit the Version control tab
    Then I should see the branch in the dropdown "Version to work from"

  @dependent @git_branch
  Scenario: Create a release for the above branch
    Given I am logged in as "git vetted user"
    And I visit "/project/test_releases"
    When I follow "Add new release"
    And I select a branch from "Git release tag or branch"
    And I press "Next"
    And I select "New features" from "Release type"
    And I fill in "Release notes" with random text
    And I press "Save"
    Then I should see "has been created"
    And the release should not be published
