@downloads @anon
Feature: Find modules to extend Drupal
  In order to add additional functionality to my site
  As a sitebuilder
  I should be able to browse various lists of modules

  @slow @timeout
  Scenario: View most installed modules
    Given I am on the homepage
    When I follow "Download & Extend"
    Then I should see at least "4" most installed modules

  Scenario: View links under new modules and module index
    Given I am on the homepage
    When I follow "Download & Extend"
    Then I should see the following <links> under "Most installed"
      | links    |
      | Views    |
      | Token    |
      | Pathauto |
    And I should see at least "4" links under "New Modules"
    And I should see at least "4" links under "Module Index"

  Scenario: View more most installed modules
    Given I am on "/download"
    When I follow "More Most installed"
    And I wait until the page loads
    Then I should see "Modules match your search"
    And I should see "Module categories"
    And I should see "Search Modules"
    And I should see the text "Extend and customize Drupal functionality with contributed modules."

  Scenario: View module categories
    Given I am on the homepage
    When I follow "Download and Extend Drupal"
    And I wait until the page loads
    Then I should see the following <links> under "Module Categories"
      | links          |
      | Administration |
      | Community      |
      | Event          |
      | Media          |

  @failing
  Scenario: View all module categories
    Given I am on "/download"
    When I follow "All Categories"
    And I wait until the page loads
    Then I should see the heading "Module categories"
    And I should see the heading "Administration"
    And I should see the heading "User Management"
    And I should see "Filter by compatibilty"

  Scenario: View more new modules
    Given I am on "/download"
    When I follow "More New Modules"
    Then I should see "Modules match your search"
    And I should see "Posted by"

  Scenario: View full modules index
    Given I am on "/download"
    When I follow "View full index"
    Then I should see the heading "Module project index"
    And I should see "Views"
    And I should see "Link"

  Scenario: Visit Modules page
    Given I am on "/download"
    When I follow "Modules"
    Then I should see the following <tabs>
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
