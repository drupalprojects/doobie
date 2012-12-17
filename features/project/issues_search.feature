@issues @slow @anon
Feature: Overall Filter Search for Issues
  In order to find issues on on all of Drupal.org
  As any user
  I need to be able to filter and search

  Background:
    Given I am on "/project/issues"

  Scenario: Visit the project issues page
    Then I should see the heading "Issues for all projects"
    And I should see the following <texts>
    | texts      |
    | Search for |
    | Project    |
    | Status     |
    | Priority   |
    | Category   |

  Scenario: Search for the issues with project name
    When I fill in "Search for" with "Achievements"
    And I press "Search" in the "content" region
    Then I should see at least "2" records

  @javascript
  Scenario: Search for the project title
    When I fill in "Project" with "Achievements"
    And I select "Achievements" from the suggestion "Project"
    And I press "Search" in the "content" region
    Then I should see at least "5" records

  Scenario Outline: Search records by status
    When I select "<status>" from "Status"
    And I press "Search" in the "content" region
    Then I should see at least "4" records
    Examples:
    | status               |
    | Active               |
    | Needs work           |
    | Patch (to be ported) |
    | Fixed                |
    | Postponed            |
    | Closed (fixed)       |

  Scenario Outline: Search records by Priority
    When I select "<priority>" from "Priority"
    And I press "Search" in the "content" region
    Then I should see at least "3" records
    Examples:
    | priority |
    | Critical |
    | Major    |
    | Normal   |
    | Minor    |

  Scenario Outline: Search records by Category
    When I select "<category>" from "Category"
    And I press "Search" in the "content" region
    Then I should see at least "5" records
    Examples:
    | category        |
    | Bug report      |
    | Task            |
    | Feature request |
    | Support request |

  Scenario: Search issues with all filters
    When I select the following <fields> with <values>
    | fields   | values     |
    | Status   | Needs work |
    | Priority | Normal     |
    | Category | Task       |
    And I press "Search" in the "content" region
    Then I should see at least "3" records
    And I should see "Needs work" under "Status"

  Scenario: View pagination links: First page
    And I should see the following <links>
    | links |
    | next  |
    | last  |
    | 2     |
    | 3     |
    And I should not see the link "first"

  Scenario: View pagination links: Second page
    When I click on page "2"
    Then I should see the following <links>
    | links    |
    | first    |
    | previous |
    | 1        |
    | 3        |
    | next     |
    | last     |

  Scenario: View pagination links: Last page
    When I click on page "last"
    Then I should see the link "first"
    And I should see the link "previous"
    And I should not see the link "next"
