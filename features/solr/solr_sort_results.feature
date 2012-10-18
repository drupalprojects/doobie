@known_git6failure @anon @wip @slow
Feature: Visitor searches site and sorts the results
  In order to see relevant search results
  As a visitor to Drupal.org
  I want to search for few terms and sort the results
   
  Background: 
    Given I am on "/search/site/views?f[0]=ss_meta_type%3Amodule"

  Scenario: Search and sort by most installed
    When I select "Most installed" from "Sort by"
    Then I should see the results sorted by most installed modules
  
  Scenario: Search and sort by last build
    When I select "Last build" from "Sort by"
    Then I should see the results sorted by last build of the project
  
  Scenario: Search and sort by last release
    When I select "Last release" from "Sort by"
    Then I should see the results sorted by latest release of the project
