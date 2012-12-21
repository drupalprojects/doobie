@user @admin @wip
Feature: Administrative view of nodes by a user
  In order to effectively fight spam
  As a site maintainer
  I should be able to view the list of nodes by a specific user and delete them

  Scenario: Create test data as site user
    Given I am logged in as "site user"
    When I visit "/node/add/book?parent=3264"
    And I create "3" book pages
    Then I should see "has been created"

  @dependent
  Scenario: View the list of items
    Given I am logged in as "admin test"
    And I visit "site user" profile page
    When I follow "Administer nodes"
    Then I should see the heading "Nodes by site user"
    And I should see at least "3" records
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
    Given I am logged in as "admin test"
    And I visit "site user" profile page
    And I follow "Administer nodes"
    When I follow a post
    Then I should see the link "Edit"
    And I should see the link "View"
    And I should not see "Page not found"
    And I should not see "Access denied"

  @dependent
  Scenario: Visit Edit link and view the contents
    Given I am logged in as "admin test"
    And I visit "site user" profile page
    And I follow "Administer nodes"
    When I follow "edit" for a post
    And I click "Revision information"
    Then I should see "Revision log message"
    And I should see "Create new revision"

  @dependent @known_git7failure
  Scenario: Vsit Delete link
    Given I am logged in as "admin test"
    And I visit "site user" profile page
    And I follow "Administer nodes"
    When I follow "delete"
    Then I should see "Are you sure you want to delete"
    And I should see "This action cannot be undone"
    And I should see "Delete"
    And I should see the link "Cancel"

  @dependent @flaky @javascript
  Scenario: Select dropdown: This page
    Given I am logged in as "admin test"
    And I visit "site user" profile page
    And I follow "Administer nodes"
    And I wait until the page is loaded
    When I "check" the table header checkbox
    And all the checkboxes are selected
    And I select "Delete item" from field "- Choose an operation -"
    And I press "Execute"
    Then I should see "You selected the following items"
    And I should see the link "Cancel"

  @dependent @javascript
  Scenario: Select dropdown: All pages
    Given I am logged in as "admin test"
    And I visit "site user" profile page
    And I follow "Administer nodes"
    And I wait until the page is loaded
    When I "check" the table header checkbox
    And all the checkboxes are selected
    And I select "Delete item" from field "- Choose an operation -"
    And I press "Execute"
    Then I should see "You selected the following items"
    And I should see the link "Cancel"

  @dependent @javascript
  Scenario: Select dropdown: None
    Given I am logged in as "admin test"
    And I visit "site user" profile page
    And I follow "Administer nodes"
    And I wait until the page is loaded
    When I "check" the table header checkbox
    And all the checkboxes are selected
    And I "uncheck" the table header checkbox
    Then none the checkboxes are selected

  @dependent @known_git7failure
  Scenario: Unpublish posts: Don't select
    Given I am logged in as "admin test"
    And I visit "site user" profile page
    And I follow "Administer nodes"
    When I select "Unpublish content" from field "- Choose an operation -"
    And I press "Execute"
    Then I should see "Please select at least one item"
    And I should not see "You selected the following item"

  @dependent @known_git7failure @javascript
  Scenario: Unpublish posts: Cancel
    Given I am logged in as "admin test"
    And I visit "site user" profile page
    And I follow "Administer nodes"
    When I check "2" checkboxes to "unpublish"
    And I select "Unpublish content" from field "- Choose an operation -"
    And I press "Execute"
    And I follow "Cancel"
    Then I should not see "Performed Unpublish content on"

  @dependent @javascript
  Scenario: Delete node: Don't select
    Given I am logged in as "admin test"
    And I visit "site user" profile page
    And I follow "Administer nodes"
    When I select "Delete item" from field "- Choose an operation -"
    And I press "Execute"
    Then I should see "Please select at least one item"
    And I should not see "You selected the following item"
    And I should not see "Performed Delete item on"

  @dependent @javascript
  Scenario: Delete posts: Cancel
    Given I am logged in as "admin test"
    And I visit "site user" profile page
    And I follow "Administer nodes"
    When I check "2" checkboxes to "delete"
    When I select "Delete item" from field "- Choose an operation -"
    And I press "Execute"
    And I follow "Cancel"
    Then I should not see "Performed Delete item on"

  @dependent @slow @javascript
  Scenario: Unpublish posts: Confirm
    Given I am logged in as "admin test"
    And I visit "site user" profile page
    And I follow "Administer nodes"
    When I check "2" checkboxes to "unpublish"
    And I select "Unpublish content" from field "- Choose an operation -"
    And I press "Execute"
    And I press "Confirm"
    And I wait until the page is loaded
    Then I should see "Performed Unpublish content on"

  @dependent @slow @javascript
  Scenario: Delete posts: Confirm
    Given I am logged in as "admin test"
    And I visit "site user" profile page
    And I follow "Administer nodes"
    When I check "2" checkboxes to "delete"
    And I select "Delete item" from field "- Choose an operation -"
    And I press "Execute"
    And I press "Confirm"
    And I wait until the page is loaded
    Then I should see "Performed Delete item on"
    