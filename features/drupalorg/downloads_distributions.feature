@downloads @anon @wip
Feature: Find Drupal distributions
  In order to avoid re-inventing the wheel
  As a site builder
  I should be able to browse available distributions
  
  Scenario: Find out about Distributions
    Given I am on "/download"
    And I follow "About Distributions"
    Then I should see the heading "Distributions"
    And I should see "What are distributions?"
    And I should be on "/documentation/build/distributions"

  Scenario: View Most Installed Distributions
    Given I am on "/download"
    And I follow "Most Installed Distributions"
    Then I should see "Distributions match your search"
    And I should see "Distributions provide site features and functions for a specific type"
    And I should see "Posted by"
  
  Scenario: View New Distributions
    Given I am on "/download"
    And I follow "New Distributions"
    Then I should see "Distributions match your search"
    And I should see "Distributions provide site features and functions for a specific type"
    And I should see "Posted by"
  
  Scenario: View Most Active Distributions
    Given I am on "/download"
    And I follow "Most Active Distributions"
    Then I should see "Distributions match your search"
    And I should see "Distributions provide site features and functions for a specific type"
    And I should see "Posted by"

  Scenario: Visit Distributions page
    Given I am on "/download"
    And I follow "Distributions"
    Then I should be on "/project/distributions"
    And I should see the following <tabs>
    | tabs                   |
    | Download & Extend Home |
    | Drupal Core            |
    | Distributions          |
    | Modules                |
    | Distributions                 |
    And I should see that the tab "Distributions" is highlighted
    And I should see "Distributions match your search"
    And I should see "Distributions provide site features and functions for a specific type"
    And I should see "Posted by"