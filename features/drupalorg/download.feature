@downloads @known_git6failure @anon @wip
Feature: Download and Extend Drupal
  In order to know popular/new drupal modules
  As a user
  I should be able to see the summary of modules and filter them

  Scenario: View Download & Extend page
    Given I am on the homepage
    When I follow "Download & Extend"
	Then I should be on "/download"
    And I should see the following <tabs>
    | tabs                   |
    | Download & Extend Home |
    | Drupal Core            |
    | Distributions          |
	| Modules                |
    | Themes                 |
    And I should see that the tab "Download & Extend Home" is highlighted
	And I should see "Download Drupal core files, and extend your site"
	And I should see the following <texts>
    | texts             |
    | Download & Extend |
    | Core              |
    | Distributions     |
    | Themes            |
    | Translations      |
	| Drupal Modules    |
    | Most installed    |
    | Module Categories |
    | New Modules       |
    | Module Index      |
    And I should see "Show only modules for Drupal version"	
  
  Scenario Outline: Visit links on Download & Extend page
  Given I am on "/download"
  When I follow "<link>"
  Then I should be on "<url>"

  Examples:
  | link                            | url                    |
  | Download Drupal 7               | /project/drupal        |
  | Download Drupal 6               | /project/drupal        |
  | Other Releases                  | /node/3060/release     |
  | More Information                | /project/drupal        |
  | Search for More Distributions   | /project/distributions |
  | Search for More Themes          | /project/themes        |
  
  Scenario: Find out about Distributions
    Given I am on "/download"
	And I follow "About Distributions"
	Then I should see the heading "Distributions"
	And I should see "What are distributions?"
	And I should be on "/documentation/build/distributions"

  Scenario: Find out about Themes
    Given I am on "/download"
    And I follow "About Themes & Subthemes"
	Then I should see the heading "About theming"
	And I should see "You can do more with a theme"

  @anon
  Scenario: View the links under Translations
    Given I am on "/download"
    Then I should see the following <links> under "Translations"
    | links     |
    | Catalan   |
    | French    |
    | Hungarian |
    | Dutch     |
	
  Scenario: View all translations
    Given I am on "/download"
	And I follow "All translations"
	Then I should see the heading "Translate"
	And I should see the heading "Drupal translations"
	And I should see "Install Drupal localized with translation"
	And I should be on "localize.drupal.org"
  
  @slow @timeout
  Scenario: View most installed modules
    Given I am on the homepage
    When I follow "Download and Extend Drupal"
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

  Scenario: Search for new modules
    Given I am on the homepage
    When I follow "Download and Extend Drupal"
    And I select "7.x" from "Show only modules for Drupal version:"
    And I press "Search" in the "content" region
    And I follow the result under "New Modules"
    And I follow "View all releases"
    Then I should see the link "7.x"

  Scenario: Search for module index
    Given I am on the homepage
    And I follow "Download and Extend Drupal"
    When I select "8.x" from "Show only modules for Drupal version:"
    And I press "Search" in the "content" region
    And I follow the result under "Module Index"
    And I follow "View all releases"
    Then I should see the link "8.x"
