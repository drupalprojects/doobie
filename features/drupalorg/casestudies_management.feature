@casestudies @wip
Feature: Case studies management
  In order to manage case studies
  As an authenticated user
  I should be able to search and filter the list of case studies

  Background:
    Given I am logged in as "site user"
    And I visit "/case-studies/manage"

  Scenario: View casestudies management page
    Then I should see the heading "Case Studies management"
    And I should see the following <texts>
    | texts          |
    | Published      |
    | Status         |
    | Title contains |
    | Category       |
    | New            |
    And I should see the following <links>
    | links                 |
    | Case Study guidelines |
    | next                  |
    | last                  |
    | Featured showcase     |
    | Community showcase    |
    And I should see at least "50" records
    And I should not see the link "previous"

  Scenario: Filter by Published
    When I select "Yes" from "Published"
    And I press "Apply"
    Then I should see at least "10" records
    And I should not see "Sorry, nothing found"
    And I should see the heading "Case Studies management"

  Scenario Outline: Filter by Status
    When I select "<option>" from "Status"
    And I press "Apply"
    Then I should see at least "1" record
    And I should not see "Sorry, nothing found"
    And I should see the heading "Case Studies management"
    And I should see "<option>" under "Status"
    Examples:
    | option       |
    | Community    |
    | Featured     |

  Scenario: Filter by Title
    When I fill in "Title contains" with "Online"
    And I press "Apply"
    Then I should see at least "1" record
    And I should not see "Sorry, nothing found"
    And I should see the heading "Case Studies management"
    And I should see the link "Online"

  Scenario Outline: Filter by Category
    When I select "<option>" from "Category"
    And I press "Apply"
    Then I should see at least "5" records
    And I should not see "Sorry, nothing found"
    And I should see the heading "Case Studies management"
    Examples:
    | option     |
    | Arts       |
    | Education  |
    | Non-profit |
    | Technology |

  Scenario: Filter by New
    When I check the box "New"
    And I press "Apply"
    Then I should see at least "25" records
    And I should not see "Sorry, nothing found"
    And I should see the heading "Case Studies management"

  Scenario: Filter for no records
    When I fill in "Title contains" with random text
    And I press "Apply"
    Then I should see "Sorry, nothing found"
    And I should see the heading "Case Studies management"

  Scenario: Filter by all the options
    When I select "Yes" from "Published"
    And I select "Featured" from "Status"
    And I fill in "Title contains" with "museum"
    And I select "Arts" from "Category"
    And I press "Apply"
    Then I should see at least "1" record
    And I should not see "Sorry, nothing found"
    And I should see the heading "Case Studies management"
    And I should see "Featured" under "Status"
