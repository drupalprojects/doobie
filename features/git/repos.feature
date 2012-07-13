Feature: Users want to share code 
  In order to share and improve code
  As a user
  I need to create sandboxes and projects

  Background: 
    Given I am logged in as "git user" with the password "gituser1"

@javascript
  Scenario: Git User agrees to terms of service for the first time
    Given I am at "/user"
    When I click "Edit"
    And I click "Git access"
    And I check the box "I agree to these terms" 
    And I press the "Save" button 
    And I press the "Confirm" button
    And I visit "/project/user"
    And I click "Add a new project"
    And I select the radio button "Modules" with the id "edit-project-type-14"
    And for "Maintenance status" I enter "13028"
    And for "Development status" I enter "9988"
    And I create a project
    And for "Description" I enter "test"
    And I press the "Save" button
    Then I should see the project

  Scenario: Git User has agreed to terms of service
    When I visit "/project/user"
    Then I should see the link "Add a new project"

  Scenario: Git User creates a project
    Given I am at "/node/add/project-project"
    And I fill in the following: 
    | Project title     |Pink Ponies              |
    | Description       |BDD test project         |
    | Maintenance status|Minimally maintained     |
    | Development status|Under active development |
    And I press the "Save" button
    Then I should see the project title


