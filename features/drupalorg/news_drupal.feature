@news @anon
Feature: Find Drupal News
  In order to stay up-to-date on what's happening in Drupal
  As any user
  I want to read the latest news

  Background:
    Given I am on "/news"


  Scenario: View the news listing page
    Then I should see the heading "Drupal News"
    And I should be on "/news"
    And I should see "Read more"
    And I should see the following <links>
    | links                  |
    | Drupal News            |
    | Planet Drupal          |
    | Drupal Association     |
    | next  |
    | last  |
    | 1     |
    | 2     |

  Scenario: View the pagination links: Second page
    When I visit "/news"
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
    When I click on page "last"
    Then I should see the link "first"
    And I should see the link "previous"
    And I should not see the link "next"


