Feature: Verify projects and commits summary in user profile page
  In order to get a summary of the projects I have worked on
  As a git vetted user
  I should see the Projects section in my profile page

  Background:
    Given I am logged in as "git vetted user"

  @gitrepo
  Scenario: Create a sandbox project and initialize repo
    When I visit "/node/add/project-project"
    And I create a "module"
    And I see the project title
    And I am on the Version control tab
    And I initialize the repository
    And I follow "Version control"
    Then I should see "Setting up repository for the first time"

  @gitrepo @dependent
  Scenario: Commit to the above sandbox project and verify the same
    When I visit the Version control tab
    And I clone the repo
    And I push "2" commits to the repository
    And I visit "/user"
    Then I should see the project link
    And I should see "2" commits for the project

  @gitrepo @dependent
  Scenario: Promote the sandbox project, commit and verify
    When I visit the project page
    And I promote the project
    And I follow "Version control"
    And I clone the repo
    And I push "2" commits to the repository
    And I visit "/user"
    Then I should see the project link
    And I should see "4" commits for the project

  @gitrepo
  Scenario: Create a full project, commit and verify
    When I visit "/node/add/project-project"
    And I create a full project
    And I follow "Version control"
    And I initialize the repository
    And I follow "Version control"
    And I push "2" commits to the repository
    And I visit "/user"
    Then I should see the project link
    And I should see "2" commits for the project