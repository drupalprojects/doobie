@project 
Feature: Ensure that sandbox repository is not available once the project is promoted
  In order to maintain a single canonical repository for a project with a memorable namespace
  As a project owner
  I should be able to promote sandbox project and it should not be available at its previous sandbox URL

  Scenario: Promote a sandbox project to full project
    Given I am logged in as the "git vetted user"
    And I am on "/node/add/project-module"
    When I create and promote a sandbox project
    Then I should see the new short name in the URL
    And I should see a new Git clone URL
    And I should not be able to edit the project short name


  Scenario Outline: Sandbox clone URL should not allow cloning
    Given a promoted sandbox
    And that I am logged in as "<user>"
    Then I should be able to use the Version control instructions to clone the repository
    And I should not be able to clone the respository at the original sandbox URL

    Examples:
    | user            |
    | anonymous       |
    | site user       |
    | git vetted user |
  
