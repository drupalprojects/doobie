@downloads @known_git6failure @anon @wip
Feature: List of downloadable drupal modules
  In order know popular/new drupal modules
  As a user
  I should be able to see the summary of modules and filter them

  @slow @timeout
  Scenario: Most installed modules block
    Given I am on the homepage
    When I follow "Download and Extend Drupal"
    Then I should see the heading "Drupal Modules"
    And I should see the following <links> under "Most installed"
    | links    |
    | Views    |
    | Token    |
    | Pathauto |
    And I should see at least "4" most installed modules

  Scenario: More most installed modules
    Given I am on the homepage
    When I follow "Download and Extend Drupal"
    And I follow "More Most installed"
    Then I should see "Modules categories"
    And I should see "Search Modules:"
    And I should see the text "Extend and customize Drupal functionality with contributed modules."

  Scenario: Module categories block
    Given I am on the homepage
    When I follow "Download and Extend Drupal"
    Then I should see the heading "Drupal Modules"
    And I should see the following <links> under "Module Categories"
    | links          |
    | Administration |
    | Community      |
    | Event          |
    | Media          |

  Scenario: More categories
    Given I am on the homepage
    When I follow "Download and Extend Drupal"
    And I follow "All Categories"
    Then I should see the heading "Modules categories"
    And I should see the heading "Administration"
    And I should see the heading "User Management"

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
