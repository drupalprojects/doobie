@front @forums
Feature: Forum posts on front page
  In order to know the latest forum posts
  As any user
  I should be able to view the Forum Posts tab on the Drupal front page

  Scenario: Create a forum post
    Given I am logged in as "site user"
    And I visit "/forum"
    And I follow "News and announcements"
    And I follow "Post new Forum topic"
    When I create a forum topic
    Then I should see "has been created"

  @dependent @anon
  Scenario: Forum Posts tab on front page
    Given I am on the homepage
    When I follow "Forum Posts"
    Then I should see the forum topic link
    And I should see "Posted by"
    And I should see at least "5" links under the "Forum Posts" tab
    And I should see the link "More forums"

  @dependent @anon
  Scenario: Forum Posts tab on front page: More
    Given I am on the homepage
    When I follow "Forum Posts"
    And I follow "More forums"
    Then I should see the heading "Community"
    And I should see the forum topic link
    And I should see "Login to post new content in the forum"
