@project @maintainers @wip
Feature: Add additional maintainers with appropriate permissions
  In order to get help maintaining my project
  As a project owner
  I need to be able to add people to my project with appropriate permissions

  Background:
    Given I am logged in as "git vetted user"

  @known_git7failure
  Scenario: Create a new project
    And I am at "/node/add/project-distribution"
    When I create a "sandbox" project
    Then I should see project data 

  @dependent @known_git7failure
  Scenario: Verify it is the maintainers tab
    When I am on the Maintainers tab
    Then I should see the heading "Development"
    And I should see the following <texts>
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

  @dependent
  Scenario: Add a maintainer: Invalid maintainer name
    Given I am on the Maintainers tab
    When I enter "git user test user name" for field "Maintainer user name"
    And I press "Update"
    Then I should see "is not a valid user on this site"

  @dependent
  Scenario: Add a maintainer: Valid maintainer name
    Given I am on the Maintainers tab
    When I enter "git user" for field "Maintainer user name"
    And I press "Update"
    Then I should see "New maintainer"
    And I should see "added and permissions updated"
    And I should see the link "git user"

  @dependent
  Scenario: Add a maintainer: Existing maintainer name
    Given I am on the Maintainers tab
    When I enter "git user" for field "Maintainer user name"
    And I press "Update"
    Then I should see "is already a maintainer of this project"

  @dependent
  Scenario: Delete a maintainer
    Given I am on the Maintainers tab
    When I follow "delete" for the maintainer "git user"
    And I press "Delete"
    Then I should see "Removed"
    And I should see "as a maintainer"

  @dependent
  Scenario: Add a maintainer: Valid maintainer name
    Given I am on the Maintainers tab
    When I enter "git user" for field "Maintainer user name"
    And I press "Update"
    Then I should see "New maintainer"
    And I should see "added and permissions updated"
    And I should see the link "git user"

  @dependent @known_git7failure
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

  @dependent @known_git7failure
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

  @dependent @known_git7failure @clean_data
  Scenario: Check if owner can create an issue
    Given I am on the Maintainers tab
    When I follow "total"
    Then I should see the link "Create a new issue"
    And I should not see "Login or register to create an issue"
