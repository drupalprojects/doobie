@front
Feature: Access document list updates from homepage
  In order to see the newly created document on home page
  As a Confirmed User
  I should create a book page document

  @javascript
  Scenario: Add a child page as Confirmed User
    Given users:
      | name         | pass     | mail                                 | roles         |
      | Confirmed User | password | ryan+siteuser@association.drupal.org | confirmed |
    And I am logged in as "Confirmed User"
    And I follow "Documentation"
    And I wait until the page is loaded
    And I follow "Understanding Drupal"
    And I wait until the page loads
    When I follow "Add child page"
    And I wait until the page loads
    And I fill in "Title" with random text
    And I fill in "Body" with "Sample random behat testing body text of more than 10 words."
    And I press "Save"
    And I see "has been created"
    And I follow "Drupal Homepage"
    And I wait until the page loads
    And I follow "Docs Updates"
    And I wait until the page loads
    Then I should see at least "5" links under the "Docs Updates" tab
    And I should see the random "Title" text
    And I should see "Submitted by Confirmed User"

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
