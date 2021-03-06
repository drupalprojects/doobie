@anon @search
Feature: Visitor searches site
  In order to see relevant search results and filters
  As a visitor to Drupal.org
  I want to search for the term 'views' and use filters provided

  Scenario: Search for the term and look for results
    Given I am on the homepage
    When I search sitewide for "views"
    And I should see the heading "Search again"
    And I should see the following <texts>
      | texts                               |
      | or filter by                        |
      | or search for                       |
      | results containing the words: views |
      | Posted by                           |
      | Sort by                             |
    And I should see the following <links>
      | links           |
      | Views           |
      | IRC Nicks       |
      | Users           |
      | Advanced Issues |
      | next            |
      | last            |
    And I should see at least "25" records
    And I should not see "Your search yielded no results"

  @javascript
  Scenario: Page contains a sorting option at the top of results
    Given I am on "/search"
    And I search sitewide for "views"
    When I select "Title" from "Sort by"
    Then I should not see "Your search yielded no results"
    And I should see at least "25" records

  Scenario: Page contains a search field in the right column
    Given I am on "/search"
    And I search sitewide for "views"
    When I enter "Masquerade" for field "Search again"
    And I press "Search" in the "right sidebar" region
    Then I should see at least "25" records
    And I should see the link "Masquerade"
    And I should see "results containing the words: Masquerade"
    And I should not see "Your search yielded no results"

  @slow
  Scenario Outline: Check links under "Or search for..."
    Given I am on "/search"
    And I search sitewide for "views"
    When I follow "<link>"
    Then I should be on "<path>"
    And I should not see "Page not found"
    And I should not see "403 - Access denied"
  Examples:
    | link            | path                              |
    | IRC Nicks       | /search/drupalorg/views           |
    | Users           | /search/user/views                |
    | Advanced Issues | /project/issues/search?text=views |

  Scenario: Facet search on the right side bar
    Given I am on "/search"
    When I search sitewide for "views"
    Then I should see the following <links>
      | links             |
      | All (             |
      | Modules (         |
      | Themes (          |
      | Documentation (   |
      | Forums & Issues ( |
    And I should see at least "10" records for each filter

  @slow
  Scenario Outline: Follow each facet filter and verify the same
    Given I am on "/search"
    And I search sitewide for "views"
    When I follow "<filter>"
    And I wait until the page loads
    And I should not see "Your search yielded no results"
    And I should see at least "10" records
    And I should see "results containing the words: views"
  Examples:
    | filter            |
    | All (             |
    | Modules (         |
    | Themes (          |
    | Documentation (   |
    | Forums & Issues ( |

  @javascript
  Scenario: Meta type modules has more filters
    Given I am on "/search"
    And I search sitewide for "views"
    And I follow "Modules ("
    And I wait until the page loads
    When I select "Event" from "Module categories"
    And I wait until the page loads
    And I select "6.x" from "Core compatibility"
    And I wait until the page loads
    And I select "All projects" from "Status"
    And I wait until the page loads
    And I select "Created date" from "Sort by"
    And I wait until the page loads
    Then I should see "results containing the words: views"
    And I should see at least "25" records

  @javascript @local
  Scenario: Meta type themes has more filters
    Given I am on "/search"
    And I search sitewide for "views"
    And I follow "Themes ("
    And I wait until the page loads
    When I select "7.x" from "Core compatibility"
    And I wait until the page loads
    And I select "Full projects" from "Status"
    And I wait until the page loads
    And I select "Author" from "Sort by"
    Then I should see "results containing the words: views"
    And I should see at least "25" records

  @javascript
  Scenario: Filters exist in the search box in the header
    Given I am on "/about"
    When I follow "Refine your search"
    Then I should see the following <texts>
      | texts           |
      | All             |
      | Modules         |
      | Themes          |
      | Documentation   |
      | Forums & Issues |
      | Groups          |
