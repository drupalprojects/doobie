Feature: Your Project Tab
  In order to easily manage the sandbox projects I've created
  As a project maintainer
  I should be able to find a list of sandboxes and their associated issues in a central location.

  Background:
    Given I am logged in as "git user"

  Scenario: Create test data: Sandbox project
    And I am on "/node/add/project"
    When I create a sandbox project
    Then I should see project data

  @dependent
  Scenario: Create test data: Sandbox project issue
    And I am on "/project/user"
    When I click "Create" from "Sandbox Projects" table
    And I create a new issue
    Then I should see the issue title

  @dependent
  Scenario: View the records in Sandbox Projects table
    And I am on "/project/user"
    Then I should see at least "1" record in "Sandbox Projects" table

  Scenario: View the links in Sandbox Project Table
    And I am on "/project/user"
    Then I should see the following <links> in column "Issue links" in "Sandbox Projects" table
    | links  |
    | View   |
    | Search |
    | Create |
    And I should see the following <links> in column "Project links" in "Sandbox Projects" table
    | links |
    | Edit  |

  Scenario: Visit View link from Issue Links column for Sandbox Project Table
    And I am on "/project/user"
    When I click "View" from "Sandbox Projects" table
    Then I should see "Project Issue" page

  Scenario: Visit Search link from Issue Links column for Sandbox Project Table
    And I am on "/project/user"
    When I click "Search" from "Sandbox Projects" table
    Then I should see "Advanced Search" page

  Scenario: Visit Create link from Issue Links column for Sandbox Project Table
    And I am on "/project/user"
    When I click "Create" from "Sandbox Projects" table
    Then I should see "Create Issue" page

  Scenario: Visit Edit link from Project Links column for Sandbox Project Table
    And I am on "/project/user"
    When I click "Edit" from "Sandbox Projects" table
    Then I should see "Project Edit" page
