@user @ci @git
Feature: Verify projects and commits summary in user profile page
  In order to get a summary of the projects I have worked on
  As a git vetted user
  I should see the Projects section in my profile page


  @gitrepo @cleanup
  Scenario: Create a sandbox project and initialize repo
    Given I am logged in as the "git vetted user"
    When I visit "/node/add/project-module"
    And I create a "sandbox" project
    And I am on the Version control tab
    And I initialize the repository
    And I visit the Version control tab
    And I clone the repo
    And I push "2" commits to the repository
    And I visit "/user"
    Then I should see the project link
    And I should see "2" commits for the project

  @gitrepo @cleanup
  Scenario: Promote the sandbox project, commit and and view the commits
    Given a promoted sandbox
    And I follow "Version control"
    And I clone the repo
    And I push "2" commits to the repository
    And I visit "/user"
    Then I should see the project link
    And I should see "4" commits for the project

  @gitrepo @cleanup
  Scenario: Create a full project, commit and and view the commits
    Given I am logged in as the "git vetted user"
    And I visit "/node/add/project-module"
    And I create a "full" project
    And I follow "Version control"
    And I initialize the repository
    When I follow "Version control"
    And I clone the repo
    And I push "2" commits to the repository
    And I visit "/user"
    Then I should see the project link
    And I should see "2" commits for the project
