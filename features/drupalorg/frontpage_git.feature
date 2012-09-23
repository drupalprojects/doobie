Feature: See git activity on home page
  In order to see how active drupal development is
  As any user
  I should be able to see commit data on the drupal.org home page

  Background:
    Given I am on the homepage

  Scenario: Code commit link 
    When I follow "Code commits"
    Then I should be on "/commitlog"
    And I should see the heading "Commit messages"       

  Scenario: Commit tab
    When I follow "Commits" 
    Then I should see "More commit messages..."


