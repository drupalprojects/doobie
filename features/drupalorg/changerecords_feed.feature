@changerecords @anon
Feature: Get a feed of change records
  In order to see the change record feeds
  As a user
  I should be able to see the rss feeds

  Scenario: Visit the feed and view the contents
    Given I am on "/project/drupal"
    When I follow "View change records"
    Then I should see the heading "Change records for Drupal core"
    And I click on the feed icon
    Then I should see the text "Change records" in the feed
    And I should see the text "Other updates done" in the feed
    And I should see at least "5" feed items
