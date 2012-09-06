Feature: Verify projects and commits summary in user profile page
  In order to get a summary of the projects I have worked on
  As a git vetted user
  I should see the Projects section in my profile page

  Background:
    Given I am logged in as "git vetted user"

  Scenario: View the Projects section
    Then I should see the heading "Projects"
    And I should see "Total:"
    And I should see "commits)"
    And I should see the link "SSH keys"

  @gitrepo
  Scenario: Create a sandbox project and initialize repo
    When I am at "/node/add/project-project"
    And I create a "module"
    And I see the project title
    And I am on the Version control tab
    Then I initialize the repository

  @gitrepo
  Scenario: Commit to the above sandbox project
    When I am on the Version control tab
    And I clone the repo
    Then I should be able to push a commit to the repository
    And I should be able to push one more commit to the repository

  Scenario: Verfiy that the above commit is displayed
    Then I should see the project link
    And I should see "2" commits for the project

  @gitrepo
  Scenario: Promote the sandbox project and commit
    When I am on the project page
    And I promote the project
    And I follow "Version control"
    And I clone the repo
    Then I should be able to push a commit to the repository
    And I should be able to push one more commit to the repository

  Scenario: Verfiy that the above commit is displayed
    Then I should see the project link
    And I should see "4" commits for the project

  @gitrepo
  Scenario: Create a full project and commit
    When I am on "/node/add/project-project"
    And I create a full project
    And I follow "Version control"
    And I initialize the repository
    And I follow "Version control"
    Then I should be able to push a commit to the repository

  Scenario: Verfiy that the above commit is displayed
    Then I should see the project link
    And I should see "1" commit for the project
