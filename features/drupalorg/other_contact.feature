@other @wip
Feature: Drupal.org contact form
  In order to prevent spammers from flooding maintainers 
  As a site visitor
  I should be required to log in with a valid account to use the contact form

  @anon
  Scenario: Anonymous users views the page
    Given I am not logged in 
    When I visit "/contact"
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
