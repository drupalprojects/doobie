@docs
Feature: Log message required for documentation edits
  In order to promote communication and collaboration in the community
  As a site user
  I should be required to supply a revision log message when editing documentation

  Background:
    Given I am logged in as "site user"
    And I follow "Documentation"
    And I follow "Installation Guide"
    And I follow "Quick install for beginners"

  Scenario: Edit a documentation: Leave blank
    When I follow "Edit"
    And I press "Save"
    Then I should see "Log message field is required"
    And the field "Log message" should be outlined in red
    And I should not see "has been updated"

  Scenario: Edit a documentation: Fill field
    When I follow "Edit"
    And I fill in "Log message" with random text
    And I press "Save"
    And I see "has been updated"
    And I follow "Revisions"
    Then I should see the random "Log message" text
    And I should see "The revisions let you track differences between multiple versions of a post"
    And I should not see "Log message field is required"
