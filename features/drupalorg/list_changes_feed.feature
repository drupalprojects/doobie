@anon
Feature: Get a feed of change records
  In order to see the change record feeds
  As a user
  I should be able to see the rss feeds

  Scenario:
    Given I am on "/project/drupal"
    When I follow "View change records"
    Then I should see the heading "Change records for Drupal core"
    And I click on the feed icon
    Then I should see the text "Sundar test record" in the feed
    And I should see the text "Updates Done" in the feed
    And I should see at least "5" feed items
