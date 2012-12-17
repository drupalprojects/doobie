@casestudies @javascript
Feature: Case studies management
  In order to manage case studies
  As an authenticated user
  I should be able to search and filter the list of case studies

  Background:
    Given I am logged in as "site user"
    And I visit "/case-studies/manage"

  Scenario: View casestudies management page
    Then I should see the heading "Drupal Case Studies"
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

  Scenario Outline: Filter by Status
    When I select "<option>" from "Status"
    And I press "Apply"
    Then I should see at least "1" record
    And I should see "<option>" under "Status"
    Examples:
    | option       |
    | Community    |
    | Featured     |

  Scenario: Filter by Title
    When I fill in "Title contains" with "BrightCove"
    And I press "Apply"
    Then I should see at least "1" record
    And I should see the link "BrightCove"

  Scenario Outline: Filter by Category
    When I select "<option>" from "Category"
    And I press "Apply"
    Then I should see at least "5" records
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

  Scenario: Filter by all the options
    When I select "Yes" from "Published"
    And I select "Community" from "Status"
    And I select "Music" from "Category"
    And I press "Apply"
    Then I should see at least "1" record
    And I should see "Community" under "Status"
