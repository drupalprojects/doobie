Feature: Ensure that sandbox repository is not available once the project is promoted
  In order to maintain a single canonical repository for a project with a memorable namespace
  As a project owner
  I should be able to promote sandbox project and it should not be available at its previous sandbox URL

  Scenario: Create a Sandbox project as git vetted user and promote
    Given I am logged in as "git vetted user"
    And I am on "/node/add/project-project"
    When I create a "theme"
    And I promote the project
    Then I should see the project title

  Scenario: Check Releases tab is available and project short name is readonly
    Given I am logged in as "git vetted user"
    And I am on the project page
    When I follow "Edit"
    Then I should see the link "Releases"
    And I should see that the project short name is readonly

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
    When I clone the sandbox repo
    Then I should see an error

  @clean_data
  Scenario: Clone the sandbox repository as anonymous user
    Given I am not logged in
    When I clone the sandbox repo
    Then I should see an error