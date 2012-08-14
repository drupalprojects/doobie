Feature: To get administrative view of nodes by a user
  In order to manage content
  As an admin user
  I should be able to view the list and filter them

  Background:
    Given I am logged in as "admin test"
    And I follow "Administer nodes"

  Scenario: View the list of items
    Then I should see at least "25" records
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

  Scenario: Navigate to an item
    When I follow a post
    Then I should see the link "Edit"
    And I should see the link "View"
    And I should not see "Page not found"
    And I should not see "Access denied"

  Scenario: Check for Edit link
    When I follow "edit" for a post
    Then I should see "Log message"
    And I should see "Create new revision"

  Scenario: Check for Delete link
    When I follow "delete"
    Then I should see "Are you sure you want to delete"
    And I should see "This action cannot be undone"
    And I should see "Delete"
    And I should see the link "Cancel"

  @javascript
  Scenario: Select dropdown: This page
    When I select "All (this page)" from field "Select..."
    And all the checkboxes are selected
    And I press "Delete node"
    Then I should see "You selected"
    And I should see "rows"
    And I should see the link "Cancel"

  @javascript
  Scenario: Select dropdown: All pages
    When I select "All (all pages)" from field "Select..."
    And all the checkboxes are selected
    And I press "Delete node"
    Then I should see "You selected all"
    And I should see "rows in this view"
    And I should see the link "Cancel"

  @javascript
  Scenario: Select dropdown: None
    When I select "All (all pages)" from field "Select..."
    And all the checkboxes are selected
    And I select "None" from field "Select..."
    Then none the checkboxes are selected

  Scenario: Unpublish posts: Dont select
    When I press "Unpublish"
    Then I should see "No row selected. Please select one or more rows"
    And I should not see "Performed Unpublish on node"

  @javascript
  Scenario: Unpublish posts: Cancel
    When I check "2" checkboxes to "unpublish"
    And I press "Unpublish"
    And I follow "Cancel"
    Then I should not see "Performed Unpublish on node"

  Scenario: Check for Delete: Dont select
    When I press "Delete node"
    Then I should see "No row selected. Please select one or more rows"
    And I should not see "This action cannot be undone"
    And I should not see "has been deleted"

  @javascript
  Scenario: Delete posts: Cancel
    When I check "2" checkboxes to "delete"
    And I press "Delete node"
    And I follow "Cancel"
    Then I should not see "has been deleted"

  # CAUTION: Use the below scenarios only when required and on dev site
  #@javascript
  #Scenario: Delete posts: Confirm
  #  When I check "2" checkboxes to "delete"
  #  And I press "Delete node"
  #  And I press "Confirm"
  #  And I wait "5" seconds
  #  Then I should see "has been deleted"

  #@javascript
  #Scenario: Unpublish posts: Confirm
  #  When I check "2" checkboxes to "unpublish"
  #  And I press "Unpublish"
  #  And I press "Confirm"
  #  And I wait "5" seconds
  #  Then I should see "The update has been performed"
