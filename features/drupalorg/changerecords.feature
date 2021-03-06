@changerecords
Feature: Add change record
  In order to see and add change records
  As an authenticated user
  I should be able to click on the respective link and submit the page

  @anon @javascript
  Scenario: Add new change record as anonymous user
    Given I am on "/list-changes/drupal"
    When I follow "Add new change record"
    Then I should see "You need to log in or create an account to access this page."
    And I should see the heading "Welcome to Drupal.org"
    But I should not see "Create Change record"

  Scenario: Navigate to a change record
    Given users:
      | name         | pass     | mail                                 | roles         |
      | Confirmed User | password | ryan+siteuser@association.drupal.org | confirmed |
    And I am logged in as "Confirmed User"
    When I am on "/project/drupal"
    And I follow "View change records"
    And I follow "Add new change record"
    Then I should see "Create Change record"

  @parenthesiserror
  Scenario: Add new change record
    Given users:
      | name         | pass     | mail                                 | roles         |
      | Confirmed User | password | ryan+siteuser@association.drupal.org | confirmed |
    And I am logged in as "Confirmed User"
    And I am on "/node/add/changenotice"
    When I create new change record
    Then I should see "has been created"
    And I should see "Posted by Confirmed User"
    And I should see the random text for the following <fields>
      | fields                |
      | Title                 |
      | Project               |
      | Introduced in branch  |
      | Introduced in version |
      | Description           |
      | Details               |
      | Progress              |
    And I should see the link "Drupal Core"
    And I should see the following <texts>
      | texts                                  |
      | Project                                |
      | Site builders, administrators, editors |
      | Module developers                      |
      | Themers                                |
      | Generic online documentation done      |
      | Theming guide done                     |
      | Module developer documentation done    |
      | Examples for developers done           |
      | Coder review done                      |
      | Coder upgrade done                     |
      | Other updates done                     |
    And I should see the attachment
    And I am on "/project/drupal"
    When I follow "View change records"
    Then I should see change record link
