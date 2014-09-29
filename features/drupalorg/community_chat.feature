@community @anon
Feature: Participate in community IRC
  In order to chat with the Drupal community via IRC
  As any user
  I need to get information about available channels

  Scenario: View IRC page
    Given I am on the homepage
    And I follow "Community"
    And I see "Chat (IRC)"
    When I follow "IRC"
    Then I should see the heading "Chat with the Drupal Community on IRC"
    And I should see "For IRC experts"
    And I should see "Essential Channels to Join"
    And I should see "Topical Channels"
    And I should be on "/irc"
