@user @git
Feature: To see the list of all the commits for a user
  In order to see code contributions made by a particular person
  As an authenticated user
  I should be able to see all of a user's code commits from one log

  Background:
    Given I am logged in as the "git user"

  @gitrepo
  Scenario: Visit the commits page and view commits 
    When I visit "/node/add/project-module"
    And I create a "sandbox" project
    And I see project data
    And I follow "Version control"
    And I initialize the repository
    And I follow "Version control"
    And I wait until the page loads
    And I should be able to push a commit to the repository
    And I should be able to push a commit to the repository
    And I should be able to push a commit to the repository
#    And I push "3" commits to the repository
    And I follow "Your Dashboard"
    And I follow "Your Commits"
    And I should see at least "3" records
    Then I should see the following <texts>
    | texts              |
    | Commit             |
    | master             |
    | Subscribe with RSS |

  @dependent
  Scenario: Click link to user profile
    And I follow "Your Dashboard"
    And I follow "Your Commits"
    When I click on "user name" of a commit
    Then I should see the following <texts>
    | texts           |
    | History         |
    | Git attribution |
    | Member for      |

  @dependent
  Scenario: Click link to project title: Full project
    And I follow "Your Dashboard"
    And I follow "Your Commits"
    When I click on "project title" of a commit
    Then I should see "Posted by"
    And I should see the link "View"
    And I should see the heading "Development"

  @dependent
  Scenario: Click link to sandbox project title: Sandbox project
    And I follow "Your Dashboard"
    And I follow "Your Commits"
    When I click on "sandbox project title" of a commit
    Then I should see "Posted by"
    And I should see the following <texts>
    | texts                     |
    | Experimental Project      |
    | This is a sandbox project |
    | Module categories:        |
    | sandbox:                  |
    And I should see the link "View"
    And I should see the heading "Development"

  @dependent
  Scenario: Click link to date
    And I follow "Your Dashboard"
    And I follow "Your Commits"
    When I click on "date" of a commit
    And I should see "Commit"

  @clean_data @dependent
  Scenario: Click link to repository
    And I follow "Your Dashboard"
    And I follow "Your Commits"
    When I click on "commit info" of a commit
    Then I should see the link "summary"
    And I should see the following <texts>
    | texts     |
    | author    |
    | committer |
    | commit    |
    | tree      |
