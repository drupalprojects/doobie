@marketplace @anon
Feature: Drupal Books
  In order to find book about Drupal suitable for me
  As any user
  I should be able to browse list of Drupal Books

  Scenario: View the list of Drupal Books
    Given I am on the homepage
    When I follow "Marketplace"
    And I follow "Books"
    Then I should not see "Page not found"
    And I should see the heading "Marketplace"
    And I should not see the link "Add book listing"
    And I should see the following <tabs>
      | tabs     |
      | Services |
      | Hosting  |
      | Training |
      | Books    |
    And I should see that the tab "Books" is highlighted
    And I should see the following <texts>
      | texts                          |
      | Status                         |
      | Drupal version                 |
      | Audience                       |
      | Format                         |
      | Availability:                  |
      | More information               |
      | by the individual contributors |

  Scenario: Filter books
    Given I am on "/books"
    When I select "Available" from "Status"
    And I select "Drupal 7.x" from "Drupal version"
    And I select "Designers/themers" from "Audience"
    And I select "Print" from "Format"
    And I press "Apply"
    Then I should see at least "2" records

  Scenario: Filter books: No records
    Given I am on "/books"
    When I select "Available" from "Status"
    And I select "Drupal 4.6.x" from "Drupal version"
    And I select "Designers/themers" from "Audience"
    And I select "Audio" from "Format"
    And I press "Apply"
    Then I should see "No books currently listed match your filters. Try a less restrictive set of filters."

  Scenario: View Book listing guidelines
    Given I am on "/books"
    When I follow "Book listing guide"
    Then I should see the heading "Books listing guide"
    And I should see the heading "Guidelines for book listings"
    And I should see the heading "How to create a book listing"
    And I should see "Books must be published in English"
