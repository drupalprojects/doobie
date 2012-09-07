@wip
Feature: To see the list of all the commits for a user
  In order to see the list of commits for a user
  As an authenticated user
  I should login and see my commits log

  Background:
    Given I am logged in as "git user"
    And I follow "Your Dashboard"
    And I follow "Your Commits"

  @gitrepo
  Scenario: Git User creates a project
    Given I am at "/node/add/project-project"
    And I create a "module"
    And I see the project title
    And I follow "Version control"
    When I initialize the repository
    Then I should be able to push a commit to the repository
    And I should be able to push one more commit to the repository

  Scenario: Check for records
    Then I should see at least "5" records
    And I should see the following <texts>
    | texts              |
    | Commit             |
    | master             |
    | Subscribe with RSS |

  Scenario: Click link to user profile
    When I click on "user name" of a commit
    Then I should see the heading "Personal information"
    And I should see the following <texts>
    | texts           |
    | Country         |
    | History         |
    | Git attribution |

  Scenario: Click link to project title: Full project
    When I click on "project title" of a commit
    Then I should see "Posted by"
    And I should see the link "View"
    And I should see the heading "Development"

  Scenario: Click link to sandbox project title: Sandbox project
    When I click on "sandbox project title" of a commit
    Then I should see "Posted by"
    And I should see the following <texts>
    | texts                     |
    | Experimental Project      |
    | This is a sandbox project |
    | Categories:               |
    | sandbox:                  |
    And I should see the link "View"
    And I should see the heading "Development"

  Scenario: Click link to date
    When I click on "date" of a commit
    Then I should see "Author date:"
    And I should see "Custom text:"
    And I should see "Commit"

  Scenario: Click link to repository
    When I click on "commit info" of a commit
    Then I should see the link "summary"
    And I should see the following <texts>
    | texts     |
    | author    |
    | committer |
    | commit    |
    | tree      |
