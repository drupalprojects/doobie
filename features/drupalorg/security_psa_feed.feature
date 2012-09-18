@anon
Feature: Get a feed of Security public service announcements
  In order to see the Security public service announcements feeds
  As a user
  I should be able to see the rss feeds icon

  Scenario:
    Given that I am on the homepage
    When I follow "Security Info"
    And I follow "Public service announcements"
    And I should see "Subscribe with RSS"
    And I click on the feed icon
    Then I should be on "/security/psa/rss.xml"
    And I should see the text "Security public service announcements" in the feed
    And I should see the text "Description" in the feed
    And I should see the text "Versions affected" in the feed
    And I should see at least "5" feed items
