@marketplace @wip
Feature: Adding books listing to the Marketplace
  In order to advertise the books services
  As an authenticated user
  I should be able to create a book page

  Scenario: Anyonymous users can't create book listings
    Given I am on the homepage
    When I visit "/books"
    Then I should see the heading "Marketplace"
    Then I should not see "Page not found"
    And I should not see the link "Add book listing"

  Scenario: Validation
    Given I am logged in as "site user"
    And I visit "/books"
    When I follow "Add book listing"
    And I see "Book descriptions are generally copyrighted by the book author or publisher"
    And I see "Book listing guidelines"
    And I press "Save"
    Then I should see "Title field is required"
    And I should see "Book availability field is required"
    And I should see "Authors field is required"
    And I should see "Publication date field is required"
    And I should see "ISBN-13 field is required"
    And I should see "ISBN-10 field is required"

  Scenario: Add organization and request promotion to Services section
    Given I am logged in as "site user"
    And I visit "/books"
    When I follow "Add book listing"
    And I wait until the page is loaded
    And I fill in "Title" with random text
    And I select "Drupal 7.x" from "Drupal version:"
    And I select "Advanced" from "Level:"
    And I select "Programmers" from "Audience"
    And I select "Print" from "Book format"
    And I select "Available" from "Book availability:"
    And I attach the local file "koala.jpg" to "Cover image:"
    And I fill in "Sub-title" with random text
    And I fill in "Authors" with random text
    And I fill in "Publisher" with random text
    And I fill in "Publication date" with random text
    And I fill in "Website" with random text
    And I fill in "ISBN-13" with random text
    And I fill in "ISBN-10" with random text
    And I fill in "Book description" with random text
    And I press "Save"
    Then I should see "has been created"

  @dependent
  Scenario: Add organization and request promotion to Services section
    Given I am logged in as "site user"
    When I visit "/books"
    Then I should see the random "Title" link
    And I should see the following <texts>
    | texts          |
    | Drupal version |
    | Programmers    |
    | Advanced       |
    | Print          |
    | Available      |
    And I should see the following <links>
    | links                          |
    | Official website for this book |
    | More information               |

  @dependent
  Scenario: More information on book page
    Given I am logged in as "site user"    
    And I visit "/books"
    When I visit the random link for "Title"
    Then I should see the random "Sub-title" text
    And I should see the random "Authors" text
    And I should see the random "ISBN-13" text
    And I should see the link "Official website for this book"
    And I should see the link "Add new comment"
    And I should see the random "Book description" text
    And I should not see the link "publish"
    And I should not see the link "unpublish"

  @dependent @javascript
  Scenario: Publish the book page as admin
    Given I am logged in as "admin test"
    And I visit "/books"
    And I visit the random link for "Title"
    When I follow "publish"
    And I wait for "8" seconds
    Then I should see the link "unpublish"

  @dependent @flaky
  Scenario: Authenticated users can't edit other's book listings
    Given I am logged in as "git user"
    And I visit "/books"
    When I visit the random link for "Title"
    Then I should not see the link "Edit"

  @dependent
  Scenario: Once book listing is edited by admin and published - it should appear in the list
    Given I am on the homepage
    When I visit "/books"
    Then I should see the random "Title" link
    And I should see the heading "Marketplace"

  @dependent @javascript
  Scenario: Unpublish the book page
    Given I am logged in as "admin test"
    And I visit "/books"
    And I visit the random link for "Title"
    When I follow "unpublish"
    And I wait for "8" seconds
    Then I should see the link "publish"

  @dependent
  Scenario: Once book listing is unpublished, it should not appear in the list
    Given I am on the homepage
    When I visit "/books"
    Then I should not see the random "Title" link
    And I should see the heading "Marketplace"

  @dependent
  Scenario: Delete the listing once testing is done
    Given I am logged in as "admin test"
    And I visit "/books"
    And I visit the random link for "Title"
    And I follow "Edit"
    And I fill in "Log message" with "Delete"
    And I press "Delete"
    And I see "Are you sure you want to delete"
    When I press "Delete"
    Then I should see "has been deleted"    