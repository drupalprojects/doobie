@wip
Feature: Your Issues
  In order to define the search for your own issues
  As an Authenticated user
  I wanted to look for search for your own issues

  Background:
    Given I am logged in as "site user"
    And I follow "Your Issues"

  Scenario: Create test data for the following scenarios
    When I follow "Create a new issue"
    And I select "443 Session" from "Project"
    And I press "Next"
    And I create a new issue
    Then I should see "has been created"

  Scenario: For navigating on the user specific issues.
    Then I should see the following <links>
    | links |
    | Create a new issue |
    | Advanced search |
    And I should see the following <texts>
    | texts |
    | Search for |
    | Project |
    | Status |
    | Priority |
    | Category |

  Scenario: For searching for alteast records.
    When I press "Search" in the "content" region
    Then I should see at least "1" records

  @javascript
  Scenario: For Searching user specific issues.
    When I fill in "Project" with "443"
    And I wait for the suggestion box to appear
    And I select "443 Session" from the suggestion "Project"
    And I select the following <fields> with <values>
    | fields | values |
    | Status | fixed |
    | Priority | normal |
    And I wait for "5" seconds
    And I press "Search" in the "content" region
    Then I should see at least "1" records
    And I should not see "No issues match your criteria."

  @javascript 
  Scenario: For navigating through a specific project issue
    When I select the following <fields> with <values>
    | fields | values |
    | Status | fixed |
    | Priority | normal |
    Then I should see at least "1" records
    And I wait for "4" seconds
    And I follow an issue of the project
    And I should see the heading "Issue Summary"
    And I should see the heading "Comments"
    And I should see the heading "Post new comment"

  Scenario: For searching the records with priority with status/priority
    When I select the following <fields> with <values>
    | fields | values |
    | Status | active |
    | Priority | normal |
    And I press "Search" in the "content" region
    Then I should see at least "1" record
    And I should see "active" under "Status"
    And I should see "normal" under "Priority"
    And I should not see "No issues match your criteria."
