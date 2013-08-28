@git @anon
Feature: Subscribe to commitlog feed
  In order to keep up on Drupal.org code changes
  As a site visitor
  I want to subscribe to an RSS feed

  Scenario: Follow the commitlog feed 
    Given I am on the homepage
    When I visit "/commitlog"
    When I click on the feed icon
    Then I should see at least "5" feed items
