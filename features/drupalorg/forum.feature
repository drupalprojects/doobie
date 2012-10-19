@wip @community @forums
Feature: Create new forum topic as a regular site user
  In order to discuss a topic
  As a site user
  I should be able to post a new forum topic

  Scenario: View the forum topic page
    Given I am logged in as "site user"
    When I follow "Support"
    And I follow "Forums"
    Then I should be on "/forum"
    And I should see the link "Post new Forum topic"
    And I should see "New forum topics" block in the right sidebar
    And I should see at least "5" links in the "right sidebar" region

  Scenario: Add a new forum topic with empty required fields
    Given I am logged in as "site user"
    And I visit "/forum"
    When I follow "Post new Forum topic"
    And I press "Save"
    Then I should see "Subject field is required"
    And I should see "Forums field is required"
    And the field "Body" should be outlined in red

  @javascript @dependent @flaky @clean_data
  Scenario: Add a new forum topic and see the latest topic in the right side block
    Given I am logged in as "site user"
    And I visit "/forum"
    And I follow "Post installation"
    And I follow "Post new Forum topic"
    When I create a forum topic
    And I see "has been created"
    And I follow "Post installation"
    Then I should see latest forum topic in the rightside block
