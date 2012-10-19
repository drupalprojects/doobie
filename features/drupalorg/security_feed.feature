@security @anon
Feature: Get a feed of security announcements
  In order to see the security announcements feeds
  As a user
  I should be able to see the rss feeds icon

  @timeout @flaky
  Scenario: Visit the feed and view the contents
    Given that I am on the homepage
    When I follow "Security Info"
    Then I should see "Subscribe with RSS"
    When I click on the feed icon
    Then I should see the text "Security advisories" in the feed
    And I should see the text "Description" in the feed
    And I should see the text "Versions affected" in the feed
    And I should see at least "5" feed items
