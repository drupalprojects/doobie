@downloads @known_git6failure @anon @wip
Feature: Find modules to extend Drupal
  In order to add additional functionality to my site
  As a sitebuilder
  I should be able to browse various lists of modules

  @slow @timeout
  Scenario: View most installed modules
    Given I am on the homepage
    When I follow "Download and Extend"
    Then I should see the following <links> under "Most installed"
    | links    |
    | Views    |
    | Token    |
    | Pathauto |
    And I should see at least "4" most installed modules

  Scenario: View more most installed modules
    Given I am on "/download"
    When I follow "More Most installed"
	Then I should see "Modules match your search"
    And I should see "Modules categories"
    And I should see "Search Modules:"
    And I should see the text "Extend and customize Drupal functionality with contributed modules."

  Scenario: View module categories
    Given I am on the homepage
    When I follow "Download and Extend Drupal"
    Then I should see the following <links> under "Module Categories"
    | links          |
    | Administration |
    | Community      |
    | Event          |
    | Media          |

  Scenario: View all module categories
    Given I am on "/download"
    When I follow "All Categories"
    Then I should see the heading "Modules categories"
	And I should see "Filter by compatibility"
    And I should see the heading "Administration"
    And I should see the heading "User Management"

  Scenario: View more new modules
    Given I am on "/download"
	And I follow "More New Modules"
	Then I should see "Modules match your search"
	And I should see "Posted by"

  Scenario: View full modules index
    Given I am on "/download"
	And I follow "View full index"
	Then I should be on "/project/modules/index"
	And I should see the heading "Modules index"
	And I should see "Views"
	And I should see "Link"	

  Scenario: Visit Modules page
    Given I am on "/download"
	And I follow "Modules"
	Then I should be on "/project/modules"
	And I should see the following <tabs>
    | tabs                   |
    | Download & Extend Home |
    | Drupal Core            |
    | Distributions          |
	| Modules                |
    | Themes                 |
    And I should see that the tab "Modules" is highlighted
	And I should see "Modules match your search"
	And I should see "Extend and customize Drupal functionality with contributed modules"
	And I should see "Posted by"