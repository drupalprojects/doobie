@anon
Feature: Get a feed of security announcements
  In order to see the security announcements feeds
  As a user
  I should be able to see the rss feeds icon

  @timeout @flaky
  Scenario: Visit the feed and view the content
    Given I am on "/project/drupalorg_whitelist"
    When I follow "list of existing whitelist entries"
    And I should see "Subscribe with RSS"
    And I click on the feed icon
    Then I should see the text "Packaging whitelist URLs" in the feed
    And I should see the text "<language>en</language>" in the feed
    And I should see the text "<channel>" in the feed
    And I should see at least "10" feed items
