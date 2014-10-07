@community @forums
Feature: Regular users should not be able to post a topic in Newsletters subforum
  In order to check Newsletters subforum post access
  As a Trusted User
  I should try to add a new forum topic

  Background:
    Given users:
      | name         | pass     | mail                                 | roles         |
      | Trusted User | password | ryan+siteuser@association.drupal.org | Not a spammer |
    And I am logged in as "Trusted User"

  Scenario: Add new forum topic from Newsletters forum page
    And I am on "/forum"
    And I follow "Newsletters"
    When I follow "Add new Forum topic"
    Then I should not see "Drupal newsletter" in the dropdown "Forums"
    And I should not see "Security advisories for Drupal core" in the dropdown "Forums"
    And I should see "Please do NOT post test pages. Drupal.org is a production site"
