@project @user
Feature: Your Project Tab
  In order to easily manage the projects I've created
  As a project maintainer
  I should be able to find a list of projects and their associated issues in a central location.

  Background:
    Given I am logged in as the "git vetted user"

  Scenario: Access navigation for a new project
    When I am on "/project/user"
    Then I should see "Add a new project"

  Scenario: See issues on in the project table
    Given a new "sandbox" "Module project" issue
    When I visit "/project/user"
    Then I should see the random "issue title" text 

  @dependent
  Scenario: View the links and count of records on the page
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
    And I should see at least "1" record in "Project Issues" table

  @dependent
  Scenario: View the links in Project Table
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

  @dependent
  Scenario: Visit link from Issue Links column for Projects
    And I am on "/project/user"
    When I click the "View" link in the "Full projects" table
    Then I should see "Project Issue" page

  @dependent
  Scenario: Visit Search link from Issue Links column for Projects
    And I am on "/project/user"
    When I click the "Search" link in the "Full projects" table
    Then I should see "Advanced Search" page

  @dependent
  Scenario: Visit Create link from Issue Links column for Projects
    And I am on "/project/user"
    When I click the "Create" link in the "Full projects" table
    And I should see "Create Issue" page

  @dependent
  Scenario: Visit Edit link from Project Links column for Projects
    And I am on "/project/user"
    When I click the "Edit" link in the "Full projects" table
    Then I should see "Project Edit" page

  @wip @dependent
  Scenario: Visit Add release link from Project Links column for Projects
    And I am on "/project/user"
    When I click the "Add release" link in the "Full projects" table
    Then I should see "Create Project Release" page

  @javascript @slow @dependent
  Scenario: Search for issue
    And I visit "/cron.php"
    And I visit "/project/user"
    When I fill in "Search for" with issue name
    And I select project name from "Project"
    And I press "Search" in the "content" region
    Then I should see at least "1" record in "Project Issues" table

  @dependent
  Scenario: Visit project link from in Project Issues table
    And I am on "/project/user"
    When I click the "Project" link in the "Full projects" table
    Then I should see "Project Issue" page

  @dependent
  Scenario: Visit Summary link from in Project Issues table
    And I am on "/project/user"
    When I click "Summary" from "Project Issues" table
    Then I should see "Issue" page

  @clean_data @dependent
  Scenario: Visit the feed link and view the contents
    And I am on "/project/user"
    When I click on the feed icon
    Then I should see at least "1" feed item
    And I should see the issue in the feed
