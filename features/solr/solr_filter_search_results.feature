@known_git7failure @anon @wip @javascript
Feature: Visitor searches site and filters the results using various options
  In order to see relevant search results
  As a visitor to Drupal.org
  I want to search for few terms and filter the results

  Background:
    Given I am on "/search"
    And I search sitewide for "views"
    And I follow "Modules ("
    And I wait until the page loads

  Scenario Outline: Filter by Modules categories
    When I select "<module>" from "Modules categories"
    And I see "results containing the words: views"
    And I follow the first search result
    Then I should see the link "<module>"
    And I should see the link "Views"
    And I should see "Project Information"
    Examples:
    | module         |
    | Administration |
    | Content        |
    | Event          |
    | Mobile         |
    | Search         |

  Scenario Outline: Filter by compatibility
    When I select "<version>" from "Filter by compatibility"
    And I see "results containing the words: views"
    And I follow the first search result
    And I follow "View all releases"
    And I wait until the page loads
    And I select "<version>" from "API version"
    And I press "Apply"
    Then I should see the link "<version>"
    And I should see "Releases for"
    Examples:
    | version |
    | 5.x     |
    | 6.x     |
    | 7.x     |
    | 8.x     |

  Scenario Outline: Filter by Status
    When I select "<status>" from "Status"
    And I see "results containing the words: views"
    And I follow the first search result
    Then I should see "<text1>"
    And I should not see "<text2>"
    Examples:
    | status                | text1                                                       | text2                                                       |
    | Only sandbox projects | This is a sandbox project, which contains experimental code | Recommended releases                                        |
    | All projects          | View all releases                                           | This is a sandbox project, which contains experimental code |
    | Full projects         | Recommended releases                                        | This is a sandbox project, which contains experimental code |
