@whitelist @anon
Feature: Get a feed of packaging whitelist entries
  In order to know when new packages are added to the whitelist
  As any user
  I should be able to see RSS feed icon to subscribe

  @failing
 Scenario: Visit the feed and view the content
    Given I am on "/project/drupalorg_whitelist"
    When I follow "list of existing whitelist entries"
    And I should see "Subscribe with RSS"
    And I click on the feed icon
    Then I should see the text "Packaging whitelist URLs" in the feed
    And I should see the text "<language>en</language>" in the feed
    And I should see the text "<channel>" in the feed
    And I should see at least "10" feed items
