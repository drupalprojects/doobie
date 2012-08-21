Feature: Your Project Tab
  In order to easily manage the projects I've created
  As a project maintainer
  I should be able to find a list of projects and their associated issues in a central location.

  Background:
    Given I am logged in as "git vetted user"
    And I follow "Your Dashboard"
    And I follow "Your Projects"

  Scenario: Check the links and count of records on the page
    Then I should see the following <links>
    | links               |
    | Dashboard           |
    | Your Posts          |
    | Your Commits        |
    | Your Issues         |
    | Your Projects       |
    | Profile             |
    | Add a new project   |
    And I should see at least "2" records in "Projects" table
    And I should see at least "2" records in "Sandbox Projects" table
    And I should see at least "2" records in "Project Issues" table

  Scenario: Check the links in Project Table
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
    When I click "View" from "Projects" table
    Then I should see "Project Issue" page

  Scenario: Check Search link from Issue Links column for Projects
    When I click "Search" from "Projects" table
    Then I should see "Advanced Search" page

  Scenario: Check Create link from Issue Links column for Projects
    When I click "Create" from "Projects" table
    And I should see "Create Issue" page

  Scenario: Check Edit link from Project Links column for Projects
    When I click "Edit" from "Projects" table
    Then I should see "Project Edit" page

  Scenario: Check Add release link from Project Links column for Projects
    When I click "Add release" from "Projects" table
    Then I should see "Create Project Release" page

  Scenario: Check the links from Sandbox Project Table
    Then I should see the following <links> in column "Issue links" in "Sandbox Projects" table
    | links  |
    | View   |
    | Search |
    | Create |
    And I should see the following <links> in column "Project links" in "Sandbox Projects" table
    | links |
    | Edit  |

  Scenario: Check View link from Issue Links column for Sandbox Project Table
    When I click "View" from "Sandbox Projects" table
    Then I should see "Project Issue" page

  Scenario: Check Search link from Issue Links column for Sandbox Project Table
    When I click "Search" from "Sandbox Projects" table
    Then I should see "Advanced Search" page

  Scenario: Check Create link from Issue Links column for Sandbox Project Table
    When I click "Create" from "Sandbox Projects" table
    And I should see "Create Issue" page

  Scenario: Check Edit link from Project Links column for Sandbox Project Table
    When I click "Edit" from "Sandbox Projects" table
    Then I should see "Project Edit" page

  Scenario: Check Issue search    
    #the below step doesn't work for git6site
    #When I fill in "Search for" with Project Name
    When I select Project Name from "Project"
    And I press "Search" in the "content" region
    Then I should see at least "2" records in "Project Issues" table

  Scenario: Check project link from in Project Issues table
    When I click "Project" from "Project Issues" table
    Then I should see "Project Issue" page

  Scenario: Check Summary link from in Project Issues table
    When I click "Summary" from "Project Issues" table
    Then I should see "Issue" page