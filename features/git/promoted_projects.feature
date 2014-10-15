@project
Feature: Ensure that sandbox repository is not available once the project is promoted
  In order to maintain a single canonical repository for a project with a memorable namespace
  As a project owner
  I should be able to promote sandbox project and it should not be available at its previous sandbox URL

  @failing
  Scenario: Create a Sandbox project as git vetted user and promote
    Given users:
      | name            | pass     | mail                                | roles           |
      | Git Vetted User | password | qa+gitvetted@association.drupal.org | Git vetted user |
    And I am logged in as "Git Vetted User"
    And I am on "/node/add/project-module"
    When I create a "sandbox" project
    And I promote the project
    Then I should see project data
    And I follow "Edit"
    And I should see "Releases"
    And I should see that the project short name is readonly

  @wip @failing
  Scenario: Initialize the repository as project owner
    Given users:
      | name            | pass     | mail                                | roles           |
      | Git Vetted User | password | qa+gitvetted@association.drupal.org | Git vetted user |
    And I am logged in as "Git Vetted User"
    And I am on "/node/add/project-module"
    When I create a "sandbox" project
    And I promote the project
    And I follow "Version control"
    When I initialize the repository
    Then I should have a local copy of the project

  @dependent @wip @failing
  Scenario: Clone the repository as anonymous user
    Given I visit the recent sandbox
    And I follow "Version control"
    When I clone the repo
    Then I should have a local copy of the project

  @dependent @wip @failing
  Scenario: Clone the sandbox repository as project owner
    Given users:
      | name            | pass     | mail                                | roles           |
      | Git Vetted User | password | qa+gitvetted@association.drupal.org | Git vetted user |
    And I am logged in as "Git Vetted User"
    When I clone the "promoted sandbox" repo
    Then I should see an error

  @clean_data @wip @failing
  Scenario: Clone the sandbox repository as anonymous user
    Given I am not logged in
    When I clone the "promoted sandbox" repo
    Then I should see an error
