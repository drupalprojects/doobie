@javascript
Feature: Search
  In order to find information related to a need I have
  As any user
  I need to be able to search the title and body of issues

  Scenario: Searching for a project using autocompletion
   Given I am on "/project/issues"
    When I fill in "projects" with "Bluemarine"
    And I wait for the suggestion box to appear
    Then I should see "Bluemarine"
    And I should see "Bluemarine_smarty"
    And I should see "Bluemarine ETS"
    And I should see "Bluemarine Twig"
    And I should not see "Bluefreedom"

  @wip
  Scenario:Searching for a listed Entries
   Given I am on "/project/issues"
    When I fill in "projects" with "Userdashboard"
    And  I wait for the suggestion box to appear
    And I fill in "Project" with "UserDashboard"
    And I press "Search" to filter
    Then I should see the link "UserDashboard"
