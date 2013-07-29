@project @search
Feature: Find modules
  In order to extend Drupal's core functionality 
  As a site builder
  I need to be able to find contributed modules
  
  Scenario: Search by name
    Given I am on "/project/project_module"
    When I fill in "Search Modules" with "Masquerade"
    And I press "Search" in the "content" region
    Then I should not see "No projects found in this category."
    And I should see the heading "Masquerade"
