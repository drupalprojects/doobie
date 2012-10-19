@flaky
Feature: To see the list of all the commits for a user
  In order to see the list of commits for a user
  As an authenticated user
  I should log in and see my commits log

  Background:
    Given I am logged in as "git user"
    And I follow "Your Dashboard"
    And I follow "Your Commits"

  @gitrepo @flaky
  Scenario: Git User creates a project
    When I visit "/node/add/project-project"
    And I create a "module"
    And I see project data
    And I follow "Version control"
    Then I initialize the repository
    And I follow "Version control"
    And I push "3" commits to the repository

  @dependent
  Scenario: Visit your commits page and view the contents
    When I visit "/user"
    And I follow "Your Commits"
    Then I should see at least "3" records
    And I should see the following <texts>
    | texts              |
    | Commit             |
    | master             |
    | Subscribe with RSS |

  @dependent
  Scenario: Click link to user profile
    When I click on "user name" of a commit
    Then I should see the following <texts>
    | texts           |
    | History         |
    | Git attribution |
    | Member for      |

  @dependent
  Scenario: Click link to project title: Full project
    When I click on "project title" of a commit
    Then I should see "Posted by"
    And I should see the link "View"
    And I should see the heading "Development"

  @dependent
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

  @dependent
  Scenario: Click link to date
    When I click on "date" of a commit
    Then I should see "Author date:"
    And I should see "Custom text:"
    And I should see "Commit"

  @clean_data @dependent
  Scenario: Click link to repository
    When I click on "commit info" of a commit
    Then I should see the link "summary"
    And I should see the following <texts>
    | texts     |
    | author    |
    | committer |
    | commit    |
    | tree      |
