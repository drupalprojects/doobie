Feature: Get a feed of security announcements for contributed modules
  In order to see the security announcements feeds for contributed modules
  As a user
  I should be able to see the rss feeds icon

  Scenario:
    Given that I am on the homepage
    When I follow "Security Info"
    Then I follow "Contributed projects"
    And I should see "Subscribe with RSS"
    When I click on the feed icon
    Then I should be on "/security/contrib/rss.xml"
    And I should see the text "Security advisories for contributed projects" in the feed
    And I should see the text "Description" in the feed
    And I should see the text "Versions affected" in the feed
    And I should see at least "5" feed items
