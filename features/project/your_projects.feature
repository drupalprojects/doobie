Feature: Your Project Tab
  In order to easily manage the projects I've created
  As a project maintainer
  I should be able to find a list of projects and their associated issues in a central location.

  Background:
    Given I am logged in as "git vetted user"

  Scenario: Create test data: Sandbox project
    And I am on "/node/add/project-project"
    When I create a "theme"
    Then I should see the project title

  Scenario: Create test data: Full project
    And I am on "/node/add/project-project"
    When I create a full project
    Then I should see the project title

  Scenario: Create test data: Project issue
    And I am on "/project/user"
    When I click "Create" from "Projects" table
    And I create a new issue
    Then I should see the issue title

  @wip
  Scenario: Check the links and count of records on the page
    And I am on "/project/user"
    Then I should see the following <links>
    | links               |
    | Dashboard           |
    | Your Posts          |
    | Your Commits        |
    | Your Issues         |
    | Your Projects       |
    | Profile             |
    | Add a new project   |
    And I should see at least "1" record in "Projects" table
    And I should see at least "1" record in "Sandbox Projects" table
    And I should see at least "1" record in "Project Issues" table

  @wip
  Scenario: Check the links in Project Table
    And I am on "/project/user"
    Then I should see the following <links> in column "Issue links" in "Projects" table
    | links   |
    | View    |
    | Search  |
    | Create  |
    And I should see the following <links> in column "Project links" in "Projects" table
    | links       |
    | Edit        |
    | Add release |

  Scenario: Check View link from Issue Links column for Projects
    And I am on "/project/user"
    When I click "View" from "Projects" table
    Then I should see "Project Issue" page

  Scenario: Check Search link from Issue Links column for Projects
    And I am on "/project/user"
    When I click "Search" from "Projects" table
    Then I should see "Advanced Search" page

  Scenario: Check Create link from Issue Links column for Projects
    And I am on "/project/user"
    When I click "Create" from "Projects" table
    And I should see "Create Issue" page

  Scenario: Check Edit link from Project Links column for Projects
    And I am on "/project/user"
    When I click "Edit" from "Projects" table
    Then I should see "Project Edit" page

  @wip
  Scenario: Check Add release link from Project Links column for Projects
    And I am on "/project/user"
    When I click "Add release" from "Projects" table
    Then I should see "Create Project Release" page

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

  @wip
  Scenario: Check Issue search
    And I am on "/project/user"
    When I fill in "Search for" with Project Name
    And I select Project Name from "Project"
    And I press "Search" in the "content" region
    Then I should see at least "1" record in "Project Issues" table

  Scenario: Check project link from in Project Issues table
    And I am on "/project/user"
    When I click "Project" from "Project Issues" table
    Then I should see "Project Issue" page

  Scenario: Check Summary link from in Project Issues table
    And I am on "/project/user"
    When I click "Summary" from "Project Issues" table
    Then I should see "Issue" page

  Scenario: Check the feed icon
    And I am on "/project/user"
    When I click on the feed icon
    Then I should see at least "1" feed item
    And I should see the issue in the feed
