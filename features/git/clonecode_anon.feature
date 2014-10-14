@git @anon
Feature: Visitor clones repositories
  In order to try out experimental code
  As a visitor to Drupal.org
  I want to clone a sandbox repo

  @failing
 Scenario: Sandbox has a repo with code
    Given I am at "/project/git_deploy"
    When I click "Version control"
    And I clone the repo
    Then I should have a local copy of "git_deploy"

  Scenario: Sandbox has a repo with no code
    Given I am at "/project/git_dev"
    When I click "Version control"
    Then I should see the heading "Empty Repository"
    And I should see the heading "Git on Drupal.org"
