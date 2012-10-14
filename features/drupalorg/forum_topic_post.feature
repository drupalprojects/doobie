@community @forums
Feature: Create new forum topic as a regular site user
  In order to discuss a topic
  As a site user
  I should be able to post a new forum topic

  Background:
    Given I am logged in as "site user"
    And I follow "Support"
    And I follow "Forums"

  Scenario: Add a new forum topic: Empty field validation
    When I follow "Add new Forum topic"
    And I press "Save"
    Then I should see "Subject field is required"
    And I should see "Forums field is required"
    And the field "Body" should be outlined in red

  Scenario: Add a new forum topic: Save topic
    When I follow "Add new Forum topic"
    And I fill in "Subject" with random text
    And I select the following <fields> with <values>
    | fields         | values                       |
    | Forums         | --Deprecated - Documentation |
    | Drupal version | Drupal 5.x                   |
    | Drupal version | Drupal 6.x                   |
    And I fill in "Body" with random text
    And I press "Save"
    Then I should see "has been created"
