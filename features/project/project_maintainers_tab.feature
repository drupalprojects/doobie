@maintainers
Feature: Add additional maintainers with appropriate permissions
  In order to get help maintaining my project
  As a project owner
  I need to be able to add people to my project with appropriate permissions

  Background:
    Given I am logged in as "git vetted user"

  Scenario: Create a new project
    Given I am at "/node/add/project-project"
    When I create a "module"
    Then I should see project data

  Scenario: View texts and links on maintainers tab
    When I am on the Maintainers tab
    Then I should see the following <texts>
    | texts                  |
    | User                   |
    | Write to VCS           |
    | Edit project           |
    | Administer maintainers |
    | Maintain issues        |
    | Operations             |
    | locked                 |
    And I should see the following <links>
    | links           |
    | View            |
    | Version control |
    | Edit            |
    | Maintainers     |
    | git vetted user |

  Scenario: Add a maintainer: Invalid maintainer name
    Given I am on the Maintainers tab
    When I enter "git user test user name" for field "Maintainer user name"
    And I press "Update"
    Then I should see "is not a valid user on this site"

  Scenario: Add a maintainer: Valid maintainer name
    Given I am on the Maintainers tab
    When I enter "git user" for field "Maintainer user name"
    And I press "Update"
    Then I should see "New maintainer"
    And I should see "added and permissions updated"
    And I should see the link "git user"

  Scenario: Add a maintainer: Existing maintainer name
    Given I am on the Maintainers tab
    When I enter "git user" for field "Maintainer user name"
    And I press "Update"
    Then I should see "is already a maintainer of this project"

  Scenario: Delete a maintainer
    Given I am on the Maintainers tab
    When I follow "delete" for the maintainer "git user"
    And I press "Delete"
    Then I should see "Removed"
    And I should see "as a maintainer"

  Scenario: Add a maintainer: Valid maintainer name
    Given I am on the Maintainers tab
    When I enter "git user" for field "Maintainer user name"
    And I press "Update"
    Then I should see "New maintainer"
    And I should see "added and permissions updated"
    And I should see the link "git user"

  Scenario: Assign permissions to a maintainer
    Given I am on the Maintainers tab
    When I assign the following <permissions> to the maintainer "git user"
    | permissions     |
    | Write to VCS    |
    | Edit project    |
    | Maintain issues |
    And I assign "Administer maintainers" to the maintainer "git user"
    And I press "Update"
    Then I should see "Maintainer permissions updated"

  Scenario: Remove permissions from a maintainer
    Given I am on the Maintainers tab
    When I unassign the following <permissions> from the maintainer "git user"
    | permissions     |
    | Write to VCS    |
    | Maintain issues |
    | Edit project    |
    And I unassign "Administer maintainers" from the maintainer "git user"
    And I press "Update"
    Then I should see "Maintainer permissions updated"

  Scenario: Create a new issue is available for owner
    Given I am on the Maintainers tab
    When I follow "total"
    Then I should see the link "Create a new issue"
    And I should not see "Login or register to create an issue"
