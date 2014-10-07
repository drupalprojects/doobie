@other @content
Feature: Drupal.org contact form
  In order to prevent spammers from flooding maintainers
  As a site visitor
  I should be required to log in with a valid account to use the contact form

  @anon
  Scenario: Anonymous users views the page
    Given I am not logged in
    When I am on "/contact"
    Then I should see "Access Denied"
    And I should not see "You can leave us a message using"
    And I should not see "Send yourself a copy"

  Scenario: Authenticated user views the page
    Given users:
      | name         | pass     | mail                                 | roles         |
      | Trusted User | password | ryan+siteuser@association.drupal.org | Not a spammer |
    And I am logged in as "Trusted User"
    And I am on "/contact"
    Then I should see "You can leave us a message using"
    And I should see "Please provide as many"
    And I should see "Your name"
    And I should see "Category"
    And I should see "Send yourself a copy"
