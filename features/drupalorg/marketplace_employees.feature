@marketplace
Feature: Company employees on organization pages
  In order to be seen on my organization page
  As an authenticated user
  I should be able to edit my profile and add myself to the company employees
  
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
