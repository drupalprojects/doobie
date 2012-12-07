@news @anon
Feature: Find Drupal News
  In order to stay up-to-date on what's happening in Drupal
  As any user
  I want to read the latest news

  Background:
    Given I am on the homepage

  Scenario: View the news listing page
    When I visit "/news"
    Then I should see the heading "Drupal News"
    And I should be on "/news"
    And I should see "Read more"
    And I should see "Forums:"
    And I should see the following <links>
    | links                  |
    | Drupal News            |
    | Planet Drupal          |
    | Drupal Association     |
    | News and announcements |
    | next  |
    | last  |
    | 1     |
    | 2     |
    And I should not see the link "previous"

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
    When I visit "/news"
    And I click on page "last"
    Then I should see the link "first"
    And I should see the link "previous"
    And I should not see the link "next"

  Scenario Outline: View News and announcements forum
    When I visit "/news"
    And I follow "News and announcements"
    Then I should see "Community"
    And I should see the heading "News and announcements"
    And I should see the heading "New forum topics"
    And I should see at least "10" links in the "right sidebar" region
    And I should see the following <links>
    | links      |
    | Topic      |
    | Replies    |
    #| Created    |
    | Last reply |
    And I should see <tablist>
    Examples:
    | tablist            |
    | "Community Home"   |
    | "Getting Involved" |
    | "Chat"             |
    | "Mailing Lists"    |
    | "Member Directory" |
    | "Forum"            |
