@marketplace
Feature: Moderate Marketplace listing
  In order to moderate Marketplace listing
  As a site maintainer
  I should be able to edit any organization page and promote it to Marketplace
  
  Scenario: Add organization
    Given I am logged in as "site user"
    And I visit "/node/add/organization"
    And I see "Request improvements to vocabularies by"
    When I create a new organization for "drupal services"
    Then I should see "has been created"
	
  @dependent @clean_data
  Scenario: Edit organization page as an admin
    Given I am logged in as "admin test"
    When I visit the organization page
    And I follow "Edit"
    Then I should see the following <texts>
    | texts             |
    | Services listing: |
    | Issue for review: |
    | Training listing: |
    | Hosting level:    |
    And I should see "Do not list" selected for "Services listing"
    And I should see "Do not list" selected for "Training listing"
    And I should see "Not listed for hosting" selected for "Hosting level"