@git @anon @failing
Feature: Subscribe to commitlog feed
  In order to keep up on Drupal.org code changes
  As a site visitor
  I want to subscribe to an RSS feed

  Scenario: Navigate to the commitlog
    Given I am on the homepage
    When I follow "Commits"
    And I wait until the page loads
    And I follow "More commit messages"
    And I wait until the page loads
    When I click on the feed icon
    Then I should see at least "5" feed items
