@known_git6failure
Feature: Get started with drupal
  In order to learn drupal
  As a user
  I should know how to get started with the site

  Scenario: To verify download & extend page
    Given I am on the homepage
    When I follow "Get Started"
    Then I should see "Get Started with Drupal"
    And I should see the heading "Most popular modules"
    And I should see the heading "Most popular themes"
    And I should see the heading "Translations"
    And I should see the following <links>
    | links                |
    | Drupal core          |
    | web hosting provider |
    | distributions        |

  Scenario: To Identity the links under most installed modules
    Given I am on the homepage
    When I follow "Get Started"
    Then I should see the following <links> under "Most popular modules"
    | links    |
    | Views    |
    | Token    |
    | Pathauto |

  Scenario: To check for all modules
    Given I am on "/start"
    When I follow "All modules"
    Then I should see "Modules categories"
    And I should see "Search Modules:"
    And I should see the text "Extend and customize Drupal functionality with contributed modules."

  Scenario: To identity the links under most installed themes
    Given I am on the homepage
    When I follow "Get Started"
    Then I should see the following <links> under "Most popular themes"
    | links         |
    | Zen           |
    | Omega         |
    | AdaptiveTheme |
    | Fusion        |

  Scenario: To check for more installed modules
    Given I am on "/start"
    When I follow "All themes"
    Then I should see "Themes match your search"
    And I should see "Search Themes:"
    And I should see "Themes allow you to change the look and feel of your Drupal site."

  Scenario: To identity transalations
    Given I am on the homepage
    When I follow "Get Started"
    Then I should see the following <links> under "Translations"
    | links     |
    | Catalan   |
    | French    |
    | Hungarian |
    | Dutch     |

  Scenario: To check for more installed modules
    Given I am on "/start"
    When I follow "All translations"
    And I should see "Drupal translations"
    And I should see "Translation news"