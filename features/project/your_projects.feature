@project @user
Feature: Your Project Tab
  In order to easily manage the projects I've created
  As a project maintainer
  I should be able to find a list of projects and their associated issues in a central location.

  Background:
    Given I am logged in as the "git vetted user"
    And I am on "/node/add/project-theme"
    And I create a "full" project
    And I am on "project/user"

  Scenario: See issues on in the project table
    Given a new "sandbox" "Module project" issue
    When I visit "/project/user"
    Then I should see the random "issue title" text 

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

  Scenario: Visit link from Issue Links column for Projects
    When I click the "View" link for the new project
    Then I should see the project name
 
  Scenario: Visit Search link from Issue Links column for Projects
    When I click the "Search" link for the new project
    Then I should see the project name

  @wip
  Scenario: Visit Create link from Issue Links column for Projects
    When I click the "Create" link for the new project
    Then I should see the project name

  Scenario: Visit Edit link from Project Links column for Projects
    When I click the "Edit" link for the new project
    Then I should see the project name

  @wip
  Scenario: Visit Add release link from Project Links column for Projects
    When I click the "Add release" link for the new project
    Then I should see the project name

  @javascript @slow @wip
  Scenario: Search for issue
    And I visit "/cron.php"
    And I visit "/project/user"
    When I fill in "Search for" with issue name
    And I select project name from "Project"
    And I press "Search" in the "content" region
    Then I should see at least "1" record in "Project Issues" table

  @wip
  Scenario: Visit project link from in Project Issues table
    When I click the "Project" link for the new project
    Then I should see the project name

  @wip
  Scenario: Visit Summary link from in Project Issues table
    When I click the "Summary" link for the new project
    Then I should see the project name

  @wip
  Scenario: Visit the feed link and view the contents
    When I click on the feed icon
    Then I should see at least "1" feed item
    And I should see the issue in the feed
