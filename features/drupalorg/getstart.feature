@get_started @known_git6failure
Feature: Get started with Drupal
  In order to use Drupal
  As any user
  I should know how to get started

  Scenario: View Get started page
    Given I am on the homepage
    When I follow "Get Started"
    Then I should see "Get Started with Drupal"
	And I should see "Download hundreds of"
    And I should see the heading "Most popular modules"
    And I should see the heading "Most popular themes"
    And I should see the heading "Translations"
	And I should see the heading "Most popular guides"
	And I should see the heading "Drupal books"
    And I should see the following <links>
    | links                |
    | Drupal core          |
    | web hosting provider |
    | distributions        |
	| our forums           |
	| IRC channels         |

  Scenario: View the links under Most popular modules
    Given I am on the homepage
    When I follow "Get Started"
    Then I should see the following <links> under "Most popular modules"
    | links    |
    | Views    |
    | Token    |
    | Pathauto |

  Scenario: Follow All modules link
    Given I am on "/start"
    When I follow "All modules"
    Then I should see "Modules categories"
    And I should see "Search Modules:"
    And I should see the text "Extend and customize Drupal functionality with contributed modules."
	And I should see "Posted by"

  Scenario: View the links under Most popular themes
    Given I am on the homepage
    When I follow "Get Started"
    Then I should see the following <links> under "Most popular themes"
    | links         |
    | Zen           |
    | Omega         |
    | AdaptiveTheme |
    | Fusion        |

  Scenario: Follow All themes link
    Given I am on "/start"
    When I follow "All themes"
    Then I should see "Themes match your search"
    And I should see "Search Themes:"
    And I should see "Themes allow you to change the look and feel of your Drupal site."
	And I should see "Posted by"

  Scenario: View the links under Translations
    Given I am on the homepage
    When I follow "Get Started"
    Then I should see the following <links> under "Translations"
    | links     |
    | Catalan   |
    | French    |
    | Hungarian |
    | Dutch     |

  Scenario: Follow All translations link
    Given I am on "/start"
    When I follow "All translations"
    Then I should see "Drupal translations"
    And I should see "Pick a language"