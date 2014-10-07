@marketplace
Feature: Company employees on organization pages
  In order to be seen on my organization page
  As an authenticated user
  I should be able to edit my profile and add myself to the company employees

  Scenario: Add organization and request promotion to Services section
    Given users:
      | name         | pass     | mail                                 | roles         |
      | Trusted User | password | ryan+siteuser@association.drupal.org | Not a spammer |
    And I am logged in as "Trusted User"
    And I visit "/drupal-services"
    And I follow "Add your listing"
    When I create a new organization for "drupal services"
    Then I should see "has been created"
    And I should see the random "Organization name" text
    And I should see "Posted by Trusted User"

  @dependent @wip
  Scenario: Edit newly created organization page and update it to get the page listed
    Given I am logged in as the "admin test"
    When I visit the organization page
    And I follow "Edit"
    And I select "Featured providers" radio button
    And I press "Save"
    Then I should see "has been updated"

  @dependent
  Scenario: Updating profile of a user with current organization
    Given users:
      | name         | pass     | mail                                 | roles         |
      | Trusted User | password | ryan+siteuser@association.drupal.org | Not a spammer |
    And I am logged in as "Trusted User"
    And I follow "Profile"
    And I follow "Edit"
    When I follow "Work"
    And I fill in "Job title" with random text
    And I fill in "Current company or organization" with organization name
    And I press "Save"
    Then I should see "The changes have been saved."

  @anon @dependent
  Scenario: Following Featured providers organization to check for its listed users
    Given I am on the homepage
    When I visit the organization page
    Then I should see the link "Trusted User"

  Scenario: Edit the document page and update
    Given users:
      | name         | pass     | mail                                 | roles         |
      | Trusted User | password | ryan+siteuser@association.drupal.org | Not a spammer |
    And I am logged in as "Trusted User"
    And I follow "Documentation"
    And I follow "Glossary"
    When I follow "Edit"
    And I fill in "Revision log message" with random text
    And I press "Save"
    Then I should see "has been updated"

  @dependent @clean_data
  Scenario: View the user profile details in brief
    Given I am on the homepage
    When I visit the organization page
    Then I should see the link "Trusted User"
    #And I should see the random "Job title" text
    And I should see "On Drupal.org for"
    And I should see text matching "(?:edit|edits) to documentation"
