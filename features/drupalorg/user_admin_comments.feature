@user @admin @javascript
Feature: Aministrative view of comments by a user
  In order to effectively fight spam
  As a site maintainer
  I should be able to view the list of comments by a specific user and delete them

  @slow 
  Scenario: Create test data
    Given I am logged in as "site user"
    When I visit "/node/add/book?parent=3264"
    And I create a book page
    And I see "has been created"
    And I follow "Add new comment"
    And I add "3" comments
    Then I should see "Posted by site user"

  @dependent
  Scenario: View the list of items
    Given I am logged in as "admin test"
    And I visit "site user" profile page
    When I follow "Administer comments"
    Then I should see the heading "Comments by site user"
    And I should see at least "3" records
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
  Scenario: Navigate into a post.
    Given I am logged in as "admin test"
    And I visit "site user" profile page
    And I follow "Administer comments"
    When I follow a post
    Then I should see the link "Edit"
    And I should see the link "View"
    And I should see the heading "Comments"
    And I should not see "Page not found"
    And I should not see "Access denied"

  @dependent
  Scenario: Visit edit page and view texts
    Given I am logged in as "admin test"
    And I visit "site user" profile page
    And I follow "Administer comments"
    When I follow "edit" for a post
    Then I should see "Subject:"
    And I should see "Comment:"

  @dependent
  Scenario: Visit Delete link
    Given I am logged in as "admin test"
    And I visit "site user" profile page
    And I follow "Administer comments"
    When I follow "delete"
    Then I should see "Are you sure you want to delete the comment"
    And I should see "Any replies to this comment will be lost. This action cannot be undone"
    And I should see "Delete"
    And I should see the link "Cancel"

  @dependent @flaky
  Scenario: Select dropdown: This page
    Given I am logged in as "admin test"
    And I visit "site user" profile page
    And I follow "Administer comments"
    And I wait until the page is loaded
    When I select "All (this page)" from field "Select..."
    And all the checkboxes are selected
    And I press "Delete comment"
    Then I should see "You selected"
    And I should see "rows"
    And I should see the link "Cancel"

  @dependent
  Scenario: Select dropdown: All pages
    Given I am logged in as "admin test"
    And I visit "site user" profile page
    And I follow "Administer comments"
    When I select "All (all pages)" from field "Select..."
    And all the checkboxes are selected
    And I press "Delete comment"
    Then I should see "You selected all"
    And I should see "rows in this view"
    And I should see the link "Cancel"

  @dependent
  Scenario: Select dropdown: None
    Given I am logged in as "admin test"
    And I visit "site user" profile page
    And I follow "Administer comments"
    When I select "All (all pages)" from field "Select..."
    And all the checkboxes are selected
    And I select "None" from field "Select..."
    Then none the checkboxes are selected

  @dependent
  Scenario: Unpublish comment: Don't select
    Given I am logged in as "admin test"
    And I visit "site user" profile page
    And I follow "Administer comments"
    When I press "Unpublish comment"
    Then I should see "No row selected. Please select one or more rows"
    And I should not see "Performed Unpublish comment on comment"

  @dependent
  Scenario: Unpublish comment: Cancel
    Given I am logged in as "admin test"
    And I visit "site user" profile page
    And I follow "Administer comments"
    When I check "2" checkboxes to "unpublish"
    And I press "Unpublish comment"
    And I follow "Cancel"
    Then I should not see "Performed Unpublish comment on comment"

  @dependent
  Scenario: Delete comment: Don't select
    Given I am logged in as "admin test"
    And I visit "site user" profile page
    And I follow "Administer comments"
    When I press "Delete comment"
    Then I should see "No row selected. Please select one or more rows"
    And I should not see "This action cannot be undone"
    And I should not see "has been deleted"

  @dependent
  Scenario: Delete comments: Cancel
    Given I am logged in as "admin test"
    And I visit "site user" profile page
    And I follow "Administer comments"
    When I check "2" checkboxes to "delete"
    And I press "Delete comment"
    And I follow "Cancel"
    Then I should not see "has been deleted"

  @dependent @slow @known_git6failure
  Scenario: Unpublish comments: Confirm
    Given I am logged in as "admin test"
    And I visit "site user" profile page
    And I follow "Administer comments"
    When I check "2" checkboxes to "unpublish"
    And I press "Unpublish comment"
    And I press "Confirm"
    And I wait until the page is loaded
    Then I should see "Performed Unpublish comment on comment"

  @dependent @slow @known_git6failure
  Scenario: Delete comments: Confirm
    Given I am logged in as "admin test"
    And I visit "site user" profile page
    And I follow "Administer comments"
    When I check "2" checkboxes to "delete"
    And I press "Delete comment"
    And I wait until the page is loaded
    And I press "Confirm"
    And I wait until the page is loaded
    Then I should see "Performed Delete comment on comment"

  @dependent @slow @known_git6failure
  Scenario: Delete all remaining comments
    Given I am logged in as "admin test"
    And I visit "site user" profile page
    And I follow "Administer comments"
    When I select "All (all pages)" from field "Select..."
    And I press "Delete comment"
    And I wait until the page is loaded
    And I press "Confirm"
    And I wait until the page is loaded
    Then I should see "Performed Delete comment on comment"

  @dependent @known_git6failure
  Scenario: Delete book page
    Given I am logged in as "admin test"
    And I visit "site user" profile page
    And I follow "Administer nodes"
    When I select "All (all pages)" from field "Select..."
    And I press "Delete node"
    And I press "Confirm"
    And I wait until the page is loaded
    Then I should see "has been deleted"
