Feature: Users promote a sandbox project to a full project
  In order to release code to the public
  As a git vetted user
  I need to promote a project

  Background:
    Given I am logged in as "git vetted user"

  Scenario: Git user creates and promotes a sandbox project to a full project
    Given I am at "/node/add/project"
    When I create a "module"
    And I see the project title
    And I follow "Promote to full project"
    And I check "I understand that this action cannot be undone and wish to proceed anyway"
    And I fill in "Short project name" with random text
    And I check "Enable releases"
    And I press "Promote to full project"
    And I see "Are you sure"
    And I press "Promote"
    And I see "has been promoted to a full project"
    And I follow "Edit"
    Then "edit-project-uri-wrapper" should not contain an input element
