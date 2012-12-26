@marketplace @wip @known_git7failure
Feature: Book listing content type
  In order to advertise Drupal book
  As an authenticated user
  I should be able to create a book listing page

  @anon
  Scenario: Anyonymous users can't create book listings
    Given I am on the homepage
    When I visit "/node/add/book-listing"
    Then I should see the heading "Access denied"
    And I should see "You are not authorized to access this page"

  Scenario: Create new book listing: validation
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

  Scenario: Create new book listing
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
    And I should see "Drupal 7.x"
    And I should see "Advanced"
    And I should see "Programmers"
    And I should see "Print"
    And I should see "Available"
    And I should see the random "Title" text
    And I should see the random "Sub-title" text
    And I should see the random "Authors" text
    And I should see the random "ISBN-13" text
    And I should see the link "Official website for this book"
    And I should see the link "Add new comment"
    And I should see the random "Book description" text
    And I should see the book cover image
    And I should not see the link "publish"
    And I should not see the link "unpublish"
    And I should see the link "edit"

  @dependent
  Scenario: New book listing is unpublished by default
    Given I am logged in as "git user"
    When I visit "/books"
    Then I should not see the random "Title" link

  @dependent @javascript
  Scenario: Publish the book listing as admin
    Given I am logged in as "admin test"
    And I visit "/books"
    And I visit the random link for "Title"
    When I follow "publish"
    And I wait for "8" seconds
    Then I should see the link "unpublish"
    And I should see the link "edit"

  @dependent @flaky
  Scenario: Authenticated users can't edit other's book listings
    Given I am logged in as "git user"
    And I visit "/books"
    When I visit the random link for "Title"
    Then I should see the heading "Book status"
    And I should not see the link "Edit"

  @dependent @anon
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

  @dependent @anon
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