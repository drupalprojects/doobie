@wip @project @anon
Feature: Find modules
  In order to extend Drupal's core functionality 
    As a site builder
    I need to be able to find contributed modules

  # we use the id instead of the label here because the page contains duplicates
  Scenario: Search by name
    Given I am on "/project/modules"
    When I fill in "Search Modules" with "Masquerade"
    And I press "edit-submit"
    Then I should not see "No projects found in this category."
    And I should see the heading "Masquerade"
