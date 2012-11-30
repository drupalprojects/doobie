@issues
Feature: Visitor views issue queue for a project
  In order to evaluate a project
  As a visitor to a project issue queue
  I want to browse issues

  Scenario: Issues exist
    Given I am on "/project/coder"
    When I click "Advanced search"
    Then I should see at least "50" records
    And I should see "Last updated" sorted in "ascending" order

  @clean_data
  Scenario: No issues exist
    Given I am logged in as "git user"
    And I create a sandbox project
    And I click "0 total"
    Then I should see "No issues match your criteria."

    
