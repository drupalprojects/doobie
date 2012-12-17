@security @anon
Feature: Get a feed of security announcements
  In order to get focused and timely information that will allow me to keep my site secure
  As a Drupal site maintainer
  I should be able to subscribe to rss feeds

  @timeout
  Scenario: Visit the Drupal core announcements feed and view the contents
    Given I am on "/security"
    Then I should see "Subscribe with RSS"
    When I click on the feed icon
    Then I should be on "/security/rss.xml"
    And I should see the text "Security advisories" in the feed
    And I should see the text "Description" in the feed
    And I should see the text "Versions affected" in the feed
    And I should see at least "5" feed items

  @timeout
  Scenario: Visit the Contributed projects feed and view the contents
    Given I am on "security/contrib"
    Then I should see "Subscribe with RSS"
    When I click on the feed icon
    Then I should be on "/security/contrib/rss.xml"
    And I should see the text "Security advisories for contributed projects" in the feed
    And I should see the text "Description" in the feed
    And I should see the text "Versions affected" in the feed
    And I should see at least "5" feed items

  @timeout
  Scenario: Visit the public service announcements feed and view the contents
    Given I am on "security/psa"
    Then I should see "Subscribe with RSS"
    When I click on the feed icon
    Then I should be on "/security/psa/rss.xml"
    And I should see the text "Security public service announcements" in the feed
    And I should see the text "Description" in the feed
    And I should see the text "Versions affected" in the feed
    And I should see at least "5" feed items
