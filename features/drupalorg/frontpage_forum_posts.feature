@front @forums
Feature: Forum posts on front page
  In order to know about the latest forum posts
  As any user
  I should be able to view the Forum Posts tab on the Drupal front page

  @javascript
  Scenario: Forum Posts tab on front page
    Given there is a new "Paid Drupal services" forum topic
    And I am on the homepage
    When I follow "Forum Posts"
    Then I should see the forum topic link
    And I should see "Posted by"
    And I should see at least "5" links under the "Forum Posts" tab
    And I should see the link "More forums"

  Scenario: Forum Posts tab on front page: More
    Given there is a new "Post installation" forum topic
    And I am on the homepage
    When I follow "Forum Posts"
    And I follow "More forums"
    And I wait until the page loads
    And I follow "Post installation"
    Then I should see the heading "Post installation"
    And I should see the forum topic link
