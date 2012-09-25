Feature: See git activity on home page
  In order to see how active drupal development is
  As any user
  I should be able to see commit data on the home page

  Background:
    Given I am on the homepage

  @gitrepo @clean_data
  Scenario: Create sample data and verify the same
    Given I am logged in as "git vetted user"
    And I visit "/node/add/project-project"
    And I create a "module"
    And I see the project title
    And I visit the Version control tab
    And I initialize the repository
    And I follow "Version control"
    When I push "2" commits to the repository
    And I follow "Drupal Homepage"
    And I follow "Commits"
    Then I should see the link "by gitvetteduser: From the step definition"

  @anon
  Scenario: Look for commit link and number of commits
    Then I should see the link "Code commits"
    And I should see "This week"
    And I should see at least "1000" code commits
    And I should see at least "1000" git developers

  @anon
  Scenario: Follow code commit link and verify
    When I follow "Code commits"
    Then I should be on "/commitlog"
    And I should see the heading "Commit messages"

  @anon
  Scenario: Commit tab
    When I follow "Commits"
    Then I should see at least "5" links under the "Commits" tab
    And I should see "Posted by"
    And I should see the newest commits from commitlog

  @anon
  Scenario: Commit tab: More commit messages
    When I follow "Commits"
    And I follow "More commit messages..."
    Then I should be on "/commitlog"
    And I should see the heading "Commit messages"

  @anon
  Scenario: Commit tab: Follow a commit
    When I follow "Commits"
    And I follow a commit from the list
    Then I should see "Author date:"
    And I should see "Commit"
    And I should see "on master"
