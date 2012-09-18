@ci @anon
Feature: Use Marketplace to find services
  In order to find the right Drupal service provider for me
  As any user
  I want to filter available providers by categories
  
  Scenario: Browse to the Marketplace page
    Given I am on the homepage
    When I follow "Marketplace"
    Then I should see the heading "Marketplace"
    And I should see the link "Marketplace"
    
  Scenario: See a paged list of service providers
    Given I am on "/drupal-services"
    When I follow "Marketplace"
    Then I should see at least "10" records
    And I click on page "2"
    And I should see at least "10" records
    And I should see the following <links>
    | links    |
    | first    |
    | next     |
    | previous |
    | last     |
    And I should see at least "10" records
    When I click on page "last"
    Then I should see at least "1" record
    
  @javascript
  Scenario: Check the subcategories under Main category
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
