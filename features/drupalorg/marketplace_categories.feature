@drupal-services @anon @content
Feature: Find Drupal service provider in the Marketplace
  In order to find the right Drupal service provider for me
  As any user
  I should be able to see the list of service providers and filter it

  Scenario: Expand main category and view subcategories
    Given I am on "/drupal-services"
    When I expand the category "Services"
    And I expand the category "Sectors"
    And I expand the category "Locations"
    Then I should see the following <texts>
      | texts     |
      | Services  |
      | Sectors   |
      | Locations |
    And I should see the following <links>
      | links              |
      | Development        |
      | Beauty and Fashion |
      | Latvia             |

  Scenario: Service categories under an organization
    Given I am on "/drupal-services"
    And I expand the category "Services"
    And I follow "Consulting"
    And I should see at least "5" records
    When I follow Organization title post
    Then I should see "Consulting" under "Services" heading

  Scenario: Sector categories under an organization
    Given I am on "/drupal-services"
    And I expand the category "Sectors"
    And I follow "Technology"
    And I should see at least "5" records
    When I follow Organization title post
    Then I should see "Technology" under "Sectors" heading

  Scenario: Location categories under an organization
    Given I am on "/drupal-services"
    And I expand the category "Locations"
    And I follow "United States"
    And I should see at least "5" records
    When I follow Organization title post
    Then I should see "United States" under "Locations" heading
