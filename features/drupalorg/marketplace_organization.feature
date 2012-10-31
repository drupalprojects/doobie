@marketplace
Feature: Adding company to the Marketplace
  In order to advertise the drupal services of my organization
  As an authenticated user
  I should be able to create an organization page

  Scenario: Add organization and request promotion to Services section
    Given I am logged in as "site user"
    And I visit "/node/add/organization"
    And I see "Request improvements to vocabularies by"
    And I see "People with your organization name"
    And I see "Marketplace guidelines"
    When I create a new organization for "drupal services"
    Then I should see "has been created"

  @dependent
  Scenario: View an issue request for services section
    Given I am logged in as "site user"
    And I follow "Your Posts"
    Then I should see the issue link
    And I follow an issue of the project
    Then I should see "Review"
    And I should see "has been posted"
    And I should see "Marketplace listing"
    And I should see "Drupal.org webmasters"
    And I should see "Posted by site user"

  @dependent @clean_data
  Scenario: Edit own organization page
    Given I am logged in as "site user"
    When I visit the organization page
    And I follow "Edit"
    Then I should see "Request improvements to vocabularies"
    And I should see "Organization name"
    And I should not see the following <texts>
    | texts             |
    | Services listing: |
    | Issue for review: |
    | Training listing: |
    | Hosting level:    |

  Scenario: Add organization and request promotion to Training section
    Given I am logged in as "site user"
    And I visit "/node/add/organization"
    And I see "Request improvements to vocabularies by"
    When I create a new organization for "training"
    Then I should see "has been created"

  @dependent @clean_data
  Scenario: View an issue request for training section
    Given I am logged in as "site user"
    And I follow "Your Dashboard"
    When I follow an issue of the project
    Then I should see "to the Training section"
    And I should see "has been posted"
    And I should see "Drupal.org webmasters"
    And I should see "Posted by site user"
