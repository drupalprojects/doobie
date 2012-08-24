Feature: Your Issues
  In order to define the search for your own issues
  As an Authenticated user
  I wanted to look for search for your own issues

  Background:
    Given I am logged in as "site user"
    And I follow "Your Issues"

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

  Scenario: For searching for a matching records.
    When I fill in "Search for" with "test 6"
    And I press "Search" in the "content" region
    Then I should see at least "2" records

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
    Then I should see at least "2" records
    And I should not see "No issues match your criteria."

  @javascript
  Scenario: For navigating through a specific project issue
    When I fill in "Search for" with "test 6"
    And I press "Search" in the "content" region
    Then I should see at least "1" record
    And I wait for "2" seconds
    And I follow "Project test 6"
    And I should see the heading "Issue Summary"
    And I should see the heading "Comments"
    And I should see the heading "Post new comment"

  Scenario: For searching the records with priority with status/priority
    When I select the following <fields> with <values>
    | fields | values |
    | Status | needs work |
    | Priority | normal |
    And I press "Search" in the "content" region
    Then I should see at least "1" record
    And I should see "needs work" under "Status"
    And I should see "normal" under "Priority"
    And I should not see "No issues match your criteria."