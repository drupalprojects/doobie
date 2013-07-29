@content @other
Feature: Get started with Drupal
  In order to use Drupal
  As any user
  I should know how to get started

  @anon
  Scenario: View Get started page
    Given I am on the homepage
    When I follow "Get Started"
    And I wait until the page is loaded
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

  @anon
  Scenario: View the links under Most popular modules
    Given I am on the homepage
    When I follow "Get Started"
    Then I should see the following <links> under "Most popular modules"
    | links    |
    | Views    |
    | Token    |
    | Pathauto |

  @anon
  Scenario: Follow All modules link
    Given I am on "/start"
    When I follow "All modules"
    Then I should not see "Recoverable fatal error"
    And I should see "Modules categories"
    And I should see "Search Modules:"
    And I should see the text "Extend and customize Drupal functionality with contributed modules."
    And I should see "Posted by"

  @anon
  Scenario: View the links under Most popular themes
    Given I am on the homepage
    When I follow "Get Started"
    Then I should see the following <links> under "Most popular themes"
    | links         |
    | Zen           |
    | Omega         |
    | AdaptiveTheme |
    | Fusion        |

  @anon
  Scenario: Follow All themes link
    Given I am on "/start"
    When I follow "All themes"
    Then I should not see "Recoverable fatal error"
    And I should see "Themes match your search"
    And I should see "Search Themes:"
    And I should see "Themes allow you to change the look and feel of your Drupal site."
    And I should see "Posted by"

  @anon
  Scenario: View the links under Translations
    Given I am on the homepage
    When I follow "Get Started"
    Then I should see the following <links> under "Translations"
    | links     |
    | Catalan   |
    | French    |
    | Hungarian |
    | Dutch     |

  @anon
  Scenario: Follow All translations link
    Given I am on "/start"
    When I follow "All translations"
    Then I should see "Drupal translations"
    And I should see "Pick a language"

  @anon
  Scenario: Follow Download drupal
    Given I am on "/start"
    When I follow "Download Drupal"
    And I wait until the page is loaded
    Then I should see the heading "Download & Extend"
    And I should see "Get started by downloading the official Drupal core files"
    And I should see the following <texts>
    | texts                |
    | Downloads            |
    | Recommended releases |
    | Development releases |
    And I should see the link "7."

  @anon
  Scenario: Follow Find distribution
    Given I am on "/start"
    When I follow "Find a Distribution"
    And I wait until the page is loaded
    Then I should not see "Recoverable fatal error"
    And I should be on "/project/distributions"
    And I should see the heading "Download & Extend"
    And I should see "Distributions provide site features and functions for a specific type of site"

  @anon
  Scenario: Drupal book image
    Given I am on the homepage
    When I follow "Get Started"
    Then I should see book image under Drupal books

  @anon
  Scenario: Follow All documentation
    Given I am on "/start"
    When I follow "All documentation"
    And I wait until the page is loaded
    Then I should not see "Recoverable fatal error"
    And I should see the heading "Community Documentation"
    And I should see "The Drupal.org Community Documentation is maintained by the Drupal community."
    And I should see the following <links>
    | links                |
    | Understanding Drupal |
    | Installation Guide   |
    | Administration Guide |
    | Structure Guide      |
    | Site Building Guide  |
    | Multilingual Guide   |
    | Theming Guide        |
    | Mobile Guide         |
    And I should see "Developer Guides"
    And I should see "Other information"
