@user @admin
Feature: Administrative view of nodes by a user
  In order to effectively fight spam
  As a site maintainer
  I should be able to view the list of nodes by a specific user and delete them

  Scenario: Create test data as Confirmed User
    Given users:
      | name         | pass     | mail                                 | roles         |
      | Confirmed User | password | ryan+siteuser@association.drupal.org | confirmed |
    And I am logged in as "Confirmed User"
    When I visit "/node/add/book?parent=3264"
    And I create "3" book pages
    Then I should see "has been created"

  @dependent @failing
  Scenario: View the list of items
    Given users:
      | name                | pass     | mail                                    | roles         |
      | Administrative User | password | qa+administrator@association.drupal.org | administrator |
    And I am logged in as "Administrative User"
    And I visit "Confirmed User" profile page
    When I follow "Administer nodes"
    Then I should see the heading "Nodes by Confirmed User"
    And I should see at least "3" records
    And I should see the following <texts>
      | texts      |
      | Title      |
      | Body       |
      | Post date  |
      | Operations |
      | Published  |
    And I should see the following <links>
      | links  |
      | View   |
      | Edit   |
      | edit   |
      | delete |

  @dependent @failing
  Scenario: Visit Delete link
    Given users:
      | name                | pass     | mail                                    | roles         |
      | Administrative User | password | qa+administrator@association.drupal.org | administrator |
    And I am logged in as "Administrative User"
    And I visit "Confirmed User" profile page
    And I follow "Administer nodes"
    When I follow "delete"
    Then I should see "Are you sure you want to delete"
    And I should see "This action cannot be undone"
    And I should see "Delete"
    And I should see the link "Cancel"

  @dependent @flaky @javascript @failing
  Scenario: Select dropdown: This page
    Given users:
      | name                | pass     | mail                                    | roles         |
      | Administrative User | password | qa+administrator@association.drupal.org | administrator |
    And I am logged in as "Administrative User"
    And I visit "Confirmed User" profile page
    And I follow "Administer nodes"
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
    And I visit "Confirmed User" profile page
    And I follow "Administer nodes"
    And I wait until the page is loaded
    When I "check" the table header checkbox
    And all the checkboxes are selected
    And I select "Delete item" from field "- Choose an operation -"
    And I press "Execute"
    Then I should see "You selected the following"
    And I should see the link "Cancel"

  @dependent @javascript @failing
  Scenario: Select dropdown: None
    Given users:
      | name                | pass     | mail                                    | roles         |
      | Administrative User | password | qa+administrator@association.drupal.org | administrator |
    And I am logged in as "Administrative User"
    And I visit "Confirmed User" profile page
    And I follow "Administer nodes"
    And I wait until the page is loaded
    When I "check" the table header checkbox
    And all the checkboxes are selected
    And I "uncheck" the table header checkbox
    Then none the checkboxes are selected

  @dependent @failing
  Scenario: Unpublish posts: Don't select
    Given users:
      | name                | pass     | mail                                    | roles         |
      | Administrative User | password | qa+administrator@association.drupal.org | administrator |
    And I am logged in as "Administrative User"
    And I visit "Confirmed User" profile page
    And I follow "Administer nodes"
    When I select "Unpublish content" from field "- Choose an operation -"
    And I press "Execute"
    Then I should see "Please select at least one item"
    And I should not see "You selected the following"

  @dependent @javascript @failing
  Scenario: Unpublish posts: Cancel
    Given users:
      | name                | pass     | mail                                    | roles         |
      | Administrative User | password | qa+administrator@association.drupal.org | administrator |
    And I am logged in as "Administrative User"
    And I visit "Confirmed User" profile page
    And I follow "Administer nodes"
    When I check "2" checkboxes to "unpublish"
    And I select "Unpublish content" from field "- Choose an operation -"
    And I press "Execute"
    And I wait until the page is loaded
    And I follow "Cancel"
    Then I should not see "Performed"

  @dependent @javascript @failing
  Scenario: Delete node: Don't select
    Given users:
      | name                | pass     | mail                                    | roles         |
      | Administrative User | password | qa+administrator@association.drupal.org | administrator |
    And I am logged in as "Administrative User"
    And I visit "Confirmed User" profile page
    And I follow "Administer nodes"
    When I select "Delete item" from field "- Choose an operation -"
    And I press "Execute"
    Then I should see "Please select at least one item"
    And I should not see "You selected the following"
    And I should not see "Performed"

  @dependent @javascript @failing
  Scenario: Delete posts: Cancel
    Given users:
      | name                | pass     | mail                                    | roles         |
      | Administrative User | password | qa+administrator@association.drupal.org | administrator |
    And I am logged in as "Administrative User"
    And I visit "Confirmed User" profile page
    And I follow "Administer nodes"
    When I check "2" checkboxes to "delete"
    When I select "Delete item" from field "- Choose an operation -"
    And I press "Execute"
    And I wait until the page is loaded
    And I follow "Cancel"
    Then I should not see "Performed"

  @dependent @slow @javascript @local @failing
  Scenario: Unpublish posts: Confirm
    Given users:
      | name                | pass     | mail                                    | roles         |
      | Administrative User | password | qa+administrator@association.drupal.org | administrator |
    And I am logged in as "Administrative User"
    And I visit "Confirmed User" profile page
    And I follow "Administer nodes"
    When I check "2" checkboxes to "unpublish"
    And I select "Unpublish content" from field "- Choose an operation -"
    And I press "Execute"
    And I press "Confirm"
    Then I should see "Performing"
    And I should see "Performed"

  @dependent @slow @javascript @local @failing
  Scenario: Delete posts: Confirm
    Given users:
      | name                | pass     | mail                                    | roles         |
      | Administrative User | password | qa+administrator@association.drupal.org | administrator |
    And I am logged in as "Administrative User"
    And I visit "Confirmed User" profile page
    And I follow "Administer nodes"
    When I check "2" checkboxes to "delete"
    And I select "Delete item" from field "- Choose an operation -"
    And I press "Execute"
    And I press "Confirm"
    Then I should see "Performing"
    And I should see "Performed"
