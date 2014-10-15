@search @anon
Feature: Visitor searches content and gets results from multiple sites
  In order to see search results from other drupal sites
  As a visitor to Drupal.org
  I want to search for the users through out the sitewide

  @failing
  Scenario: Search using the sitewide search: Exact word
    Given I am on the homepage
    When I search sitewide for "Senpai"
    And I follow "Users"
    Then I should see at least "1" record
    And I should see the link "Senpai"

  Scenario: Search using the sitewide search: Part of the word
    Given I am on the homepage
    When I search sitewide for "eliza"
    And I follow "Users"
    Then I should see at least "10" records

  Scenario: Search using the direct url
    Given I am on "/search/user"
    When I enter "ksbalaji" for field "Enter your keywords"
    And I press "Search" in the "content" region
    Then I should see at least "1" record
    And I should see the link "ksbalajisundar"
