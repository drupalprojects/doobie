@user @project @sandbox 
Feature: Your Project Tab
  In order to easily manage the sandbox projects I've created
  As a project maintainer
  I should be able to find a list of sandboxes and their associated issues in a central location.

  Background:
    Given I am logged in as the "git user"
    And I am on "/node/add/project-module"
    And I create a "sandbox" project
    And I am on "project/user"

  Scenario: View the records in Sandbox Projects table
    When I click the "Create" link for the new project
    And I create a new issue
    And I visit "/project/user"
    Then I should see at least "1" record in "Project Issues" table

  Scenario: Visit View link from Issue Links column for Sandbox Project Table
    When I click the "View" link for the new project
    Then I should see the project name 

  Scenario: Visit Search link from Issue Links column for Sandbox Project Table
    When I click the "Search" link for the new project
    Then I should see the project name

  Scenario: Visit Edit link from Project Links column for Sandbox Project Table
    When I click the "Edit" link for the new project
    Then I should see the project name
