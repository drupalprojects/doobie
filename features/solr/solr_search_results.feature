@known_git6failure
Feature: Visitor searches site for Views
  In order to see relevant search results and filters
  As a visitor to Drupal.org
  I want to search for the term 'views'
 
  Scenario: Drupal.org has facet blocks on search results page
    When I go to "/search/apachesolr_search/views"
    Then I should see "or filter by…"
    And I should see "or search for…"
