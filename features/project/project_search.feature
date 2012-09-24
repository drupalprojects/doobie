@slow
Feature: Overall Filter Search for Issues
  In order to define the overall Filter search for Issues
  As an Anonymous user
  I wanted to look for overall Filter search for Issues

  Background:
    Given I am on "/project/issues"
  
  Scenario: Visting the project issues page
    Then I should see the heading "Issues for all projects"
    And I should see "Download & Extend"
    And I should see the following <texts>
    | texts       |
    | Search for  |
    | Project     |
    | Status      |
    | Priority    |
    | Category    |

  Scenario: Searching for the issues with project name
    When I fill in "Search for" with "Achievements"
    And I press search to filter
    Then I should see at least "2" records

  @javascript @wip @known_git6failure
  Scenario: When Searching for the Project title
    When I fill in "Project" with "Achie"
    And I select "Achievements" from the suggestion "Project"
    And I press search to filter
    Then I should see at least "5" records
    And I wait for "1" seconds
    And I should see "Achievements" under "Project"

  Scenario: For Searching issues that are active
    When I select "active" from "Status"
    And I press search to filter
    Then I should see at least "2" records
    And I should see "active" under "Status"
    And I should not see "needs work" under "Status"
    And I should not see "fixed" under "Status"

    Scenario: For Searching issues that needs review
    When I select "needs review" from "Status"
    And I press search to filter
    Then I should see at least "1" record
    And I should see "needs review" under "Status"
    And I should not see "needs work" under "Status"
    And I should not see "active" under "Status"

    Scenario: For Searching issues based on Priorty and Category
    When I select "normal" from "Priority"
    Then I press search to filter
    And I should see at least "1" record
    And I should see "normal" under "Priority"
    And I select "bug report" from "Category"
    And I press search to filter
    And I should see at least "1" record
    And I should see "bug reports" under "Category"

  Scenario: For Searching issues with all filters
    When I select the following <fields> with <values>
    | fields   | values |
    | Status   | active |
    | Priority | normal |
    | Category | Any    |
    And I press search to filter
    Then I should see at least "3" records
    And I should see "active" under "Status"
    And I should see "normal" under "Priority"

  Scenario Outline: Search records by status
    When I select "<status>" from "Status"
    And I press search to filter
    Then I should see at least "4" records
    Examples:
    | status                                 |
    | active                                 |
    | needs work                             |
    | needs review                           |
    | reviewed & tested by the community     |
    | patch (to be ported)                   |
    | fixed                                  |
    | postponed                              |
    | postponed (maintainer needs more info) |
    | closed (duplicate)                     |
    | closed (won't fix)                     |
    | closed (works as designed)             |
    | closed (cannot reproduce)              |
    | closed (fixed) |

  Scenario Outline: Search records by Priority
    When I select "<priority>" from "Priority"
    And I press search to filter
    Then I should see at least "5" records
    Examples:
    | priority |
    | critical |
    | major    |
    | normal   |
    | minor    |

  Scenario Outline: Search records by Category
    When I select "<category>" from "Category"
    And I press search to filter
    Then I should see at least "5" records
    Examples:
    | category        |
    | bug report      |
    | task            |
    | feature request |
    | support request |

  Scenario: For verifying the pagination links: First page
    And I should see the following <links>
    | links |
    | next  |
    | last  |
    | 1     |
    | 2     |
    And I should not see the link "first"

  Scenario: For verifying the pagination links: Second page
    When I click on page "2"
    Then I should see the following <links>
    | links    |
    | first    |
    | previous |
    | 1        |
    | 3        |
    | next     |
    | last     |

  Scenario: For verifying the pagination links: Last page
    When I click on page "last"
    Then I should see the link "first"
    And I should see the link "previous"
    And I should not see the link "next"
