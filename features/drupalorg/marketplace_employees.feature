@marketplace
Feature: Company employees on organization pages
  In order to be seen on my organization page
  As an authenticated user
  I should be able to edit my profile and add myself to the company employees

  Scenario: Add organization and request promotion to Services section
    Given I am logged in as "site user"
    And I visit "/drupal-services"
    And I follow "Add your listing"
    When I create a new organization for "drupal services"
    Then I should see "has been created"
    And I should see the random "Organization name" text
    And I should see the random "Drupal contributions" text
    And I should see "Posted by site user"

  @dependent
  Scenario: Edit newly created organization page and update it to get the page listed
    Given I am logged in as "admin test"
    When I visit the organization page
    And I follow "Edit"
    And I select "Featured providers" radio button
    And I press "Save"
    Then I should see "has been updated"

  Scenario: Updating profile of a user with current organization
    Given I am logged in as "site user"
    And I follow "Profile"
    And I follow "Edit"
    When I follow "Work"
    And I fill in "Current company or organization:" with organization name
    And I press "Save"
    Then I should see "The changes have been saved."

  @dependent @anon @clean_data
  Scenario: Following Featured providers organization to check for its listed users
    Given that I am on the homepage
    When I visit the organization page
    Then I should see the link "site user"