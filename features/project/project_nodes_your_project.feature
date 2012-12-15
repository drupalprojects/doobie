@project 
Feature: Learn about details of a full project
  In order to learn about the details and components associated with a project
  As any user
  I should be able to visit the project page, follow links, and find assorted information

  @anon
  Scenario: Project page
    Given I am on the homepage
    When I visit "/project/test_releases"
    Then I should see the heading "BDD Testing - d.o. releases"
    And I should see the heading "Development"
    And I should see the following <links>
    | links                    |
    | View                     |
    | Version control          |
    | View all releases        |
    | Actively maintained      |
    | Under active development |

  @anon @content
  Scenario: Project git instructions
    Given I am on "/project/test_releases"
    When I follow "Version control"
    Then I should see the heading "BDD Testing - d.o. releases"
    And I should see the following <links>
    | links                          |
    | BDD Testing - d.o. releases    |
    | Troubleshooting Git clone      |
    | Git deploy                     |
    | Versioned dependencies and Git |
    | branching and tagging          |
    And I should see the following <texts>
    | texts                                      |
    | This page gives the essential Git commands |
    | Version to work from                       |
    | One-Time Only                              |
    | Routinely                                  |
    | Patching                                   |
    | git clone --recursive --branch master      |

  @anon @content
  Scenario: Browse repository link
    Given I am on "/project/test_releases"
    When I follow "Repository viewer"
    Then I should see the following <links>
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
  Scenario: Git messages
    Given I am on "/project/test_releases"
    When I follow "View commits"
    Then I should see at least "10" commits
    And I should see the following <texts>
    | texts              |
    | Commit             |
    | Commits            |
    | Subscribe with RSS |
    | Development        |
    And I should see the link "next"

  @anon
  Scenario: Commit numbers in maintainers block
    Given I am on the homepage
    When I visit "/project/test_releases"
    Then the <user> should have at least <count> commits
    | user            | count |
    | ksbalajisundar  | 7     |
    | pradeeprkara    | 2     |
    | sachin2dhoni    | 4     |

  @anon
  Scenario: Users in maintainers block
    Given I am on the homepage
    When I visit "/project/test_releases"
    Then the project should have the following <committers>
    | committers      |
    | ksbalajisundar  |
    | pradeeprkara    |
    | sachin2dhoni    |

  @anon @timeout
  Scenario: Read issue queue
    Given I am on "/project/test_releases"
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

  @timeout
  Scenario: Site user can post an issue or not
    Given I am logged in as "site user"
    And I visit "/project/issues/test_releases"
    When I follow "Create a new issue"
    Then I should not see "Access denied"
    But I should see the heading "Create Issue"
    And I should see "Title"
    And I should see "Description"
