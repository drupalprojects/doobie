@news @anon
Feature: Find Drupal News
  In order to stay up-to-date on what's happening in Drupal
  As any user
  I want to read the latest news

  Background:
    Given I am on the homepage

  Scenario: View the news listing page
    When I follow "Planet Drupal"
    Then I should see the heading "Planet Drupal"
    And I should be on "/planet"
    And I should see the following <texts>
    | texts                    |
    | Posted by                |
    | Subscribe with RSS       |
    | Planet Drupal aggregates |
    And I should see the following <links>
    | links                  |
    | Drupal News            |
    | Planet Drupal          |
    | Drupal Association     |
    | next                   |
    | last                   |
    | 1                      |
    | 2                      |

  Scenario: View the pagination links: Second page
    When I follow "Planet Drupal"
    And I click on page "2"
    Then I should see the following <links>
    | links    |
    | first    |
    | previous |
    | 1        |
    | 3        |
    | next     |
    | last     |

  Scenario: View the pagination links: Last page
    When I follow "Planet Drupal"
    And I click on page "last"
    Then I should see the link "first"
    And I should see the link "previous"

  Scenario: View links in the right sidebar region
    When I visit "/planet"
    Then I should see at least "100" links in the "right sidebar" region
    And I should see the link "feed" in the "right sidebar" region
    And I should see the link "the requirements and steps on how to join" in the "right sidebar" region
    And I should see the link "Drupal.org frontpage posts for the Drupal planet" in the "right sidebar" region
