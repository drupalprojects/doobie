@user @admin @wip
Feature: Administrative view of comments by a user
  In order to effectively fight spam
  As a site maintainer
  I should be able to view the list of comments by a specific user and delete them

  @slow
  Scenario: Create test data
    Given users:
      | name         | pass     | mail                                 | roles         |
      | Trusted User | password | ryan+siteuser@association.drupal.org | trusted |
    And I am logged in as "Trusted User"
    When I visit "/node/add/book?parent=3264"
    And I create a book page
    And I see "has been created"
    And I follow "Add new comment"
    And I add "3" comments
    Then I should see "Trusted User commented"

  @dependent @failing
  Scenario: View the list of items
    Given users:
      | name                | pass     | mail                                    | roles         |
      | Administrative User | password | qa+administrator@association.drupal.org | administrator |
    And I am logged in as "Administrative User"
    And I visit "Trusted User" profile page
    When I follow "Administer comments"
    Then I should not see "Page not found"
    And I should see the heading "Comments by Trusted User"
    And I should see at least "3" records
    And I should see the following <texts>
      | texts        |
      | Title        |
      | Node title   |
      | Comment      |
      | Updated date |
      | Operations   |
      | Published    |
    And I should see the following <links>
      | links  |
      | View   |
      | Edit   |
      | edit   |
      | delete |

  @dependent @failing
  Scenario: Navigate into a post
    Given users:
      | name                | pass     | mail                                    | roles         |
      | Administrative User | password | qa+administrator@association.drupal.org | administrator |
    And I am logged in as "Administrative User"
    And I visit "Trusted User" profile page
    And I follow "Administer comments"
    When I follow a post
    Then I should see the link "Edit"
    And I should see the link "View"
    And I should see the heading "Comments"
    And I should not see "Page not found"
    And I should not see "Access denied"

  @dependent @failing
  Scenario: Visit edit page and view texts
    Given users:
      | name                | pass     | mail                                    | roles         |
      | Administrative User | password | qa+administrator@association.drupal.org | administrator |
    And I am logged in as "Administrative User"
    And I visit "Trusted User" profile page
    And I follow "Administer comments"
    When I follow "edit" for a post
    Then I should see "Subject"
    And I should see "Comment"

  @dependent @failing
  Scenario: Visit Delete link
    Given users:
      | name                | pass     | mail                                    | roles         |
      | Administrative User | password | qa+administrator@association.drupal.org | administrator |
    And I am logged in as "Administrative User"
    And I visit "Trusted User" profile page
    And I follow "Administer comments"
    When I follow "delete"
    Then I should see "Are you sure you want to delete the comment"
    And I should see "Any replies to this comment will be lost. This action cannot be undone"
    And I should see "Delete"
    And I should see the link "Cancel"

  @dependent @javascript @failing
  Scenario: Select dropdown: This page
    Given users:
      | name                | pass     | mail                                    | roles         |
      | Administrative User | password | qa+administrator@association.drupal.org | administrator |
    And I am logged in as "Administrative User"
    And I visit "Trusted User" profile page
    And I follow "Administer comments"
    And I wait until the page is loaded
    When I "check" the table header checkbox
    And all the checkboxes are selected
    And I select "Delete item" from field "- Choose an operation -"
    And I press "Execute"
    Then I should see "You selected the following"
    And I should see the link "Cancel"

  @dependent @javascript @failing
  Scenario: Select dropdown: All pages
    Given users:
      | name                | pass     | mail                                    | roles         |
      | Administrative User | password | qa+administrator@association.drupal.org | administrator |
    And I am logged in as "Administrative User"
    And I visit "Trusted User" profile page
    And I follow "Administer comments"
    And I wait until the page is loaded
    When I "check" the table header checkbox
    And all the checkboxes are selected
    And I select "Delete item" from field "- Choose an operation -"
    And I press "Execute"
    Then I should see "You selected the following"
    And I should see the link "Cancel"

  @dependent  @javascript @failing
  Scenario: Select dropdown: None
    Given users:
      | name                | pass     | mail                                    | roles         |
      | Administrative User | password | qa+administrator@association.drupal.org | administrator |
    And I am logged in as "Administrative User"
    And I visit "Trusted User" profile page
    And I follow "Administer comments"
    And I wait until the page is loaded
    When I "check" the table header checkbox
    And all the checkboxes are selected
    And I "uncheck" the table header checkbox
    Then none the checkboxes are selected

  @dependent @failing
  Scenario: Unpublish comment: Don't select
    Given users:
      | name                | pass     | mail                                    | roles         |
      | Administrative User | password | qa+administrator@association.drupal.org | administrator |
    And I am logged in as "Administrative User"
    And I visit "Trusted User" profile page
    And I follow "Administer comments"
    When I select "Unpublish comment" from field "- Choose an operation -"
    And I press "Execute"
    Then I should see "Please select at least one item"
    And I should not see "You selected the following item"

  @dependent @failing
  Scenario: Unpublish comment: Cancel
    Given users:
      | name                | pass     | mail                                    | roles         |
      | Administrative User | password | qa+administrator@association.drupal.org | administrator |
    And I am logged in as "Administrative User"
    And I visit "Trusted User" profile page
    And I follow "Administer comments"
    When I check "2" checkboxes to "unpublish"
    And I select "Unpublish content" from field "- Choose an operation -"
    And I press "Execute"
    And I follow "Cancel"
    Then I should not see "Performed Unpublish content on"

  @dependent @failing
  Scenario: Delete comment: Don't select
    Given users:
      | name                | pass     | mail                                    | roles         |
      | Administrative User | password | qa+administrator@association.drupal.org | administrator |
    And I am logged in as "Administrative User"
    And I visit "Trusted User" profile page
    And I follow "Administer comments"
    When I select "Delete item" from field "- Choose an operation -"
    And I press "Execute"
    Then I should see "Please select at least one item"
    And I should not see "You selected the following item"
    And I should not see "Performed Delete item on"

  @dependent @failing
  Scenario: Delete comments: Cancel
    Given users:
      | name                | pass     | mail                                    | roles         |
      | Administrative User | password | qa+administrator@association.drupal.org | administrator |
    And I am logged in as "Administrative User"
    And I visit "Trusted User" profile page
    And I follow "Administer comments"
    When I check "2" checkboxes to "delete"
    When I select "Delete item" from field "- Choose an operation -"
    And I press "Execute"
    And I follow "Cancel"
    Then I should not see "Performed Delete item on"

  @dependent @slow @failing
  Scenario: Unpublish comments: Confirm
    Given users:
      | name                | pass     | mail                                    | roles         |
      | Administrative User | password | qa+administrator@association.drupal.org | administrator |
    And I am logged in as "Administrative User"
    And I visit "Trusted User" profile page
    And I follow "Administer comments"
    When I check "2" checkboxes to "unpublish"
    And I select "Unpublish content" from field "- Choose an operation -"
    And I press "Execute"
    And I press "Confirm"
    And I wait until the page is loaded
    Then I should see "Performed Unpublish content on"

  @dependent @slow @failing
  Scenario: Delete comments: Confirm
    Given users:
      | name                | pass     | mail                                    | roles         |
      | Administrative User | password | qa+administrator@association.drupal.org | administrator |
    And I am logged in as "Administrative User"
    And I visit "Trusted User" profile page
    And I follow "Administer comments"
    When I check "2" checkboxes to "delete"
    And I select "Delete item" from field "- Choose an operation -"
    And I press "Execute"
    And I press "Confirm"
    And I wait until the page is loaded
    Then I should see "Performed Delete item on"
