@front
Feature: Access document list updates from homepage
  In order to see the newly created document on home page
  As a Trusted User
  I should create a book page document

  Scenario: Add a child page as Trusted User
    Given users:
      | name         | pass     | mail                                 | roles         |
      | Trusted User | password | ryan+siteuser@association.drupal.org | Not a spammer |
    And I am logged in as "Trusted User"
    And I follow "Documentation"
    And I follow "Understanding Drupal"
    When I follow "Add child page"
    And I fill in "Title" with random text
    And I fill in "Body" with "Sample random behat testing body text of more than 10 words."
    And I press "Save"
    And I see "has been created"
    And I follow "Drupal Homepage"
    And I follow "Docs Updates"
    And I wait until the page loads
    Then I should see at least "5" links under the "Docs Updates" tab
    And I should see the random "Title" text
    And I should see "Submitted by Trusted User"

  @anon @javascript
  Scenario: More documentation
    Given I am on the homepage
    And I follow "Docs Updates"
    When I follow "More documentation"
    And I wait until the page loads
    Then I should see the heading "Community Documentation"
    And I should see the link "Understanding Drupal"
    And I should see the link "Installation Guide"
    And I should see "Developer Guides"
    And I should see "Other information"
