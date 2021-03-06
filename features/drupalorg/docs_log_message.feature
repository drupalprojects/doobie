@docs
Feature: Log message required for documentation edits
  In order to promote communication and collaboration in the community
  As a Confirmed User
  I should be required to supply a revision log message when editing documentation

  Background:
    Given users:
      | name         | pass     | mail                                 | roles         |
      | Confirmed User | password | ryan+siteuser@association.drupal.org | confirmed |
    And I am logged in as "Confirmed User"
    And I am on "/best-practices"

  Scenario: Edit a documentation: Leave blank
    When I follow "Edit"
    And I press "Save"
    Then I should see "Revision log message field is required"
    And the field "Revision log message" should be outlined in red
    And I should not see "has been updated"

  Scenario: Edit a documentation: Fill field
    When I follow "Edit"
    And I fill in revision log message with random text
    And I press "Save"
    And I see "has been updated"
    And I follow "Revisions"
    Then I should see the random "Revision log message" text
    And I should see "Revisions allow you to track differences between multiple versions of your content"
    And I should not see "Log message field is required"

  Scenario: Edit a documentation: Log message field should be in foreground
    When I follow "Edit"
    And I fill in "Revision log message" with random text
    And I press "Save"
    And I see "has been updated"
