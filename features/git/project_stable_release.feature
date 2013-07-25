@slow
Feature: Manage stable releases
  In order to make stable releases available to users
  As a project owner
  I should be able to create a tag and stable release
  
  @javascript
  Scenario: Add git vetted user as maintainer
    Given I am logged in as "admin test"
    And I am on "/project/test_releases"
    When I follow "Maintainers"
    And I wait until the page loads
    Then I should see "git vetted user" as a maintainer

  @dependent
  Scenario: Create a new tag
    Given I am logged in as "git vetted user"
    And I visit "/project/test_releases"
    And I see project data
    And I am on the Version control tab
    And I clone the repo
    When I create a new tag for "7.x" version
    And I visit "/project/test_releases"
    And I follow "Add new release"
    Then I should see the tag in the dropdown "Git release tag or branch"

  @dependent @git_tag @flaky
  Scenario: Create a release for the above tag
    Given I am logged in as "git vetted user"
    And I visit "/project/test_releases"
    When I follow "Add new release"
    And I select a tag from "Git release tag or branch"
    And I press "Next"
    And I select "New features" from "Release type"
    And I fill in "Release notes" with random text
    And I press "Save"
    Then I should see "has been created"
    And the release should not be published
