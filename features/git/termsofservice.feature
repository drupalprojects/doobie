Feature: Users must agree to the terms of service to commit code
  In order to prove that I am aware of the terms of service
  As a user
  I need to agree to the terms of service before I can commit code

  Background: 
 Given I am logged in as a user with the "authenticated user" role

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
    Then I should see the text "Pink Ponies"

  Scenario: Git User no longer agrees to terms of service
    Given I am at "/user"
    When I click "Edit" 
     And I click "Git access" 
     And I uncheck the box "I agree to these terms"
     And I press the "Update Git access agreement" button
    Then I should see the text "You will not be able to use Git"

  Scenario: Git User, having disagreed, tries to edit an existing project
    When I visit "/project/user"
    Then I should see the link "View"
      And I should not see the link "Edit"
   
  Scenario: Git User decides to agree again
    Given I am at "/user"
    When I click "Edit"
      And I click "Git access"
      And I check the box "I agree to these terms"
      And I press the "Save" button
    Then I should not see the text "You will not be able to use Git"
      And I should see the text "Git user configuration"
