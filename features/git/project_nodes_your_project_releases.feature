@wip @slow @javascript
Feature: Manage releases
  In order to make releases available to users
  As a project owner
  I should be able to create releases

  Scenario: Add git vetted user as maintainer
    Given I am logged in as "admin test"
    And I visit "/node/1791620/maintainers"
    And I wait until the page loads
    When I enter "git vetted user" for field "Maintainer user name"
    And I select "git vetted user" from the suggestion "Maintainer user name"
    And I press "Update"
    And I wait until the page loads
    Then I should see "added and permissions updated"

  @dependent
  Scenario: Assign permissions to git vetted user
    Given I am logged in as "admin test"
    And I visit "/node/1791620/maintainers"
    And I wait until the page loads
    When I assign the following <permissions> to the maintainer "git vetted user"
    | permissions            |
    | Write to VCS           |
    | Edit project           |
    | Administer maintainers |
    | Administer releases    |
    And I press "Update"
    Then I should see "Maintainer permissions updated"

  @dependent
  Scenario: View releases links
    Given I am logged in as "git vetted user"
    When I visit "/project/test_releases"
    And I wait until the page loads
    Then I should see the following <links>
    | links                    |
    | View all releases        |
    | Add new release          |
    | Administer releases      |
    | Actively maintained      |
    | Under active development |

  @dependent
  Scenario: Create a new branch
  Given I am logged in as "git vetted user"
    And I visit "/project/test_releases"
    And I wait until the page loads
    And I see project data
    And I am on the Version control tab
    And I clone the repo
    When I create a new branch for "6.x" version
    And I reload the page
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
    And I select "New features" from "Release type"
    And I fill in "Release notes" with random text
    And I press "Save"
    Then I should see "has been created"
    And the release should not be published

  @dependent @flaky
  Scenario: Create a new tag
    Given I am logged in as "git vetted user"
    And I visit "/project/test_releases"
    And I wait until the page loads
    And I see project data
    And I am on the Version control tab
    And I wait until the page loads
    And I clone the repo
    When I create a new tag for "7.x" version
    And I visit "/project/test_releases"
    And I follow "Add new release"
    Then I should see the tag in the dropdown "Git release tag or branch"

  @dependent @git_tag @flaky
  Scenario: Create a release for the above tag
    Given I am logged in as "git vetted user"
    And I visit "/project/test_releases"
    And I wait until the page loads
    When I follow "Add new release"
    And I wait until the page loads
    And I select a tag from "Git release tag or branch"
    And I press "Next"
    And I select "New features" from "Release type"
    And I fill in "Release notes" with random text
    And I press "Save"
    Then I should see "has been created"
    And the release should not be published

  @anon
  Scenario: View all releases as anonymous and no releases should be published
    Given I am at "/project/test_releases"
    When I follow "View all releases"
    And I wait until the page loads
    Then I should see "API version"
    And I should see "There are no published releases for this project"

  @dependent
    Scenario: Remove git vetted user
    Given I am logged in as "admin test"
    And I visit "/node/1791620/maintainers"
    And I wait until the page loads
    When I follow "delete" for the maintainer "git vetted user"
    And I press "Delete"
    Then I should see "Removed"
    And I should see "as a maintainer"
