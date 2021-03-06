@user @manual
Feature: View the issues I am interested in
  In order to see all the issues I am interested in
  As an authenticated user
  I should be able to see the list of issues I follow and filter them

  Background:
    Given users:
      | name         | pass     | mail                                 | roles         |
      | Confirmed User | password | ryan+siteuser@association.drupal.org | confirmed |
    And I am logged in as "Confirmed User"
    And I follow "Your Issues"

  @failing
  Scenario: View links and texts on the page
    Then I should see the following <links>
      | links              |
      | Create a new issue |
      | Advanced search    |
    And I should see the following <texts>
      | texts        |
      | Search for   |
      | Project      |
      | Status       |
      | Priority     |
      | Category     |
      | Summary      |
      | Version      |
      | Replies      |
      | Last updated |
      | Assigned to  |
      | Created      |

  @failing
  Scenario: Create test data for the following scenarios
    When I follow "Create a new issue"
    And I fill in "Project" with "443 Session"
    And I press "Next"
    When I create a new issue
    Then I should see "has been created"

  @javascript @dependent @failing
  Scenario: Search issue fill few fields
    When I fill in "Project" with "443"
    And I wait for the suggestion box to appear
    And I select "443 Session" from the suggestion "Project"
    And I press "Search" in the "content" region
    Then I should see the issue link
    And I should not see "No issues match your criteria."

  @javascript @dependent @failing
  Scenario: Search issue fill all fields
    When I fill in "Project" with "443"
    And I wait for the suggestion box to appear
    And I select "443 Session" from the suggestion "Project"
    And I select the following <fields> with <values>
      | fields   | values |
      | Status   | Active |
      | Priority | Normal |
      | Category | Task   |
    And I press "Search" in the "content" region
    Then I should see the issue link
    And I should not see "No issues match your criteria."

# clean_data tag was failing because of revision log message
  @dependent @failing
  Scenario: Navigate through the issue created previously
    When I follow an issue of the project
    Then I should see the random "Description" text
    And I should see the heading "Issue status"
    And I should see "443 Session"
