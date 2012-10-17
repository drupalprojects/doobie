@known_git6failure @anon @wip @slow
Feature: Visitor searches site and sorts the results
  In order to see relevant search results
  As a visitor to Drupal.org
  I want to search for few terms and sort the results
   
  Background: 
    Given I am on "/search/site/views?f[0]=ss_meta_type%3Amodule"

  Scenario: Search and sort by most installed
    Then show last response 
    When I select "Most installed" from "Sort by"
    Then I should see the results sorted by most installed modules
    And I should see the heading "Search results"
  
  Scenario: Search and sort by last build
    When I select "Last build" from "Sort by"
    And I should see the results sorted by last build of the project
    Then I should see the heading "Search results"
  
  Scenario: Search and sort by last release
    When I select "Last release" from "Sort by"
    Then I should see the results sorted by latest release of the project
    And I should see the heading "Search results"
