Feature: Verify that log message should be entered before saving a documentation
  In order to check log message is mandatory or not
  As a site user
  I should edit a documentation page

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
      And I fill in "Log message" with "no changes made here - 3"
      And I press "Save"
      And I follow "Revisions"
      Then I should see "no changes made here - 3"
      And I should see "The revisions let you track differences between multiple versions of a post"
      And I should not see "Log message field is required"
