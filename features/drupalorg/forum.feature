@community @forums
Feature: Create new forum topic as a regular Trusted User
  In order to discuss a topic
  As a Trusted User
  I should be able to post a new forum topic

  Background:
    Given users:
      | name         | pass     | mail                                 | roles         |
      | Trusted User | password | ryan+siteuser@association.drupal.org | trusted |
    And I am logged in as "Trusted User"

  @failing
  Scenario: View the forum topic page
    When I follow "Support"
    And I follow "Forums"
    Then I should be on "/forum"
    And I should see the link "Add new Forum topic"
    And I should see "New forum topics" block in the right sidebar
    And I should see at least "5" links in the "right sidebar" region

  @failing
  Scenario: Add a new forum topic with empty required fields
    And I visit "/forum"
    When I follow "Add new Forum topic"
    And I press "Save"
    Then I should see "Subject field is required"
    And I should see "Forums field is required"
    And the field "Body" should be outlined in red

  @cache @api
  Scenario: Add a new forum topic and see the latest topic in the right side block
    And I visit "/forum"
    And I follow "Post installation"
    And I follow "Add new Forum topic"
    When I create a forum topic
    And I see "has been created"
    And I follow "Post installation"
    And the cache has been cleared
    And I visit "/forum/22"
    Then I should see latest forum topic in the rightside block
