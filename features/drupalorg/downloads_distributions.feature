@downloads @anon
Feature: Find Drupal distributions
  In order to avoid re-inventing the wheel
  As a site builder
  I should be able to browse available distributions

  Scenario: Find out about Distributions
    Given I am on "/download"
    When I follow "About Distributions"
    Then I should see the heading "Distributions"
    And I should see "What are distributions?"
    And I should be on "/documentation/build/distributions"

  Scenario Outline: View links under Distributions
    Given I am on "/download"
    When I follow "<link>"
    Then I should see "Distributions match your search"
    And I should see "Distributions provide site features and functions for a specific type"
    And I should see "Posted by"

    Examples:
    | link                         |
    | Most Installed Distributions |
    | New Distributions            |
    | Most Active Distribitions    |

  Scenario: Visit Distributions page
    Given I am on "/download"
    When I follow "Distributions"
    Then I should be on "/project_distribution"
    And I should see the following <tabs>
    | tabs                   |
    | Download & Extend Home |
    | Drupal Core            |
    | Distributions          |
    | Modules                |
    | Distributions          |
    And I should see that the tab "Distributions" is highlighted
    And I should see "Distributions match your search"
    And I should see "Distributions provide site features and functions for a specific type"
    And I should see "Posted by"
