@known_git6failure @anon @wip
Feature: Visitor searches content and gets results from multiple sites
  In order to see search results from other drupal sites
  As a visitor to Drupal.org
  I want to search for the term 'views' under Groups meta filter

  Scenario: Search multisites
    Given I am on "/search/apachesolr_multisitesearch/views"
    When I follow "Groups ("
    Then I should see at least "10" records
    And I should see the heading "Search results"
    And the results should not link to Drupal.org

  Scenario: Follow a result
    Given I am on "/search/apachesolr_multisitesearch/views?filters=ss_meta_type:group"
    When I follow "Views"
    Then I should see "views"
    And I should see the link "Go to Drupal.org"
