@project @maintainers @wip
Feature: 'Administer maintainers' permission check
  In order to get help maintaining my project
  As a project owner
  I need to be able to add people to my project with appropriate permissions

  @known_git7failure
  Scenario: Create a new project
    Given I am logged in as "git vetted user"
    And I am at "/node/add/project-distribution"
    When I create a "sandbox" project
    Then I should see project data

  @dependent
  Scenario: Add a maintainer: Valid maintainer name
    Given I am logged in as "git vetted user"
    And I am on the Maintainers tab
    When I enter "git user" for field "Maintainer user name"
    And I press "Update"
    Then I should see "added and permissions updated"

  @dependent
  Scenario: Assign Administer maintainers permission to a maintainer
    Given I am logged in as "git vetted user"
    And I am on the Maintainers tab
    When I assign "Administer maintainers" to the maintainer "git user"
    And I press "Update"
    Then I should see "Maintainer permissions updated"

  @dependent
  Scenario: Log in as maintainer and see that if you can add a maintainer
    Given I am logged in as "git user"
    And I am on the Maintainers tab
    When I enter "site user" for field "Maintainer user name"
    And I press "Update"
    Then I should see "added and permissions updated"

  @dependent
  Scenario: Unassign Administer maintainers permission from a maintainer
    Given I am logged in as "git vetted user"
    And I am on the Maintainers tab
    When I unassign "Administer maintainers" from the maintainer "git user"
    And I press "Update"
    Then I should see "Maintainer permissions updated"

  @dependent @clean_data
  Scenario: Log in as maintainer and see that maintainers tab is accessible
    Given I am logged in as "git user"
    When I am on the Maintainers tab
    Then I should not see the link "Maintainers"
