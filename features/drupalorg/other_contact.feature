@content
Feature: Drupal.org contact form
  In order to prevent spammers from flooding maintainers
  As a site visitor
  I should be required to log in with a valid account to use the contact form

  @anon @failing
  Scenario: Anonymous users views the page
    Given I am not logged in
    When I am on "/contact"
    Then I should see "403 - Access denied"
    And I should not see "You can leave us a message using"
    And I should not see "Send yourself a copy"

  Scenario: Authenticated user views the page
    Given users:
      | name         | pass     | mail                                 | roles         |
      | Confirmed User | password | ryan+siteuser@association.drupal.org | confirmed |
    And I am logged in as "Confirmed User"
    And I am on "/contact"
    Then I should see "You can leave us a message using"
    And I should see "Please provide as many"
    And I should see "Your name"
    And I should see "Category"
    And I should see "Send yourself a copy"
