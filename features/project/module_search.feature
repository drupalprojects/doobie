@project @search @anon
Feature: Find modules
  In order to extend Drupal's core functionality
  As a site builder
  I need to be able to find contributed modules

  Scenario Outline: Search by name
    Given I am on "/project/<path>"
    When I fill in "Search <type>" with "<term>"
    And I press "Search" in the "content" region
    Then I should not see "No projects found in this category."
    And I should see the heading "<term>"

  Examples:

    | path                 | type                | term                   |
    | project_module       | Modules             | Masquerade             |
    | project_theme        | Themes              | Zen                    |
    | project_core         | Drupal Cores        | Fake core              |
    | project_distribution | Distributions       | OpenScholar            |
    | project_drupalorg    | Drupal.org projects | Association.drupal.org |
    | project_theme_engine | Theme engines       | wgSmarty theme engine  |
    | project_translation  | Translations        | Haitian Creole         |
