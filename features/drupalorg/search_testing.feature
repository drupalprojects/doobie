@anon
Feature: To test search on various pages
  In order to search for some content
  As a user
  I should be able to fill a field and press the search button

  Scenario: Search using site wide search box
    Given that I am on the homepage
    When I search sitewide for "Drupal.org BDD"
    Then I should see "Your search yielded no results"

  Scenario: Search using issues search box in content region
    Given I am on "/project/issues"
    When I fill in "Doobie" for "Search for"
    And I press "Search" in the "content" region
    Then I should see at least "1" record
    And I should see "Drupal.org BDD"

  Scenario: Search using issues search box in right sidebar region
    Given I am on "/project/doobie"
    When I fill in "doobie" for "edit-text"
    And I press "Search" in the "right sidebar" region
    Then I should see at least "1" record
    And I should see "Feature/Scenarios"
