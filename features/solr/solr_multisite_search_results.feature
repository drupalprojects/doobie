@known_git6failure @anon @wip @javascript
Feature: Visitor searches content and gets results from multiple sites
  In order to see search results from other drupal sites
  As a visitor to Drupal.org
  I want to search for the term 'views' under Groups meta filter

  Background:
    Given I am on "/search"
    And I search sitewide for "views"

  Scenario: Search multisites
    When I follow "Groups ("
    Then I should see at least "10" records
    And the results should not link to Drupal.org

  Scenario: Follow a result
    When I follow "Groups ("
    And I follow the first search result
    Then I should see "views"
    And I should see the link "Go to Drupal.org"
