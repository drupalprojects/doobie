@project @anon @content
Feature: To view the project details
  In order to learn about the project
  As an anonymous user
  I should be able to see data and follow links about it

  Scenario: Visit the project page
    Given I am on the homepage
    When I follow "Download & Extend"
    And I follow "Download Drupal"
    Then I should see the heading "Download & Extend"
    And I should see the heading "Issues for Drupal core"
    And I should see the following <texts>
    | texts                |
    | Posted by            |
    | Downloads            |
    | Recommended releases |
    | Development releases |
    And I should see the following <links>
    | links           |
    | View            |
    | Version control |
    | Advanced search |
    | total           |
    | Modules         |

  Scenario: Project Git instructions
    Given I am on "/project/drupal"
    When I follow "Version control"
    Then I should see "This page gives the essential Git commands for working with this project's source files"
    And I should see the following <texts>
    | texts                |
    | Version to work from |
    | One-Time Only        |
    | Routinely            |
    | Patching             |
    And I should see the following <links>
    | links                          |
    | Git instructions updates       |
    | Troubleshooting Git clone      |
    | Git deploy                     |
    | Versioned dependencies and Git |
    | branching and tagging          |
    | Advanced patch workflow        |

  Scenario: Change the branch and view the content
    Given I am on "/project/drupal/git-instructions"
    When I select "7.x" from "Version to work from"
    And I press "Show"
    And I should see the following <texts>
    | texts                           |
    | 7.x                             |
    | Checking your repository status |
    | Switching to a different branch |

  Scenario: Browse repository link
    Given I am on "/project/drupal"
    When I follow "Repository viewer"
    Then I should not see "Page not found"
    And I should see the following <links>
    | links              |
    | project/drupal.git |
    | shortlog           |
    | log                |
    | commit             |
    | commitdiff         |
    | tree               |
    | snapshot           |
    | tags               |
    | heads              |
    And I should see the following <texts>
    | texts       |
    | description |
    | owner       |
    | drupal-git  |
    | last change |
    | search:     |
    | summary     |

  Scenario: View git messages
    Given I am on "/project/drupal"
    When I follow "View commits"
    Then I should see the heading "Commits for Drupal core"
    And I should see at least "10" records
    And I should see the following <texts>
    | texts              |
    | Commit             |
    | commits            |
    | Issue #            |
    | Subscribe with RSS |
    And I should see the link "next"
    And I should not see the link "first"
    And I should not see the link "previous"

  Scenario: View committers and commit numbers: Maintainers block
    Given I am on "/download"
    When I follow "Download Drupal"
    Then I should see the heading "Maintainers for Drupal core"
    And I should see at least "5" committers
    And I should see at least "11716" commits

  Scenario: View users: Maintainers block
    Given I am on "/download"
    When I follow "Download Drupal"
    Then I should see the heading "Maintainers for Drupal core"
    And I should see the following <links>
    | links               |
    | Dries               |
    | View all committers |
    | View commits        |

  Scenario: Releases: all - Hidden releases exists
    Given I am on "/project/drupal"
    When I follow "View all releases"
    Then I should see the heading "Releases for Drupal core"
    And I should see the following <texts>
    | texts                     |
    | API version               |
    | Download                  |
    | Size                      |
    | md5 hash                  |
    | Release notes             |
    | Known issues              |
    | Official release from tag |

  Scenario: Issue queue can be read
    Given I am on "/project/drupal"
    When I follow " open"
    Then I should see the heading "Issues for Drupal core"
    And I should see the following <texts>
    | texts              |
    | Search for         |
    | Status             |
    | Summary            |
    | Priority           |
    | Replies            |
    | Task               |
    | Subscribe with RSS |
    And I should see at least "25" records
