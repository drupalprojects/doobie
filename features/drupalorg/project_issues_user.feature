Feature: View the issues created by a user
  In order to view the issues created by me
  As an authenticated user
  I should see my issues list and filter them

  Background:
    Given I am logged in as "site user"
    And I follow "Your Issues"

  Scenario: Verify that this is the your issues page
    Then I should see the following <links>
    | links |
    | Create a new issue |
    | Advanced search |
    And I should see the following <texts>
    | texts              |
    | Search for         |
    | Project            |
    | Status             |
    | Priority           |
    | Category           |

  Scenario: Create test data for the following scenarios
    When I follow "Create a new issue"
    And I select "443 Session" from "Project"
    And I press "Next"
    And I create a new issue
    Then I should see "has been created"

  @javascript @dependent
  Scenario: Search issue fill few fields
    When I fill in "Project" with "443"
    And I wait for the suggestion box to appear
    And I select "443 Session" from the suggestion "Project"
    And I wait for "5" seconds
    And I press "Search" in the "content" region
    Then I should see the issue link
    And I should not see "No issues match your criteria."

  @javascript @dependent
  Scenario: Search issue fill all fields
    When I fill in "Project" with "443"
    And I wait for the suggestion box to appear
    And I select "443 Session" from the suggestion "Project"
    And I wait for "4" seconds
    And I select the following <fields> with <values>
    | fields   | values    |
    | Status   | active    |
    | Priority | normal    |
    | Category | task      |
    And I press "Search" in the "content" region
    Then I should see the issue link
    And I should not see "No issues match your criteria."

  @dependent @clean_data
  Scenario: Navigate through the issue created previously
    When I follow an issue of the project
    Then I should see the heading "Issue Summary"
    And I should see the heading "Comments"
    And I should see the heading "Post new comment"	
