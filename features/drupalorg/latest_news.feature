@planet @anon
Feature: Find News
  In order to stay up-to-date on what's happinging in Drupal
  As any user
  I want to read the latest news

  Background:
    Given I am on "/news"

  Scenario: Browse to the news listing page
    When I visit "/"
    And I see at least "6" links under the "News" tab
    And I follow "More news…"
    Then I should see the heading "Drupal News"
    And I should see "Read more"

  Scenario: View the links in News page
    Then I should see the following <links>
    | links                  |
    | Drupal News            |
    | Planet Drupal          |
    | Drupal Association     |
    | News and announcements |

  Scenario Outline: Move Backward and Forward from the Existing Page
    When I follow "News and announcements"
    Then I should see "Community"
    And I should see the heading "News and announcements"
    And I should see the heading "New forum topics"
    And I should see at least "10" links in the "right sidebar" region
    And I should see <tablist>
    Examples:
    | tablist            |
    | "Community Home"   |
    | "Getting Involved" |
    | "Chat"             |
    | "Mailing Lists"    |
    | "Member Directory" |
    | "Forum"            |

  Scenario: Browse to the News and announcements page
    When I follow "News and announcements"
    Then I should see the following <links>
    | links      |
    | Topic      |
    | Replies    |
    | Created    |
    | Last reply |

  Scenario: View the pagination links: First page
    Then I should see the following <links>
    | links |
    | next  |
    | last  |
    | 1     |
    | 2     |
    And I should not see the link "previous"

  Scenario: View the pagination links: Second page
    When I click on page "2"
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
