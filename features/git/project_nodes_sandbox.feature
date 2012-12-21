@ci @sandbox
Feature: Learn about details of a (sandbox) project
  In order to learn about the various details and components associated with a project
  As any user
  I should be able to visit the project page, follow various links, and find assorted information

  @anon @smoke
  Scenario: View the project page
    Given I am on the homepage
    When I visit "/node/1765126"
    Then I should see the following <texts>
    | texts                     |
    | Posted by                 |
    | Sandbox                   |
    | Experimental Project      |
    | This is a sandbox project |
    | Categories:               |
    | Maintainers for           |
    | Issues for                |
    And I should see the following <links>
    | links                |
    | sandbox project      |
    | View all committers  |
    | View commits         |
    | Advanced search      |
    | Subscribe via e-mail |
    And I should see the heading "Development"

  @anon @smoke
  Scenario: Project Git instructions
    Given I am on "/node/1765126"
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
    | branching and tagging          |
    | Advanced patch workflow        |

  @anon
  Scenario: Browse repository link
    Given I am on "/node/1765126"
    When I follow "Repository viewer"
    Then I should not see "Page not found"
    And I should see the following <links>
    | links       |
    | shortlog    |
    | log         |
    | commit      |
    | commitdiff  |
    | tree        |
    | snapshot    |
    | heads       |
    And I should see the following <texts>
    | texts       |
    | description |
    | owner       |
    | drupal-git  |
    | last change |
    | search:     |
    | summary     |

  @anon
  Scenario: View git messages
    Given I am on "/node/1765126"
    When I follow "View commits"
    Then I should see at least "5" commits
    And I should see the following <texts>
    | texts              |
    | Commit             |
    | Commits            |
    | Subscribe with RSS |
    | Development        |
    And I should not see the link "first"
    And I should not see the link "previous"

  @anon @smoke
  Scenario: View commit numbers against the user in maintainers block
    Given I am on the homepage
    When I visit "/node/1765126"
    Then the <user> should have at least <count> commits
    | user           | count |
    | ksbalajisundar | 5     |
    | sachin2dhoni   | 2     |

  @anon
  Scenario: View users in maintainers block
    Given I am on the homepage
    When I visit "/node/1765126"
    Then the project should have the following <committers>
    | committers     |
    | ksbalajisundar |
    | sachin2dhoni   |

  @anon
  Scenario: Releases should not exist
    Given I am on the homepage
    When I visit "/node/1765126"
    Then I should not see the link "Notes"
    And I should not see the link "View all releases"
    And I should not see the following <texts>
    | texts                |
    | Downloads            |
    | Recommended releases |
    | Development releases |
    | Downloads            |
    | tar.gz (             |
    | zip (                |
    But I should see the link "sandbox project"

  @anon @smoke
  Scenario: Read issue queue
    Given I am on "/node/1765126"
    When I follow "open"
    Then I should see the following <texts>
    | texts          |
    | Issues for     |
    | Search for     |
    | Status         |
    | Priority       |
    | Category       |
    | Component      |
    And I should see the link "Login"
    And I should see the link "register"

  @smoke
  Scenario: Visit create a new issue page to post an issue
    Given I am logged in as "site user"
    And I visit "/project/issues/1765126"
    When I follow "Create a new issue"
    Then I should not see "Access denied"
    But I should see the heading "Create Issue"
    And I should see "Title"
    And I should see "Description"
