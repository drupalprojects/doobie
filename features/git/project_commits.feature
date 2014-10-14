@ci @git
Feature: View the commits for a project
  In order to track the changes made to the source code of the project
  As a user
  I should see the commits made for the project

  Background:
    Given I am on "/node/1765126"
    And I follow "View commits"

  @smoke
  Scenario: Navigate to commits page
    Then I should see the heading "Commits for BDD Sandbox Test Project-Please do not delete this"
    And I should see at least "5" commits
    And I should see the following <texts>
      | texts              |
      | Commit             |
      | on master          |
      | Subscribe with RSS |
    And I should not see "No commits yet"

  Scenario: Click link to project title
    When I click on "project title" of a commit
    Then I should see "by"
    And I should see "Commit"

  @failing
 Scenario: Click link to date
    When I click on "date" of a commit
    And I should see "Commit"

  @wip @failing
 Scenario: Click link to user profile
    When I click on "user name" of a commit
    Then I should see the following <texts>
      | texts                |
      | History              |
      | Member for           |
      | Personal information |

  @timeout @failing
 Scenario: Click link to repository
    When I click on "commit info" of a commit
    Then I should see the link "summary"
    And I should see the following <texts>
      | texts     |
      | author    |
      | committer |
      | commit    |
      | tree      |
