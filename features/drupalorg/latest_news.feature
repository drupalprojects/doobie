Feature: Find About News
  In order to find the Latest news for me
  As any user
  I want to know the latest news in drupal 

  Scenario: Browse to the news listing page
    Given I am on "/"
    When I follow "More news…"
    Then I should be on "/news"
    And I should see "Drupal News"
    And I should see "Read more"

   Scenario: Browse to the Detail News page
    Given I am on "/news"
    And I see the link "Read more"
    And I see the link "next"
    And I do not see the link "previous"
    When I follow "next"
    Then I should see "first"
    And I should see "previous"
    When I follow "last"
    Then I should see "first"
    Then I should see "previous"
    Then I should not see "next"

  Scenario: Browse to the Events page
    Given I am on "/news"
    And I see the heading "Events"
    When I follow "Events"
    Then I should see "Topic"
    And I should see "Replies"
    And I should see "Created"
    
  Scenario Outline: Move Backward and Forward from the Existing Page
   
    Given I am on "/news"
    And I see the heading "Drupal News" 
    When I follow "Events"
    Then I should see "Community"
    And I should see <tablist>
   
     Examples: And I should see "Prev"
     | tablist            |
     | "Community Home"   |
     | "Getting Involved" |
     | "Chat"             |
     | "Mailing Lists"    |
     | "Member Directory" |
     | "Forum"            |

  Scenario: Browse to the Events page
    Given I am on "/news"
    When I follow "Events"
    Then I should see "Topic"
    And I should see "Replies"
    And I should see "Created"

  @javascript
  Scenario: Refine the search
    Given I am on "/community"
    And I see "Search Documentation: "
    And I fill in "search_term" with "invite"
    And I wait for the suggestion box to appear
    Then I should see "Chat invites"
