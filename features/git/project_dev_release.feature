@wip @slow @javascript
Feature: Manage development releases
  In order to make development releases available to users
  As a project owner
  I should be able to create a branch and development release

  Scenario: Add git vetted user as maintainer
    Given I am logged in as "admin test"
    And I visit "/node/1791620/maintainers"
    And I wait until the page loads
    When I enter "git vetted user" for field "Maintainer user name"
    And I wait "3" seconds
    And I select "git vetted user" from the suggestion "Maintainer user name"
    And I wait "2" seconds
    And I check the box "edit-new-maintainer-permissions-write-to-vcs"
    And I check the box "edit-new-maintainer-permissions-edit-project"
    And I check the box "edit-new-maintainer-permissions-administer-releases"
    And I press "Update"
    And I wait until the page loads
    Then I should see "New maintainer git vetted user added and permissions updated"

  @dependent
  Scenario: Create a new branch
  Given I am logged in as "git vetted user"
    And I visit "/project/test_releases"
    And I wait until the page loads
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
    And I wait until the page loads
    When I follow "Add new release"
    And I wait until the page loads
    And I select a branch from "Git release tag or branch"
    And I press "Next"
    And I wait until the page loads
    And I select "New features" from "Release type"
    And I fill in "Release notes" with random text
    And I press "Save"
    And I wait until the page loads
    Then I should see "has been created"
    And the release should not be published

  @dependent
  Scenario: Remove git vetted user
    Given I am logged in as "admin test"
    And I visit "/node/1791620/maintainers"
    And I wait until the page loads
    When I follow "delete" for the maintainer "git vetted user"
    And I press "Delete"
    Then I should see "Removed git vetted user as a maintainer"
