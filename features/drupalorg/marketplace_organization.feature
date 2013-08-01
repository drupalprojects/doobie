@marketplace
Feature: Adding company to the Marketplace
  In order to advertise the Drupal services of my organization
  As an authenticated user
  I should be able to create an organization page

  Scenario: Organization cannot be created without filling req fields
    Given I am logged in as the "site user"
    And I follow "Marketplace"
    And I follow "Add your listing"
    And I see "People with your organization name"
    And I see "Marketplace guidelines"
    When I press "Save"
    Then I should see "Organization name field is required."
    #And I should see "URL field is required."
    #And I should see "Drupal contributions field is required."

  @javascript
  Scenario: Add organization and request promotion to Services section
    Given I am logged in as the "site user"
    And I am on "/node/add/organization"
    And I wait until the page is loaded
    When I create a new organization for "drupal services"
#Then show last response
    And I wait until the page is loaded
    Then I should see "has been created"
    And I should see the random "Organization name" text
    And I should see the random "Website" text
    And I should see the organization logo
    And I should see the random "Services" text
    And I should see the random "Sectors" text
    And I should see the random "Locations" text
    And I should see the random "Drupal contributions" text
    And I should see the random "Organization description" text
    And I should see the random "Headquarters" text
    And I should see the random "Usual project budget (optional)" text
    And I should see "Posted by site user"

  @dependent @flaky
  Scenario: View an issue request for services section
    Given I am logged in as the "site user"
    And I visit the organization page
    And I see "Regarding Services listing communicate with webmasters"
    When I follow "this issue"
    Then I should see the issue link
    And I should see the following <texts>
    | texts                    |
    | has been posted          |
    | Review                   |
    | Services listing         |
    | Drupal.org content       |
    | Posted by site user      |
    And I should see the heading "Comments"
    And I should see the heading "Add new comment"

  @dependent
  Scenario: Edit own organization page
    Given I am logged in as the "site user"
    When I visit the organization page
    And I follow "Edit"
    Then I should see "Organization name"
    And I should not see the following <texts>
    | texts            |
    | Services listing |
    | Issue for review |
    | Hosting level    |

  @dependent @clean_data
  Scenario: User can't edit organization pages or see the issues - that are not created by him
    Given I am logged in as the "git user"
    When I visit the organization page
    Then I should not see "Regarding Services listing communicate with webmasters"
    And I should see "Posted by site user"
    And I should see the random "Services" text
    And I should see the random "Drupal contributions" text
    And I should see the random "Organization description" text
    And I should not see the following <links>
    | links      |
    | Edit       |
    | this issue |

  Scenario: Add organization and request promotion to Training section
    Given I am logged in as the "site user"
    And I visit "/training"
    And I follow "Add your listing"
    When I create a new organization for "training"
    Then I should see "has been created"
    And I should see the random "Organization name" text
    And I should see the random "Drupal contributions" text
    And I should see the random "Training url" text
    And I should see the random "Training description" text
    And I should see "Posted by site user"

  @dependent @flaky
  Scenario: View an issue request for training section
    Given I am logged in as the "site user"
    And I visit the organization page
    And I see "Regarding Training listing communicate with webmasters"
    When I follow "this issue"
    Then I should see the issue link
    And I should see the following <texts>
    | texts                 |
    | Training section      |
    | has been posted       |
    | Drupal.org content |
    And I should see the heading "Comments"
    And I should see the heading "Add new comment"

  @dependent @clean_data
  Scenario:  User can't edit organization pages or see the issues - that are not created by him
    Given I am logged in as the "git user"
    When I visit the organization page
    Then I should not see "Regarding Training listing communicate with webmasters"
    And I should see "Posted by site user"
    And I should see the random "Organization name" text
    And I should see the random "Drupal contributions" text
    And I should not see the following <links>
    | links      |
    | Edit       |
    | this issue |
