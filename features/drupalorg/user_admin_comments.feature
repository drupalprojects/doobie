@admin
Feature: To get administrative view of comments by a user
  In order to manage comments
  As an admin user
  I should be able to view the list and filter them

  Background:
    Given I am logged in as "admin test"
    And I follow "Administer comments"

  @slow
  Scenario: Create test data
    When I visit "/node/add/page"
    And I create "1" page
    And I follow "Add new comment"
    And I add "3" comments
    Then I should see "Posted by admin test"

  @dependent
  Scenario: View the list of items
    Then I should see at least "3" records
    And I should see the following <texts>
    | texts      |
    | Title      |
    | Node title |
    | Comment    |
    | Post date  |
    | Operations |
    | Published  |
    And I should see the following <links>
    | links  |
    | View   |
    | Edit   |
    | edit   |
    | delete |

  @dependent
  Scenario: Navigate into a post
    When I follow a post
    Then I should see the link "Edit"
    And I should see the link "View"
    And I should see the heading "Comments"
    And I should not see "Page not found"
    And I should not see "Access denied"

  @dependent
  Scenario: Visit edit page and view texts
    When I follow "edit" for a post
    Then I should see "Subject:"
    And I should see "Comment:"

  @dependent
  Scenario: Visit Delete link
    When I follow "delete"
    Then I should see "Are you sure you want to delete the comment"
    And I should see "Any replies to this comment will be lost. This action cannot be undone"
    And I should see "Delete"
    And I should see the link "Cancel"

  @javascript @dependent @flaky
  Scenario: Select dropdown: This page
    When I wait for "3" seconds
    And I select "All (this page)" from field "Select..."
    And all the checkboxes are selected
    And I press "Delete comment"
    Then I should see "You selected"
    And I should see "rows"
    And I should see the link "Cancel"

  @javascript @dependent
  Scenario: Select dropdown: All pages
    When I select "All (all pages)" from field "Select..."
    And all the checkboxes are selected
    And I press "Delete comment"
    Then I should see "You selected all"
    And I should see "rows in this view"
    And I should see the link "Cancel"

  @javascript @dependent
  Scenario: Select dropdown: None
    When I select "All (all pages)" from field "Select..."
    And all the checkboxes are selected
    And I select "None" from field "Select..."
    Then none the checkboxes are selected

  @dependent
  Scenario: Unpublish comment: Dont select
    When I press "Unpublish comment"
    Then I should see "No row selected. Please select one or more rows"
    And I should not see "Performed Unpublish comment on comment"

  @javascript @dependent
  Scenario: Unpublish comment: Cancel
    When I check "2" checkboxes to "unpublish"
    And I press "Unpublish comment"
    And I follow "Cancel"
    Then I should not see "Performed Unpublish comment on comment"

  @dependent
  Scenario: Delete commen: Dont select
    When I press "Delete comment"
    Then I should see "No row selected. Please select one or more rows"
    And I should not see "This action cannot be undone"
    And I should not see "has been deleted"

  @javascript @dependent
  Scenario: Delete comments: Cancel
    When I check "2" checkboxes to "delete"
    And I press "Delete comment"
    And I follow "Cancel"
    Then I should not see "has been deleted"

  @javascript @dependent @slow
  Scenario: Unpublish comments: Confirm
    When I check "2" checkboxes to "unpublish"
    And I press "Unpublish comment"
    And I press "Confirm"
    And I wait "10" seconds
    Then I should see "Performed Unpublish comment on comment"

  @javascript @dependent @slow
  Scenario: Delete comments: Confirm
    When I check "2" checkboxes to "delete"
    And I press "Delete comment"
    And I wait "2" seconds
    And I press "Confirm"
    And I wait "10" seconds
    Then I should see "Performed Delete comment on comment"

  @javascript @clean_data @dependent @slow
  Scenario: Delete all remaining comments
    When I select "All (all pages)" from field "Select..."
    And I press "Delete comment"
    And I wait "2" seconds
    And I press "Confirm"
    And I wait "10" seconds
    Then I should see "Performed Delete comment on comment"
