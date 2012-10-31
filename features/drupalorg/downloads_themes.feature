@downloads @anon
Feature: Find Drupal themes
  In order to make my site visually distinct from other sites
  As a site builder
  I should be able to browse available themes
  
  Scenario: Find out about Themes
    Given I am on "/download"
    When I follow "About Themes & Subthemes"
    Then I should see the heading "About theming"
    And I should see "You can do more with a theme"
	
  Scenario Outline: Visit links under Themes
    Given I am on "/download"
    When I follow "<link>"
    Then I should see "Themes match your search"
    And I should see "Themes allow you to change the look and feel of your Drupal site"
    And I should see "Posted by"

    Examples:
    | link                     |
    | Most Installed Themes    |
    | New Themes               |
    | Most Active Themes       |

  @javascript
  Scenario: Visit Themes page
    Given I am on "/download"
    When I follow "Themes"
    And I wait until the page loads
    Then I should be on "/project/themes"
    And I should see the following <tabs>
    | tabs                   |
    | Download & Extend Home |
    | Drupal Core            |
    | Distributions          |
    | Modules                |
    | Themes                 |
    And I should see that the tab "Themes" is highlighted
    And I should see "Themes match your search"
    And I should see "Themes allow you to change the look and feel of your Drupal site"
    And I should see "Posted by"
    And I should see the heading "Drupal Themes"
    And I should see "Theme guide"
    And I should see "More advanced themes are table-less"
