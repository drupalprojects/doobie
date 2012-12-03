@issues @slow @wip
Feature: Overall Filter Search for issues
  In order to define the Advanced Filter search for project issues
  As an Authenticated user
  I wanted to look for Advanced Filter search options for finding the Issues

  Background:
    Given I am logged in as "site user"
    And I am on "/project/issues/search"

  @javascript
  Scenario: Visit the advanced search page
    When I wait until the page loads
    Then I should see the heading "Search issues for all projects"
    And I should see the following <texts>
    | texts        |
    | Search for   |
    | Project      |
    | Assigned     |
    | Submitted by |
    | Status       |
    And I should see at least "50" records
    And I should see the link "next"
    And I should see the link "last"

  Scenario: Search for matching records
    When I fill in "Search for" with "Achievements"
    And I press "Search" in the "content" region
    Then I should see at least "5" records

  @javascript
  Scenario: Seach the project issue with submitted users
    When I fill in "Project" with "Achievements"
    And I select "Achievements" from the suggestion "Project"
    And I press "Search" in the "content" region
    Then I should see at least "1" record

  @javascript
  Scenario: Search the issue with status/priority/category with additonal select
    When I fill in "Project" with "Achievements"
    And I select "Achievements" from the suggestion "Project"
    And I wait for "2" seconds
    And I select the following <fields> with <values>
    | fields   | values       |
    | Status   | Active       |
    | Status   | Needs review |
    | Priority | Normal       |
    | Priority | Minor        |
    And I wait for "3" seconds
    And I press "Search" in the "content" region
    Then I should see at least "2" records

  @javascript
  Scenario: Search the project by applying all filters
    When I fill in "Project" with "Achievements"
    And I select "Achievements" from the suggestion "Project"
    And I select the following <fields> with <values>
    | fields   | values          |
    | Status   | Active          |
    | Status   | Needs review    |
    | Status   | Closed (fixed)  |
    | Priority | Normal          |
    | Priority | Minor           |
    | Priority | Major           |
    | Category | Feature request |
    | Category | Support request |
    And I wait for "3" seconds
    And I press "Search" in the "content" region
    Then I should see at least "2" records

  @javascript
  Scenario: Search the issues with tags
    When I fill in "Assigned" with "sdboyer"
    And I select "sdboyer" from the suggestion "Assigned"
    And I select "Is one of" from field "Issue tags"
    And I fill in "sprint 2" for "Issue tags"
    And I wait for "5" seconds
    And I press "Search" in the "content" region
    Then I should see at least "1" record

  @javascript
  Scenario: Search the issues with tags
    When I select "Is all of" from field "Issue tags"
    And I fill in "sprint 2, sprint 1" for "Issue tags"
    And I fill in "Assigned" with "mirzu"
    And I select "mirzu" from the suggestion "Assigned"
    And I wait for "5" seconds
    And I press "Search" in the "content" region
    Then I should see at least "1" record

  @javascript
  Scenario: Search the issues with tags
    When I fill in "Assigned" with "site user"
    And I select "site user" from the suggestion "Assigned"
    And I select the following <fields> with <values>
    | fields   | values     |
    | Status   | Needs work |
    | Priority | Normal     |
    And I wait for "5" seconds
    And I press "Search" in the "content" region
    And I follow a post
    Then I should see the submitted user "site user"
