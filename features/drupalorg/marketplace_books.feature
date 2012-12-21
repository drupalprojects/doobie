@marketplace @wip @anon
Feature: Marketplace books filtering
  In order to define the overall Filter search for books listing
  As an authenticated user
  I should be able to look for filter options that are available

  Scenario: Anyonymous users can't create book listings
    Given I am on the homepage
    When I visit "/books"
    Then I should not see "Page not found"
    And I should see the heading "Marketplace"
    And I should see the following <texts>
    | texts          |
    | Status         |
    | Drupal version |
    | Audience       |
    | Format         |

  Scenario: Search record by applying filters
    Given I am on the homepage
    And I visit "/books"
    When I select "Available" from "Status"
    And I select "Drupal 7.x" from "Drupal version"
    And I select "Designers/themers" from "Audience"
    And I select "Print" from "Format"
    When I select the following <fields> with <values>
    | fields         | values                 |
    | Status         | Available              |
    | Drupal version | Drupal 7.x             |
    | Audience       | Designers/themers      |
    | Format         | Print                  |
    And I press "Apply"
    Then I should see at least "2" records

  Scenario: Search record by applying filters: No records
    Given I am on the homepage
    And I visit "/books"
    When I select "Available" from "Status"
    And I select "Drupal 4.6.x" from "Drupal version"
    And I select "Designers/themers" from "Audience"
    And I select "Audio" from "Format"
    And I press "Apply"
    Then I should see "No books currently listed match your filters. Try a less restrictive set of filters."

  Scenario: Navigate through Book listing guidelines
    Given I am on the homepage
    And I visit "/books"
    When I follow "Book listing guidelines"
    Then I should see the heading "Books listing"
    And I should see the heading "Guidelines for book listings"
    And I should see the heading "How to create a book listing"
    And I should see "Books must be published in English"