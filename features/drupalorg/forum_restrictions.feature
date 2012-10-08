@community @forums
Feature: Regular users should not be able to post a topic in Newsletters subforum
  In order to check Newsletters subforum post access
  As a site user
  I should try to add a new forum topic

  Background:
    Given I am logged in as "site user"
    And I follow "Support"
    And I follow "Forums"
    And I follow "Newsletters"

  Scenario: Try to add new forum topic from Drupal newsletter subforum
    When I follow "Drupal newsletter"
    And I follow "Post new Forum topic"
    Then I should see the heading "Drupal newsletter"
    And I should see "You do not have permission to post to this forum"
    And I should not see "Please do NOT post test pages. Drupal.org is a production site"

  Scenario: Try to add new forum topic from Newsletters forum page
    When I follow "Post new Forum topic"
    Then I should not see "Drupal newsletter" in the dropdown "Forums:"
    And I should not see "Security advisories for Drupal core" in the dropdown "Forums:"
    And I should see "Please do NOT post test pages. Drupal.org is a production site"
