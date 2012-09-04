Feature: Ensure that sandbox repository is not available once the project is promoted
  In order to restrict using sandbox repository once it is promoted
  As a project owner
  I should be able to promote sandbox project and make sure it is not available

  Scenario: Create a Sandbox project as git vetted user and promote
    Given I am logged in as "git vetted user"
    And I am on "/node/add/project-project"
    When I create a "theme"
    And I promote the project
    Then I should see the project title

  Scenario: Initialize the repository as project owner
    Given I am logged in as "git vetted user"
    And I am on the Version control tab
    When I initialize the repository
    Then I should have a local copy of the project

  Scenario: Clone the repository as anonymous user
    Given I am on the Version control tab
    When I clone the repo
    Then I should have a local copy of the project

  Scenario: Clone the sandbox repository as project owner
    Given I am logged in as "git vetted user"
    Then I should not be able to clone the sandbox repo

  Scenario: Clone the sandbox repository as anonymous user
    Given I am on the homepage
    Then I should not be able to clone the sandbox repo
