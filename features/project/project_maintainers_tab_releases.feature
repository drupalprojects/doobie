Feature: 'Administer releases' permission check
  In order to get help maintaining my project releases
  As a project owner
  I need to be able to add people to my project with appropriate permissions

  Scenario: Create a new project
    Given I am logged in as "git vetted user"
    And I am at "/node/add/project-project"
    When I create a full project
    Then I should see the project title

  Scenario: Add a maintainer: Valid maintainer name
    Given I am logged in as "git vetted user"
    And I am on the Maintainers tab
    When I enter "git user" for field "Maintainer user name"
    And I press "Update"
    Then I should see "added and permissions updated"

  Scenario: Assign Administer releases permission to a maintainer
    Given I am logged in as "git vetted user"
    And I am on the Maintainers tab
    When I assign "Administer releases" to the maintainer "git user"
    And I press "Update"
    Then I should see "Maintainer permissions updated"

  Scenario: Login as maintainer and check if you can see the add new release link
    Given I am logged in as "git user"
    When I am on the project page
    And I follow "Administer releases"
    Then I should see "Supported versions"
    And I should see "For each term in the Core compatibility vocabulary"

  Scenario: Unassign Administer releases permission from a maintainer
    Given I am logged in as "git vetted user"
    And I am on the Maintainers tab
    When I unassign "Administer releases" from the maintainer "git user"
    And I press "Update"
    Then I should see "Maintainer permissions updated"

  Scenario: Login as maintainer and check if you have access to add new release link
    Given I am logged in as "git user"
    When I am on the project page
    Then I should not see the link "Add new release"
    And I should not see the link "Administer releases"