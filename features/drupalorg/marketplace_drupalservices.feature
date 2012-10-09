@wip
Feature: Market place Drupal services section
  In order to advertise the drupal services section of my organization
  As an authenticated user
  I should be able to create the organization

  @anon
  Scenario: Navigate through feature providers
    Given I am on the homepage
    And I follow "Marketplace"
    When I follow "Featured providers"
    Then I should see "Featured providers section lists"

  @anon
  Scenario: Navigate through All providers
    Given I am on the homepage
    And I follow "Marketplace"
    When I follow "All providers"
    Then I should see "All providers section lists"

  @anon @known_git6failure
  Scenario: Featured providers services list
    Given I am on "/drupal-services"
    And I follow "Featured providers"
    When I follow Featured providers title post
    Then I should see "This organization is a Featured services provider."

  @anon
  Scenario: All providers services list
    Given I am on "/drupal-services"
    And I follow "All providers"
    When I follow All providers title post
    Then I should see "This organization is a Drupal services provider."

  @anon
  Scenario: Working with Drupal service providers
    Given I am on "/drupal-services"
    When I follow "Working with Drupal service providers"
    Then I should see the heading "Working with Drupal service providers"

  Scenario: Add organization
    Given I am logged in as "site user"
    And I visit "/node/add/organization"
    And I see "Request improvements to vocabularies by"
    When I create a new organization for "drupal services"
    Then I should see "has been created"

  @dependent
  Scenario: View the created drupal services session
    Given I am logged in as "site user"
    And I follow "Your Posts"
    Then I should see the issue link
    And I follow an issue of the project
    Then I should see "Review"
    And I should see "has been posted"
    And I should see "Marketplace listing"
    And I should see "Drupal.org webmasters"
    And I should see "Posted by site user"

  @dependent
  Scenario: View the created drupal services session as normal user
    Given I am logged in as "site user"
    When I visit the organization page
    And I follow "Edit"
    Then I should not see the following <texts>
    | texts             |
    | Services listing: |
    | Issue for review: |
    | Training listing: |
    | Hosting level:    |

  @dependent @clean_data
  Scenario: View the created drupal service session
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

  Scenario: Updating profile of a user with current organization
    Given I am logged in as "site user"
    And I follow "Profile"
    And I follow "Edit"
    When I follow "Work"
    And I fill in "Current company or organization:" with "2bits.com, Inc."
    And I press "Save"
    Then I should see "The changes have been saved."

  @dependent @anon
  Scenario: Following Featured providers organization to check for its listed users
    Given I am on "/drupal-services"
    And I follow "Featured providers"
    When I follow Featured providers title post
    Then I should see the link "site user"

  Scenario: Resetting the profile
    Given I am logged in as "site user"
    And I follow "Profile"
    And I follow "Edit"
    When I follow "Work"
    And I fill in "Current company or organization:" with ""
    And I press "Save"
    Then I should see "The changes have been saved."