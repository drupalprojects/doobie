@known_git6failure @anon
Feature: Visitor searches site
  In order to see relevant search results and filters
  As a visitor to Drupal.org
  I want to search for the term 'views' and use filters provided

  Scenario: Search box in the header on every page drives to solr d.o search
    Given I am on "/project/drupal"
    When I search sitewide for "views"
    Then I should be on "/search/site/views"

  Scenario: Search for the term and look for results
    Given that I am on the homepage
    When I search sitewide for "views"
    And I should see the heading "Search again"
    And I should see the following <texts>
    | texts                               |
    | or filter by                        |
    | or search for                       |
    | results containing the words: views |
    | Posted by                           |
    | Sort by:                            |
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
    Given I am on "/search/site/views"
    When I select "Title" from "Sort by"
    And I should not see "Your search yielded no results"

  Scenario: Page contains a search field in the right column
    Given I am on "/search/site/views"
    When I enter "cck" for field "Search again"
    And I press "Submit"
    Then I should see at least "25" records
    And I should see the link "CCK"
    And I should see "results containing the words: cck"
    And I should not see "Your search yielded no results"

  @slow
  Scenario Outline: Check links under "Or search for..."
    Given I am on "/search/site/views"
    When I follow "<link>"
    Then I should be on "<path>"
    And I should not see "Page not found"
    And I should not see "Access denied"
    Examples:
    | link            | path                      |
    | IRC Nicks       | /search/drupalorg/views   |
    | Users           | /search/user_search/views |
    | Advanced Issues | /search/issues?text=views |

  Scenario: Facet search on the right side bar
    Given that I am on the homepage
    When I search sitewide for "views"
    Then I should see the following <links>
    | links             |
    | All (             |
    | Modules (         |
    | Themes (          |
    | Documentation (   |
    | Forums & Issues ( |
    | Groups (          |
    And I should see at least "10" records for each filter

  @slow
  Scenario Outline: Follow each facet filter and verify the same
    Given I am on "/search/site/views"
    When I follow "<filter>"
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
    | Groups (          |

  @javascript
  Scenario: Meta type modules has more filters
    Given I am on "/search/site/views?f[0]=ss_meta_type%3Amodule"
    When I select "Event" from "Modules categories"
    And I select "6.x" from "Filter by compatibility"
    And I select "All projects" from "Status"
    And I select "Date" from "Sort by"
    Then I should see "results containing the words: views"
    And I should see at least "25" records

  @javascript
  Scenario: Meta type themes has more filters
    Given I am on "/search/site/views?f[0]=ss_meta_type%3Atheme"
    When I select "7.x" from "Filter by compatibility"
    And I select "Full projects" from "Status"
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
