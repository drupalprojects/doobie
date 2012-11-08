@marketplace @content
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

  @dependent
  Scenario: Visit edit organization page as an admin
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

  @dependent @wip
  Scenario: Edit organization page as an admin to promote to All providers
    Given I am logged in as "admin test"
    And I am on the organization page
    When I follow "Edit"
    And I select "All providers" radio button
    And I press "Save"
    Then I should see "has been updated"
    And I should see "Regarding Services listing communicate with webmasters using this issue"

  @dependent @anon @wip
  Scenario: View organization page in All providers list anonymously
    Given I am not logged in
    When I follow "Marketplace"
    And I follow "All providers"
    Then I should see the organization link

  @dependent @wip
  Scenario: Edit organization page as an admin to promote to Featured providers
    Given I am logged in as "admin test"
    And I am on the organization page
    When I follow "Edit"
    And I select "Featured providers" radio button
    And I press "Save"
    Then I should see "has been updated"

  @dependent @anon @wip
  Scenario: View organization page in Featured providers list anonymously
    Given I am not logged in
    When I follow "Marketplace"
    And I follow "Featured providers"
    Then I should see the organization link

  @dependent @wip
  Scenario: Edit organization page as an admin to promote to Training section
    Given I am logged in as "admin test"
    And I am on the organization page
    When I follow "Edit"
    And I check "Request listing in the Training section"
    And I select "List in the Training section" radio button
    And I press "Save"
    Then I should see "has been updated"
    And I should see "Regarding Training listing communicate with webmasters using this issue"

  @dependent @anon @clean_data @wip
  Scenario: View organization page in training section anonymously
    Given I am not logged in
    When I follow "Marketplace"
    And I follow "Training"
    Then I should see the organization link
