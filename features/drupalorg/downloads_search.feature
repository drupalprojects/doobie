@downloads @known_git7failure @anon @wip
Feature: Find modules for specific Drupal version
  In order to find modules for Drupal version of my website
  As a sitebuilder
  I should be able to filter modules on download page

  Scenario: Search for new modules
    Given I am on "/download"
    When I select "7.x" from "Show only modules for Drupal version:"
    And I press "Search" in the "content" region
    And I follow the result under "New Modules"
    And I follow "View all releases"
    Then I should see the link "7.x"

  Scenario: Search for module index
    Given I am on "/download"
    When I select "8.x" from "Show only modules for Drupal version:"
    And I press "Search" in the "content" region
    And I follow the result under "Module Index"
    And I follow "View all releases"
    Then I should see the link "8.x"
