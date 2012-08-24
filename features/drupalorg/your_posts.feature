Feature: Your Posts
  In order to keep track of responses to issues I've posted
  As an authenticated user
  I want to find them listed all in a single place

  Background:
    Given I am logged in as "site user"
    And I follow "Your Posts"

  Scenario: To navigate to your posts page
    Then I should see the following <texts>
    | texts        |
    | Type         |
    | Posts        |
    | Author       |
    | Replies      |
    | Last updated |
    And I should see at least "5" replies for the post
    And I should see at least "1" new reply for the post
    And I should see updated for the post

  Scenario: Verify pagination links: First page
    Then I should see the following <links>
    | links        |
    | next         |
    | last         |
    | 1            |
    | 2            |
    And I should not see the link "first"

  Scenario: Verify pagination links: Second page
    When I click on page "2"
    Then I should see the following <links>
    | links       |
    | first       |
    | previous    |
    | 1           |
    | 2           |

  Scenario: Verify pagination links: Last page
    When I click on page "last"
    Then I should see the link "first"
    And I should see the link "previous"
    And I should not see the link "last"

  Scenario: Navigate to the specific post and check for the new post.
    When I follow a post
    And I move backward one page
    Then I should see at least "5" replies for the post
    And I should not see updated for the post

  Scenario: To check for the comments posting page
    When I follow a post
    Then I should see the heading "Issue Summary"
    And I should see the heading "Comments"
    And I should see the heading "Post new comment"
    And I should see the following <texts>
    | texts       |
    | Issue title |
    | Project     |
    | Component   |
    | Assigned    |
    | Category    |
    | Priority    |
    | Status      |
    | Comment     |