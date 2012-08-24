Feature: Search for IRC nicknames on the site
  In order to chat with the Drupal Community on IRC
  As a user
  I should search for IRC nicknames on the site

  Scenario: Search using the sitewide search: Exact word
    Given that I am on the homepage
    When I search sitewide for "Senpai"
    And I follow "IRC Nicks"
    Then I should see at least "1" record
    And I should see the heading "Search results"
    And I should see the link "Senpai"

  Scenario: Search using the sitewide search: Part of the word
    Given that I am on the homepage
    When I search sitewide for "eliza"
    And I follow "IRC Nicks"
    Then I should see at least "3" records
    And I should see the heading "Search results"
    And I should see the link "eliza411"

  Scenario: Search using the direct url
    Given I am on "/search/drupalorg"
    When I enter "ksbalaji" for field "Enter your keywords"
    And I press "Search" in the "content" region
    Then I should see at least "1" record
    And I should see the heading "Search results"
    And I should see the link "ksbalajisundar"
