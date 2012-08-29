Feature: Overall Filter Search for Issues
  In order to define the Advanced Filter search for Issues
  As an Authenticated user
  I wanted to look for Advanced Filter search for Issues

  Background:
    Given I am logged in as "site user"
    And I am on "/project/issues/search"

  Scenario: For visting the advanced search page
    Then I should see the heading "Search issues for all projects"
    And I should see the following <texts>
    | texts        |
    | Search for   |
    | Project      |
    | Assigned     |
    | Submitted by |
    | Status       |

  Scenario: For searching for a matching records.
    When I fill in "Search for" with "Achievements"
    And I press "Search" in the "content" region
    Then I should see at least "5" records

  @javascript
  Scenario: For seaching the project issue with submitted users
    When I fill in "Project" with "Achie"
    And I wait for the suggestion box to appear
    And I select "Achievements" from the suggestion "Project"
    And I wait for "5" seconds
    And I press "Search" in the "content" region
    Then I should see at least "1" records

  @javascript
  Scenario: For Search the issue with status/priority/category with additonal select
    When I fill in "Project" with "Achie"
    And I select "Achievements" from the suggestion "Project"
    And I wait for "2" seconds
    And I select the following <fields> with <values>
    | fields   | values       |
    | Status   | active       |
    | Status   | needs review |
    | Priority | normal       |
    | Priority | minor        |
    And I wait for "5" seconds
    And I press "Search" in the "content" region
    Then I should see at least "2" records

  @javascript
  Scenario: For Searching the project by applying all filters
    When I fill in "Project" with "Achie"
    And I select "Achievements" from the suggestion "Project"
    And I select the following <fields> with <values>
    | fields   | values          |
    | Status   | active          |
    | Status   | needs review    |
    | Status   | closed (fixed)  |
    | Priority | normal          |
    | Priority | minor           |
    | Priority | major           |
    | Category | feature request |
    | Category | support request |
    And I wait for "5" seconds
    And I press "Search" in the "content" region
    Then I should see at least "2" records

  @javascript
  Scenario: For Searching the issues with tags
    When I fill in "Assigned" with "sdb"
    And I wait for the suggestion box to appear
    And I select "sdboyer" from the suggestion "Assigned"
    And I select "Is one of" from field "Issue tags"
    And I fill in "sprint 2" for "Issue tags"
    And I wait for "5" seconds
    And I press "Search" in the "content" region
    Then I should see at least "1" records

  @javascript
  Scenario: For Searching the issues with tags
    When I select "Is all of" from field "Issue tags"
    And I fill in "sprint 2, sprint 1" for "Issue tags"
    And I fill in "Assigned" with "mirzu"
    And I wait for the suggestion box to appear
    And I select "mirzu" from the suggestion "Assigned"
    And I wait for "5" seconds
    And I press "Search" in the "content" region
    Then I should see at least "1" records

  @javascript
  Scenario: For Searching the issues with tags
    When I fill in "Assigned" with "site u"
    And I wait for the suggestion box to appear
    And I select "site user" from the suggestion "Assigned"
    And I select the following <fields> with <values>
    | fields   | values     |
    | Status   | needs work |
    | Priority | normal     |
    And I wait for "5" seconds
    And I press "Search" in the "content" region
    And I follow a post
    Then I should see the submitted user "site user"