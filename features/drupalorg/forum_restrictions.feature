Feature: To check whether user can post a topic under newsletter subsite forums
  In order to check newsletter subset forum post access
  As a site user
  I should try to add a new forum topic

  Background:
    Given I am logged in as "site user"
    And I follow "Support"
    And I follow "Forums"
    And I follow "Newsletters"

  Scenario: Try to add from a subset forum
    When I follow "Drupal newsletter"
    And I follow "Post new Forum topic"
    Then I should see the heading "Drupal newsletter"
    And I should see "You do not have permission to post to this forum"
    And I should not see "Please do NOT post test pages. Drupal.org is a production site"

  Scenario: Try to add from newsletter forum page
    When I follow "Post new Forum topic"
    Then I should not see "Drupal newsletter" in the dropdown "Forums:"
    And I should not see "Security advisories for Drupal core" in the dropdown "Forums:"
    And I should see "Please do NOT post test pages. Drupal.org is a production site"
