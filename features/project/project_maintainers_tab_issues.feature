Feature: 'Maintain issues' permission check
  In order to get help maintaining my project issues
  As a project owner
  I need to be able to add people to my project with appropriate permissions

  Scenario: Create a new project and an issue
    Given I am logged in as "git vetted user"
    And I am at "/node/add/project-project"
    When I create a "module"
    Then I should see the project title
    And I follow "open"
    And I follow "Create a new issue"
    And I create a new issue

  Scenario: Add a maintainer: Valid maintainer name
    Given I am logged in as "git vetted user"
    And I am on the Maintainers tab
    When I enter "git user" for field "Maintainer user name"
    And I press "Update"
    Then I should see "added and permissions updated"

  Scenario: Assign Maintain issues permission to a maintainer
    Given I am logged in as "git vetted user"
    And I am on the Maintainers tab
    When I assign "Maintain issues" to the maintainer "git user"
    And I press "Update"
    Then I should see "Maintainer permissions updated"

  Scenario: Login as maintainer and check if you can assign an issue to maintainer
    Given I am logged in as "git user"
    And I am on the project page
    And I follow "open"
    And I follow an issue of the project
    Then I should see "git vetted user" in the dropdown "Assigned:"

  Scenario: Unassign Maintain issues permission from a maintainer
    Given I am logged in as "git vetted user"
    And I am on the Maintainers tab
    When I unassign "Maintain issues" from the maintainer "git user"
    And I press "Update"
    Then I should see "Maintainer permissions updated"

  Scenario: Login as maintainer and check if you can assign an issue to maintainer
    Given I am logged in as "git user"
    And I am on the project page
    And I follow "open"
    And I follow an issue of the project
    Then I should not see "git vetted user" in the dropdown "Assigned:"