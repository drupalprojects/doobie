@project @maintainers @wip
Feature: 'Edit project' permission check
  In order to provide information about a project
  As a project maintainer
  I should be able to edit the project

  @known_git7failure
  Scenario: Create a new project
    Given I am logged in as "git vetted user"
    And I am at "/node/add/project-core"
    When I create a "sandbox" project
    Then I should see the project title

  @depenent
  Scenario: Add a maintainer: Valid maintainer name
    Given I am logged in as "git vetted user"
    And I am on the Maintainers tab
    When I enter "git user" for field "Maintainer user name"
    And I press "Update"
    Then I should see "added and permissions updated"

  @depenent
  Scenario: Assign Edit project permission to a maintainer
    Given I am logged in as "git vetted user"
    And I am on the Maintainers tab
    When I assign "Edit project" to the maintainer "git user"
    And I press "Update"
    Then I should see "Maintainer permissions updated"

  @depenent
  Scenario: Login as maintainer and check if you can edit the project
    Given I am logged in as "git user"
    And I am on the project page
    And I follow "Edit"
    And I press "Save"
    Then I should see "has been updated"

  @depenent
  Scenario: Unassign Edit project permission from a maintainer
    Given I am logged in as "git vetted user"
    And I am on the Maintainers tab
    When I unassign "Edit project" from the maintainer "git user"
    And I press "Update"
    Then I should see "Maintainer permissions updated"

  @depenent
  Scenario: Login as maintainer and check if you can edit the project
    Given I am logged in as "git user"
    And I am on the project page
    Then I should not see the link "Edit"
