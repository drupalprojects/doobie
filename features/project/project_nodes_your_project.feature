@project
Feature: Learn about details of a full project
  In order to learn about the details and components associated with a project
  As any user
  I should be able to visit the project page, follow links, and find assorted information

  @anon
  Scenario: Project page
    Given I am on the homepage
    When I visit "/project/commons"
    Then I should see the heading "Drupal Commons"
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
    Given I am on "/project/commons"
    When I follow "Version control"
    Then I should see the heading "Drupal Commons"
    And I should see the following <links>
      | links                          |
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
      | git clone --branch                         |

  @anon @content
  Scenario: Browse repository link
    Given I am on "/project/commons"
    When I follow "Repository viewer"
    Then I should see the following <links>
      | links      |
      | shortlog   |
      | log        |
      | commit     |
      | commitdiff |
      | tree       |
      | snapshot   |
      | heads      |
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
    Given I am on "/project/commons"
    When I follow "View commits"
    Then I should see at least "10" commits
    And I should see the following <texts>
      | texts              |
      | Commit             |
      | Commits            |
      | Subscribe with RSS |
    And I should see the link "next"
    And I should see "Resources" in the "right sidebar" region
    And I should see "Development" in the "right sidebar" region


  @anon @wip
  Scenario: Commit numbers in maintainers block
    Given I am on the homepage
    When I visit "/project/commons"
    Then the <user> should have at least <count> commits
      | user           | count |
      | ksbalajisundar | 7     |
      | pradeeprkara   | 2     |
      | sachin2dhoni   | 4     |

  @anon @wip
  Scenario: Users in maintainers block
    Given I am on the homepage
    When I visit "/project/commons"
    Then the project should have the following <committers>
      | committers     |
      | ksbalajisundar |
      | pradeeprkara   |
      | sachin2dhoni   |

  @anon @timeout
  Scenario: Read issue queue
    Given I am on "/project/commons"
    When I follow "open"
    Then I should see the following <texts>
      | texts      |
      | Issues for |
      | Search for |
      | Status     |
      | Priority   |
      | Category   |
      | Component  |
    And I should see the link "Login"
    And I should see the link "register"

  @timeout
  Scenario: Trusted User can post an issue or not
    Given users:
      | name         | pass     | mail                                 | roles         |
      | Trusted User | password | ryan+siteuser@association.drupal.org | Not a spammer |
    And I am logged in as "Trusted User"
    And I visit "/project/issues/commons"
    When I follow "Create a new issue"
    Then I should not see "Access denied"
    But I should see the heading "Create Issue"
    And I should see "Title"
    And I should see "Description"
