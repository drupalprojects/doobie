@ci
Feature: Verify git access
  In order to push code to the repository
  As an authenticated user
  I should agree to the git access agreement

  Background:
    Given I am logged in as "git vetted user"

  @gitrepo
  Scenario: Create a sandbox project and initialize repo
    When I visit "/node/add/project-project"
    And I create a "module"
    And I see project data
    And I follow "Version control"
    Then I initialize the repository

  Scenario: Disagree to git access agreement
    When I follow "Edit"
    And I click "Git access"
    And I uncheck the box "I agree to these terms"
    And I press "Update Git access agreement"
    Then I should see the text "You will not be able to use Git"

  @gitrepo @dependent @clean_data
  Scenario: Clone repo and push to repo as non-git user
    When I am on the project page
    And I follow "Version control"
    And I clone the repo
    Then I should not be able to push a commit to the repository

  @dependent
  Scenario: Agree git access agreement - Reset to original
    When I follow "Edit"
    And I click "Git access"
    And I check the box "I agree to these terms"
    And I press "Save"
    Then I should not see the text "You will not be able to use Git"
    And I should see the text "Git user configuration"