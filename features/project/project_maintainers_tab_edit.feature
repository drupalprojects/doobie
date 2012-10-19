@project @maintainers
Feature: 'Edit project' permission check
  In order to provide information about a project
  As a project maintainer
  I should be able to edit the project

  Scenario: Create a new project
    Given I am logged in as "git vetted user"
    And I am at "/node/add/project-project"
    When I create a "module"
    Then I should see project data

  Scenario: Add a maintainer: Valid maintainer name
    Given I am logged in as "git vetted user"
    And I am on the Maintainers tab
    When I enter "git user" for field "Maintainer user name"
    And I press "Update"
    Then I should see "added and permissions updated"

  Scenario: Assign Edit project permission to a maintainer
    Given I am logged in as "git vetted user"
    And I am on the Maintainers tab
    When I assign "Edit project" to the maintainer "git user"
    And I press "Update"
    Then I should see "Maintainer permissions updated"

  Scenario: Log in as maintainer and edit the project
    Given I am logged in as "git user"
    And I am on the project page
    And I follow "Edit"
    And I press "Save"
    Then I should see "has been updated"

  Scenario: Unassign Edit project permission from a maintainer
    Given I am logged in as "git vetted user"
    And I am on the Maintainers tab
    When I unassign "Edit project" from the maintainer "git user"
    And I press "Update"
    Then I should see "Maintainer permissions updated"

  Scenario: Log in as maintainer and look for edit link
    Given I am logged in as "git user"
    And I am on the project page
    Then I should not see the link "Edit"
