@downloads @anon @wip
Feature: Find Drupal themes
  In order to make my site visually distinct from other sites
  As a site builder
  I should be able to browse available themes
  
  Scenario: Find out about Themes
    Given I am on "/download"
    And I follow "About Themes & Subthemes"
	Then I should see the heading "About theming"
	And I should see "You can do more with a theme"
	
  Scenario: View Most Installed Themes
    Given I am on "/download"
    And I follow "Most Installed Themes"
    Then I should see "Themes match your search"
    And I should see "Themes allow you to change the look and feel of your Drupal site"
    And I should see "Posted by"
  
  Scenario: View New Themes
    Given I am on "/download"
    And I follow "New Themes"
    Then I should see "Themes match your search"
    And I should see "Themes allow you to change the look and feel of your Drupal site"
    And I should see "Posted by"
  
  Scenario: View Most Active Themes
    Given I am on "/download"
    And I follow "Most Active Themes"
    Then I should see "Themes match your search"
    And I should see "Themes allow you to change the look and feel of your Drupal site"
    And I should see "Posted by"

  Scenario: Visit Themes page
    Given I am on "/download"
    And I follow "Themes"
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