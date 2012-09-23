Feature: Your Project Tab
  In order to easily manage the sandbox projects I've created
  As a project maintainer
  I should be able to find a list of sandboxes and their associated issues in a central location.

  Background:
    Given I am logged in as "git user"

  Scenario: Create test data: Sandbox project
    And I am on "/node/add/project-project"
    When I create a sandbox project 
    Then I should see the project title

  @dependent
  Scenario: Create test data: Sandbox project issue
    And I am on "/project/user"
    When I click "Create" from "Sandbox Projects" table
    And I create a new issue
    Then I should see the issue title

  @dependent
  Scenario: Check the links and count of records on the page
    And I am on "/project/user"
    And I should see at least "1" record in "Sandbox Projects" table

  Scenario: Check the links from Sandbox Project Table
    And I am on "/project/user"
    Then I should see the following <links> in column "Issue links" in "Sandbox Projects" table
    | links  |
    | View   |
    | Search |
    | Create |
    And I should see the following <links> in column "Project links" in "Sandbox Projects" table
    | links |
    | Edit  |

  Scenario: Check View link from Issue Links column for Sandbox Project Table
    And I am on "/project/user"
    When I click "View" from "Sandbox Projects" table
    Then I should see "Project Issue" page

  Scenario: Check Search link from Issue Links column for Sandbox Project Table
    And I am on "/project/user"
    When I click "Search" from "Sandbox Projects" table
    Then I should see "Advanced Search" page

  Scenario: Check Create link from Issue Links column for Sandbox Project Table
    And I am on "/project/user"
    When I click "Create" from "Sandbox Projects" table
    Then I should see "Create Issue" page

  Scenario: Check Edit link from Project Links column for Sandbox Project Table
    And I am on "/project/user"
    When I click "Edit" from "Sandbox Projects" table
    Then I should see "Project Edit" page
