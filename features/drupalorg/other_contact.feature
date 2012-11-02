@other
Feature: Drupal.org contact form
  In order to contact Drupal.org maintainers
  As an authenticated user
  I should be able to access site's contact form

  @anon
  Scenario: Anonymous users views the page
    Given I am on "/contact"
    Then I should see the heading "Contact"
    And I should see "You have to log in to contact us"
    And I should not see "You can leave us a message using"
    And I should not see "Send yourself a copy"

  Scenario: Authenticated user views the page
    Given I am logged in as "site user"
    And I am on "/contact"
    Then I should see "You can leave us a message using"
    And I should see "Please provide as many"
    And I should see "Your name"
    And I should see "Category"
    And I should see "Send yourself a copy"
