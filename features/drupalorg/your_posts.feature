@user
Feature: Your Posts
  In order to keep track of responses to issues I've posted
  As an authenticated user
  I want to find them listed all in a single place

  Scenario: Create test data for the following scenarios
    Given I am logged in as "git vetted user"
    And I am at "/node/add/project-project"
    When I create a "module"
    Then I should see project data
    And I follow "open"
    And I follow "Create a new issue"
    And I create a new issue
    And I add a comment to the issue
    And I add one more comment to the issue

  Scenario: To comment on a specific post
    Given I am logged in as "git user"
    And I am on the project page
    When I follow "open"
    Then I should see the issue link
    And I follow an issue of the project
    And I add a comment to the issue
    And I add one more comment to the issue

  Scenario: To navigate to your posts page
    Given I am logged in as "git vetted user"
    When I follow "Your Posts"
    Then I should see the following <texts>
    | texts        |
    | Type         |
    | Posts        |
    | Author       |
    | Replies      |
    | Last updated |
    And I should see at least "1" reply for the post
    And I should see at least "1" new reply for the post
    And I should see updated for the post

  @clean_data
  Scenario: Navigate to the specific post and check for the new post.
    Given I am logged in as "git vetted user"
    And I follow "Your Posts"
    And I follow an issue of the project
    When I move backward one page
    Then I should see at least "4" replies for the post
    And I should not see updated for the post