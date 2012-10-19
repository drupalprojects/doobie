@admin
Feature: To get administrative view of nodes by a user
  In order to manage content
  As an admin user
  I should be able to view the list and filter them

  Background:
    Given I am logged in as "admin test"
    And I follow "Administer nodes"

  @slow
  Scenario: Create test data
    When I visit "/node/add/page"
    And I create "3" pages
    Then I should see "has been created"

  @dependent
  Scenario: View the list of items
    Then I should see at least "3" records
    And I should see the following <texts>
    | texts     |
    | Title     |
    | Body      |
    | Post date |
    | Operations|
    | Published |
    And I should see the following <links>
    | links     |
    | View      |
    | Edit      |
    | edit      |
    | delete    |

  @dependent
  Scenario: Navigate to an item
    When I follow a post
    Then I should see the link "Edit"
    And I should see the link "View"
    And I should not see "Page not found"
    And I should not see "Access denied"

  @dependent
  Scenario: Visit Edit link and view the contents
    When I follow "edit" for a post
    Then I should see "Log message"
    And I should see "Create new revision"

  @dependent
  Scenario: Vsit Delete link
    When I follow "delete"
    Then I should see "Are you sure you want to delete"
    And I should see "This action cannot be undone"
    And I should see "Delete"
    And I should see the link "Cancel"

  @javascript @dependent @flaky
  Scenario: Select dropdown: This page
    When I wait for "3" seconds
    And I select "All (this page)" from field "Select..."
    And all the checkboxes are selected
    And I press "Delete node"
    Then I should see "You selected"
    And I should see "rows"
    And I should see the link "Cancel"

  @javascript @dependent
  Scenario: Select dropdown: All pages
    When I select "All (all pages)" from field "Select..."
    And all the checkboxes are selected
    And I press "Delete node"
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
  Scenario: Unpublish posts: Don't select
    When I press "Unpublish"
    Then I should see "No row selected. Please select one or more rows"
    And I should not see "Performed Unpublish on node"

  @javascript @dependent
  Scenario: Unpublish posts: Cancel
    When I check "2" checkboxes to "unpublish"
    And I press "Unpublish"
    And I follow "Cancel"
    Then I should not see "Performed Unpublish on node"

  @dependent
  Scenario: Delete node: Don't select
    When I press "Delete node"
    Then I should see "No row selected. Please select one or more rows"
    And I should not see "This action cannot be undone"
    And I should not see "has been deleted"

  @javascript @dependent
  Scenario: Delete posts: Cancel
    When I check "2" checkboxes to "delete"
    And I press "Delete node"
    And I follow "Cancel"
    Then I should not see "has been deleted"

  @javascript @slow @dependent
  Scenario: Unpublish posts: Confirm
    When I check "2" checkboxes to "unpublish"
    And I press "Unpublish"
    And I press "Confirm"
    And I wait "5" seconds
    Then I should see "The update has been performed"

  @javascript @slow @dependent
  Scenario: Delete posts: Confirm
    When I check "2" checkboxes to "delete"
    And I press "Delete node"
    And I press "Confirm"
    And I wait "5" seconds
    Then I should see "has been deleted"

  @javascript @dependent
  Scenario: Select dropdown: All pages and delete
    When I select "All (all pages)" from field "Select..."
    And I press "Delete node"
    And I press "Confirm"
    And I wait "5" seconds
    Then I should see "has been deleted"
