@project @maintainers 
Feature: 'Administer releases' permission check
  In order to get help maintaining my project releases
  As a project owner
  I need to be able to add people to my project with appropriate permissions

  Scenario: Create a new project
    Given I am logged in as the "git vetted user"
    And I am at "/node/add/project-distribution"
    When I create a "full" project with releases
    Then I should see project data

  @dependent
  Scenario: Add a maintainer: Valid maintainer name
    Given I am logged in as the "git vetted user"
    And I am on the Maintainers tab
    When I enter "git user" for field "Maintainer user name"
    And I press "Update"
    Then I should see "added and permissions updated"

  @dependent
  Scenario: Assign Administer releases permission to a maintainer
    Given I am logged in as the "git vetted user"
    And I am on the Maintainers tab
    When I assign "Administer releases" to the maintainer "git user"
    And I press "Update"
    Then I should see "Maintainer permissions updated"

  @dependent
  Scenario: Log in as maintainer and view add new release link
    Given I am logged in as the "git user"
    When I am on the project page
    And I follow "Add new release"
    Then I should see "No valid branches or tags found"

  @dependent
  Scenario: Unassign Administer releases permission from a maintainer
    Given I am logged in as the "git vetted user"
    And I am on the Maintainers tab
    When I unassign "Administer releases" from the maintainer "git user"
    And I press "Update"
    Then I should see "Maintainer permissions updated"

  @dependent @clean_data
  Scenario: Log in as maintainer and see that add new release link is accessible
    Given I am logged in as the "git user"
    When I am on the project page
    Then I should not see the link "Add new release"
    And I should not see the link "Administer releases"
