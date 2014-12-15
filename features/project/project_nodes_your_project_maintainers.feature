@project
Feature: Maintain the project
  In order to maintain the project
  As a project maintainer
  I should be able to commit to the repository and the edit project

  @failing
  Scenario: Add git vetted user as maintainer
    Given users:
      | name                | pass     | mail                                    | roles         |
      | Administrative User | password | qa+administrator@association.drupal.org | administrator |
    And I am logged in as "Administrative User"
    And I am on "/project/test_releases"
    When I follow "Maintainers"
    And I enter "git vetted user" for field "Maintainer user name"
    And I press "Update"
    Then I should see the link "git vetted user"

  @failing
  Scenario: Add Trusted User as another maintainer
    Given users:
      | name                | pass     | mail                                    | roles         |
      | Administrative User | password | qa+administrator@association.drupal.org | administrator |
    And I am logged in as "Administrative User"
    And I am on "/project/test_releases"
    When I follow "Maintainers"
    And I enter "Trusted User" for field "Maintainer user name"
    And I press "Update"
    Then I should see the link "Trusted User"

  @dependent @failing
  Scenario: Assign permissions to above users
    Given users:
      | name                | pass     | mail                                    | roles         |
      | Administrative User | password | qa+administrator@association.drupal.org | administrator |
    And I am logged in as "Administrative User"
    And I am on "/project/test_releases"
    When I follow "Maintainers"
    And I assign the following <permissions> to the maintainer "git vetted user"
      | permissions            |
      | Write to VCS           |
      | Edit project           |
      | Administer maintainers |
    And I assign "Write to VCS" to the maintainer "Trusted User"
    And I press "Update"
    Then I should see "Maintainer permissions updated"

  @dependent @failing
  Scenario: Maintainers users
    Given users:
      | name            | pass     | mail                                | roles           |
      | Git Vetted User | password | qa+gitvetted@association.drupal.org | Git vetted user |
    And I am logged in as "Git Vetted User"
    And I visit "/node/1791620/maintainers"
    Then I should see the following <links>
      | links           |
      | eliza411        |
      | ksbalajisundar  |
      | pradeeprkara    |
      | sachin2dhoni    |
      | git vetted user |

  @dependent @failing
  Scenario: Maintainers tab users and permissions
    Given users:
      | name            | pass     | mail                                | roles           |
      | Git Vetted User | password | qa+gitvetted@association.drupal.org | Git vetted user |
    And I am logged in as "Git Vetted User"
    And I visit "/project/test_releases"
    When I follow "Maintainers"
    Then I should see the <users> with the following <permissions>
      | users          | permissions            |
      | eliza411       | Edit project           |
      | eliza411       | Write to VCS           |
      | ksbalajisundar | Write to VCS           |
      | ksbalajisundar | Edit project           |
      | ksbalajisundar | Administer maintainers |
      | ksbalajisundar | Administer releases    |
      | ksbalajisundar | Maintain issues        |
      | pradeeprkara   | Write to VCS           |
      | pradeeprkara   | Edit project           |
      | pradeeprkara   | Administer maintainers |
      | pradeeprkara   | Administer releases    |
      | sachin2dhoni   | Write to VCS           |
      | sachin2dhoni   | Edit project           |
      | sachin2dhoni   | Administer maintainers |
    And I should see the <users> without the following <permissions>
      | users        | permissions            |
      | eliza411     | Administer maintainers |
      | eliza411     | Administer releases    |
      | eliza411     | Maintain issues        |
      | pradeeprkara | Maintain issues        |
      | sachin2dhoni | Maintain issues        |
      | sachin2dhoni | Administer releases    |

  @dependent @failing
  Scenario: Updated maintainers permissions
    Given users:
      | name            | pass     | mail                                | roles           |
      | Git Vetted User | password | qa+gitvetted@association.drupal.org | Git vetted user |
    And I am logged in as "Git Vetted User"
    And I am on "/project/test_releases"
    When I follow "Maintainers"
    And I assign the following <permissions> to the maintainer "eliza411"
      | permissions            |
      | Administer maintainers |
      | Administer releases    |
      | Maintain issues        |
    And I unassign "Administer maintainers" from the maintainer "pradeeprkara"
    And I press "Update"
    Then I should see "Maintainer permissions updated"

  @dependent @failing
  Scenario: Updated maintainers permissions: Reset to previous
    Given users:
      | name            | pass     | mail                                | roles           |
      | Git Vetted User | password | qa+gitvetted@association.drupal.org | Git vetted user |
    And I am logged in as "Git Vetted User"
    And I am on "/project/test_releases"
    When I follow "Maintainers"
    And I unassign the following <permissions> from the maintainer "eliza411"
      | permissions            |
      | Administer maintainers |
      | Administer releases    |
      | Maintain issues        |
    And I assign "Administer maintainers" to the maintainer "pradeeprkara"
    And I press "Update"
    Then I should see "Maintainer permissions updated"

  @dependent @local @failing
  Scenario: Git vetted user commits to repo
    Given users:
      | name            | pass     | mail                                | roles           |
      | Git Vetted User | password | qa+gitvetted@association.drupal.org | Git vetted user |
    And I am logged in as "Git Vetted User"
    And I am on "/node/1791620/maintainers"
    And I follow "Version control"
    When I clone the repo
    And I push "2" commits to the repository
    Then I should have a local copy of "test_releases"

  @dependent @failing
  Scenario: Trusted User should not be able to commit to repo
    Given users:
      | name         | pass     | mail                                 | roles         |
      | Trusted User | password | ryan+siteuser@association.drupal.org | trusted |
    And I am logged in as "Trusted User"
    And I am on "/project/test_releases"
    When I follow "Version control"
    Then I should see "Account Settings Missing"
    And I should see "Your Git username has not been set yet. Please set one at the Git access page"

  @dependent @failing
  Scenario: Remove Trusted User
    Given users:
      | name            | pass     | mail                                | roles           |
      | Git Vetted User | password | qa+gitvetted@association.drupal.org | Git vetted user |
    And I am logged in as "Git Vetted User"
    And I am on "/project/test_releases"
    When I follow "Maintainers"
    And I follow "delete" for the maintainer "Trusted User"
    And I press "Delete"
    Then I should see "Removed"
    And I should see "as a maintainer"

  @dependent @failing
  Scenario: Remove git vetted user
    Given users:
      | name                | pass     | mail                                    | roles         |
      | Administrative User | password | qa+administrator@association.drupal.org | administrator |
    And I am logged in as "Administrative User"
    And I am on "/project/test_releases"
    When I follow "Maintainers"
    And I follow "delete" for the maintainer "git vetted user"
    And I press "Delete"
    Then I should see "Removed"
    And I should see "as a maintainer"
