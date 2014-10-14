@issues
Feature: Visitor views issue queue for a project
  In order to evaluate a project
  As a visitor to a project issue queue
  I want to browse issues

  Scenario: Issues exist in existing project
    Given I am on "/project/coder"
    When I click "Advanced search"
    Then I should see at least "50" records
    And I should see "Last updated" sorted in "ascending" order

  @clean_data @failing
 Scenario: No issues exist in new project
    Given users:
      | name     | pass     | mail                              | roles    |
      | Git User | password | qa+gituser@association.drupal.org | Git user |
    And I am logged in as "Git User"
    And I visit "/node/add/project-module"
    When I create a "sandbox" project
    And I click "0 total"
    Then I should see "No issues match your criteria"

