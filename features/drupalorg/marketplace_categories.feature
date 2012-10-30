@marketplace @anon
Feature: Find Drupal service provider in the Marketplace
  In order to find the right Drupal service provider for me
  As any user
  I should be able to see the list of service providers and filter it
  
  @javascript
  Scenario: Expand main category and view subcategories
    Given I am on "/marketplace"
    When I expand the category "Services"
    And I expand the category "Sectors"
    And I expand the category "Countries served"
    Then I should see the following <texts>
    | texts            |
    | Services         |
    | Sectors          |
    | Countries served |
    And I should see assorted links under "Services"
    And I should see assorted links under "Sectors"
    And I should see assorted links under "Countries served"