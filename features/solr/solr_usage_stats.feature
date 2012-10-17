@known_git6failure @anon @wip @slow
Feature: Visitor searches site and sorts the results
  In order to see relevant search results
  As a visitor to Drupal.org
  I want to search for few terms and sort the results

  Scenario: Search and sort by most installed
    Given I am on "/search/site/views?filters=ss_meta_type:module"
    When I select "Most installed" from "Sort by"
    Then I should see the heading "Search results"
    And I should see the results sorted by most installed modules
  
  Scenario: Search and sort by last build
    Given I am on "/search/site/Masquerade?filters=ss_meta_type:module"
    When I select "Last build" from "Sort by"
    Then I should see the heading "Search results"
    And I should see the results sorted by last build of the project
  
  Scenario: Search and sort by last release
    Given I am on "/search/site/views?filters=ss_meta_type:module"
    When I select "Last release" from "Sort by"
    Then I should see the heading "Search results"
    And I should see the results sorted by latest release of the project