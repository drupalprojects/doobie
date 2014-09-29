@issues
Feature: Prominently display issue metadata
  In order to easily see the status of an issue
  As a site visitor
  I want to see the status categories prominently displayed

  @api
  Scenario:
    Given users:
      | name       | pass     | mail                                 | roles         |
      | site user2 | password | ryan+fakeuser@association.drupal.org | Not a spammer |
    And I am logged in as "site user2"
    And I visit "/project/issues/doobie"
    And I follow "Create a new issue"
    And I fill in "Title" with "Metadata Example"
    And I select the following <fields> with <values>
      | fields    | values       |
      | Version   | 7.x-1.x-dev  |
      | Component | Failing test |
      | Assigned  | site user2   |
      | Category  | Task         |
      | Priority  | Normal       |
      | Status    | Active       |
    And I fill in "Issue summary" with random text
    And I fill in "qa" for "Issue tags"
    And I press "Save"
    And I wait until the page loads
    Then I should see the "Active" issue status
    Then I should see "7.x-1.x-dev" in the "Version" metadata
    And I should see "Failing test" in the "Component" metadata
    And I should see "site user2" in the "Assigned" metadata
    And I should see "Task" in the "Category" metadata
    And I should see "Normal" in the "Priority" metadata
    And I should see "qa" in the "Issue tags" metadata
    And I should see the link "Update this issue"
    And I should see "Last updated"

