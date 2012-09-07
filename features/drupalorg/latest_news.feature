Feature: Find About News
  In order to find the Latest news for me
  As any user
  I want to know the latest news in drupal

  Background:
    Given I am on "/news"

  Scenario: Browse to the news listing page
    Given I am on the homepage
    Then I should see at least "6" links under the "News" tab
    When I follow "More news…"
    Then I should see the heading "Drupal News"
    And I should see "Read more"

  Scenario: Check for the Links in News page
    Then I should see the following <links>
    | links |
    | Drupal News |
    | Planet Drupal |
    | Drupal Association |
    | News and announcements |

  Scenario Outline: Move Backward and Forward from the Existing Page
    When I follow "News and announcements"
    Then I should see "Community"
    And I should see the heading "News and announcements"
    And I should see the heading "New forum topics"
    And I should see at least "10" links in the "right sidebar" region
    And I should see <tablist>
    Examples:
    | tablist |
    | "Community Home" |
    | "Getting Involved" |
    | "Chat" |
    | "Mailing Lists" |
    | "Member Directory" |
    | "Forum" |

  Scenario: Browse to the News and announcements page
    When I follow "News and announcements"
    Then I should see the following <links>
    | links |
    | Topic |
    | Replies |
    | Created |
    | Last reply |

  Scenario: For verifying the pagination links: First page
    And I should see the following <links>
    | links |
    | next |
    | last |
    | 1 |
    | 2 |
    And I should not see the link "previous"

  Scenario: For verifying the pagination links: Second page
    When I click on page "2"
    Then I should see the following <links>
    | links |
    | first |
    | previous |
    | 1 |
    | 3 |
    | next |
    | last |

  Scenario: For verifying the pagination links: Last page
    When I click on page "last"
    Then I should see the link "first"
    And I should see the link "previous"
    And I should not see the link "next"