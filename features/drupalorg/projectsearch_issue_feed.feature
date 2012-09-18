@anon
Feature: Get a feed of Search issues
  In order to see the Search issues Feeds
  As a user
  I should be able to see the rss feeds icon

  Scenario:
    Given I am on "/project/issues/search/feed"
    When I click on the feed icon
    Then I should see the text "Search issues for Feed" in the feed
    And I should see at least "2" feed items