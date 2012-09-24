@anon
Feature: To check the contents of Drupal 7.0 page
  In order to learn more about Drupal 7.0
  As a user
  I should view Drupal 7.0 page

  Scenario: Check for basic content on the page
    Given I am on "/drupal-7.0"
    Then I should see the heading "Friendly and powerful: Drupal 7"
    And I should see the heading "Take a tour"
    And I should see the heading "Features"
    And I should see the following <texts>
    | texts                   |
    | We are proud to present |
    | Easier to use           |
    | See Drupal 7 in action  |
    | Requirements            |
    | This announcement is available in |
    And I should see the following <links>
    | links                     |
    | Get started with Drupal 7 |
    | Installing Drupal 7       |
    | requirements information  |
    | API Documentation         |

  Scenario Outline: Check for language links
    Given I am on "/drupal-7.0"
    When I follow "<language>"
    Then I should see "This announcement is available in"
    And I should see "<translation text 1>"
    And I should see "<translation text 2>"
    And I should not see the following <texts>
    | texts                   |
    | We are proud to present |
    | Easier to use           |
    | See Drupal 7 in action  |
    | Requirements            |
    And I should see the following <texts>
    | texts    |
    | Apache   |
    | MySQL    |
    | PHP      |
    | Drupal 7 |

    Examples:
    | language   | translation text 1       | translation text 2 |
    | French     | Agréable et puissant     | Fonctionnalités    |
    | Portuguese | Amigável e poderoso      | Caraterísticas     |
    | Spanish    | Amigable y poderoso      | Funcionalidades    |
    | Catalan    | Amigable i potent        | Característiques   |
    | Danish     | Venligt og kraftfuldt    | Features           |
    | Italian    | Facile e potente         | Funzionalità       |
    | Swedish    | Enkel och kraftfull      | Features           |

  Scenario: View slideshow texts
    Given I am on "/drupal-7.0"
    Then I should see the heading "Friendly and powerful: Drupal 7"
    And I should see the following <slides>
    | slides               |
    | Chicago Public Media |
    | Drupal Gardens       |
    | iQmetrix             |
    | Stefan Sagmeister    |
    | Voxel                |
    | Ipswich Brewery      |
    | Left-click           |
    | SubHubLite           |
