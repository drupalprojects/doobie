@news @anon
Feature: Drupal Association News
  In order to stay up-to-date on what's happening in Drupal Association
  As any user
  I want to read the latest Drupal Association News

  Background:
    Given I am on "/news"

  Scenario: View the news listing page
    When I follow "Drupal Association"
    Then I should see the heading "Drupal Association News"
    And I should be on "/aggregator/sources/628"
    And I should see the following <texts>
    | texts       |
    | URL         |
    | Updated     |
    | Categories: |
    And I should see the following <links>
    | links                                    |
    | Planet Drupal                            |
    | Drupal News                              |
    | Planet Drupal                            |
    | Drupal Association                       |
    | next                                     |
    | last                                     |
    | https://association.drupal.org/news/feed |

  Scenario: View the pagination links: Second page
    When I follow "Drupal Association"
    And I click on page "2"
    Then I should see the following <links>
    | links    |
    | first    |
    | previous |
    | 1        |

  Scenario: View the pagination links: Last page
    When I follow "Drupal Association"
    And I click on page "last"
    Then I should see the link "first"
    And I should see the link "previous"
