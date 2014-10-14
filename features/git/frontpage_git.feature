@front @ci
Feature: See git activity on the front page
  In order to see how active drupal development is
  As any user
  I should be able to see commit data on the Drupal.org front page

  Background:
    Given I am on the homepage

  @gitrepo @clean_data @timeout @smoke @local @cache @api @failing
 Scenario: Create sample data, push commits and view the commits on the homepage
    Given users:
      | name     | pass     | mail                              | roles    |
      | Git User | password | qa+gituser@association.drupal.org | Git user |
    And I am logged in as "Git User"
    And I am on "/node/add/project-module"
    And I create a "sandbox" project
    And I see project data
    And I follow "Version control"
    And I initialize the repository
    And I reload the page
    When I push "2" commits to the repository
    And I follow "Drupal Homepage"
    And the cache has been cleared
    And I visit "/home#tab-commits"
    Then I should see the link "by gituser: From the step definition"

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
    And I should see the heading "All commits"

  @anon
  Scenario: Commit tab
    Then I should see at least "5" links under the "Commits" tab
    And I should see "Posted by"
    And I should see the newest commits from commitlog

  @anon
  Scenario: Commit tab: More commit messages
    When I follow "More commit messages…"
    Then I should be on "/commitlog"
    And I should see the heading "All commits"

  @anon
  Scenario: Commit tab: Follow a commit
    When I follow a commit from the list
    And I should see "Commit"
