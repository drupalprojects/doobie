@ci
Feature: To see the list of all the commits
  In order to see the list of commits
  As a user
  I should got to the commit log page

  @smoke
  Scenario: View the list of commits
    Given that I am on the homepage
    When I follow "Commits"
    And I follow "More commit messages..."
    Then I should see the heading "Commit messages"
    And I should see at least "10" records
    And I should see the following <texts>
    | texts              |
    | Commit             |
    | Subscribe with RSS |
    | next               |
    And I should see the link "next"

  Scenario: Click link to project title
    Given I am on "/commitlog"
    When I click on "project title" of a commit
    Then I should see "Posted by"
    And I should see the link "View"
    And I should see the link "Version control"
    And I should see the heading "Development"

  Scenario: Click link to date
    Given I am on "/commitlog"
    When I click on "date" of a commit
    Then I should see "Author date:"
    And I should see "Commit"

  Scenario: Click link to user profile
    Given I am on "/commitlog"
    When I click on "user name" of a commit
    Then I should see the following <texts>
    | texts      |
    | Member for |
    | History    |

  Scenario: Click link to repository
    Given I am on "/commitlog"
    When I click on "commit info" of a commit
    Then I should see the link "summary"
    And I should see the following <texts>
    | texts     |
    | author    |
    | committer |
    | commit    |
    | tree      |

  Scenario: Check that project title is displayed first
    Given that I am on the homepage
    When I follow "Commits"
    And I follow "More commit messages..."
    Then I should see the heading "Commit messages"
    And I should see project name in the first part of the heading
